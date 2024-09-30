unit LamwToolKit;

{$mode objfpc}{$H+}

interface

uses
  {$ifdef unix}
  cthreads,
  {$endif}
  Classes,
  SysUtils,
  Forms,
  Controls,
  Graphics,
  Dialogs,
  ComCtrls,
  StdCtrls,
  ExtCtrls,
  process,
  UTF8Process,
  LCLType,
  Laz2_DOM,
  Laz2_XMLRead,
  Buttons, ShellCtrls, Menus,
  LamwSettings,
  uFormStartEmulator,
  ProjectIntf,
  LazFileUtils,
  LazIDEIntf,
  Types;

type

  //https://github.com/wadman/wthread/
  //https://wiki.freepascal.org/Multithreaded_Application_Tutorial#Pure_FPC_example

  TShowStatusEvent = procedure(Status: String) of Object;
  TStopStatusEvent = procedure                 of Object;

  TMyThread = class(TThread)
    private
      fStatusText  : string;
      FOnShowStatus: TShowStatusEvent;
      FOnStopStatus: TStopStatusEvent;
      procedure ShowStatus;
    protected
      procedure Execute; override;
    public
      DeviceId     : string;
      PackageName  : string;
      AdbPath      : string;
      ApkPath      : string;
      constructor Create(CreateSuspended : Boolean);
      property OnShowStatus: TShowStatusEvent read FOnShowStatus write FOnShowStatus;
      property OnStopStatus: TStopStatusEvent read FOnStopStatus write FOnStopStatus;
  end;

  { TToolKit }

  TToolKit = class(TForm)
    ComboDevices: TComboBox;
    GroupBox1: TGroupBox;
    ImageList1: TImageList;
    Label1: TLabel;
    Memo1: TMemo;
    Panel1: TPanel;
    BtnUpdate: TSpeedButton;
    BtnRun: TSpeedButton;
    RadioBits: TRadioGroup;
    procedure ComboDevicesChange(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure BtnRunClick(Sender: TObject);
    procedure BtnUpdateClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure MyThreadStop;
    procedure RunApk(DeviceId: string;
                     PackageName: string;
                     AdbPath:string;
                     ApkPath: string);

  private
    FDevices: TStringList;
    FProjPath: String;
    FPackageName: String;
    FAdbPath: string;
    FDeviceId: string;
    FApkPath: string;

    FBuildSystem: string; //Ant or Gradle

    MyThread: TMyThread;
    procedure ShowStatus(Status: string);

    procedure FillComboDevices;
    procedure DiscoverDevices;

    function GetApkPath(): string;
    function GetPackageName(): String;
    function GetManufacturer(manufacturerDevice: String): String;
    function GetModel(numberDevice: String): String;

  end;

var
  ToolKit: TToolKit;

implementation

{$R *.lfm}

constructor TMyThread.Create(CreateSuspended : boolean);
begin
  inherited Create(CreateSuspended);
  FreeOnTerminate := True;
  FOnStopStatus   := Nil;
  FOnStopStatus   := Nil;
end;

//https://gist.github.com/Pulimet/5013acf2cd5b28e55036c82c91bd56d8    --> adb commands...
procedure TMyThread.Execute;
var
  outLog: string;
  done: boolean;
begin
   fStatusText := 'Try install "'+PackageName+'" wait...';
   Synchronize(@Showstatus);
   done:= False;
   while (not Terminated) and (not done) do
   begin
        //here goes the code of the main thread loop]
        RunCommand(AdbPath, ['-s', DeviceId, 'uninstall', PackageName], outLog, [poUsePipes, poNoConsole]);

        fStatusText := outLog;
        Synchronize(@Showstatus);

        if Pos('Success', outLog) > 0 then
        begin
           fStatusText := 'Uninstalled! wait...';
           Synchronize(@Showstatus);
        end;

        if RunCommand(AdbPath, ['-s', DeviceId, 'install', ApkPath], outLog, [poUsePipes, poNoConsole]) then
        begin
            fStatusText := outLog;
            Synchronize(@Showstatus);

            if Pos('Success', outLog) > 0 then
            begin
               fStatusText := 'Installed! wait...';
               Synchronize(@Showstatus);
            end;

            {
            RunCommand(AdbPath, ['-s', DeviceId, 'shell', 'monkey', '-p',
                       PackageName, '-c', 'android.intent.category.LAUNCHER', '1'], outLog,
                       [poUsePipes, poNoConsole]);
            }

             //adb shell monkey -p your.app.package.name 1
            RunCommand(AdbPath, ['-s', DeviceId, 'shell', 'monkey', '-p',
                       PackageName, '1'], outLog,
                       [poUsePipes, poNoConsole]);

            fStatusText := outLog;
            Synchronize(@Showstatus);

            fStatusText := 'Done!';
            Synchronize(@Showstatus);
        end;

        done:= True;
   end; //while

   If Assigned(FOnStopStatus) then FOnStopStatus;
end;

procedure TMyThread.ShowStatus;
  // this method is executed by the mainthread and can therefore access all GUI elements.
begin
    if Assigned(FOnShowStatus) then
    begin
      FOnShowStatus(fStatusText);
    end;
end;


procedure TToolKit.ShowStatus(Status: string);
begin
  Memo1.Lines.Add(Status);

  if Pos('Done!', Status) > 0  then
     BtnRun.Enabled:= True;

end;

procedure TToolKit.ComboDevicesChange(Sender: TObject);
begin
  //if BtnRun.Enabled then
     RadioBits.ItemIndex:= -1;
end;

procedure TToolKit.FormActivate(Sender: TObject);
var
  FProj: TLazProject;
  sdkPath: string;
begin
  if FDevices = nil then
    FDevices := TStringList.Create;

  FProj := LazarusIDE.ActiveProject;
  FProjPath := ExtractFilePath(ChompPathDelim(ExtractFilePath(FProj.MainFile.Filename)));
  FBuildSystem:= LazarusIDE.ActiveProject.CustomData.Values['BuildSystem'];

  sdkpath:= LamwGlobalSettings.PathToAndroidSDK;
  FAdbPath:= IncludeTrailingPathDelimiter(sdkPath) + 'platform-tools' + PathDelim + 'adb';

  FPackageName:= GetPackageName();

  RadioBits.ItemIndex:= -1;

  DiscoverDevices;
  FillComboDevices;
end;

function TToolKit.GetApkPath(): string;
var
  smallProjectName, auxPath, apkPath: String;
  instructionChip, DebugOrRelease, final: String;
  p: integer;
begin

  auxPath:= Copy(FProjPath, 1, Length(FProjPath)-1);
  p:= LastDelimiter(PathDelim,auxPath);
  smallProjectName:= Copy(auxPath, p+1 , MaxInt);

  instructionChip:= ExtractFileDir(LazarusIDE.ActiveProject.LazCompilerOptions.TargetFilename);
  instructionChip:= ExtractFileName(instructionChip);  //armeabi-v7a

  case RadioBits.ItemIndex of
    0:  //Debug:
      begin
       DebugOrRelease := 'debug';
       final := '-debug.apk';
      end;
    1: //Release:
    begin
      DebugOrRelease := 'release';
      final:= '-release-unsigned.apk';
       //Failure [INSTALL_PARSE_FAILED_NO_CERTIFICATES: Failed to collect certificates
       //from /data/app/vmdl1333619077.tmp/base.apk: Attempt to get length of null array]

       // vou deixar o ComboBoxBits desabilitado por enquanto, qualquer coisa, pode tirar a visibilidade
    end;
  end;

  if FBuildSystem = 'Gradle' then
     apkPath := FProjPath + 'build'+ PathDelim + 'outputs' + PathDelim + 'apk' + PathDelim +
             DebugOrRelease + PathDelim + smallProjectName + '-' + instructionChip + final
  else //Ant
     apkPath:= FProjPath + 'bin'+ PathDelim +
             smallProjectName + final;

  if FileExists(apkPath) then
    Result := apkPath
  else
    Result := '';

end;

procedure TToolKit.DiscoverDevices;
var
  adb: TProcessUTF8;
  i: integer;
begin

  if  FAdbPath <> '' then
  begin

    adb := TProcessUTF8.Create(nil);
    try
      adb.Options := [poUsePipes, poStderrToOutPut, poWaitOnExit];
      adb.Executable := FAdbPath;
      adb.Parameters.Text := 'devices';
      adb.ShowWindow := swoHIDE;
      adb.Execute;

      FDevices.LoadFromStream(adb.Output);
      FDevices.Delete(FDevices.Count-1);

      i := 0;
      while (i < FDevices.Count) do
      begin
        if FDevices[i].Contains('*') or FDevices[i].Contains('List') then
        begin
          FDevices.Delete(i);
          Continue;
        end;
        i := i + 1;
      end;

      for i:=0 to FDevices.Count-1 do
      begin
        FDevices[i] := StringReplace(FDevices[i], 'device', '', [rfReplaceAll]);
        FDevices[i] := Trim(FDevices[i]);
      end;

    finally
      adb.Free;
    end;
  end;
end;

procedure TToolKit.FillComboDevices;
var
  i: integer;
  model: String;
begin
  ComboDevices.Clear;
  for i:=0 to FDevices.Count-1 do
  begin
    model := Format('%s - %s', [GetManufacturer(FDevices[i]), GetModel(FDevices[i])]);
    ComboDevices.Items.AddPair(model, FDevices[i]);
  end;
  ComboDevices.ItemIndex := 0;
end;

function TToolKit.GetModel(numberDevice: String): String;
var
  adb: TProcessUTF8;
  model: TStringList;
begin
  adb := TProcessUTF8.Create(nil);
  try
    adb.Options := [poUsePipes, poStderrToOutPut, poWaitOnExit];
    adb.Executable := FAdbPath;
    adb.Parameters.Add('-s');
    adb.Parameters.Add(numberDevice);
    adb.Parameters.Add('shell');
    adb.Parameters.Add('getprop');
    adb.Parameters.Add('ro.product.model');
    adb.ShowWindow := swoHIDE;
    adb.Execute;

    model := TStringList.Create;
    model.LoadFromStream(adb.Output);
    Result := model[0];
  finally
    adb.Free;
    model.Free;
  end;
end;

function TToolKit.GetManufacturer(manufacturerDevice: String): String;
var
  adb: TProcessUTF8;
  manufacturer: TStringList;
begin
  adb := TProcessUTF8.Create(nil);
  try
    adb.Options := [poUsePipes, poStderrToOutPut, poWaitOnExit];
    adb.Executable := FAdbPath;
    adb.Parameters.Add('-s');
    adb.Parameters.Add(manufacturerDevice);
    adb.Parameters.Add('shell');
    adb.Parameters.Add('getprop');
    adb.Parameters.Add('ro.product.manufacturer');
    adb.ShowWindow := swoHIDE;
    adb.Execute;

    manufacturer := TStringList.Create;
    manufacturer.LoadFromStream(adb.Output);
    Result := manufacturer[0];
  finally
    adb.Free;
    manufacturer.Free;
  end;
end;

function TToolKit.GetPackageName(): String;
var
  xml:TXMLDocument;
begin
  If FPackageName <> '' then
  begin
    Result := FPackageName;
    Exit;
  end else
    Result := '';
  try
    ReadXMLFile(xml, FProjPath + PathDelim + 'AndroidManifest.xml');
    Result := xml.DocumentElement.AttribStrings['package'];
    If Result = '' then
      raise Exception.Create('Cannot determine package name!')
    else
      FPackageName:= Result;
  finally
    xml.Free;
  end;
end;

procedure TToolKit.MyThreadStop;
begin
  MyThread := Nil;
end;

procedure TToolKit.RunApk(
                   DeviceId: string;
                   PackageName: string;
                   AdbPath:string;
                   ApkPath: string);
begin
  If          MyThread <> Nil then
    begin
      If Not  MyThread.Terminated then
              MyThread.Terminate;
// This is also not safe code, since after the first check MyThread <> Nil
// the thread may finish executing and the reference will already be zeroed,
// but in 99% of scenarios this can be ignored
// "FreeOnTerminate is true [default]" so we should not write: MyThread.Free;
// At the same time, no one will install a link to the stream  MyThread:=Nil
// Only Call from TMyThread FOnStopStatus can do this
      While   MyThread <> Nil do Sleep(100);
// If the thread hangs, it will be an infinite loop
    end;
              MyThread := TMyThread.Create(True);
  {$ifdef windows}
  If Assigned(MyThread.FatalException) then
       raise  MyThread.FatalException;
  {$endif}
              MyThread.OnShowStatus := @ShowStatus;
              MyThread.OnStopStatus := @MyThreadStop;
              MyThread.DeviceId     := DeviceId;
              MyThread.PackageName  := PackageName;
              MyThread.AdbPath      := AdbPath;
              MyThread.ApkPath      := ApkPath;
              MyThread.Start;
end;

procedure TToolKit.BtnRunClick(Sender: TObject);
begin
  if RadioBits.ItemIndex < 0 then
  begin
    ShowMessage('Please, select "Debug" or "Release"');
    Exit;
  end;

  FDeviceId:= ComboDevices.Items.ValueFromIndex[ComboDevices.ItemIndex];
  FApkPath:= GetApkPath();
  if FApkPath <> '' then
  begin
     Memo1.Lines.Clear;
     BtnRun.Enabled:= False;
     RunApk(FDeviceId,
            FPackageName,   //form create
            FAdbPath,       //form create
            FApkPath);

  end
  else
     ShowMessage('Sorry... ['+FPackageName+'] not Found...' + sLIneBreak + sLIneBreak +
                 'Hint: try first "[LAMW] Build Android Apk and Run"');

end;

procedure TToolKit.BtnUpdateClick(Sender: TObject);
begin   //reset...
  Memo1.Lines.Clear;
  RadioBits.ItemIndex:= -1;
  DiscoverDevices;
  FillComboDevices;
end;

procedure TToolKit.FormDestroy(Sender: TObject);
begin
  if FDevices <> nil then
     FDevices.Free;

  if MyThread <> nil then
  begin
    if (not MyThread.Terminated) then
      MyThread.Terminate; //"FreeOnTerminate is true" so we should not write: MyThread.Free;
  end;

  inherited;
end;

procedure TToolKit.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin

  if MyThread <> nil then
  begin
    if (not MyThread.Terminated) then
      MyThread.Terminate; //"FreeOnTerminate is true" so we should not write: MyThread.Free;
  end;

  CloseAction := caFree;
end;


end.









