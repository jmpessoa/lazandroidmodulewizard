{Hint: save all files to location: C:\android-neon\eclipse\workspace\AppEditTextSetTextDirectionRTLDemo1\jni }
unit unit1;

{$mode delphi}

interface

uses
  Classes, SysUtils, AndroidWidget, Laz_And_Controls;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jEditText1: jEditText;
    jTextView1: jTextView;
    procedure AndroidModule1JNIPrompt(Sender: TObject);
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

procedure TAndroidModule1.AndroidModule1JNIPrompt(Sender: TObject);
begin
  jEditText1.Clear;
  jEditText1.SetTextDirection(tdRTL); // thanks to  @majid.ebru
  //warning: added android:supportsRtl="true" to the <application> element in manifest file.
  //need android Api >= 17
end;

end.
