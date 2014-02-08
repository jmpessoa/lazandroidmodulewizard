{Hint: save all files to location: C:\adt32\ant\workspace\AppAntDemo1\jni }
unit unit1;
  
{$mode delphi}
  
interface
  
uses
  Classes, SysUtils, And_jni, And_jni_Bridge, Laz_And_Controls;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
      jButton1: jButton;
      jEditText1: jEditText;
      jTextView1: jTextView;
      jTextView2: jTextView;
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
  AndroidModule1: TAndroidModule1;

implementation
  
{$R *.lfm}

{ TAndroidModule1 }

procedure TAndroidModule1.jButton1Click(Sender: TObject);
begin
    ShowMessage(UpperCase(jEditText1.Text));
end;

procedure TAndroidModule1.DataModuleCreate(Sender: TObject);
begin        //jus to fix *.lfm parse fail on Laz4Android cross compile... why fail ?
    Self.OnJNIPrompt:= DataModuleJNIPrompt;
end;

procedure TAndroidModule1.DataModuleJNIPrompt(Sender: TObject);
begin
    Self.Show;
end;

procedure TAndroidModule1.DataModuleRotate(Sender: TObject; rotate: integer;
  var rstRotate: integer);
begin
   Self.UpdateLayout;
end;

end.
