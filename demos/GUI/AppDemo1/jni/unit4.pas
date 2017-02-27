{Hint: save all files to location: \jni }
unit unit4;
  
{$mode delphi}
  
interface
  
uses
  Classes, SysUtils, And_jni, And_jni_Bridge, Laz_And_Controls, Laz_And_Controls_Events, AndroidWidget;
  
type

  { TAndroidModule4 }

  TAndroidModule4 = class(jForm)
      jButton1: jButton;
      jEditText1: jEditText;
      jEditText2: jEditText;
      jScrollView1: jScrollView;
      jTextView1: jTextView;

      procedure DataModuleCloseQuery(Sender: TObject; var CanClose: boolean);
      procedure DataModuleCreate(Sender: TObject);
      procedure DataModuleJNIPrompt(Sender: TObject);
      procedure jButton1Click(Sender: TObject);
    private
      {private declarations}
    public
      {public declarations}
  end;
  
var
  AndroidModule4: TAndroidModule4;

implementation
  
{$R *.lfm}
  

{ TAndroidModule4 }

procedure TAndroidModule4.jButton1Click(Sender: TObject);
var
  str: TStringList;

begin
   str:= TStringList.Create;

   str.Add('Screen: '+ IntToStr(gApp.Screen.WH.Width) + 'x' + IntToStr(gApp.Screen.WH.Height));
   str.Add('App Path: '+gApp.Path.App);
   str.Add('App Path Dat: '+gApp.Path.Dat);
   str.Add('App Path DataBase: '+gApp.Path.DataBase);
 //  str.Add('Phone Number: '+gApp.Device.PhoneNumber);
 //  str.Add('Device ID: '+gApp.Device.ID);
   str.Add('Date Time: '+Self.GetDateTime);

   jEditText1.Text:= str.Text;
   jEditText2.Text:= str.Text;

   str.Free
end;

procedure TAndroidModule4.DataModuleCreate(Sender: TObject);
begin
   //
end;

procedure TAndroidModule4.DataModuleCloseQuery(Sender: TObject; var CanClose: boolean);
begin
  CanClose:= True;
end;

procedure TAndroidModule4.DataModuleJNIPrompt(Sender: TObject);
begin
  //
end;

end.
