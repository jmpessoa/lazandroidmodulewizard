{Hint: save all files to location: C:\android\workspace\AppMikrotikRouterOSDemo1\jni }
unit unit1;

{$mode delphi}

interface

uses
  Classes, SysUtils, AndroidWidget, Laz_And_Controls, mikrotikrouteros;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jButton1: jButton;
    jButton2: jButton;
    jListView1: jListView;
    jMikrotikRouterOS1: jMikrotikRouterOS;
    jTextView1: jTextView;
    procedure jButton1Click(Sender: TObject);
    procedure jButton2Click(Sender: TObject);
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

//https://github.com/GideonLeGrange/mikrotik-java/blob/master/src/main/java/examples/SimpleCommand.java
procedure TAndroidModule1.jButton1Click(Sender: TObject);
begin
  jMikrotikRouterOS1.Username:= 'admin';
  jMikrotikRouterOS1.Password:= '';
  jMikrotikRouterOS1.Connect('192.168.1.1');
  jMikrotikRouterOS1.Execute('/system/reboot');
  jMikrotikRouterOS1.Disconnect();

  ShowMessage('Success!! system rebooted!');

end;

//https://github.com/GideonLeGrange/mikrotik-java/blob/master/src/main/java/examples/SimpleCommandWithResults.java
procedure TAndroidModule1.jButton2Click(Sender: TObject);
var
  dataResult : TDynArrayOfString;
  count, i: integer;
begin
  jMikrotikRouterOS1.Username:= 'admin';
  jMikrotikRouterOS1.Password:= '';
  jMikrotikRouterOS1.Connect('192.168.1.1');

  dataResult:= jMikrotikRouterOS1.ExecuteForResult('/interface/print');
  jMikrotikRouterOS1.Disconnect();

  count:= Length(dataResult);

  jListView1.Clear;
  for i:= 0 to count-1 do     //'0:0' --> empty result...
  begin
     jListView1.Add(dataResult[i]);
  end;

  SetLength(dataResult, 0);

end;

end.
