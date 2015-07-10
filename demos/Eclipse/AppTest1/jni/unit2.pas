{Hint: save all files to location: \jni }
unit unit2;
  
{$mode delphi}
  
interface
  
uses
  Classes, SysUtils, And_jni, And_jni_Bridge, Laz_And_Controls,
  Laz_And_Controls_Events, AndroidWidget, customdialog, Unit3;
  
type

  { TAndroidModule2 }

  TAndroidModule2 = class(jForm)
      jButton1: jButton;
      jButton2: jButton;
      jEditText1: jEditText;
      jEditText2: jEditText;
      jImageList1: jImageList;
      jImageView1: jImageView;
      jImageView2: jImageView;
      jImageView3: jImageView;
      jImageView4: jImageView;
      jImageView5: jImageView;
      jScrollView1: jScrollView;
      jTextView1: jTextView;
      jTextView2: jTextView;
      jTextView3: jTextView;
      procedure AndroidModule2Close(Sender: TObject);
      procedure AndroidModule2JNIPrompt(Sender: TObject);
      procedure jButton1Click(Sender: TObject);
      procedure jButton2Click(Sender: TObject);
    private
      {private declarations}
    public
      {public declarations}
  end;
  
var
  AndroidModule2: TAndroidModule2;

implementation

{$R *.lfm}

uses unit1;

{ TAndroidModule2 }

procedure TAndroidModule2.jButton1Click(Sender: TObject);
begin
    Self.Close;
end;

procedure TAndroidModule2.jButton2Click(Sender: TObject);
begin
  if(AndroidModule3 = nil) then
  begin
    gApp.CreateForm(TAndroidModule3, AndroidModule3);
    AndroidModule3.TryBacktrackOnClose:= True;
    AndroidModule3.Init(gApp);
  end
  else
  begin
    AndroidModule3.Show;
  end;
end;

  //the last close event!
procedure TAndroidModule2.AndroidModule2Close(Sender: TObject);
begin
  //ShowMessage('jForm 2 "game over!"!');
  Self.CallBackDataString:= jEditText1.Text;
  Self.CallBackDataInteger:= 3*StrToInt(jEditText2.Text);
  Self.CallBackDataDouble:= SQRT(Self.CallBackDataInteger);
end;

procedure TAndroidModule2.AndroidModule2JNIPrompt(Sender: TObject);
begin
   ShowMessage('jForm 2 jni prompt!  FormBaseIndex = '+ IntToStr(Self.FormBaseIndex)+
                                 '  FormIndex = '+ IntToStr(Self.FormIndex));
   jEditText1.SetFocus;
end;

end.
