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
  Classes,       SysUtils,
  GDBMIDebugger, GDBMIMiscClasses, DbgIntfDebuggerBase, LCLVersion;

type
  { TGDBMIServerDebuggerLAMW }

  TGDBMIServerDebuggerLAMW = class(TGDBMIDebugger)
  private
    function       GDBServerAttach(AProcessID: String): Boolean;
  protected
    function       CreateCommandInit : TGDBMIDebuggerCommandInitDebugger;
                                                                       override;
    function       CreateCommandStartDebugging(AContinueCommand:TGDBMIDebuggerCommand)
                                : TGDBMIDebuggerCommandStartDebugging; override;
    procedure      InterruptTarget;                                    override;

    function       RequestCommand(const ACommand : TDBGCommand;
                                  const AParams  : Array of const;
                                  const ACallback: TMethod): Boolean;  override;
  public
    constructor    Create(const AExternalDebugger: String);            override;

    destructor     Destroy;                                            override;

    function       GetProcessList({%H-}AList: TRunningProcessInfoList): Boolean;
                                                                       override;
                                                   // List from one PID & Name
    function       NeedReset: Boolean;                                 override;

    class function CreateProperties: TDebuggerProperties;              override;
                                                   // Creates debuggerproperties
    class function Caption: String;                                    override;

    class function RequiresLocalExecutable: Boolean;                   override;
  end;


  { TGDBMIServerDebuggerProperties }

  TGdbServerRun  = (gsrRunAsPackageName, gsrRunAsCommand);
  TGdbProcAttach = (gpaAutoDetermVerGDB, gpaInitBeforeConnect,  gpaConnectBeforeInit);
  TGdbCleanExec  = (gceAutoDetermVerGDB, gceClneanBeforeAttach, gceNotClnBeforeAttach);
  TGdbCopGdbServ = (gcsAutoDeterminate,  gcsUseInProjGdbServ,   gcsCopyGdbServFromNDK);

  TGDBMIServerDebuggerPropertiesLAMW = class(TGDBMIDebuggerPropertiesBase)
  private
    FRemote_HostName   : String;
    FRemote_Port       : String;
    FRemote_ServerRun  : TGdbServerRun;
    FRemote_ProcAttach : TGdbProcAttach;
    FRemote_CleanExec  : TGdbCleanExec;
    FRemote_CopGdbServ : TGdbCopGdbServ;

  public
    constructor Create;                                                override;

    procedure   Assign              (Source  : TPersistent);           override;

    procedure   SetRemote_HostName  (NewHost : String);                 virtual;

    procedure   SetRemote_Port      (NewPort : String);                 virtual;

    procedure   SetRemote_ServerRun (NewRun  : TGdbServerRun);          virtual;

    procedure   SetRemote_ProcAttach(NewAth  : TGdbProcAttach);         virtual;

    procedure   SetRemote_CleanExec (NewCln  : TGdbCleanExec);          virtual;

    procedure   SetRemote_CopGdbServ(NewCop  : TGdbCopGdbServ);         virtual;

  published
    property    Remote_HostName   : String
                       read FRemote_Hostname       write SetRemote_HostName;
    property    Remote_Port       : String
                       read FRemote_Port           write SetRemote_Port;
    property    Remote_ServerRun  : TGdbServerRun
                       read FRemote_ServerRun      write SetRemote_ServerRun;
    property    Remote_ProcAttach : TGdbProcAttach
                       read FRemote_ProcAttach     write SetRemote_ProcAttach;
    property    Remote_CleanExec  : TGdbCleanExec
                       read FRemote_CleanExec      write SetRemote_CleanExec;
    property    Remote_CopGdbServ : TGdbCopGdbServ
                       read FRemote_CopGdbServ     write SetRemote_CopGdbServ;
  published
    property    Debugger_Startup_Options;
    {$IFDEF UNIX}
    property    ConsoleTty;
    {$ENDIF}
    property    MaxDisplayLengthForString;
    property    MaxDisplayLengthForStaticArray;
    property    MaxLocalsLengthForStaticArray;
    property    TimeoutForEval;
    property    WarnOnTimeOut;
    property    WarnOnInternalError;
    property    EncodeCurrentDirPath;
    property    EncodeExeFileName;
    property    InternalStartBreak;
    property    UseNoneMiRunCommands;
    property    DisableLoadSymbolsForLibraries;
  //property    WarnOnSetBreakpointError;
    property    CaseSensitivity;
    property    GdbValueMemLimit;
    property    GdbLocalsValueMemLimit;
    property    AssemblerStyle;
    property    DisableStartupShell;
    property    FixStackFrameForFpcAssert;
//  property    InternalExceptionBreakPoints;
  end;


  { TGDBMIServerDebuggerConfig }

  TGDBMIServerDebuggerConfigLAMW = class
  private
    FLogList       : TStringList;        // Log List
    FModifid       : Boolean;            // Data Modifid
    FProjPID       : Cardinal;           // LAMW PID
    FProjName      : String;             // LAMW project name (package name)
    FProjPath      : String;             // LAMW project path
    FGdbServerPort : String;             // gdbserver remote hostport
    FGdbServerName : String;             // gdbserver remote hostname
    FGdbServerRun  : TGdbServerRun;      // gdbserver remote start method
    FGdbProcAttach : TGdbProcAttach;     // target process attach  method
    FGdbCleanExec  : TGdbCleanExec;      // clean exe file inform before attach
    FGdbCopGdbServ : TGdbCopGdbServ;     // copy NDK gdbserver to target

    function    GetGdbServerPort      : String;                         virtual;
    procedure   SetGdbServerPort(Port : String);                        virtual;

    function    GetGdbServerName      : String;                         virtual;
    procedure   SetGdbServerName(Name : String);                        virtual;

    function    GetGdbServerRun       : TGdbServerRun;                  virtual;
    procedure   SetGdbServerRun (SRun : TGdbServerRun);                 virtual;

    function    GetGdbProcAttach      : TGdbProcAttach;                 virtual;
    procedure   SetGdbProcAttach(SAth : TGdbProcAttach);                virtual;

    function    GetGdbCleanExec       : TGdbCleanExec;                  virtual;
    procedure   SetGdbCleanExec (SCln : TGdbCleanExec);                 virtual;

    function    GetGdbCopGdbServ      : TGdbCopGdbServ;                 virtual;
    procedure   SetGdbCopGdbServ(SCop : TGdbCopGdbServ);                virtual;

  public
    constructor Create;

    procedure   LoadDebuggerProperties;

    procedure   LogStr(const Info : String);                           overload;

    procedure   LogStr(const Frmt : String;
                       const Args : Array of const);                   overload;

    procedure   LogCmd(const Cmnd : String;
                       const Args : Array of const;
                             R    : TGDBMIExecResult);                 overload;

    procedure   LogCmd(const Cmnd : String;
                             R    : TGDBMIExecResult);                 overload;

    procedure   SaveLogListToFile;

    property    ProjPID       : Cardinal       read FProjPID  write FProjPID;

    property    ProjName      : String         read FProjName write FProjName;

    property    ProjPath      : String         read FProjPath write FProjPath;

    property    GdbServerPort : String         read GetGdbServerPort
                                                              write SetGdbServerPort;
    property    GdbServerName : String         read GetGdbServerName
                                                              write SetGdbServerName;
    property    GdbServerRun  : TGdbServerRun  read GetGdbServerRun
                                                              write SetGdbServerRun;
    property    GdbProcAttach : TGdbProcAttach read GetGdbProcAttach
                                                              write SetGdbProcAttach;
    property    GdbCleanExec  : TGdbCleanExec  read GetGdbCleanExec
                                                              write SetGdbCleanExec;
    property    GdbCopGdbServ : TGdbCopGdbServ read GetGdbCopGdbServ
                                                              write SetGdbCopGdbServ;
  end;


function  GdbCfg : TGDBMIServerDebuggerConfigLAMW;

procedure Register;

implementation

uses Forms, Laz2_XMLCfg, LazStringUtils, GdbmiStringConstants
  {$if lcl_fullversion > 2020600}, LazDebuggerIntfBaseTypes {$endif};

resourcestring
  GDBMiSNoAsyncMode = 'GDB does not support async mode';

const    lamwDBGState      : Array  [TDBGState]        of String =
  ('dsNone', 'dsIdle', 'dsStop',  'dsPause',     'dsInternalPause',
   'dsInit', 'dsRun',  'dsError', 'dsDestroying');

function lamwGDBMIResFlagStr(Flags : TGDBMIResultFlags) : String;
begin
  If rfNoMI        in Flags then Result :=              'rfNoMI'
                            else Result :=              '';
  If rfAsyncFailed in Flags then
    begin
      If Result <> '' then       Result :=     Result + ', ';
                                 Result :=     Result + 'rfAsyncFailed';
    end;
                                 Result := '['+Result+']';
 end;

type                        TGdbVersionIdx = (gdb_7_7, gdb_8_3, gdb_15_1);

const
  lamwDBGAttachTyps : Array[TGdbVersionIdx] of
    Record
      VersMajor     : Integer;
      VersMinor     : Integer;
      ProcAttach    : TGdbProcAttach;
      CleanExec     : TGdbCleanExec;
    end                                     =
    (
// ------------- GNU gdb (GDB)  7.7 from android-ndk-r10e ----------------------
     (VersMajor     :  7;
      VersMinor     :  7;
      ProcAttach    : gpaConnectBeforeInit;
      CleanExec     : gceClneanBeforeAttach),
// ------------- GNU gdb (GDB)  8.3 from android-ndk-r21e ----------------------
     (VersMajor     :  8;
      VersMinor     :  3;
      ProcAttach    : gpaInitBeforeConnect;
      CleanExec     : gceNotClnBeforeAttach),
// ------------- GNU gdb (GDB) 15.1 (gdb-multiarch) ----------------------------
     (VersMajor     : 15;
      VersMinor     :  1;
      ProcAttach    : gpaInitBeforeConnect;
      CleanExec     : gceNotClnBeforeAttach)
    );

type

  { TGDBMIServerDebuggerCommandInitDebugger }

  TGDBMIServerDebuggerCommandInitDebugger = class(TGDBMIDebuggerCommandInitDebugger)
  protected
    function  DoExecute: Boolean;                                      override;
  end;


  { TGDBMIServerDebuggerCommandStartDebugging }

  TGDBMIServerDebuggerCommandStartDebugging = class(TGDBMIDebuggerCommandStartDebugging)
  protected
    function  GdbRunCommand    : TGDBMIExecCommandType;                override;
    procedure DetectTargetPid(InAttach : Boolean = False);             override;
    function  DoTargetDownload : Boolean;                              override;
  end;


  { TGDBMIServerDebuggerCommandAttach }

  TGDBMIServerDebuggerCommandAttach = class(TGDBMIDebuggerCommandAttach)
  private
     FProcStrID        : String;
     FServSucc         : Boolean;
     FGdbProcAttach    : TGdbProcAttach; // target process attach  method
     FGdbCleanExec     : TGdbCleanExec;  // clean exe file inform before attach
//------------------------------------------------------------------------------
     FGDBVersion       : String;
     FGDBVersionMajor,
     FGDBVersionMinor,
     FGDBVersionRev    : Integer;
//------------------------------------------------------------------------------
  protected
    function    GetGdbVersion          : Boolean;
    function    ExecCmd(const ACommand : String;
                        const AValues  : Array of const;
                          out AResult  : TGDBMIExecResult;
                              AFlags   : TGDBMICommandFlags = [];
                              ATimeOut : Integer            = -1)
                                       : Boolean;
    function    DoAttach               : Boolean;                       virtual;
    function    DoExecute              : Boolean;                      override;
    procedure   SetGdbProcAttach
                      (AProcAttach     : TGdbProcAttach);               virtual;
    procedure   SetGdbCleanExec
                      (ACleanExec      : TGdbCleanExec );               virtual;
  public
    constructor Create(AOwner          : TGDBMIDebuggerBase;
                       AProcessID      : String);
    property    ServSucc               : Boolean        read  FServSucc;
    property    GdbProcAttach          : TGdbProcAttach read  FGdbProcAttach
                                                        write SetGdbProcAttach;
    property    GdbCleanExec           : TGdbCleanExec  read  FGdbCleanExec
                                                        write SetGdbCleanExec;
  end;


  { TGDBMIServerDebuggerCommandStartDebugging }

function TGDBMIServerDebuggerCommandStartDebugging.GdbRunCommand: TGDBMIExecCommandType;
begin
  Result := ectContinue; // Call '-exec-continue';
//------------------------------------------------------------------------------
//GdbCfg.LogStr('GDB Command = ectContinue');
//------------------------------------------------------------------------------
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
begin
  Result := inherited DoExecute;
  If (Not FSuccess) then Exit;

  If Not TGDBMIDebugger(FTheDebugger).AsyncModeEnabled then
    begin
      SetDebuggerErrorState(GDBMiSNoAsyncMode);
      FSuccess := False;
      Exit;
    end;
end;


  { TGDBMIServerDebuggerCommandAttach }

constructor TGDBMIServerDebuggerCommandAttach.Create
                  (AOwner : TGDBMIDebuggerBase; AProcessID : String);
begin
  inherited Create(AOwner, AProcessID);
      FProcStrID    :=     AProcessID;
      FServSucc     :=     False;
      GetGdbVersion;
  With TGDBMIServerDebuggerPropertiesLAMW(DebuggerProperties) do
    begin
      GdbProcAttach :=     Remote_ProcAttach;
      GdbCleanExec  :=     Remote_CleanExec;
    end;
end;

function   TGDBMIServerDebuggerCommandAttach.GetGdbVersion : Boolean;
// -----------------------------------------------------------------------------
//  Unfortunately the GNU gdb debugger version is declared as a private field,
//    so I had to define it again
// -----------------------------------------------------------------------------
  function StoreGdbVersionAsNumber: Boolean;
  var I: Integer; S: String;
  begin
    Result           := False;
    FGDBVersionMajor := -1;
    FGDBVersionMinor := -1;
    FGDBVersionRev   := -1;
    S := FGDBVersion;
// ------------------- Remove none leading digits ------------------------------
           I := 1;
    While (I <= Length(S)) and Not (S[i] in ['0'..'9']) do Inc(I);
    Delete(S, 1, I - 1);
    If     S = '' then Exit;
    FGDBVersion := S;
// ------------------- Major ---------------------------------------------------
           I := 1;
    While (I <= Length(S)) and     (S[I] in ['0'..'9']) do Inc(I);
    If (I = 1) or (I > Length(s)) or (S[I] <> '.') then Exit;
    FGDBVersionMajor := StrToIntDef(Copy(S, 1, I - 1), -1);
    If I < 0 then Exit;
    Delete(S, 1, I);
// ------------------- Minor ---------------------------------------------------
           I := 1;
    While (I <= Length(S)) and     (S[I] in ['0'..'9']) do Inc(I);
    If     I  = 1 then Exit;
    FGDBVersionMinor := StrToIntDef(Copy(S, 1, I - 1), -1);
    Result           := True;
    If (I > Length(S)) or (S[I] <> '.') then Exit;
    Delete(S, 1, I);
// ------------------- Rev -----------------------------------------------------
           I := 1;
    While (I <= Length(S)) and (S[I] in ['0'..'9']) do Inc(I);
    If     I  = 1 then exit;
    FGDBVersionRev   := StrToIntDef(Copy(S, 1, I - 1), -1);
  end;

  function ParseGDBVersionMI: Boolean;
  var R:TGDBMIExecResult; List:TGDBMINameValueList;
  begin
           Result := ExecCmd('-gdb-version', [], R) and ({%H-}R.Values <> '');
    If Not Result then Exit;
    List          := TGDBMINameValueList.Create(R);
    FGDBVersion   := List.Values['version'];
    List.Free;
    If StoreGdbVersionAsNumber then Exit;
{$IFDEF WINDOWS}
    FGDBVersion := GetPart(['GNU gdb unicode (GDB)'],
                                              [#10, #13], R.Values, False, False);
    If StoreGdbVersionAsNumber then Exit;
{$ENDIF}
    FGDBVersion := GetPart(['GNU gdb (GDB)'], [#10, #13], R.Values, False, False);
    If StoreGdbVersionAsNumber then Exit;

    FGDBVersion := GetPart(['GNU gdb '     ], [#10, #13], R.Values, False, False);
    If StoreGdbVersionAsNumber then Exit;

    FGDBVersion := GetPart(['('],             [')'],      R.Values, False, False);
    If StoreGdbVersionAsNumber then Exit;

    FGDBVersion := GetPart(['gdb '],          [#10, #13], R.Values, True,  False);
    If StoreGdbVersionAsNumber then Exit;

// -------------- Retry, but do not check for format (old behaviour) -----------
    FGDBVersion := GetPart(['('],             [')'],      R.Values, False, False);
       StoreGdbVersionAsNumber;

    If FGDBVersion <> '' then Exit;
    FGDBVersion := GetPart(['gdb '],          [#10, #13], R.Values, True,  False);
       StoreGdbVersionAsNumber;
    Result := False;
  end;

begin
  ParseGDBVersionMI;
//------------------------------------------------------------------------------
  GdbCfg.LogStr('GDB Version Major = "%d", Minor = "%d"',
            [FGDBVersionMajor,            FGDBVersionMinor]);
//------------------------------------------------------------------------------
  Result := (FGDBVersionMajor <> -1) and (FGDBVersionMinor <> -1)
end;

procedure   TGDBMIServerDebuggerCommandAttach.SetGdbProcAttach(AProcAttach : TGdbProcAttach);
var       I:TGdbVersionIdx;
begin
  If AProcAttach = gpaAutoDetermVerGDB then
    begin
      For I:=Low(I) to High(I) do
        With lamwDBGAttachTyps[I] do
          If (VersMajor=FGDBVersionMajor)and(VersMinor=FGDBVersionMinor) then
            begin
              FGdbProcAttach  :=  ProcAttach;
              Exit;
            end;
              FGdbProcAttach  :=  gpaInitBeforeConnect;
    end                                else
              FGdbProcAttach  := AProcAttach;
end;

procedure   TGDBMIServerDebuggerCommandAttach.SetGdbCleanExec (ACleanExec  : TGdbCleanExec );
var       I:TGdbVersionIdx;
begin
  If ACleanExec  = gceAutoDetermVerGDB then
    begin
      For I:=Low(I) to High(I) do
        With lamwDBGAttachTyps[I] do
          If (VersMajor=FGDBVersionMajor)and(VersMinor=FGDBVersionMinor) then
            begin
              FGdbCleanExec   :=  CleanExec;
              Exit;
            end;
              FGdbCleanExec   :=  gceClneanBeforeAttach;
    end                                else
              FGdbCleanExec   := ACleanExec;
end;

function    TGDBMIServerDebuggerCommandAttach.ExecCmd
                    (const ACommand : String;
                     const AValues  : Array of const;
                     out   AResult  : TGDBMIExecResult;
                           AFlags   : TGDBMICommandFlags = [];
                           ATimeOut : Integer            = -1) : Boolean;
begin
  Result := ExecuteCommand(ACommand, AValues, AResult, AFlags, ATimeOut);
  GdbCfg.LogCmd           (ACommand, AValues, AResult                  );
end;

function  TGDBMIServerDebuggerCommandAttach.DoAttach : Boolean;
var R:TGDBMIExecResult; StoppedParams,CmdResp,S,FileType:String;
    NewPID:Integer; List:TGDBMINameValueList;
begin
  Result := False;
//---------------- Clean file-exec-and-symbol before attach --------------------
  If GdbCleanExec = gceClneanBeforeAttach then
    begin
      If Not ExecCmd       ('-file-exec-and-symbols %s',
        [TGDBMIServerDebuggerLAMW(FTheDebugger).ConvertToGDBPath('', cgptExeName)],
         R)                 then
         R.State := dsError;
      If R.State  = dsError then
        begin
          SetDebuggerErrorState('Attach failed');
          Exit;
        end;
    end;
//---------------- Service functions -------------------------------------------
  DefaultTimeOut          := DebuggerProperties.TimeoutForEval;
  TargetInfo^.TargetFlags := [tfHasSymbols];
                   // Set until proven otherwise
  ExecCmd       ('-gdb-set language pascal', [], R, [cfCheckError]);
                   // TODO: Maybe remove, must be done after attach
  SetDebuggerState(dsInit);
                   // triggers all breakpoints to be set.
  Application.ProcessMessages;
                   // workaround, allow source-editor to queue line info request
                   //   (Async call)
//---------------- Attach to Target Remote process = FProcStrID ----------------
  If Not ExecCmd       ('attach %s', [FProcStrID], R) then
     R.State := dsError;
  If R.State  = dsError  then
    begin
         ExecCmd       ('detach',    [],           R);
         SetDebuggerErrorState('Attach failed'      );
         Exit;
    end;
//---------------- Save text result of Attach command --------------------------
  CmdResp := R.Values;
//---------------- Set Debugger Current State to R.State -----------------------
  If R.State <> dsNone  then SetDebuggerState(R.State);
//---------------- Try Stop running program ------------------------------------
  If R.State =  dsRun   then
    begin
      ProcessRunning        (StoppedParams,        R);
      CmdResp   := CmdResp + StoppedParams    +    R.Values;
      If R.State = dsError then
        begin
          ExecCmd       ('detach',   [],           R);
          SetDebuggerErrorState('Attach failed'     );
          Exit;
        end;
    end;
//------------------------------------------------------------------------------
//GdbCfg.LogStr('CmdResp = "%s"', [CmdResp]);
//---------------- Save remote process PID to TargetInfo -----------------------
        NewPID := 0;
     S := GetPart(['Attaching to process '], [LineEnding, '.'],CmdResp,True,False);
  If S <> ''        then
        NewPID := StrToIntDef(S, 0);
  If    NewPID  = 0 then
    begin
         S := GetPart(['=thread-group-started,'], [LineEnding],CmdResp,True,False);
      If S <> ''    then
         S := GetPart(['pid="'], ['"'], S, True, False);
      If S <> ''    then
        NewPID := StrToIntDef(S, 0);
    end;
  If    NewPID  = 0 then
        NewPID := StrToIntDef(FProcStrID, 0);
  If    NewPID <> 0 then
    TargetInfo^.TargetPID := NewPID;
  If    NewPID  = 0 then
    DetectTargetPid(True);
//------------------------------------------------------------------------------
//GdbCfg.LogStr('Remote PID = "%d"', [NewPID]);
//------------------------------------------------------------------------------
  Include(TargetInfo^.TargetFlags, tfPidDetectionDone);
  If TargetInfo^.TargetPID = 0 then
    begin
      ExecCmd       ('detach', [], R);
      SetDebuggerErrorState(Format(gdbmiCommandStartMainRunNoPIDError, [LineEnding]));
      Exit;
    end;
//---------------- Setup gdb configuration -------------------------------------
  DoSetPascal;
  DoSetCaseSensitivity;
  DoSetMaxValueMemLimit;
  DoSetAssemblerStyle;
//---------------- Setup -file-exec-and-symbols = FileName after attach --------
  If (FTheDebugger.FileName <> '') and
     (PosI('reading symbols from', CmdResp) < 1) then
    begin
      ExecCmd       ('ptype TObject', [], R);
      If PosI('no symbol table is loaded', R.Values) > 0 then
        begin
          ExecCmd   ('-file-exec-and-symbols %s',
            [TGDBMIServerDebuggerLAMW(FTheDebugger).ConvertToGDBPath(FTheDebugger.FileName, cgptExeName)], R);
          DoSetPascal;
          // TODO: check with ALL versions of gdb, if that value needs to be refreshed or not.
          DoSetCaseSensitivity;
        end;
    end;
//---------------- Setup FileType to TargetInfo --------------------------------
          FileType := '';
  If ExecCmd       ('info file', [], R) then
    begin
      If rfNoMI in R.Flags then
        begin
          FileType := GetPart('file type ', '.', R.Values);
        end                else
        begin // OS X gdb has mi output here
          List     := TGDBMINameValueList.Create(R, ['section-info']);
          FileType := List.Values['filetype'];
          List.Free;
        end;
    end;
  SetTargetInfo(FileType);
//------------------------------------------------------------------------------
//GdbCfg.LogStr('Target FileType = "%s"', [FileType]);
//---------------- Set DebuggerState = dsPause ---------------------------------
  If Not     (DebuggerState in [dsPause])
    then   SetDebuggerState    (dsPause);
  ProcessFrame; // Includes DoLocation
//------------------------------------------------------------------------------
//GdbCfg.LogStr('DebuggerState = "%s"', [lamwDBGState[DebuggerState]]);
//------------------------------------------------------------------------------
  Result := True;
end;

function  TGDBMIServerDebuggerCommandAttach.DoExecute: Boolean;
var FileName,DirName,TargetExtendRemote:String;

  function DoExecCmd(Cmd:Array of String):Boolean;
  var   I:Integer;                          R:TGDBMIExecResult;
  begin
             Result := True;
    For I:=Low(Cmd) to High(Cmd) do
      If     Result then
             Result :=  ExecCmd(Cmd[I], [], R) and ({%H-}R.State <> dsError)
                    else
             Exit;
  end;

begin
  Result           := True; // This Result is not used in GDBServerAttach!
  FileName         :=                FTheDebugger.FileName;
  DirName          := ExtractFileDir(FTheDebugger.FileName);
  If PathDelim <> '/' then
    begin
      DirName      := StringReplace(DirName,  PathDelim, '/', [rfReplaceAll]);
      FileName     := StringReplace(FileName, PathDelim, '/', [rfReplaceAll]);
    end;

  With TGDBMIServerDebuggerPropertiesLAMW(DebuggerProperties) do
      TargetExtendRemote
                   := Format( 'target extended-remote %s:%s',
                        [Remote_Hostname, Remote_Port]);
//------------------------------------------------------------------------------
  GdbCfg.LogStr('CleanBeforeAttach = "%s", InitBeforeConnect = "%s"',
    [
       BoolToStr(GdbCleanExec  = gceClneanBeforeAttach),
       BoolToStr(GdbProcAttach = gpaInitBeforeConnect )
                                                                             ]);
//------------------------------------------------------------------------------
  If GdbProcAttach = gpaInitBeforeConnect then
    begin
         FServSucc := DoExecCmd(
                            [
                              'set osabi GNU/Linux',
                              '-file-exec-and-symbols '    + FileName,
                              'set solib-absolute-prefix ' +  DirName,
                              'set solib-search-path '     +  DirName,
                              'handle SIG33 nopass nostop noprint',
                              'handle SIG35 nopass nostop noprint',
//-------------------------- for 64 bits only ----------------------------------
                              'handle SIGSTOP nopass nostop noprint',
                              'handle SIGSEGV nostop noprint',
                              'handle SIGBUS nopass noprint',
//------------------------------------------------------------------------------
                               TargetExtendRemote
                                                                             ]);
      If FServSucc then
         FServSucc := DoAttach;
    end                                   else
    begin
         FServSucc := DoExecCmd(
                            [
                               TargetExtendRemote
                                                                             ]);
      If FServSucc then
         FServSucc := DoAttach
                   else Exit;
      If FServSucc then
         FServSucc := DoExecCmd(
                            [
                              'set solib-search-path '     +  DirName,
                              'handle SIG33 nopass nostop noprint',
                              'handle SIG35 nopass nostop noprint',
//-------------------------- for 64 bits only ----------------------------------
                              'handle SIGSTOP nopass nostop noprint',
                              'handle SIGSEGV nostop noprint',
                              'handle SIGBUS nopass noprint'
//------------------------------------------------------------------------------
                                                                             ]);
    end;
end;


  { TGDBMIServerDebuggerProperties }

constructor TGDBMIServerDebuggerPropertiesLAMW.Create;
begin
  inherited Create;
      FRemote_Hostname     := '';
      FRemote_Port         := '2021';
      FRemote_ServerRun    := Low(TGdbServerRun);
      FRemote_ProcAttach   := Low(TGdbProcAttach);
      FRemote_CleanExec    := Low(TGdbCleanExec);
      FRemote_CopGdbServ   := Low(TGdbCopGdbServ);
      UseAsyncCommandMode  := True;
end;

procedure TGDBMIServerDebuggerPropertiesLAMW.Assign(Source : TPersistent);
begin
  inherited                                  Assign(Source);
  If Source is   TGDBMIServerDebuggerPropertiesLAMW then
    begin
      FRemote_HostName     :=
                 TGDBMIServerDebuggerPropertiesLAMW(Source).FRemote_HostName;
      FRemote_Port         :=
                 TGDBMIServerDebuggerPropertiesLAMW(Source).FRemote_Port;
      FRemote_ServerRun    :=
                 TGDBMIServerDebuggerPropertiesLAMW(Source).FRemote_ServerRun;
      FRemote_ProcAttach   :=
                 TGDBMIServerDebuggerPropertiesLAMW(Source).FRemote_ProcAttach;
      FRemote_CleanExec    :=
                 TGDBMIServerDebuggerPropertiesLAMW(Source).FRemote_CleanExec;
      FRemote_CopGdbServ   :=
                 TGDBMIServerDebuggerPropertiesLAMW(Source).FRemote_CopGdbServ;
      UseAsyncCommandMode  := True;
    end;
end;

procedure TGDBMIServerDebuggerPropertiesLAMW.SetRemote_HostName  (NewHost:String);
begin
  FRemote_HostName         := NewHost;
  GdbCfg.GdbServerName     := NewHost;
end;

procedure TGDBMIServerDebuggerPropertiesLAMW.SetRemote_Port      (NewPort:String);
begin
  FRemote_Port             := NewPort;
  GdbCfg.GdbServerPort     := NewPort;
end;

procedure TGDBMIServerDebuggerPropertiesLAMW.SetRemote_ServerRun (NewRun:TGdbServerRun);
begin
  FRemote_ServerRun        := NewRun;
  GdbCfg.GdbServerRun      := NewRun;
end;

procedure TGDBMIServerDebuggerPropertiesLAMW.SetRemote_ProcAttach(NewAth:TGdbProcAttach);
begin
  FRemote_ProcAttach       := NewAth;
  GdbCfg.GdbProcAttach     := NewAth;
end;

procedure TGDBMIServerDebuggerPropertiesLAMW.SetRemote_CleanExec (NewCln:TGdbCleanExec);
begin
  FRemote_CleanExec        := NewCln;
  GdbCfg.GdbCleanExec      := NewCln;
end;

procedure TGDBMIServerDebuggerPropertiesLAMW.SetRemote_CopGdbServ(NewCop:TGdbCopGdbServ);
begin
  FRemote_CopGdbServ       := NewCop;
  GdbCfg.GdbCopGdbServ     := NewCop;
end;

  { TGDBMIServerDebuggerLAMW }

constructor    TGDBMIServerDebuggerLAMW.Create(const AExternalDebugger: String);
begin
  inherited                                   Create(AExternalDebugger);
  GdbCfg.LogStr('Create  Debugger = "%s", File = "%s"',
                                          [ClassName,AExternalDebugger]);
end;

destructor     TGDBMIServerDebuggerLAMW.Destroy;
begin
  GdbCfg.LogStr('Destroy Debugger = "%s"',[ClassName]);
  GdbCfg.SaveLogListToFile;
  inherited Destroy;
end;

class function TGDBMIServerDebuggerLAMW.Caption: String;
begin
  Result := 'GNU remote debugger (gdbserver) LAMW';
end;

function TGDBMIServerDebuggerLAMW.GDBServerAttach(AProcessID: String): Boolean;
var
  Cmd    :  TGDBMIServerDebuggerCommandAttach;
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
  If ACommand = dcAttach then
    begin
         LockRelease;
       try
         Result := GDBServerAttach(String(AParams[0].VAnsiString));
       finally
         UnlockRelease;
       end;
    end                  else
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

function    TGDBMIServerDebuggerConfigLAMW.GetGdbProcAttach      : TGdbProcAttach;
begin
  LoadDebuggerProperties;
  Result := FGdbProcAttach;
end;

procedure   TGDBMIServerDebuggerConfigLAMW.SetGdbProcAttach(SAth : TGdbProcAttach);
begin
  FGdbProcAttach := SAth;
  FModifid       := True;
end;

function    TGDBMIServerDebuggerConfigLAMW.GetGdbCleanExec       : TGdbCleanExec;
begin
  LoadDebuggerProperties;
  Result := FGdbCleanExec;
end;

procedure   TGDBMIServerDebuggerConfigLAMW.SetGdbCleanExec (SCln : TGdbCleanExec);
begin
  FGdbCleanExec  := SCln;
  FModifid       := True;
end;

function    TGDBMIServerDebuggerConfigLAMW.GetGdbCopGdbServ      : TGdbCopGdbServ;
begin
  LoadDebuggerProperties;
  Result := FGdbCopGdbServ;
end;

procedure   TGDBMIServerDebuggerConfigLAMW.SetGdbCopGdbServ(SCop : TGdbCopGdbServ);
begin
  FGdbCopGdbServ := SCop;
  FModifid       := True;
end;

constructor TGDBMIServerDebuggerConfigLAMW.Create;
begin
  FLogList       := TStringList.Create;     // Log List
  FModifid       := False;                  // Data Modifid
  FProjPID       := 0;                      // LAMW PID
  FProjName      := '';                     // LAMW project name (package name)
  FProjPath      := '';                     // LAMW project path
  FGdbServerPort := '2021';                 // gdbserver remote hostport
  FGdbServerName := '';                     // gdbserver remote hostname
  FGdbServerRun  := Low(TGdbServerRun);     // gdbserver remote start method
  FGdbProcAttach := Low(TGdbProcAttach);    // target process attach  method
  FGdbCleanExec  := Low(TGdbCleanExec);     // clean exe file inform before attach
  FGdbCopGdbServ := Low(TGdbCopGdbServ);    // copy NDK gdbserver to target
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
    GdbProcAttach := Prop.Remote_ProcAttach;// target process attach  method
    GdbCleanExec  := Prop.Remote_CleanExec; // clean exe file inform before attach
    GdbCopGdbServ := Prop.Remote_CopGdbServ;// copy NDK gdbserver to target

  finally
    DDef.  Free;
    Prop.  Free;
    XMLCfg.Free;
  end;
end;

procedure   TGDBMIServerDebuggerConfigLAMW.LogStr(const Info : String);
begin
  If Assigned(FLogList) then               FLogList.Add(Info);
end;

procedure   TGDBMIServerDebuggerConfigLAMW.LogStr(const Frmt : String;
                                                  const Args : Array of const);
begin
  LogStr(Format(Frmt, Args));
end;

procedure   TGDBMIServerDebuggerConfigLAMW.LogCmd(const Cmnd : String;
                                                  const Args : Array of const;
                                                        R    : TGDBMIExecResult);
begin
  LogCmd(Format(Cmnd, Args), R);
end;

procedure   TGDBMIServerDebuggerConfigLAMW.LogCmd(const Cmnd : String;
                                                        R    : TGDBMIExecResult);
begin
  LogStr('Command = "%s", Result = "%s", Values = "%s", Flags = "%s"',
    [Cmnd, lamwDBGState[R.State],  R.Values, lamwGDBMIResFlagStr(R.Flags)]);
end;

procedure   TGDBMIServerDebuggerConfigLAMW.SaveLogListToFile;
begin
  If Assigned(FLogList) then
    begin
      If (0 < FLogList.Count) and (FProjPath <> '') then
              FLogList.SaveToFile (FProjPath + 'LogDebugLAMW.txt');
    end;
end;

var       GdbCfgLAMW :  TGDBMIServerDebuggerConfigLAMW = Nil;

function  GdbCfg     :  TGDBMIServerDebuggerConfigLAMW;
begin
  If      GdbCfgLAMW  = Nil
    then  GdbCfgLAMW := TGDBMIServerDebuggerConfigLAMW.Create;
  Result:=GdbCfgLAMW;
end;

procedure Register;
begin
  RegisterDebugger(TGDBMIServerDebuggerLAMW);
end;



end.


