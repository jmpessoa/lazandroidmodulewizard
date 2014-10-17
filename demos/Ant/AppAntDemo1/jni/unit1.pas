{Hint: save all files to location: C:\adt32\ant\workspace\AppAntDemo1\jni }
unit unit1;
  
{$mode delphi}
  
interface
  
uses
  Classes, SysUtils, And_jni, And_jni_Bridge, Laz_And_Controls, 
    Laz_And_Controls_Events, AndroidWidget;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
      jButton1: jButton;
      jEditText1: jEditText;
      jTextView1: jTextView;
      jTextView2: jTextView;
      procedure AndroidModule1Click(Sender: TObject);
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
   ShowMessage(jEditText1.Text);
end;

procedure TAndroidModule1.AndroidModule1Click(Sender: TObject);
begin
     ShowMessage('Form Clicked!');
end;

end.
