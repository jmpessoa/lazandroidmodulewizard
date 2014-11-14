unit ThreadProcess;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

Type

  TDisplayOutputEvent = procedure(Output: TStrings) of Object;

  TThreadProcess = class(TThread)
  private
    FOnDisplayOutput: TDisplayOutputEvent;
    FCommandLine: string;
    OutPut: TStringList;
    FEnv: TStringList;
    FDir: string;
    FIsTerminated: boolean;
    FDelay: integer;

    (*TODO: : by jmpessoa
    FParameters: TStringList;
    FExecutable: string;
    *)
    procedure DisplayOutput;


  protected
    procedure Execute; override;
  public
    ForceStop: boolean;
    Constructor Create(CreateSuspended: Boolean);
    property Delay: integer read FDelay write FDelay;
    property IsTerminated: boolean read FIsTerminated;
    property CommandLine: string read FCommandLine write FCommandLine;
    property Env: TStringList read FEnv write FEnv;
    property Dir: string read FDir write FDir;
    property OnDisplayOutput: TDisplayOutputEvent read FOnDisplayOutput write FOnDisplayOutput;

    (*TODO: by jmpessoa
    property Parameters: TStringList read FParameters write FParameters;
    property Executable: string read FExecutable write FExecutable;
    *)

  end;

implementation

uses process;

{ TThreadProcess }

procedure TThreadProcess.Execute;
Var
  FProcess: TProcess;
  i: integer;
begin
  OutPut:= TStringList.Create;
  FProcess:= TProcess.Create(nil);
  {$IFDEF WINDOWS}
    FProcess.ShowWindow:= swoHIDE;;
  {$ENDIF}
  for i:= 0 To FEnv.Count -1 do
    FProcess.Environment.add(FEnv.Strings[i]);
  FProcess.CurrentDirectory:= FDir;
  FProcess.Options := FProcess.Options + [poUsePipes {$IFDEF UNIX},poNoConsole {$ENDIF}];

  FProcess.CommandLine:= FCommandLine;  //TODO: : [by jmpessoa] fix here: deprecated!

  (*TODO: [by jmpessoa] test it!  :
  FProcess.Executable:= FExecutable;
  for i:= 0 To FParameters.Count -1 do
     FProcess.Parameters.add(FParameters.Strings[i]);
  *)

  FProcess.Execute;

  while (not Terminated) and FProcess.Running do
  begin
    if ForceStop then
      FProcess.Terminate(0);

    if not FProcess.Running then Terminate;
    OutPut.LoadFromStream(FProcess.Output);
//    if Length(OutPut.Text) > 0 then
      Synchronize(@DisplayOutput);
    if FDelay > 0 then
      sleep(FDelay);
  end;
  OutPut.LoadFromStream(FProcess.Output);
  if Length(OutPut.Text) > 0 then
    Synchronize(@DisplayOutput);
  if Assigned(FProcess) then
    FProcess.Free;
  OutPut.Free;
  FEnv.Free;

  (*TODO: by jmpessoa
  FParameters.Free;
  *)

  FIsTerminated:= True;
end;

procedure TThreadProcess.DisplayOutput;
begin
  if Assigned(FOnDisplayOutput) then
    FOnDisplayOutput(Output);
  OutPut.Clear;
end;

constructor TThreadProcess.Create(CreateSuspended: Boolean);
begin
  inherited Create(CreateSuspended);
  FreeOnTerminate:= True;
  FIsTerminated:= False;
  ForceStop:= False;
  FDelay:= 200;
  FEnv:= TStringList.Create;

  (*TUDO: by jmpessoa
  FParameters:= TStringList.Create;
  *)

end;

end.

