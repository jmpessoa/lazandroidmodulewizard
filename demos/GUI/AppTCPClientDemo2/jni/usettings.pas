unit uSettings;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, uTCPSockets, Laz2_XMLCfg;

type

  { TSettings }
  TSettings = class
  private
    FVersion: Integer;
    FFileName: String;
    FConnectionList: TList;
    FActiveIP: String;
    FAutoConnect: Boolean;
    FActiveConnection: TConnection;
    FSaveConnections: Boolean;
    FSaveCredentials: Boolean;
    FHideInternalMessages: Boolean;
    FHideErrorMessages: Boolean;
    FDownloadDirectory: String;
    procedure Cleanup;
  public
    constructor Create;
    destructor Destroy; override;
  public
    procedure Load;
    procedure Save;
    procedure CopyConnection(const AFrom, ATo: TConnection);
  public
    property FileName: String read FFileName write FFileName;
    property ConnectionList: TList read FConnectionList write FConnectionList;
    property AutoConnect: Boolean read FAutoConnect write FAutoConnect;
    property ActiveConnection: TConnection read FActiveConnection write FActiveConnection;
    property SaveConnections: Boolean read FSaveConnections write FSaveConnections;
    property SaveCredentials: Boolean read FSaveCredentials write FSaveCredentials;
    property HideInternalMessages: Boolean read FHideInternalMessages write FHideInternalMessages;
    property HideErrorMessages: Boolean read FHideErrorMessages write FHideErrorMessages;
    property DownloadDirectory: String read FDownloadDirectory write FDownloadDirectory;
  end;


implementation

uses uTCPCryptoCompression;

const
  InternalVersion = 1;

constructor TSettings.Create;
begin
  FActiveConnection := TConnection.Create;
  FConnectionList := TList.Create;
end;

destructor TSettings.Destroy;
begin
  FActiveConnection.Free;
  Cleanup;
  FConnectionList.Free;
  inherited Destroy;
end;

procedure TSettings.Cleanup;
var
  I: Integer;
begin
  for I := FConnectionList.Count - 1 downto 0 do
    TConnection(FConnectionList[I]).Free;
  FConnectionList.Clear;
end;

function Compare(Item1, Item2: Pointer): Integer;
begin
  Result := CompareStr(TConnection(Item1).FIP, TConnection(Item2).FIP);
end;

procedure TSettings.Load;
var
  XML: TXMLConfig;
  I: Integer;
  Cnt: Integer;
  Path: String;
  SubPath: String;
  Connection: TConnection;
begin
  Cleanup;
  XML := TXMLConfig.Create(FFileName);
  try
    FVersion := XML.GetValue('Version/Value', 1);
    FAutoConnect := XML.GetValue('AutoConnect/Value', False);
    Path := 'Connections/';
    FSaveConnections := XML.GetValue(Path + 'SaveConnections/Value', True);
    FSaveCredentials := XML.GetValue(Path + 'SaveCredentials/Value', False);
    FHideInternalMessages := XML.GetValue('HideInternalMessages/Value', False);
    FHideErrorMessages := XML.GetValue('HideErrorMessages/Value', False);
    FDownloadDirectory := XML.GetValue('DownloadDirectory/Value', '');
    if FSaveConnections then
    begin
      FActiveIP := XML.GetValue(Path + 'ActiveIP/Value', '');
      Cnt := XML.GetValue(Path + 'Count/Value', 0);
      for I := 0 to Cnt - 1 do
      begin
        SubPath := Path + 'Connection' + IntToStr(I) + '/';
        Connection := TConnection.Create;
        with Connection do
        begin
          FIP   := XML.GetValue(SubPath + 'IP/Value', '');;
          FPort := XML.GetValue(SubPath + 'Port/Value', '40516');
          FUser := XML.GetValue(SubPath + 'User/Value', '');
            FPass := Decrypt(SHA1Hash(FPort), XML.GetValue(SubPath + 'Pass/Value', ''));

          if FSaveCredentials then
          begin

          end;
          FProxy.FProxyType := TProxyType(XML.GetValue(SubPath + 'ProxyType/Value', 0));
          FProxy.FProxyIP   := XML.GetValue(SubPath + 'ProxyIP/Value', '');
          FProxy.FProxyPort := XML.GetValue(SubPath + 'ProxyPort/Value', '8080');
          if FSaveCredentials then
          begin
            FProxy.FProxyUser := XML.GetValue(SubPath + 'ProxyUser/Value', '');
            FProxy.FProxyPass := Decrypt(SHA1Hash(FProxy.FProxyPort), XML.GetValue(SubPath + 'ProxyPass/Value', ''));
          end;
        end;
        if Connection.FIP = FActiveIP then
          CopyConnection(Connection, FActiveConnection);
        if Trim(Connection.FIP) <> '' then
          FConnectionList.Add(Connection);
      end;
    end;

  finally
    XML.Free;
  end;
  FConnectionList.Sort(@Compare);
end;

procedure TSettings.Save;
var
  XML: TXMLConfig;
  I: Integer;
  Cnt: Integer;
  Path: String;
  SubPath: String;
begin
  FConnectionList.Sort(@Compare);
  XML := TXMLConfig.CreateClean(FFileName);
  try
    XML.SetDeleteValue('Version/Value', InternalVersion, 0);
    XML.SetDeleteValue('AutoConnect/Value', FAutoConnect, False);
    Path := 'Connections/';
    XML.SetDeleteValue(Path + 'SaveConnections/Value', FSaveConnections, True);
    XML.SetDeleteValue(Path + 'SaveCredentials/Value', FSaveCredentials, False);
    XML.SetDeleteValue('HideInternalMessages/Value', FHideInternalMessages, False);
    XML.SetDeleteValue('HideErrorMessages/Value', FHideErrorMessages, False);
    XML.SetDeleteValue('DownloadDirectory/Value', FDownloadDirectory, '');
    if FSaveConnections then
    begin
      XML.SetDeleteValue(Path + 'ActiveIP/Value', FActiveConnection.FIP, '');
      Cnt := FConnectionList.Count;
      XML.SetDeleteValue(Path + 'Count/Value', Cnt, 0);
      for I := 0 to Cnt - 1 do
      begin
        SubPath := Path + 'Connection' + IntToStr(I) + '/';
        XML.SetDeleteValue(SubPath + 'IP/Value', TConnection(FConnectionList[I]).FIP, '');
        XML.SetDeleteValue(SubPath + 'Port/Value', TConnection(FConnectionList[I]).FPort, '40516');
         XML.SetDeleteValue(SubPath + 'User/Value', TConnection(FConnectionList[I]).FUser, '');
           XML.SetDeleteValue(SubPath + 'Pass/Value', Encrypt(SHA1Hash(TConnection(FConnectionList[I]).FPort), TConnection(FConnectionList[I]).FPass), '');
        if FSaveCredentials then
        begin

        end;
        XML.SetDeleteValue(SubPath + 'ProxyType/Value', Ord(TConnection(FConnectionList[I]).FProxy.FProxyType), 0);
        XML.SetDeleteValue(SubPath + 'ProxyIP/Value',   TConnection(FConnectionList[I]).FProxy.FProxyIP, '');
        XML.SetDeleteValue(SubPath + 'ProxyPort/Value', TConnection(FConnectionList[I]).FProxy.FProxyPort, '8080');
        if FSaveCredentials then
        begin
          XML.SetDeleteValue(SubPath + 'ProxyUser/Value', TConnection(FConnectionList[I]).FProxy.FProxyUser, '');
          XML.SetDeleteValue(SubPath + 'ProxyPass/Value', Encrypt(SHA1Hash(TConnection(FConnectionList[I]).FProxy.FProxyPort), TConnection(FConnectionList[I]).FProxy.FProxyPass), '')
        end;
      end;
    end;
    XML.Flush;
  finally
    XML.Free;
  end;
end;

procedure TSettings.CopyConnection(const AFrom, ATo: TConnection);
begin
  if AFrom = nil then
  begin
    with ATo do
    begin
      FIP := ''; FPort := ''; FUser := ''; FPass := '';
      FProxy.FProxyType := ptNone; FProxy.FProxyIP := ''; FProxy.FProxyPort := '8080'; FProxy.FProxyUser := ''; FProxy.FProxyPass := '';
    end;
    Exit;
  end;

  with ATo do
  begin
    FIP := AFrom.FIP; FPort := AFrom.FPort; FUser := AFrom.FUser; FPass := AFrom.FPass;
    FProxy.FProxyType := AFrom.FProxy.FProxyType; FProxy.FProxyIP := AFrom.FProxy.FProxyIP;
    FProxy.FProxyPort := AFrom.FProxy.FProxyPort; FProxy.FProxyUser := AFrom.FProxy.FProxyUser; FProxy.FProxyPass := AFrom.FProxy.FProxyPass;
  end;
end;

end.

