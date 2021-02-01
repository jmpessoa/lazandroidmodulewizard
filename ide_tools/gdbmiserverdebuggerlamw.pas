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

  TGDBMIServerDebuggerPropertiesLAMW = class(TGDBMIDebuggerPropertiesBase)
  private
    FDebugger_Remote_Hostname     : String;
    FDebugger_Remote_Port         : String;
    FDebugger_Remote_DownloadExe  : Boolean;
  public
    constructor Create; override;
    procedure Assign(Source: TPersistent); override;

    procedure SetDebugger_Remote_Hostname(NewHost:String);              virtual;
    procedure SetDebugger_Remote_Port    (NewPort:String);              virtual;

  published
    property Debugger_Remote_Hostname    : String
                 read FDebugger_Remote_Hostname    write SetDebugger_Remote_Hostname;
    property Debugger_Remote_Port        : String
                 read FDebugger_Remote_Port        write SetDebugger_Remote_Port;
    property Debugger_Remote_DownloadExe : Boolean
                 read FDebugger_Remote_DownloadExe write   FDebugger_Remote_DownloadExe;
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


var
  ProjPID_LAMW  : Cardinal =      0;    // LAMW PID
  ProjNameLAMW  : String   =     '';    // LAMW project name
  GdbServerPort : String   = '2021';    // gdbserver current port
  GdbServerName : String   = '';        // gdbserver current name


procedure Register;

implementation

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
    function GdbRunCommand: String;{$if lcl_fullversion<2010000}override;{$endif}
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
  if TGDBMIServerDebuggerPropertiesLAMW(DebuggerProperties).FDebugger_Remote_DownloadExe then
  begin
    // Called after -file-exec-and-symbols, so gdb knows what file to download
    // If call sequence is different, then supply binary file name below as parameter
    Result := ExecuteCommand('-target-download', [], [cfCheckError]);
    Result := Result and (DebuggerState <> dsError);
  end;
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
                             [TGDBMIServerDebuggerPropertiesLAMW(DebuggerProperties).FDebugger_Remote_Hostname,
                              TGDBMIServerDebuggerPropertiesLAMW(DebuggerProperties).Debugger_Remote_Port ]),
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
      FDebugger_Remote_Hostname    := '192.168.34.101';
      FDebugger_Remote_Port        := GdbServerPort;
      FDebugger_Remote_DownloadExe := False;
      UseAsyncCommandMode          := True;
end;


procedure TGDBMIServerDebuggerPropertiesLAMW.Assign(Source: TPersistent);
begin
  inherited Assign(Source);
  If Source is TGDBMIServerDebuggerPropertiesLAMW then
    begin
      FDebugger_Remote_Hostname    :=
        TGDBMIServerDebuggerPropertiesLAMW(Source).FDebugger_Remote_Hostname;
      FDebugger_Remote_Port        :=
        TGDBMIServerDebuggerPropertiesLAMW(Source).FDebugger_Remote_Port;
      FDebugger_Remote_DownloadExe :=
        TGDBMIServerDebuggerPropertiesLAMW(Source).FDebugger_Remote_DownloadExe;
      UseAsyncCommandMode          := True;
      GdbServerPort                := FDebugger_Remote_Port;
    end;
end;


procedure TGDBMIServerDebuggerPropertiesLAMW.SetDebugger_Remote_Hostname(NewHost:String);
begin
  FDebugger_Remote_Hostname := NewHost;
  GdbServerName             := NewHost;
end;

procedure TGDBMIServerDebuggerPropertiesLAMW.SetDebugger_Remote_Port    (NewPort:String);
begin
  FDebugger_Remote_Port     := NewPort;
  GdbServerPort             := NewPort;
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
     Result:=(ProjPID_LAMW <> 0) and (ProjNameLAMW <> '');
  If Result then AList.Add(TRunningProcessInfo.Create(ProjPID_LAMW, ProjNameLAMW));
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


procedure Register;
begin
  RegisterDebugger(TGDBMIServerDebuggerLAMW);
end;


end.


