unit ThreadProcess;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, process, UTF8Process;

Type

  TOnTerminated = procedure(Sender: TObject) of Object;

  TDisplayOutputEvent = procedure(Output: TStrings) of Object;

  { TThreadProcess }

  TThreadProcess = class(TThread)
  private
    FOnDisplayOutput: TDisplayOutputEvent;
    OutPut: TStringList;
    FEnv: TStringList;
    FDir: string;
    FIsTerminated: boolean;
    FDelay: integer;
    FOnTerminated: TOnTerminated;

    FProcess: TProcessUTF8;

    FParameters: TStringList;
    FExecutable: string;
    procedure DisplayOutput;
  protected
    procedure Execute; override;
  public
    FForceStop: boolean;
    FActive: boolean;
    constructor Create(CreateSuspended: Boolean);
    destructor Destroy; override;
    procedure Terminate;
    procedure TerminateProcess(Sender: TObject);
    property Delay: integer read FDelay write FDelay;
    property IsTerminated: boolean read FIsTerminated;
    property Env: TStringList read FEnv write FEnv;
    property Dir: string read FDir write FDir;
    property Parameters: TStringList read FParameters write FParameters;
    property Executable: string read FExecutable write FExecutable;
    property OnDisplayOutput: TDisplayOutputEvent read FOnDisplayOutput write FOnDisplayOutput;
    property OnTerminated: TOnTerminated read FOnTerminated write FOnTerminated;
  end;

implementation

{ TThreadProcess }

procedure TThreadProcess.Execute;
begin
  With FProcess do
  begin
    Environment.Assign(FEnv);
    CurrentDirectory:= FDir;
    Options := FProcess.Options + [poUsePipes {$IFDEF UNIX},poNoConsole {$ENDIF}];
    Executable:= FExecutable;
    Parameters.Assign(FParameters);
    FParameters.Clear;
    try
      Execute;
    except
      on e: Exception do
      begin
        Parameters.Delimiter := ' ';
        Self.OutPut.Text := Executable + ' ' + Parameters.DelimitedText;
        Self.OutPut.Add(e.ClassName + ': ' + e.Message);
        Synchronize(@DisplayOutput);
        Exit;
      end;
    end;
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
  FIsTerminated:= True;
  if Assigned(FOnTerminated) then FOnTerminated(Self);
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
  FProcess:= TProcessUTF8.Create(nil);
  OutPut:= TStringList.Create;
  {$IFDEF WINDOWS}
  FProcess.ShowWindow:= swoHIDE;
  {$ENDIF}
  FParameters:= TStringList.Create;
end;

destructor TThreadProcess.Destroy;
begin
  FParameters.Free;
  FProcess.Free;
  OutPut.Free;
  FEnv.Free;
  inherited Destroy;
end;

end.

