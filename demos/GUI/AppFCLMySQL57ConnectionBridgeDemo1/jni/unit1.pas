{Hint: save all files to location: C:\android\workspace\AppFCLMySQL57ConnectionBridgeDemo1\jni }
unit unit1;

{$mode delphi}

interface

uses
  Classes, SysUtils, AndroidWidget, Laz_And_Controls, mysql57connectionbridge;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jButton1: jButton;
    jEditText1: jEditText;
    jListView1: jListView;
    jTextView1: jTextView;
    jTextView2: jTextView;
    MySQL57ConnectionBridge1: TMySQL57ConnectionBridge;
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
var
  dataStr: string;
begin

  ShowMessage('Enter real dabase info and uncomment the code!');

(*
  MySQL57ConnectionBridge1.DatabaseName:='DATABASEFOO';
  MySQL57ConnectionBridge1.HostName:='50.116.8.95';
  MySQL57ConnectionBridge1.Port:=3306;
  MySQL57ConnectionBridge1.UserName:='admin';
  MySQL57ConnectionBridge1.Password:='123456';

  if MySQL57ConnectionBridge1.Connect() then
  begin
    try
      MySQL57ConnectionBridge1.SQLQuery.close;
      MySQL57ConnectionBridge1.SQLQuery.SQL.Text:='select * from TABFOO;';
      MySQL57ConnectionBridge1.SQLQuery.Active:=true;
      MySQL57ConnectionBridge1.SQLQuery.Open;

      jListView1.Clear;

      dataStr:= MySQL57ConnectionBridge1.SQLQuery.FieldByName('id').value;
      jListView1.Add(dataStr);

      dataStr:= MySQL57ConnectionBridge1.SQLQuery.FieldByName('name').value;
      jListView1.Add(dataStr);

      dataStr:= MySQL57ConnectionBridge1.SQLQuery.FieldByName('company').value;
      jListView1.Add(dataStr);

      dataStr:= MySQL57ConnectionBridge1.SQLQuery.FieldByName('address').value;
      jListView1.Add(dataStr);

      dataStr:= MySQL57ConnectionBridge1.SQLQuery.FieldByName('role').value;
      jListView1.Add(dataStr);

    finally
      MySQL57ConnectionBridge1.SQLQuery.Close;
    end;
   end;

*)
end;

end.
