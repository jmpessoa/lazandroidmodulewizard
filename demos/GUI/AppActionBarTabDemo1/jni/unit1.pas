{Hint: save all files to location: C:\adt32\eclipse\workspace\AppActionBarTabDemo1\jni }
unit unit1;
  
{$mode delphi}
  
interface
  
uses
  Classes, SysUtils, And_jni, And_jni_Bridge, Laz_And_Controls,
    Laz_And_Controls_Events, AndroidWidget, actionbartab, gridview;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
      jActionBarTab1: jActionBarTab;
      jButton1: jButton;
      jButton2: jButton;
      jEditText1: jEditText;
      jEditText2: jEditText;
      jListView1: jListView;
      jPanel1: jPanel;
      jPanel2: jPanel;
      jPanel3: jPanel;
      jTextView1: jTextView;
      jTextView2: jTextView;

      procedure AndroidModule1JNIPrompt(Sender: TObject);
      procedure jActionBarTab1TabSelected(Sender: TObject; view: jObject; title: string);
      procedure jActionBarTab1UnSelected(Sender: TObject; view: jObject; title: string);
      procedure jButton1Click(Sender: TObject);
      procedure jButton2Click(Sender: TObject);
      procedure jPanel1FlingGesture(Sender: TObject; flingGesture: TFlingGesture);
      procedure jPanel2FlingGesture(Sender: TObject; flingGesture: TFlingGesture);
      procedure jPanel3FlingGesture(Sender: TObject; flingGesture: TFlingGesture);

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

    //NOTE: for  jPanel1, jPanel2, jPanel3 "LayoutParamHeight =  lpUseWeight"

    Self.SetIconActionBar('ic_bullets');
    jActionBarTab1.Add('ADDNAME', jPanel1.View{sheet view}, 'ic_bullet_green');    // ...\res\drawable-xxx
    jActionBarTab1.Add('ADDRESS', jPanel2.View {sheet view}, 'ic_bullet_yellow'); //...\res\drawable-xxx
    jActionBarTab1.Add('LIST', jPanel3.View{sheet view},'ic_bullet_red');
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
  jListView1.Add(jEditText1.Text);
  ShowMessage(jEditText1.Text + ': Added to List ...')
end;

procedure TAndroidModule1.jButton2Click(Sender: TObject);
begin
  jListView1.Add(jEditText2.Text);
  ShowMessage(jEditText2.Text + ': Added to List ... ');
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

procedure TAndroidModule1.jPanel3FlingGesture(Sender: TObject;
  flingGesture: TFlingGesture);
begin
   case flingGesture of
     fliLeftToRight: jActionBarTab1.SelectTabByIndex(1);
     fliRightToLeft: jActionBarTab1.SelectTabByIndex(0);
   end;
end;

end.
