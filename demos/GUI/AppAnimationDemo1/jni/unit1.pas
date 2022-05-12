{Hint: save all files to location: C:\android\workspace\AppAnimationDemo1\jni }
unit unit1;

{$mode delphi}

interface

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, AndroidWidget, Laz_And_Controls, unit2;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jButton1: jButton;
    jEditText1: jEditText;
    jEditText2: jEditText;
    jImageView1: jImageView;
    jPanel1: jPanel;
    jTextView1: jTextView;
    jTextView2: jTextView;
    jTextView3: jTextView;
    jTextView4: jTextView;
    procedure jButton1Click(Sender: TObject);
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
  //prepare scene at first launch...
  //put initialize here to not "delay" the application at startup...

  if AndroidModule2 = nil then //hint: property "ActiveMode = actEasel" dont "show"  form
  begin
    gApp.CreateForm(TAndroidModule2, AndroidModule2);
    AndroidModule2.Init;
    AndroidModule2.jPanel1.Parent:= Self;   // <<-------- need to handle LayoutParamWidth/LayoutParamHeight "OnRotate"
    AndroidModule2.jPanel1.SetViewParent(Self.View); //add scene 2  to Self
  end;

  AndroidModule2.jPanel1.BringToFront();  //show and do the jPanel1 animation....

end;

end.
