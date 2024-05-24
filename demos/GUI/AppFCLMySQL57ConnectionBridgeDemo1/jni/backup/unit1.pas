{Hint: save all files to location: C:\android\workspace\AppFCLMySQL57ConnectionBridgeDemo1\jni }
unit unit1;

{$mode delphi}

interface

uses
  Classes, SysUtils, AndroidWidget, Laz_And_Controls, mysql57connectionbridge;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    ButtonConnect: jButton;
    jButton1: jButton;
    jEditText1: jEditText;
    jListView1: jListView;
    jTextView1: jTextView;
    jTextView2: jTextView;
    MySQL57ConnectionBridge1: TMySQL57ConnectionBridge;
    procedure ButtonConnectClick(Sender: TObject);
    procedure jButton1Click(Sender: TObject);
  private
    {private declarations}
  public
    {public declarations}
  end;

var
  AndroidModule1: TAndroidModule1;

implementation
  
{$R *.lfm}
  

{ TAndroidModule1 }

procedure TAndroidModule1.jButton1Click(Sender: TObject);
begin

  ShowMessage('Query a real dabase info and uncomment the code!');

  (*
  if MySQL57ConnectionBridge1.IsConnected then
  begin
    jListView1.Clear;
    MySQLAndroidConnection1.SQLQuery.Close;
    MySQLAndroidConnection1.SQLQuery.SQL.Text := 'SELECT * FROM T_CATEGORIES;';
    MySQLAndroidConnection1.SQLQuery.Open;
    MySQLAndroidConnection1.SQLQuery.Last;
    jListView1.Add('Number of records: ' + IntToStr(MySQLAndroidConnection1.SQLQuery.RecordCount));
    MySQLAndroidConnection1.SQLQuery.First;
    while not MySQLAndroidConnection1.SQLQuery.EOF do
      begin
        jListView1.Add(MySQLAndroidConnection1.SQLQuery.FieldByName('F_CATEGORYNAME').AsString);
        MySQLAndroidConnection1.SQLQuery.Next;
      end;
  end;
  *)

end;

procedure TAndroidModule1.ButtonConnectClick(Sender: TObject);
begin
  ShowMessage('Enter real dabase info and uncomment the code!');

  (*
  MySQL57ConnectionBridge1.HostName := '192.168.1.40';
  MySQL57ConnectionBridge1.Port := 3306;
  MySQL57ConnectionBridge1.DatabaseName := 'xxx';  //DATABASEFOO
  MySQL57ConnectionBridge1.UserName := 'xxx';
  MySQL57ConnectionBridge1.Password := 'xxx';

  if MySQL57ConnectionBridge1.Connect then
  begin
      ShowMessage('Connected!');
      if MySQL57ConnectionBridge1.SQLTransaction.Active then
        ShowMessage('Transaction is active!!')
      else
        ShowMessage('Transaction is NOT active...');
  end
  else
  begin
       ShowMessage('Error... Connection fail...');
       Exit;
  end;
  *)
end;

end.
