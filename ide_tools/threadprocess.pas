unit ThreadProcess;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, process;

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

    FProcess: TProcess;

    (*TODO: : by jmpessoa
    FParameters: TStringList;
    FExecutable: string;
    *)
    procedure DisplayOutput;


  protected
    procedure Execute; override;
  public
    FForceStop: boolean;
    FActive: boolean;
    procedure Terminate;
    procedure TerminateProcess(Sender: TObject);
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

{ TThreadProcess }

procedure TThreadProcess.Execute;
Var
  i: integer;
begin
  With FProcess do
  begin
    for i:= 0 To FEnv.Count -1 do
      Environment.add(FEnv.Strings[i]);
    CurrentDirectory:= FDir;
    Options := FProcess.Options + [poUsePipes {$IFDEF UNIX},poNoConsole {$ENDIF}];
    CommandLine:= FCommandLine;   // //TODO: : [by jmpessoa] fix here: deprecated!

    (*TODO: [by jmpessoa] test it!  :
    Executable:= FExecutable;
    for i:= 0 To FParameters.Count -1 do
      Parameters.add(FParameters.Strings[i]);
    *)

    Execute;
  end;

  FActive:= True;
  OutPut.LoadFromStream(FProcess.Output);
  Synchronize(@DisplayOutput);

  While (not Terminated) and (FProcess.Running) do
  begin

    FActive:= FProcess.Running;
    if not FProcess.Running then Terminate;
    Output.LoadFromStream(FProcess.Output);
    Synchronize(@DisplayOutput);

    if FDelay > 0 then
      sleep(FDelay);

  end;

  FActive:= False;
  OutPut.LoadFromStream(FProcess.Output);
  Synchronize(@DisplayOutput);

  (*TODO: by jmpessoa
  FParameters.Free;
  *)

  FIsTerminated:= True;
  Terminate;
end;

procedure TThreadProcess.TerminateProcess(Sender: TObject);
begin
  if Assigned(FProcess) then
  begin
    FActive:= False;
    FProcess.Terminate(0);
    FIsTerminated:= True;
  end;

  Synchronize(@DisplayOutput);
  FForceStop:= True;
  FProcess.CloseOutput;
  FProcess.Terminate(0);
  FProcess.Free;
  OutPut.Free;
  FEnv.Free;
  FIsTerminated:= True;
end;

procedure TThreadProcess.Terminate;
begin
  if Assigned(FProcess) then
  begin
    FActive:= False;
    FProcess.Terminate(0);
  end;
  FIsTerminated:= True;
end;

procedure TThreadProcess.DisplayOutput; //fix by thierry 15-11-2014
begin

  if Assigned(FOnDisplayOutput) then
     if Length(Output.Text) > 0 then
       FOnDisplayOutput(Output);
   OutPut.Clear;

end;

constructor TThreadProcess.Create(CreateSuspended: Boolean);  //fix by thierry 15-11-2014
begin
  inherited Create(CreateSuspended);
  FreeOnTerminate:= True;
  OnTerminate:= @TerminateProcess;
  FIsTerminated:= False;
  FDelay:= 200;
  FActive:= False;
  FEnv:= TStringList.Create;
  FProcess:= TProcess.Create(nil);
  OutPut:= TStringList.Create;
  {$IFDEF WINDOWS}
    FProcess.ShowWindow:= swoHIDE;;
  {$ENDIF}

  (*TUDO: by jmpessoa
  FParameters:= TStringList.Create;
  *)

end;

end.

