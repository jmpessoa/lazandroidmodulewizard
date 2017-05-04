{Hint: save all files to location: C:\android-neon\eclipse\workspace\AppCustomDialogDemo2\jni }
unit unit1;

{$mode delphi}

interface

uses
  Classes, SysUtils, AndroidWidget, Laz_And_Controls, customdialog, And_jni;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jButton1: jButton;
    jButton2: jButton;
    jButton3: jButton;
    jButton4: jButton;
    jButton5: jButton;
    jCustomDialog1: jCustomDialog;
    jEditText1: jEditText;
    jEditText2: jEditText;
    jEditText3: jEditText;
    jEditText4: jEditText;
    jPanel1: jPanel;
    jPanel2: jPanel;
    jPanel3: jPanel;
    jPanel4: jPanel;
    jPanel5: jPanel;
    jPanel6: jPanel;
    jTextView1: jTextView;
    jTextView2: jTextView;
    jTextView3: jTextView;
    jTextView4: jTextView;
    jTextView5: jTextView;
    procedure AndroidModule1Rotate(Sender: TObject; rotate: TScreenStyle);
    procedure jButton1Click(Sender: TObject);
    procedure jButton4Click(Sender: TObject);
    procedure jButton5Click(Sender: TObject);
    procedure jCustomDialog1BackKeyPressed(Sender: TObject; title: string);
    procedure jCustomDialog1Show(Sender: TObject; dialog: jObject; title: string);

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

procedure TAndroidModule1.AndroidModule1Rotate(Sender: TObject; rotate: TScreenStyle);
begin
  Self.UpdateLayout;    // try/test:  comment this line
end;

procedure TAndroidModule1.jButton1Click(Sender: TObject);
begin
   jCustomDialog1.Show('LAMW Custom Dialog');
end;

procedure TAndroidModule1.jButton4Click(Sender: TObject);
begin
  ShowMessage('Ok');
  ShowMessage('Hint: jPanel4.LayoutParamWidth = lpNineTenthsOfParent');
  jCustomDialog1.Close();
end;

procedure TAndroidModule1.jButton5Click(Sender: TObject);
begin
  ShowMessage('Cancel');
  jCustomDialog1.Close();
end;

procedure TAndroidModule1.jCustomDialog1BackKeyPressed(Sender: TObject; title: string);
begin
  jCustomDialog1.Close();
end;

procedure TAndroidModule1.jCustomDialog1Show(Sender: TObject; dialog: jObject; title: string);
begin
   ShowMessage('Hint: jPanel4.LayoutParamWidth = lpNineTenthsOfParent');
end;

end.
