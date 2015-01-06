{Hint: save all files to location: C:\adt32\eclipse\workspace\AppEditTextDemo1\jni }
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
      procedure AndroidModule1JNIPrompt(Sender: TObject);
      procedure jButton1Click(Sender: TObject);
      procedure jEditText1Change(Sender: TObject; txt: string; count: integer);
      procedure jEditText1Changed(Sender: TObject; txt: string; count: integer);
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
begin
   ShowMessage(jEditText1.Text);
end;

procedure TAndroidModule1.AndroidModule1JNIPrompt(Sender: TObject);
begin
  jEditText1.DispatchOnChangeEvent(True);   //the trick!
  jEditText1.DispatchOnChangedEvent(True);   //the trick!
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

procedure TAndroidModule1.jEditText1Enter(Sender: TObject);
begin
  ShowMessage('Enter or Next or Done....');
end;

end.
