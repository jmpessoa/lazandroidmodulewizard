{Hint: save all files to location: C:\android\workspace\AppJCenterMikrotikRouterOSDemo1\jni }
unit unit1;

{$mode delphi}

interface

uses
  Classes, SysUtils, AndroidWidget, Laz_And_Controls, cmikrotikrouteros, unit2;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jButtonLogin: jButton;
    jEditText1: jEditText;
    jEditText2: jEditText;
    jEditText3: jEditText;
    jEditText4: jEditText;
    jImageView1: jImageView;
    jScrollView1: jScrollView;
    jTextView1: jTextView;
    jTextView2: jTextView;
    jTextView3: jTextView;
    jTextView4: jTextView;
    jTextView5: jTextView;
    procedure AndroidModule1Close(Sender: TObject);
    procedure AndroidModule1JNIPrompt(Sender: TObject);

    procedure AndroidModule1SpecialKeyDown(Sender: TObject; keyChar: char;
                                           keyCode: integer; keyCodeString: string; var mute: boolean);
    procedure jButtonLoginClick(Sender: TObject);
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

procedure TAndroidModule1.AndroidModule1Close(Sender: TObject);
begin
  //if jcMikrotikRouterOS1.IsConnected() then jcMikrotikRouterOS1.Disconnect();
end;

procedure TAndroidModule1.AndroidModule1JNIPrompt(Sender: TObject);
begin
   Self.jEditText1.SetFocus;
   if not Self.isConnectedWifi then ShowMessage('Please, connect to wifi...');
   if AndroidModule2 = nil then  //prepare form 2
   begin
     gApp.CreateForm(TAndroidModule2, AndroidModule2);
     AndroidModule2.Init(gApp); //fire OnJniPrompt but dont show the form...
   end;
end;

procedure TAndroidModule1.AndroidModule1SpecialKeyDown(Sender: TObject;
  keyChar: char; keyCode: integer; keyCodeString: string; var mute: boolean);
begin
  //try keep app connected!!
  mute:= True;
  Self.Minimize();
end;

procedure TAndroidModule1.jButtonLoginClick(Sender: TObject);
var
  IP: string;
  Port: integer;
  Timeout: integer;
begin

  if not Self.isConnectedWifi then
  begin
    ShowMessage('Please, connect to wifi...');
    Exit;
  end;

  if not AndroidModule2.jcMikrotikRouterOS1.IsConnected() then
  begin
    IP:= Trim(jEditText1.Text);
    Port:= StrToInt(Trim(jEditText2.Text));
    Timeout:= 60000;
    if AndroidModule2.jcMikrotikRouterOS1.Connect(IP, Port, Timeout) then
    begin

       AndroidModule2.jcMikrotikRouterOS1.Password:= Trim(jEditText4.Text);

       if AndroidModule2.jcMikrotikRouterOS1.Password =  '' then
       begin
         ShowMessage('Sorry... empty/blank password is not supported...');
         Exit;
       end;

       AndroidModule2.jcMikrotikRouterOS1.Username:= Trim(jEditText3.Text); //'admin';

       if AndroidModule2.jcMikrotikRouterOS1.Login() then
         AndroidModule2.Show()
       else
         ShowMessage('Sorry... fail to Login...');

    end;
  end
  else AndroidModule2.Show();

end;

end.
