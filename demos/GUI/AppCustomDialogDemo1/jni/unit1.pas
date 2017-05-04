{Hint: save all files to location: C:\adt32\eclipse\workspace\AppCustomDialogDemo1\jni }
unit unit1;
  
{$mode delphi}
  
interface
  
uses
  Classes, SysUtils, And_jni, And_jni_Bridge, Laz_And_Controls, 
    Laz_And_Controls_Events, AndroidWidget, customdialog;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
      jButton1: jButton;
      jButton2: jButton;
      jButton3: jButton;
      jCustomDialog1: jCustomDialog;
      jEditText1: jEditText;
      jEditText2: jEditText;
      jPanel1: jPanel;
      jPanel2: jPanel;
      jPanel3: jPanel;
      jTextView1: jTextView;
      jTextView2: jTextView;
      jTextView3: jTextView;
      jTextView4: jTextView;
      procedure jButton1Click(Sender: TObject);
      procedure jButton2Click(Sender: TObject);
      procedure jButton3Click(Sender: TObject);
      procedure jCustomDialog1BackKeyPressed(Sender: TObject; title: string);
      procedure jCustomDialog1Show(Sender: TObject; dialog: jObject;
        title: string);
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
  //jCustomDialog1.Show(jCustomDialog1.Text);  {ok!}
  jCustomDialog1.Show('User Info', 'ic_user');   //'ic_user' -->>  ../res/drawable
end;

procedure TAndroidModule1.jButton2Click(Sender: TObject);  //ok
begin
   ShowMessage(jEditText1.Text);
   ShowMessage(jEditText2.Text);
   jCustomDialog1.Close();
end;

procedure TAndroidModule1.jButton3Click(Sender: TObject);   //cancel
begin
  jCustomDialog1.Close();
end;

procedure TAndroidModule1.jCustomDialog1BackKeyPressed(Sender: TObject; title: string);
begin
  ShowMessage('CustomDialog ["'+title+'"] BackKeyPressed');
  jCustomDialog1.Close();
end;

procedure TAndroidModule1.jCustomDialog1Show(Sender: TObject; dialog: jObject; title: string);
begin
   jEditText1.Text:= 'Lazarus';
   jEditText2.Text:= '66-4441-5555';
end;

end.
