{Hint: save all files to location: \jni }
unit unit4;
  
{$mode delphi}
  
interface
  
uses
  Classes, SysUtils, And_jni, And_jni_Bridge, Laz_And_Controls;
  
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
      procedure DataModuleRotate(Sender: TObject; rotate: integer;
        var rstRotate: integer);
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

   str.Add('Screen: '+ IntToStr(App.Screen.WH.Width) + 'x' + IntToStr(App.Screen.WH.Height));
   str.Add('App Path: '+App.Path.App);
   str.Add('App Path Dat: '+App.Path.Dat);
   str.Add('Phone Number: '+App.Device.PhoneNumber);
   str.Add('Device ID: '+App.Device.ID);
   str.Add('Date Time: '+getDateTime);

   jEditText1.Text:= str.Text;
   jEditText2.Text:= str.Text;

   str.Free
end;

procedure TAndroidModule4.DataModuleCreate(Sender: TObject);
begin
  Self.BackButton:= True;
  Self.BackgroundColor:= colbrBlack;
  //mode delphi
  Self.OnJNIPrompt:= DataModuleJNIPrompt;
  Self.OnRotate:= DataModuleRotate;
  Self.OnCloseQuery:= DataModuleCloseQuery;
end;

procedure TAndroidModule4.DataModuleCloseQuery(Sender: TObject;
  var CanClose: boolean);
begin
  CanClose:= True;
end;

procedure TAndroidModule4.DataModuleJNIPrompt(Sender: TObject);
begin
  jEditText2.Parent:= jScrollView1.View;
  Self.Show
end;

procedure TAndroidModule4.DataModuleRotate(Sender: TObject; rotate: integer;
  var rstRotate: integer);
begin
  Self.UpdateLayout;
end;

end.
