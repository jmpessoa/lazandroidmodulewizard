{Hint: save all files to location: C:\adt32\eclipse\workspace\AppTest1\jni }
unit unit1;
  
{$mode delphi}
  
interface
  
uses
  Classes, SysUtils, And_jni, And_jni_Bridge, Laz_And_Controls,
  Laz_And_Controls_Events, AndroidWidget, Unit2, unit5;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
      jButton1: jButton;
      jButton2: jButton;
      jButton3: jButton;
      jEditText1: jEditText;
      jListView1: jListView;
      jPanel1: jPanel;
      jPanel2: jPanel;
      jPanel3: jPanel;
      jPanel4: jPanel;
      jPanel5: jPanel;
      jTextView1: jTextView;
      jTextView2: jTextView;

      procedure AndroidModule1JNIPrompt(Sender: TObject);
      procedure AndroidModule1Rotate(Sender: TObject; rotate: integer; var rstRotate: integer);
      procedure jButton1Click(Sender: TObject);
      procedure jButton2Click(Sender: TObject);
      procedure jButton3Click(Sender: TObject);

    private
      {private declarations}
    public
      {public declarations}
      Procedure CallBackNotify(Sender: TObject);
      Procedure CallBackData(Sender: TObject; strData: string; intData: integer; doubleData: double);

  end;
  
var
  AndroidModule1: TAndroidModule1;

implementation
  
{$R *.lfm}

{ TAndroidModule1 }

Procedure TAndroidModule1.CallBackNotify(Sender: TObject);
begin
  //ShowMessage('Form 2 close notify!');  //ok!
end;

Procedure TAndroidModule1.CallBackData(Sender: TObject; strData: string; intData: integer; doubleData: double);
begin
  jListView1.Add('form 2: '+ strData);
  jListView1.Add('form 2: '+IntToStr(intData));
  jListView1.Add('form 2: '+FloatToStr(doubleData));
end;

procedure TAndroidModule1.jButton1Click(Sender: TObject);
begin
  jListView1.Add(jEditText1.Text);
end;

procedure TAndroidModule1.jButton2Click(Sender: TObject);
begin
  if(AndroidModule2 = nil) then
  begin
    gApp.CreateForm(TAndroidModule2, AndroidModule2);
    AndroidModule2.SetCloseCallBack(CallBackNotify, Self);
    AndroidModule2.SetCloseCallBack(CallBackData, Self);
    AndroidModule2.PromptOnBackKey:= False;
    AndroidModule2.Init(gApp);
  end
  else
  begin
    AndroidModule2.Show;
  end;
end;

procedure TAndroidModule1.jButton3Click(Sender: TObject);
begin
  if AndroidModule5 = nil then
  begin
     gApp.CreateForm(TAndroidModule5, AndroidModule5);
     AndroidModule5.Init(gApp);
  end
  else
  begin
    AndroidModule5.Show;
  end;
end;

procedure TAndroidModule1.AndroidModule1JNIPrompt(Sender: TObject);
begin
   ShowMessage('jForm 1 jni prompt!  FormBaseIndex = '+ IntToStr(Self.FormBaseIndex)+
                                  '  FormIndex = '+ IntToStr(Self.FormIndex));
end;

procedure TAndroidModule1.AndroidModule1Rotate(Sender: TObject; rotate: integer; var rstRotate: integer);
begin
   if rotate = 1 then
   begin
     jPanel1.LayoutParamHeight:= lpOneQuarterOfParent;
     jPanel1.LayoutParamWidth:= lpMatchParent;
     jPanel1.PosRelativeToParent:= [rpTop];

     jPanel2.PosRelativeToAnchor:= [raBelow];

     jPanel1.ResetAllRules;
     jPanel2.ResetAllRules;

     jPanel4.PosRelativeToParent:= [rpBottom,rpLeft];
     jPanel5.PosRelativeToParent:= [rpBottom,rpRight];
     jPanel4.ResetAllRules;
     jPanel5.ResetAllRules;

   end;
   if rotate = 2 then
   begin
     jPanel1.LayoutParamHeight:= lpMatchParent;
     jPanel1.LayoutParamWidth:= lpOneThirdOfParent;
     jPanel1.PosRelativeToParent:= [rpLeft];

     jPanel2.PosRelativeToAnchor:= [raToRightOf];

     jPanel1.ResetAllRules;
     jPanel2.ResetAllRules;

     jPanel4.PosRelativeToParent:= [rpCenterVertical,rpLeft];
     jPanel5.PosRelativeToParent:= [rpCenterVertical,rpRight];
     jPanel4.ResetAllRules;
     jPanel5.ResetAllRules;

   end;
   Self.UpdateLayout;
end;


end.
