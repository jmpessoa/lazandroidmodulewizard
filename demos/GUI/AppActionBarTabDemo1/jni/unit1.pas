{Hint: save all files to location: C:\adt32\eclipse\workspace\AppActionBarTabDemo1\jni }
unit unit1;
  
{$mode delphi}
  
interface
  
uses
  Classes, SysUtils, And_jni, And_jni_Bridge, Laz_And_Controls, 
    Laz_And_Controls_Events, AndroidWidget, actionbartab;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
      jActionBarTab1: jActionBarTab;
      jButton1: jButton;
      jButton2: jButton;
      jCheckBox1: jCheckBox;
      jEditText1: jEditText;
      jEditText2: jEditText;
      jImageView1: jImageView;
      jListView1: jListView;
      jPanel1: jPanel;
      jPanel2: jPanel;
      jPanel3: jPanel;
      jPanel4: jPanel;
      jTextView1: jTextView;
      jTextView2: jTextView;
      jTextView3: jTextView;

      procedure AndroidModule1JNIPrompt(Sender: TObject);
      procedure jActionBarTab1TabSelected(Sender: TObject; view: jObject; title: string);
      procedure jActionBarTab1UnSelected(Sender: TObject; view: jObject; title: string);
      procedure jButton1Click(Sender: TObject);
      procedure jButton2Click(Sender: TObject);
      procedure jPanel1FlingGesture(Sender: TObject; flingGesture: TFlingGesture);
      procedure jPanel2FlingGesture(Sender: TObject; flingGesture: TFlingGesture);
      procedure jPanel4FlingGesture(Sender: TObject; flingGesture: TFlingGesture);

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
    Self.SetIconActionBar('ic_bullets');

    //prepare custom tab view - jPanel3
    jPanel3.MatchParent();
    //jPanel3.CenterInParent();
    jTextView3.TextTypeFace:= tfBold;
    jImageView1.SetImageByResIdentifier('ic_bullet_red');    //...\res\drawable-xxx
    jCheckBox1.Checked:= True;

    jActionBarTab1.Add('NAME', jPanel1.View{sheet view}, 'ic_bullet_green');    // ...\res\drawable-xxx
    jActionBarTab1.Add('ADDRESS', jPanel2.View {sheet view}, 'ic_bullet_yellow'); //...\res\drawable-xxx
    jActionBarTab1.Add('ADDLIST', jPanel4.View{sheet view}, jPanel3.View {custom tab view!});

    Self.SetTabNavigationModeActionBar;  //this is needed!!!

end;

procedure TAndroidModule1.jActionBarTab1TabSelected(Sender: TObject;
  view: jObject; title: string);
begin
    //ShowMessage('Tab Selected: '+title);
end;

procedure TAndroidModule1.jActionBarTab1UnSelected(Sender: TObject;
  view: jObject; title: string);
begin
   //ShowMessage('Tab Un Selected: '+title);
end;

procedure TAndroidModule1.jButton1Click(Sender: TObject);
begin

  if jCheckBox1.Checked then
  begin
     jListView1.Add(jEditText1.Text);
     ShowMessage(jEditText1.Text + ': Added to List ...')
  end
  else ShowMessage(jEditText1.Text + ': Not Listed!');
end;

procedure TAndroidModule1.jButton2Click(Sender: TObject);
begin
    if jCheckBox1.Checked then
    begin
      jListView1.Add(jEditText2.Text);
      ShowMessage(jEditText2.Text + ': Added to List ... ');
    end
    else ShowMessage(jEditText2.Text + ': Not Listed!');
end;

procedure TAndroidModule1.jPanel1FlingGesture(Sender: TObject;
  flingGesture: TFlingGesture);
begin
   case flingGesture of
     fliLeftToRight: jActionBarTab1.SelectTabByIndex(2);
     fliRightToLeft: jActionBarTab1.SelectTabByIndex(1);
  end;
end;

procedure TAndroidModule1.jPanel2FlingGesture(Sender: TObject;
  flingGesture: TFlingGesture);
begin
   case flingGesture of
     fliLeftToRight: jActionBarTab1.SelectTabByIndex(0);
     fliRightToLeft: jActionBarTab1.SelectTabByIndex(2);
  end;
end;

procedure TAndroidModule1.jPanel4FlingGesture(Sender: TObject;
  flingGesture: TFlingGesture);
begin
  case flingGesture of
    fliLeftToRight: jActionBarTab1.SelectTabByIndex(1);
    fliRightToLeft: jActionBarTab1.SelectTabByIndex(0);
  end;
end;

end.
