{              ----------------------------------------------
                GDBMiServerDebuggerLAMW.pas  -  Debugger class for gdbserver
               ----------------------------------------------

 This unit contains the debugger class for the GDB/MI debugger for LAMW project

 ***************************************************************************
 *                                                                         *
 *   This source is free software; you can redistribute it and/or modify   *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License, or     *
 *   (at your option) any later version.                                   *
 *                                                                         *
 *   This code is distributed in the hope that it will be useful, but      *
 *   WITHOUT ANY WARRANTY; without even the implied warranty of            *
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU     *
 *   General Public License for more details.                              *
 *                                                                         *
 *   A copy of the GNU General Public License is available on the World    *
 *   Wide Web at <http://www.gnu.org/copyleft/gpl.html>. You can also      *
 *   obtain it by writing to the Free Software Foundation,                 *
 *   Inc., 51 Franklin Street - Fifth Floor, Boston, MA 02110-1335, USA.   *
 *                                                                         *
 ***************************************************************************
}
unit GDBMIServerDebuggerLAMW;

{$mode objfpc}
{$H+}

interface

uses
  Classes, SysUtils, GDBMIDebugger, GDBMIMiscClasses, DbgIntfDebuggerBase, LCLVersion;

type

  { TGDBMIServerDebugger }

  TGDBMIServerDebuggerLAMW = class(TGDBMIDebugger)
  private
    function  GDBServerAttach(AProcessID: String): Boolean;
  protected
    function  CreateCommandInit : TGDBMIDebuggerCommandInitDebugger;   override;
    function  CreateCommandStartDebugging(AContinueCommand:TGDBMIDebuggerCommand)
                                : TGDBMIDebuggerCommandStartDebugging; override;
    procedure InterruptTarget;                                         override;
    function  RequestCommand(const ACommand : TDBGCommand;
                             const AParams  : Array of const;
                             const ACallback: TMethod): Boolean;       override;
  public
    function  GetProcessList({%H-}AList: TRunningProcessInfoList): Boolean;
                                                                       override;
                                                   // List from one PID & Name
    function  NeedReset: Boolean; override;
    class function CreateProperties: TDebuggerProperties; override;
                                                   // Creates debuggerproperties
    class function Caption: String;                                    override;
    class function RequiresLocalExecutable: Boolean;                   override;
  end;

  { TGDBMIServerDebuggerProperties }

  TGdbServerRun                      = (gsrRunAsPackageName, gsrRunAsCommand);

  TGDBMIServerDebuggerPropertiesLAMW = class(TGDBMIDebuggerPropertiesBase)
  private
    FRemote_HostName   : String;
    FRemote_Port       : String;
    FRemote_ServerRun  : TGdbServerRun;
  public
    constructor Create; override;
    procedure   Assign(Source: TPersistent);                           override;

    procedure   SetRemote_HostName (NewHost : String);                  virtual;
    procedure   SetRemote_Port     (NewPort : String);                  virtual;
    procedure   SetRemote_ServerRun(NewRun  : TGdbServerRun);           virtual;

  published
    property    Remote_HostName  : String
                       read FRemote_Hostname     write SetRemote_HostName;
    property    Remote_Port      : String
                       read FRemote_Port         write SetRemote_Port;
    property    Remote_ServerRun : TGdbServerRun
                       read FRemote_ServerRun    write SetRemote_ServerRun;

  published
    property Debugger_Startup_Options;
    {$IFDEF UNIX}
    property ConsoleTty;
    {$ENDIF}
    property MaxDisplayLengthForString;
    property MaxDisplayLengthForStaticArray;
    property MaxLocalsLengthForStaticArray;
    property TimeoutForEval;
    property WarnOnTimeOut;
    property WarnOnInternalError;
    property EncodeCurrentDirPath;
    property EncodeExeFileName;
    property InternalStartBreak;
    property UseNoneMiRunCommands;
    property DisableLoadSymbolsForLibraries;
  //property WarnOnSetBreakpointError;
    property CaseSensitivity;
    property GdbValueMemLimit;
    property GdbLocalsValueMemLimit;
    property AssemblerStyle;
    property DisableStartupShell;
    property FixStackFrameForFpcAssert;
  end;


  { TGDBMIServerDebuggerConfig }

  TGDBMIServerDebuggerConfigLAMW = class
  private
    FModifid       : Boolean;            // Data Modifid
    FProjPID       : Cardinal;           // LAMW PID
    FProjName      : String;             // LAMW project name (package name)
    FGdbServerPort : String;             // gdbserver remote hostport
    FGdbServerName : String;             // gdbserver remote hostname
    FGdbServerRun  : TGdbServerRun;      // gdbserver remote start method

    function    GetGdbServerPort      : String;                         virtual;
    procedure   SetGdbServerPort(Port : String);                        virtual;

    function    GetGdbServerName      : String;                         virtual;
    procedure   SetGdbServerName(Name : String);                        virtual;

    function    GetGdbServerRun       : TGdbServerRun;                  virtual;
    procedure   SetGdbServerRun (SRun : TGdbServerRun);                 virtual;
  public
    constructor Create;
    procedure   LoadDebuggerProperties;

    property    ProjPID       : Cardinal      read FProjPID  write FProjPID;
    property    ProjName      : String        read FProjName write FProjName;

    property    GdbServerPort : String        read GetGdbServerPort
                                                             write SetGdbServerPort;
    property    GdbServerName : String        read GetGdbServerName
                                                             write SetGdbServerName;

    property    GdbServerRun  : TGdbServerRun read GetGdbServerRun
                                                             write SetGdbServerRun;
  end;


function  GdbCfg : TGDBMIServerDebuggerConfigLAMW;

procedure Register;

implementation

uses Forms, Laz2_XMLCfg {$if lcl_fullversion > 2020600}, LazDebuggerIntfBaseTypes {$endif};

resourcestring
  GDBMiSNoAsyncMode = 'GDB does not support async mode';

type

  { TGDBMIServerDebuggerCommandInitDebugger }

  TGDBMIServerDebuggerCommandInitDebugger = class(TGDBMIDebuggerCommandInitDebugger)
  protected
    function  DoExecute: Boolean; override;
  end;

  { TGDBMIServerDebuggerCommandStartDebugging }

  TGDBMIServerDebuggerCommandStartDebugging = class(TGDBMIDebuggerCommandStartDebugging)
  protected
    function  GdbRunCommand: String;{$if lcl_fullversion<2010000}override;{$endif}
    procedure DetectTargetPid(InAttach: Boolean = False); override;
    function  DoTargetDownload: boolean; override;
  end;

  { TGDBMIServerDebuggerCommandAttach }

  TGDBMIServerDebuggerCommandAttach = class(TGDBMIDebuggerCommandAttach)
  private
     FServSucc : Boolean;
  protected
    function  DoExecute: Boolean; override;
  public
    property  ServSucc : Boolean read FServSucc;
  end;


{ TGDBMIServerDebuggerCommandStartDebugging }

function TGDBMIServerDebuggerCommandStartDebugging.GdbRunCommand: String;
begin
  Result := '-exec-continue';
end;

procedure TGDBMIServerDebuggerCommandStartDebugging.DetectTargetPid(InAttach: Boolean);
begin
  // do nothing // prevent dsError in inherited
end;

function TGDBMIServerDebuggerCommandStartDebugging.DoTargetDownload: boolean;
begin
  Result := True;
end;

{ TGDBMIServerDebuggerCommandInitDebugger }

function TGDBMIServerDebuggerCommandInitDebugger.DoExecute: Boolean;
var
  R: TGDBMIExecResult;
begin
  Result := inherited DoExecute;
  If (Not FSuccess) then Exit;

  If Not TGDBMIDebugger(FTheDebugger).AsyncModeEnabled then
    begin
      SetDebuggerErrorState(GDBMiSNoAsyncMode);
      FSuccess := False;
      Exit;
    end;

  // TODO: Maybe should be done in CommandStart, But Filename, and Environment will be done before Start
  FSuccess := ExecuteCommand(Format('target extended-remote %s:%s',
    [TGDBMIServerDebuggerPropertiesLAMW(DebuggerProperties).Remote_Hostname,
     TGDBMIServerDebuggerPropertiesLAMW(DebuggerProperties).Remote_Port      ]),
                            R);
  FSuccess := FSuccess and (R.State <> dsError);
end;


{ TGDBMIServerDebuggerCommandAttach }

function  TGDBMIServerDebuggerCommandAttach.DoExecute: Boolean;
var R1,R2,R3:TGDBMIExecResult; DirName:String;
begin
     DirName := ExtractFileDir(FTheDebugger.FileName);
   If PathDelim <> '/' then
     DirName := StringReplace(DirName, PathDelim, '/', [rfReplaceAll]);

     Result := inherited DoExecute;
  If Result and Success
    then FServSucc:=
      ExecuteCommand('set solib-search-path '+DirName,    R1)and(R1.State<>dsError)and
      ExecuteCommand('handle SIG33 nopass nostop noprint',R2)and(R2.State<>dsError)and
      ExecuteCommand('handle SIG35 nopass nostop noprint',R3)and(R3.State<>dsError)
    else FServSucc:=False;
end;


{ TGDBMIServerDebuggerProperties }

constructor TGDBMIServerDebuggerPropertiesLAMW.Create;
begin
  inherited Create;
      FRemote_Hostname     := '';
      FRemote_Port         := '2021';
      FRemote_ServerRun    := Low(TGdbServerRun);
      UseAsyncCommandMode  := True;
end;

procedure TGDBMIServerDebuggerPropertiesLAMW.Assign(Source: TPersistent);
begin
  inherited Assign(Source);
  If Source is TGDBMIServerDebuggerPropertiesLAMW then
    begin
      FRemote_HostName     :=
        TGDBMIServerDebuggerPropertiesLAMW(Source).FRemote_HostName;
      FRemote_Port         :=
        TGDBMIServerDebuggerPropertiesLAMW(Source).FRemote_Port;
      FRemote_ServerRun    :=
        TGDBMIServerDebuggerPropertiesLAMW(Source).FRemote_ServerRun;
      UseAsyncCommandMode  := True;
    end;
end;

procedure TGDBMIServerDebuggerPropertiesLAMW.SetRemote_HostName(NewHost:String);
begin
  FRemote_HostName         := NewHost;
  GdbCfg.GdbServerName     := NewHost;
end;

procedure TGDBMIServerDebuggerPropertiesLAMW.SetRemote_Port    (NewPort:String);
begin
  FRemote_Port             := NewPort;
  GdbCfg.GdbServerPort     := NewPort;
end;

procedure TGDBMIServerDebuggerPropertiesLAMW.SetRemote_ServerRun(NewRun:TGdbServerRun);
begin
  FRemote_ServerRun        := NewRun;
  GdbCfg.GdbServerRun      := NewRun;
end;

{ TGDBMIServerDebugger }

class function TGDBMIServerDebuggerLAMW.Caption: String;
begin
  Result := 'GNU remote debugger (gdbserver) LAMW';
end;

function TGDBMIServerDebuggerLAMW.GDBServerAttach(AProcessID: String): Boolean;
var
  Cmd: TGDBMIServerDebuggerCommandAttach;
begin
  Result := False;
  If State <> dsStop then Exit;
  Cmd    := TGDBMIServerDebuggerCommandAttach.Create(Self, AProcessID);
  Cmd.AddReference;
  QueueCommand(Cmd);
  Result := Cmd.ServSucc;
  If Not Result then Cmd.Cancel;
  Cmd.ReleaseReference;
end;

function TGDBMIServerDebuggerLAMW.CreateCommandInit: TGDBMIDebuggerCommandInitDebugger;
begin
  Result := TGDBMIServerDebuggerCommandInitDebugger.Create(Self);
end;

function TGDBMIServerDebuggerLAMW.CreateCommandStartDebugging(
  AContinueCommand: TGDBMIDebuggerCommand): TGDBMIDebuggerCommandStartDebugging;
begin
  Result:= TGDBMIServerDebuggerCommandStartDebugging.Create(Self, AContinueCommand);
end;

procedure TGDBMIServerDebuggerLAMW.InterruptTarget;
begin
  If Not(CurrentCmdIsAsync and (CurrentCommand <> Nil)) then Exit;
  inherited InterruptTarget;
end;

function TGDBMIServerDebuggerLAMW.NeedReset: Boolean;
begin
  Result := True;
end;

function TGDBMIServerDebuggerLAMW.GetProcessList({%H-}AList: TRunningProcessInfoList): boolean;
begin
     Result:=(GdbCfg.ProjPID <> 0) and (GdbCfg.ProjName <> '');
  If Result then AList.Add(TRunningProcessInfo.Create(GdbCfg.ProjPID, GdbCfg.ProjName));
end;{TGDBMIServerDebugger.GetProcessList}

function  TGDBMIServerDebuggerLAMW.RequestCommand(const ACommand : TDBGCommand;
                                                  const AParams  : Array of const;
                                                  const ACallback: TMethod): Boolean;
begin
  If ACommand=dcAttach then
    begin
         LockRelease;
       try
         Result := GDBServerAttach(String(AParams[0].VAnsiString));
       finally
         UnlockRelease;
       end;
    end                else
         Result := inherited RequestCommand(ACommand, AParams, ACallback)
end;

class function TGDBMIServerDebuggerLAMW.CreateProperties: TDebuggerProperties;
begin
  Result := TGDBMIServerDebuggerPropertiesLAMW.Create;
end;

class function TGDBMIServerDebuggerLAMW.RequiresLocalExecutable: Boolean;
begin
  Result := False;
end;


{ TGDBMIServerDebuggerConfig }

function    TGDBMIServerDebuggerConfigLAMW.GetGdbServerPort      : String;
begin
  LoadDebuggerProperties;
  Result := FGdbServerPort;
end;

procedure   TGDBMIServerDebuggerConfigLAMW.SetGdbServerPort(Port : String);
begin
  FGdbServerPort := Port;
  FModifid       := True;
end;

function    TGDBMIServerDebuggerConfigLAMW.GetGdbServerName      : String;
begin
  LoadDebuggerProperties;
  Result := FGdbServerName;
end;

procedure   TGDBMIServerDebuggerConfigLAMW.SetGdbServerName(Name : String);
begin
  FGdbServerName := Name;
  FModifid       := True;
end;

function    TGDBMIServerDebuggerConfigLAMW.GetGdbServerRun       : TGdbServerRun;
begin
  LoadDebuggerProperties;
  Result := FGdbServerRun;
end;

procedure   TGDBMIServerDebuggerConfigLAMW.SetGdbServerRun (SRun : TGdbServerRun);
begin
  FGdbServerRun  := SRun;
  FModifid       := True;
end;

constructor TGDBMIServerDebuggerConfigLAMW.Create;
begin
  FModifid       := False;                  // Data Modifid
  FProjPID       := 0;                      // LAMW PID
  FProjName      := '';                     // LAMW project name (package name)
  FGdbServerPort := '2021';                 // gdbserver remote hostport
  FGdbServerName := '';                     // gdbserver remote hostname
  FGdbServerRun  := Low(TGdbServerRun);     // gdbserver remote start method
end;

procedure   TGDBMIServerDebuggerConfigLAMW.LoadDebuggerProperties;
var XMLCfg: TRttiXMLConfig; FileName:String;
    DDef,Prop: TGDBMIServerDebuggerPropertiesLAMW;
begin
  If FModifid then Exit;                    // Read One time on start only

  FileName:=Application.Location+'config'+PathDelim+'environmentoptions.xml';
  try
    XMLCfg := TRttiXMLConfig.Create(Filename);
    Prop   := TGDBMIServerDebuggerPropertiesLAMW.Create;
    DDef   := TGDBMIServerDebuggerPropertiesLAMW.Create;

    XMLCfg.ReadObject(
      'EnvironmentOptions/Debugger/ClassTGDBMIServerDebuggerLAMW/Properties/',
                     Prop, DDef);

    GdbServerPort := Prop.Remote_Port;      // gdbserver remote hostport
    GdbServerName := Prop.Remote_HostName;  // gdbserver remote hostname
    GdbServerRun  := Prop.Remote_ServerRun; // gdbserver remote start method

  finally
    DDef.  Free;
    Prop.  Free;
    XMLCfg.Free;
  end;
end;

var       GdbCfgLAMW : TGDBMIServerDebuggerConfigLAMW = Nil;

function  GdbCfg     : TGDBMIServerDebuggerConfigLAMW;
begin
  If      GdbCfgLAMW = Nil
    then  GdbCfgLAMW := TGDBMIServerDebuggerConfigLAMW.Create;
  Result:=GdbCfgLAMW;
end;

procedure Register;
begin
  RegisterDebugger(TGDBMIServerDebuggerLAMW);
end;


end.


