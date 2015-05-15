{Hint: save all files to location: C:\adt32\eclipse\workspace\AppCustomShowMessageDemo1\jni }
unit unit1;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, And_jni_Bridge, Laz_And_Controls, 
    Laz_And_Controls_Events, AndroidWidget, digitalclock;

type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jButton1: jButton;
    jButton2: jButton;
    jCheckBox1: jCheckBox;
    jDigitalClock1: jDigitalClock;
    jImageView1: jImageView;
    jPanel1: jPanel;
    jTextView1: jTextView;
    jTextView2: jTextView;
    procedure AndroidModule1JNIPrompt(Sender: TObject);
    procedure jButton1Click(Sender: TObject);
    procedure jButton2Click(Sender: TObject);
    procedure jCheckBox1Click(Sender: TObject);

  private
    {private declarations}
       FlyingAppTitle: boolean;
  public
    {public declarations}
  end;

var
  AndroidModule1: TAndroidModule1;

implementation

{$R *.lfm}

{ TAndroidModule1 }

//Note: jPanel1.Visible:= false!
procedure TAndroidModule1.jButton1Click(Sender: TObject);
begin
   ShowCustomMessage(jPanel1.View, gvBottom);  //gvCenter
end;

procedure TAndroidModule1.AndroidModule1JNIPrompt(Sender: TObject);
begin
   //Self.SetScreenOrientation(ssLandScape);
   FlyingAppTitle:= False;
end;

procedure TAndroidModule1.jButton2Click(Sender: TObject);
begin
   if not FlyingAppTitle then
   begin
      ShowCustomMessage(jTextView1.View, gvCenter);   //  just for fun!
      FlyingAppTitle:= True
   end
   else
   begin
      jTextView1.PosRelativeToParent:= [rpTop, rpCenterHorizontal];
      jTextView1.ViewParent:= Self.View;
      FlyingAppTitle:= False;
   end;

end;

procedure TAndroidModule1.jCheckBox1Click(Sender: TObject);
begin
  if jCheckBox1.Checked then
     ShowCustomMessage(jTextView2.View, gvCenter)  //just for fun!
  else
     jTextView2.ViewParent:= jPanel1.View;
end;


end.
