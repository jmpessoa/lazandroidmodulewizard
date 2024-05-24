unit mysql57connectionbridge;

//fixed by Alcatiz
//https://forum.lazarus.freepascal.org/index.php/topic,67249.0.html

{$mode objfpc}{$H+}

interface

uses

  Classes, {SysUtils,} SQLDB, DB, MySQL57Conn;

type

  { TMySQL57ConnectionBridgeError }

  TMySQL57ConnectionBridgeError = (err_NoError, err_CreateSQLConnection, err_CreateSQLTransaction, err_CreateSQLQuery);

  { TMySQL57ConnectionBridge }

  TMySQL57ConnectionBridge = class(TComponent)
  private

    FDataBaseName: String;
    FHostName: String;
    FPort: Integer;
    FPassword: String;
    FUserName: String;
    FError: TMySQL57ConnectionBridgeError;
    FIsConnected: boolean;
    procedure SetDataBaseName(AValue: String);
    procedure SetHostName(AValue: String);
    procedure SetPassword(AValue: String);
    procedure SetPort(AValue: Integer);
    procedure SetUserName(AValue: String);

  protected

  public

    MySQL57Connection: TMySQL57Connection;
    SQLQuery: TSQLQuery;
    SQLTransaction: TSQLTransaction;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Connect: boolean;

    property IsConnected: boolean read FIsConnected write FIsConnected;
  published
    property DataBaseName: String read FDataBaseName write SetDataBaseName;
    property HostName: String read FHostName write SetHostName;
    property Port: Integer read FPort write SetPort;
    property Password: String read FPassword write SetPassword;
    property UserName: String read FUserName write SetUserName;
    property Error: TMySQL57ConnectionBridgeError read FError;

  end;


implementation

{ TMySQL57ConnectionBridge }

procedure TMySQL57ConnectionBridge.SetDatabaseName(AValue: string);
begin
  if FDataBaseName = AValue then Exit;
  FDataBaseName := AValue;
end;

procedure TMySQL57ConnectionBridge.SetHostName(AValue: string);
begin
   if FHostName = AValue then Exit;
   FHostName := AValue;
end;

procedure TMySQL57ConnectionBridge.SetPort(AValue: integer);
begin
    if FPort = AValue then Exit;
    FPort := AValue;
end;

procedure TMySQL57ConnectionBridge.SetPassword(AValue: string);
begin
    if FPassword = AValue then Exit;
    FPassword := AValue;
end;

procedure TMySQL57ConnectionBridge.SetUserName(AValue: string);
begin
  if FUserName = AValue then Exit;
  FUserName := AValue;
end;

(* Allocates SQLDB components *)
constructor TMySQL57ConnectionBridge.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

   FIsConnected:= False;
   FError := err_NoError;

   try
     MySQL57Connection := TMySQL57Connection.Create(Nil);
     MySQL57Connection.SkipLibraryVersionCheck := True;
   except
     FError := err_CreateSQLConnection;
     Exit;
   end;
   try
     SQLTransaction := TSQLTransaction.Create(Nil)
   except
     FError := err_CreateSQLTransaction;
     Exit;
   end;
   try
     SQLQuery := TSQLQuery.Create(Nil);
   except
     FError := err_CreateSQLQuery;
   end;
end;


(* Deallocates SQLDB components *)
destructor TMySQL57ConnectionBridge.Destroy;
begin
  if Assigned(SQLQuery)
       then
         begin
           SQLQuery.Close;
           SQLQuery.Free;
         end;
    if Assigned(SQLTransaction)
       then
         begin
           SQLTransaction.Active := False;
           SQLTransaction.Free;
         end;
    if Assigned(MySQL57Connection)
       then
         begin
           MySQL57Connection.Connected := False;
           MySQL57Connection.Free;
         end;
    inherited Destroy;
end;

(* Tries to connect to database *)
function TMySQL57ConnectionBridge.Connect(): boolean;
begin
  FIsConnected:= False;
  Result := False;
  MySQL57Connection.DatabaseName := FDataBaseName;
  MySQL57Connection.HostName := FHostName;
  MySQL57Connection.Port := FPort;
  MySQL57Connection.Password := FPassword;
  MySQL57Connection.UserName := FUserName;
  MySQL57Connection.Transaction := SQLTransaction;
  MySQL57Connection.CharSet := 'UTF8';
  SQLQuery.DataBase := MySQL57Connection;
  try
    MySQL57Connection.Open;
    MySQL57Connection.Connected := True;
  except
    MySQL57Connection.Connected := False;
  end;

  FIsConnected:= MySQL57Connection.Connected;
  Result := FIsConnected;

end;

end.
