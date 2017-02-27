{Hint: save all files to location: \jni }
unit unit3;
  
{$mode delphi}
  
interface
  
uses
  Classes, SysUtils, And_jni, And_jni_Bridge, Laz_And_Controls, Laz_And_Controls_Events, AndroidWidget;
  
type

  { TAndroidModule3 }

  TAndroidModule3 = class(jForm)
      jButton1: jButton;
      jButton2: jButton;
      jButton3: jButton;
      jButton4: jButton;
      jCheckBox1: jCheckBox;
      jDialogProgress1: jDialogProgress;
      jDialogYN1: jDialogYN;
      jEditText1: jEditText;
      jImageList1: jImageList;
      jImageView1: jImageView;
      jProgressBar1: jProgressBar;
      jRadioButton1: jRadioButton;
      jTextView1: jTextView;
      jTextView2: jTextView;
      jTimer1: jTimer;
      jTimer2: jTimer;
      jTimer3: jTimer;

      procedure DataModuleClose(Sender: TObject);
      procedure DataModuleCloseQuery(Sender: TObject; var CanClose: boolean);
      procedure DataModuleCreate(Sender: TObject);
      procedure DataModuleJNIPrompt(Sender: TObject);
      procedure jButton1Click(Sender: TObject);
      procedure jButton2Click(Sender: TObject);
      procedure jButton3Click(Sender: TObject);
      procedure jButton4Click(Sender: TObject);
      procedure jCheckBox1Click(Sender: TObject);
      procedure jDialogYN1ClickYN(Sender: TObject; YN: TClickYN);
      procedure jRadioButton1Click(Sender: TObject);
      procedure jTimer1Timer(Sender: TObject);
      procedure jTimer2Timer(Sender: TObject);
      procedure jTimer3Timer(Sender: TObject);
    private
      {private declarations}
      Prog_Cnt: integer;
      Prog_Max: integer;
      Img_Cnt: integer;
    public
      {public declarations}
  end;
  
var
  AndroidModule3: TAndroidModule3;

implementation
  
{$R *.lfm}
  

{ TAndroidModule3 }

procedure TAndroidModule3.jDialogYN1ClickYN(Sender: TObject; YN: TClickYN);
begin
  case YN of
    ClickYes : ShowMessage('Clicked Yes');
    ClickNo  : ShowMessage('Clicked No' );
  end;
end;

procedure TAndroidModule3.jRadioButton1Click(Sender: TObject);
begin
  if jRadioButton1.Checked then  ShowMessage('RadioButton1 checked');
end;

procedure TAndroidModule3.jTimer1Timer(Sender: TObject);
begin
  Inc(Prog_Cnt);
  if Prog_Cnt > 10 then
  begin
    jTimer1.Enabled:= False;
    jDialogProgress1.Stop;
  end;
end;

procedure TAndroidModule3.jTimer2Timer(Sender: TObject);
begin
  Prog_Cnt:= Prog_Cnt + 10;
  if Prog_Cnt <= Prog_Max then
  begin
    jProgressBar1.Progress:=  Prog_Cnt;
  end
  else
  begin
    jProgressBar1.Stop;
    jTimer2.Enabled:= False;
  end;
end;

procedure TAndroidModule3.jTimer3Timer(Sender: TObject);
begin
  Inc(Img_Cnt);
  if Img_Cnt = jImageView1.Count then Img_Cnt:= 0;
  jImageView1.ImageIndex:= Img_Cnt;
end;

procedure TAndroidModule3.jButton1Click(Sender: TObject);
begin
  jDialogYN1.Show;
end;

procedure TAndroidModule3.jButton2Click(Sender: TObject);
begin
  Prog_Cnt:= 0;
  jDialogProgress1.Start;
  jTimer1.Enabled:= True;
end;

procedure TAndroidModule3.jButton3Click(Sender: TObject);
begin
  Prog_Cnt:= jProgressBar1.Progress;   //default  =0
  Prog_Max:= jProgressBar1.Max;        //default  =100
  jProgressBar1.Start;
  jTimer2.Enabled:= True;
end;

procedure TAndroidModule3.jButton4Click(Sender: TObject);
begin
   ShowMessage(jEditText1.Text);
end;

procedure TAndroidModule3.jCheckBox1Click(Sender: TObject);
begin
  case jCheckBox1.Checked of
     True  : ShowMessage('CheckBox1 checked');
     False : begin
               ShowMessage('CheckBox1 and jRadioButton1 unchecked!');
               jRadioButton1.Checked:= False;
             end;
  end;
end;

procedure TAndroidModule3.DataModuleCreate(Sender: TObject);
begin //this initialization code is need here to fix Laz4Andoid  *.lfm parse.... why parse fails?
  Img_Cnt:= -1;
(*  Self.ActivityMode:= actRecyclable;
  //Self.BackgroundColor:= colbrBlack;
  //mode delphi
  Self.OnJNIPrompt:= DataModuleJNIPrompt;
  Self.OnRotate:= DataModuleRotate;
  Self.OnCloseQuery:= DataModuleCloseQuery;
 // Self.OnActive:= DataModuleActive;
  Self.OnClose:= DataModuleClose;    *)
end;

procedure TAndroidModule3.DataModuleCloseQuery(Sender: TObject; var CanClose: boolean);
begin
  CanClose:= True;
  ShowMessage('close form 3');
end;

procedure TAndroidModule3.DataModuleClose(Sender: TObject);
begin
  jTimer3.Enabled:= False;
end;

procedure TAndroidModule3.DataModuleJNIPrompt(Sender: TObject);
begin
  jTimer3.Enabled:= True;
  jEditText1.SetFocus;
end;

end.
