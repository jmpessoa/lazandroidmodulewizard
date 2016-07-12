{Hint: save all files to location: C:\adt32\eclipse\workspace\AppEditTextDemo1\jni }
unit unit1;
  
{$mode delphi}
  
interface
  
uses
  Classes, SysUtils, And_jni, And_jni_Bridge, Laz_And_Controls, 
    Laz_And_Controls_Events, AndroidWidget, textfilemanager;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
      jButton1: jButton;
      jEditText1: jEditText;
      jTextFileManager1: jTextFileManager;
      jTextView1: jTextView;

      jEditTemp: jEditText;

      procedure AndroidModule1Destroy(Sender: TObject);
      procedure AndroidModule1JNIPrompt(Sender: TObject);
      procedure jButton1Click(Sender: TObject);
      procedure jEditText1Change(Sender: TObject; txt: string; count: integer);
      procedure jEditText1Changed(Sender: TObject; txt: string; count: integer);
      procedure jEditText1Click(Sender: TObject);
      procedure jEditText1Enter(Sender: TObject);
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
//var
  //jButtonTemp: jButton;
begin

  jEditTemp := jEditText.Create(Self);
 // jEditTemp.Parent := jPanel1;
 // jEditTemp.Text:='test';
  jEditTemp.LayoutParamWidth:=lpMatchParent;
 // jEditTemp.LayoutParamHeight:=lpWrapContent;
 // jEditTemp.FontSize:=18;
  jEditTemp.PosRelativeToParent:=[rpCenterInParent];

  jEditTemp.Init(gApp);

 {jButtonTemp := jButton.Create(Self);
  jButtonTemp.Parent:=jPanel1;
  jButtonTemp.Text:='press me';
  jButtonTemp.LayoutParamWidth:=lpMatchParent;
  jButtonTemp.LayoutParamHeight:=lpWrapContent;
  jButtonTemp.Anchor:=jEditTemp;
  jButtonTemp.PosRelativeToAnchor:=[raAbove];}

end;

{var
   strFromAssets: string;
begin
   strFromAssets:= jTextFileManager1.LoadFromAssets('name1.txt');
   ShowMessage(strFromAssets);

   jEditText1.SelectAll();  //just test!
end;
}
{
TImeOptions = (imeFlagNoFullScreen,
               imeActionNone,
               imeActionGo,
               imeActionSearch,
               imeActionSend,
               imeActionNext,
               imeActionDone,
               imeActionPrevious,
               imeFlagForceASCII);
}

procedure TAndroidModule1.AndroidModule1JNIPrompt(Sender: TObject);
begin
  //jEditText1.DispatchOnChangeEvent(False);   //the trick!  stop event [improve performace]!
  //jEditText1.DispatchOnChangedEvent(False);   //the trick! stop event [improve performace]!
  jEditText1.SetImeOptions(imeFlagNoFullScreen); //Thanks to @Ps !!
                                                   //IMEs will never go into full screen mode,
                                                   //and always leave some space to display the application UI

  jTextView1.TextTypeFace:= tfBold;
  jTextView1.CustomColor:= $FF2C2F3E;   //Thanks to @Ps  !!
  jTextView1.FontColor:= colbrCustom;

  jEditText1.SetSelectAllOnFocus(True);  //just test!
  jEditText1.SetFocus;    //OK!


end;

procedure TAndroidModule1.AndroidModule1Destroy(Sender: TObject);
begin
  jEditTemp.Free;
end;

procedure TAndroidModule1.jEditText1Change(Sender: TObject; txt: string;
  count: integer);
begin
   ShowMessage('before= ' +txt+ ' :: count= '+ intToStr(count));
end;

procedure TAndroidModule1.jEditText1Changed(Sender: TObject; txt: string;
  count: integer);
begin
   ShowMessage('after= ' +txt+ ' :: count= '+ intToStr(count));
end;

procedure TAndroidModule1.jEditText1Click(Sender: TObject);
begin
  //ShowMessage('Clicked....');
end;

procedure TAndroidModule1.jEditText1Enter(Sender: TObject);
begin
  ShowMessage('Enter or Next or Done....');
end;

end.
