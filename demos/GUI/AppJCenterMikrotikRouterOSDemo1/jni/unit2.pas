{Hint: save all files to location: \jni }
unit unit2;

{$mode delphi}

interface

uses
  Classes, SysUtils, AndroidWidget, Laz_And_Controls, comboedittext,
  sfloatingbutton, cmikrotikrouteros;
  
type

  { TAndroidModule2 }

  TAndroidModule2 = class(jForm)
    jButton1: jButton;
    jcMikrotikRouterOS1: jcMikrotikRouterOS;
    jComboEditText1: jComboEditText;
    jDialogYN1: jDialogYN;
    jImageBtn1: jImageBtn;
    jListView1: jListView;
    jsFloatingButton1: jsFloatingButton;
    jTextView1: jTextView;
    jTextView2: jTextView;
    jTextView3: jTextView;
    procedure jButton1Click(Sender: TObject);
    procedure jDialogYN1ClickYN(Sender: TObject; YN: TClickYN);
    procedure jImageBtn1Click(Sender: TObject);
    procedure jListView1LongClickItem(Sender: TObject; itemIndex: integer;
      itemCaption: string);
    procedure jsFloatingButton1Click(Sender: TObject);
  private
    {private declarations}
  public
    {public declarations}
  end;

var
  AndroidModule2: TAndroidModule2;

implementation
  
{$R *.lfm}
  

{ TAndroidModule2 }

procedure TAndroidModule2.jsFloatingButton1Click(Sender: TObject);
begin
  Self.Close;
end;

procedure TAndroidModule2.jDialogYN1ClickYN(Sender: TObject; YN: TClickYN);
begin
  if YN = ClickYes then
  begin
    if jcMikrotikRouterOS1.Execute('/system/reboot') then
    begin
      jListView1.Clear;
      jListView1.Add('Success!!   System rebooted!');
    end;
  end;
end;

procedure TAndroidModule2.jImageBtn1Click(Sender: TObject);
begin
  jListView1.Clear;
  jComboEditText1.ShowDropDown();
end;

procedure TAndroidModule2.jListView1LongClickItem(Sender: TObject;
  itemIndex: integer; itemCaption: string);
begin
  jListView1.Clear;
end;

procedure TAndroidModule2.jButton1Click(Sender: TObject);
var
  dataResult : TDynArrayOfString;
  count, i: integer;
begin

  if (not jcMikrotikRouterOS1.IsConnected()) or (not jcMikrotikRouterOS1.IsLogged()) then
  begin
    ShowMessage('Sorry... Fail to connect or login...');
    Exit;
  end;

  if (jComboEditText1.Text <> '/system/reboot') and (jComboEditText1.Text <> '')  then
  begin
    dataResult:= jcMikrotikRouterOS1.ExecuteForResult(jComboEditText1.Text);
    count:= Length(dataResult);
    jListView1.Clear;
    for i:= 0 to count-1 do
    begin
      jListView1.Add(dataResult[i]);  //'ExecuteForResult:no command ...' --> fail...
    end;
    SetLength(dataResult, 0);
  end
  else
  begin
    jDialogYN1.Show();
  end;

end;


end.
