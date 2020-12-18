unit midimanager;

//by Marco Bramardi

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, AndroidWidget;

type

  TOnMidiManagerDeviceAdded=procedure(Sender:TObject;deviceId:integer;deviceName:string;productId:string;manufacture:string) of object;
  TOnMidiManagerDeviceRemoved=procedure(Sender:TObject;deviceId:integer;deviceName:string;productId:string;manufacture:string) of object;

  //Keep in the same order as the corresponding numbers in jMidiManager.java:
  TDeviceInfoKind = (
    diAllXML, diAllJSON, diAllText,
    diInputsXML,   diOutputsXML,
    diInputsJSON,  diOutputsJSON,
    diInputsText,  diOutputsText);
  TMidiManagerEvent = procedure(Sender: TObject; info: integer; data:int64) of object;

{ jMidiManager }

  jMidiManager = class(jControl)
  private
    fOpenDeviceId: integer;
    fOpenPortNumber: integer;
    fPitchRange: integer; // value in cents of maximum pitch shift
    fOnEvent: TMidiManagerEvent;
    FOnDeviceAdded: TOnMidiManagerDeviceAdded;
    FOnDeviceRemoved: TOnMidiManagerDeviceRemoved;

    function OpenIO(InputOutput: AnsiString; DeviceId, PortNumber: integer): integer;
    function DoAction(_cmd: integer; _param: int64 = 0): integer;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init(refApp: jApp); override;
    function jCreate(): jObject;
    procedure jFree();
    function GetDeviceInfo(Kind: TDeviceInfoKind): string;
    function GetDebug: string;
    // WARNING JSON MAY BE BUGGY
    function GetDeviceCount(CountInput, CountOutput: boolean): integer;
    function GetDeviceID(): integer;
    function OpenInput(DeviceId, PortNumber: integer): integer; overload;
    function OpenInput(MyId: string): integer; overload;
    function OpenOutput(DeviceId, PortNumber: integer): integer; overload;
    function OpenOutput(MyId: string): integer; overload;
    procedure Close;
    // important: this method sends 3-byte midi messages. If you need to send a
    // 2-byte midi message, set the third value (b3) to -1.
    function SendMidiMessage(b1, b2, b3: integer; timestamp: int64 = 0): integer;
    function PlayChNoteVol(ch, note, vol: integer; timestamp: int64 = 0): integer;
    function SetChVol(ch, vol: integer; timestamp: int64 = 0): integer;
    function SetChPatch(ch, patch: integer; timestamp: int64 = 0): integer;
    function SetChPan(ch, pan: integer; timestamp: int64 = 0): integer;
    function SetChPitch(ch, pitch: integer; timestamp: int64 = 0): integer;
    function SetChPitchCent(ch, cent: integer; timestamp: int64 = 0): integer;
    function GetStatus: integer;
    function Flush: integer;
    function AllNotesOff(timestamp: int64 = 0): integer;
    function Start: integer;
    function MyId: string;
    procedure GenEvent_OnOpened(Sender: TObject);
    procedure GenEvent_OnEvent(Sender: TObject; info: integer; data: int64);
    procedure GenEvent_OnMidiManagerDeviceAdded(Sender:TObject;deviceId:integer;deviceName:string;productId:string;manufacture:string);
    procedure GenEvent_OnMidiManagerDeviceRemoved(Sender:TObject;deviceId:integer;deviceName:string;productId:string;manufacture:string);
    function Active: boolean;

    property OnEvent: TMidiManagerEvent read fOnEvent write fOnEvent;
    property OpenDeviceId: integer read fOpenDeviceId;
    property OpenPortNumber: integer read fOpenPortNumber;

  published
    property OnDeviceAdded: TOnMidiManagerDeviceAdded read FOnDeviceAdded write FOnDeviceAdded;
    property OnDeviceRemoved: TOnMidiManagerDeviceRemoved read FOnDeviceRemoved write FOnDeviceRemoved;

  end;

function jMidiManager_jCreate(env: PJNIEnv; this: JObject;_Self: int64): jObject;
procedure jMidiManager_jFree(env: PJNIEnv; _jmidimanager: JObject);
function jMidiManager_GetStatus(env: PJNIEnv; _jmidimanager: JObject): integer;
function jMidiManager_MidiOpen(env: PJNIEnv; _jmidimanager: JObject; MethodName: PChar; _deviceId, _portNumber: integer): integer;
procedure jMidiManager_MidiClose(env: PJNIEnv; _jmidimanager: JObject);
function jMidiManager_GetDeviceInfo(env: PJNIEnv; _jmidimanager: JObject; XmlJsonText: integer): string;
function jMidiManager_GetDebug(env: PJNIEnv; _jmidimanager: JObject): string;
function jMidiManager_SendMidiMessage(env: PJNIEnv; _jmidimanager: JObject;
  _b1, _b2, _b3: integer; _timestamp: int64): integer;
function jMidiManager_DoAction(env: PJNIEnv; _jmidimanager: JObject;
  _cmd: integer; _param: int64): integer;

implementation

const // DoAction _cmd parameter:
  CMD_FLUSH            = 0; // flush messages, all notes off immediately
  CMD_START            = 1; // set starting time for MIDI messages
  CMD_GET_STATUS       = 2; // return value of myStatus
  CMD_GET_DEVICE_ID    = 3; // return device iD if active
  CMD_GET_DEVICE_COUNT = 4; // how many devices available
  CMD_ALL_NOTES_OFF    = 5; // all notes off at time T=_param
  CMD_MIDI_CLOSE       = 6;
  //GET_COUNT_INPUT    = 1; //
  //GET_COUNT_OUTPUT   = 2; //
  //GET_COUNT_ALL      = 3; //

function jMidiManager_jCreate(env: PJNIEnv; this: JObject;_Self: int64): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jMidiManager_jCreate', '(J)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;

procedure jMidiManager_jFree(env: PJNIEnv; _jmidimanager: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jmidimanager);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jmidimanager, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

function jMidiManager_GetStatus(env: PJNIEnv; _jmidimanager: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jmidimanager);
  jMethod:= env^.GetMethodID(env, jCls, 'getStatus', '()I');
  result := env^.CallIntMethod(env, _jmidimanager, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

function jMidiManager_MidiOpen(env: PJNIEnv; _jmidimanager: JObject;
    MethodName: PChar; _deviceId, _portNumber: integer): integer;
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i := _deviceId;
  jParams[1].i := _PortNumber;
  jCls:= env^.GetObjectClass(env, _jmidimanager);
  jMethod:= env^.GetMethodID(env, jCls, MethodName, '(II)I');
  result := env^.CallIntMethodA(env, _jmidimanager, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jMidiManager_MidiClose(env: PJNIEnv; _jmidimanager: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jmidimanager);
  jMethod:= env^.GetMethodID(env, jCls, 'midiClose', '()V');
  env^.CallVoidMethod(env, _jmidimanager, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

function jMidiManager_SendMidiMessage(env: PJNIEnv; _jmidimanager: JObject;
    _b1, _b2, _b3: integer; _timestamp: int64): integer;
var
  jParams: array[0..3] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i := _b1;
  jParams[1].i := _b2;
  jParams[2].i := _b3;
  jParams[3].j := _timestamp;
  jCls:= env^.GetObjectClass(env, _jmidimanager);
  jMethod:= env^.GetMethodID(env, jCls, 'sendMidiMessage', '(IIIJ)I');
  result := env^.CallIntMethodA(env, _jmidimanager, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

function jMidiManager_DoAction(env: PJNIEnv; _jmidimanager: JObject;
    _cmd: integer; _param: int64): integer;
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i := _cmd;
  jParams[1].j := _param;
  jCls:= env^.GetObjectClass(env, _jmidimanager);
  jMethod:= env^.GetMethodID(env, jCls, 'doAction', '(IJ)I');
  result := env^.CallIntMethodA(env, _jmidimanager, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

function jMidiManager_GetDeviceInfo(env: PJNIEnv; _jmidimanager: JObject;
  XmlJsonText: integer): string;
var
  jStr: JString;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  jBoo: JBoolean;
begin
  // WARNING JSON syntax should be double-checked
  result := '';
  jParams[0].i := XmlJsonText;
  jCls:= env^.GetObjectClass(env, _jmidimanager);
  jMethod:= env^.GetMethodID(env, jCls, 'getDeviceInfo', '(I)Ljava/lang/String;');
  jStr:= env^.CallObjectMethodA(env, _jmidimanager, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
  if jStr <> nil then begin
    jBoo:= JNI_False;
    result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
  end;
end;

function jMidiManager_GetDebug(env: PJNIEnv; _jmidimanager: JObject): string;
var
  jStr: JString;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  jBoo: JBoolean;
begin
  jCls:= env^.GetObjectClass(env, _jmidimanager);
  jMethod:= env^.GetMethodID(env, jCls, 'getDebug', '()Ljava/lang/String;');
  jStr:= env^.CallObjectMethod(env, _jmidimanager, jMethod);
  env^.DeleteLocalRef(env, jCls);
  if jStr <> nil then begin
    jBoo:= JNI_False;
    result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
  end;
end;

{ jMidiManager }

constructor jMidiManager.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  fPitchRange := 200; // should be checked, and may be changed!
end;

destructor jMidiManager.Destroy;
begin
  if not (csDesigning in ComponentState) then begin
    if FjObject <> nil then  begin
      jFree();
      FjObject:= nil;
    end;
  end;
  inherited Destroy;
end;

procedure jMidiManager.Init(refApp: jApp);
begin
  if FInitialized  then Exit;
  inherited Init(refApp);
  FjObject := jCreate(); if FjObject = nil then exit;
  FInitialized:= True;
end;

function jMidiManager.jCreate(): jObject;
begin
  Result:= jMidiManager_jCreate(FjEnv, FjThis , int64(Self));
end;

procedure jMidiManager.jFree();
begin
  if FInitialized then
     jMidiManager_jFree(FjEnv, FjObject);
end;

function jMidiManager.GetDeviceInfo(Kind: TDeviceInfoKind): string;
begin
  if FInitialized then
    result := jMidiManager_GetDeviceInfo(FjEnv, FjObject, ord(Kind))
  else
    result := '';
end;

function jMidiManager.GetDebug: string;
begin
  if FInitialized then
    result := jMidiManager_GetDebug(FjEnv, FjObject)
  else
    result := '';
end;

function jMidiManager.GetStatus: integer;
begin
  result := DoAction(CMD_GET_STATUS);
end;

procedure jMidiManager.GenEvent_OnOpened(Sender: TObject);
begin
  if Assigned(fOnEvent) then
    fOnEvent(Sender, 0, 1);
end;

procedure jMidiManager.GenEvent_OnEvent(Sender: TObject; info: integer; data: int64);
begin
  if assigned(fOnEvent) then
    fOnEvent(Sender, info, data);
end;

function jMidiManager.Active: boolean;
begin
  result := (OpenDeviceId>0) and (GetStatus = 3);
end;

function jMidiManager.SendMidiMessage(b1, b2, b3: integer; timestamp: int64): integer;
begin
  if FInitialized then
    result := jMidiManager_SendMidiMessage(FjEnv, FjObject, b1, b2, b3, timestamp)
  else
    result := -1;
end;

function jMidiManager.PlayChNoteVol(ch, note, vol: integer; timestamp: int64): integer;
begin
  result := SendMidiMessage($90 + ch, note, vol, timestamp);
end;

function jMidiManager.SetChVol(ch, vol: integer; timestamp: int64): integer;
begin
  result := SendMidiMessage($B0 + ch, 7, vol, timestamp);
end;

function jMidiManager.SetChPatch(ch, patch: integer; timestamp: int64): integer;
begin
  result := SendMidiMessage($C0 + ch, patch, -1, timestamp);
  //Note: -1 in the third parameter means only the first 2 bytes will be sent
end;

function jMidiManager.SetChPan(ch, pan: integer; timestamp: int64): integer;
begin
  result := SendMidiMessage($B0 + ch, 10, pan, timestamp);
end;

function jMidiManager.SetChPitch(ch, pitch: integer; timestamp: int64): integer;
begin
  result := SendMidiMessage($E0 + ch, pitch, -1, timestamp);
  //-1 in the third parameter means only the first 2 bytes will be sent
end;

function jMidiManager.SetChPitchCent(ch, cent: integer; timestamp: int64): integer;
var Pitch: integer;
begin
  Pitch := 16349 + (Cent * 16348) div fPitchRange;
  result := SetChPitch(ch, Pitch, timestamp);
end;

function jMidiManager.DoAction(_cmd: integer; _param: int64): integer;
begin
  if FInitialized then
    result := jMidiManager_DoAction(FjEnv, FjObject, _cmd, _param)
  else
    result := -1;
end;

function jMidiManager.Flush: integer;
begin
  result := DoAction(CMD_FLUSH);
end;

function jMidiManager.AllNotesOff(timestamp: int64): integer;
begin
  result := DoAction(CMD_ALL_NOTES_OFF, timestamp)
end;

function jMidiManager.Start: integer;
begin
  result := DoAction(CMD_START)
end;

function jMidiManager.MyId: string;
begin
  if Active then
    result := 'D' + IntToStr(fOpenDeviceId) + 'P' + IntToStr(fOpenPortNumber)
  else
    result := '';
end;

procedure jMidiManager.Close;
begin
  DoAction(CMD_MIDI_CLOSE);
  GenEvent_OnEvent(nil, 12, 0);
end;


function jMidiManager.GetDeviceCount(CountInput, CountOutput: boolean): integer;
var CountWhat: integer;
begin
  CountWhat := 0;
  if CountInput then
    CountWhat := CountWhat or 1;
  if CountOutput then
    CountWhat := CountWhat or 2;
  if CountWhat > 0 then
    result := DoAction(CMD_GET_DEVICE_COUNT, CountWhat)
  else
    result := 0;
end;

function jMidiManager.GetDeviceID(): integer;
begin
  result := DoAction(CMD_GET_DEVICE_ID);
end;

function jMidiManager.OpenIO(InputOutput: AnsiString; DeviceId, PortNumber: integer): integer;
var T: Int64; NewStatus: integer;
begin
  if FInitialized and (DeviceId>=0) and (PortNumber>=0) then begin
    result := jMidiManager_MidiOpen(FjEnv, FjObject,
      PChar('midiOpen'+InputOutput), DeviceId, PortNumber);
    T := GetTickCount64 + 500; // let's take half a second to check if port is opened
    repeat
      sleep(50);
      NewStatus := GetStatus;
      case NewStatus of
      2:; // wait, still pending
      3:
        begin
          fOpenDeviceId:=DeviceId;
          fOpenPortNumber := PortNumber;
          break;
        end;
      1: // failed
        begin
          fOpenDeviceId := 0;
          fOpenPortNumber := 0;
          break;
        end;
      end;
    until T < GetTickCount64;

    // because I don't know how to set up a listener to get the subesequent
    // callback, I will use a timer
    GenEvent_OnEvent(nil, 10, NewStatus);
  end
  else
    result := -1;
end;

function jMidiManager.OpenInput(DeviceId, PortNumber: integer): integer; overload;
begin
  result := OpenIO('Input', DeviceId, PortNumber)
end;

function jMidiManager.OpenOutput(DeviceId, PortNumber: integer): integer; overload;
begin
  result := OpenIO('Output', DeviceId, PortNumber);
end;

function ExtractDeviceId(MyId: string): integer;
var x1, x2: integer;
begin
  x1 := pos('D',MyId);
  x2 := pos('P',MyId);
  if (x1=1) and (x2>2) and (x2 < length(MyId)) then
    result := StrToInt(copy(MyId, X1+1, X2-X1-1))
  else
    result := -1;
end;

function ExtractPortNumber(MyId: string): integer;
var x1, x2: integer;
begin
  x1 := pos('D',MyId);
  x2 := pos('P',MyId);
  if (x1=1) and (x2>2) and (x2 < length(MyId)) then
    result := StrToInt(copy(MyId,X2+1,length(MyId)))
  else
    result := -1;
end;

function jMidiManager.OpenInput(MyId: string): integer; overload;
begin
  result := OpenInput(ExtractDeviceId(MyId), ExtractPortNumber(MyId));

end;

function jMidiManager.OpenOutput(MyId: string): integer; overload;
begin
  result := OpenOutput(ExtractDeviceId(MyId), ExtractPortNumber(MyId));
end;

procedure jMidiManager.GenEvent_OnMidiManagerDeviceAdded(Sender:TObject;deviceId:integer;deviceName:string;productId:string;manufacture:string);
begin
  if Assigned(FOnDeviceAdded) then FOnDeviceAdded(Sender,deviceId,deviceName,productId,manufacture);
end;

procedure jMidiManager.GenEvent_OnMidiManagerDeviceRemoved(Sender:TObject;deviceId:integer;deviceName:string;productId:string;manufacture:string);
begin
  if Assigned(FOnDeviceRemoved) then FOnDeviceRemoved(Sender,deviceId,deviceName,productId,manufacture);
end;

end.
