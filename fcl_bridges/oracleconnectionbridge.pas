unit oracleconnectionbridge;

{$mode objfpc}{$H+}

interface

uses
  Classes, oracleconnection, sqldb;

type

  { TOracleConnectionBridge }

  TOracleConnectionBridge = class(TComponent)
  private

    FDatabaseName: string;
    FHostName: string;
    FPort: string;
    FPassword: string;
    FUserName: string;

    procedure SetDatabaseName(database: string);
    procedure SetHostName(host: string);
    procedure SetPort(portnumber: string);
    procedure SetPassword(pwd: string);
    procedure SetUserName(user: string);

  protected

  public

    OracleConnection: TOracleConnection;
    SQLQuery: TSQLQuery;
    SQLTransaction: TSQLTransaction;

    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    function Connect(): boolean;


  published
    property DatabaseName: string read FDatabaseName write SetDatabaseName;
    property HostName: string read FHostName write SetHostName;
    property Port: string read FPort write FPort;
    property Password: string read FPassword write SetPassword;
    property UserName: string read FUserName write SetUserName;

  end;


implementation

{ TOracleBridge }

procedure TOracleConnectionBridge.SetDatabaseName(database: string);
begin
   FDatabaseName:= database;
end;

procedure TOracleConnectionBridge.SetHostName(host: string);
begin
   FHostName:= host;
end;

procedure TOracleConnectionBridge.SetPort(portnumber: string);
begin
   FPort:= portnumber;
end;

procedure TOracleConnectionBridge.SetPassword(pwd: string);
begin
   FPassword:= pwd;
end;

procedure TOracleConnectionBridge.SetUserName(user: string);
begin
  FUserName:= user;
end;

constructor TOracleConnectionBridge.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  try
    OracleConnection:=TOracleConnection.Create(nil);
   // OracleConnection.SkipLibraryVersionCheck:=true;
    SQLTransaction:=TSQLTransaction.Create(nil);
    SQLQuery:=TSQLQuery.Create(nil);
  except
     //ShowMessage('fail to init TOracleBridge');
  end;
end;

destructor TOracleConnectionBridge.Destroy;
begin
  SQLTransaction.Free;
  SQLQuery.Free;
  OracleConnection.Free;
  inherited Destroy;
end;

function TOracleConnectionBridge.Connect(): boolean;
begin

  Result:= False;
  //OracleConnection1.Directory := 'C:\TestMySQL_Laz';
  OracleConnection.DatabaseName:= FDatabaseName;
  //OracleConnection1.DataBaseName := 'localhost:1521/XE';
  OracleConnection.HostName:= FHostName + ':' + FPort;
  OracleConnection.Password:= FPassword;
  OracleConnection.UserName:= FUserName;

  SQLQuery.DataBase:=OracleConnection;
  SQLQuery.Transaction:=SQLTransaction;
  try
    OracleConnection.Open();
    OracleConnection.Connected:= True;
  except
    OracleConnection.Connected:= False;
     //ShowMessage('connection fail...');
  end;

  Result:= OracleConnection.Connected;
end;

end.
