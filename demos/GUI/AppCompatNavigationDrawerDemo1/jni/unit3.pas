{Hint: save all files to location: \jni }
unit unit3;

{$mode delphi}

interface

uses
  Classes, SysUtils, AndroidWidget, Laz_And_Controls;
  
type

  { TAndroidModule3 }

  TAndroidModule3 = class(jForm)
    jImageView1: jImageView;
    jPanel1: jPanel;
    jTextView1: jTextView;
    procedure AndroidModule3JNIPrompt(Sender: TObject);
    procedure AndroidModule3Rotate(Sender: TObject; rotate: TScreenStyle);
    procedure jImageView1Click(Sender: TObject);
  private
    {private declarations}
  public
    {public declarations}
  end;

var
  AndroidModule3: TAndroidModule3;

implementation
  
{$R *.lfm}
  

{ TAndroidModule3 }

procedure TAndroidModule3.jImageView1Click(Sender: TObject);
begin
    ShowMessage('Scene 3');
end;

procedure TAndroidModule3.AndroidModule3JNIPrompt(Sender: TObject);
begin
   if Self.GetScreenOrientationStyle =  ssLandscape then
   begin
     jTextView1.PosRelativeToParent:= [rpCenterHorizontal];
     jTextView1.UpdateLayout;
   end
end;

procedure TAndroidModule3.AndroidModule3Rotate(Sender: TObject;
  rotate: TScreenStyle);
begin
   if rotate =  ssLandscape then
   begin
     jTextView1.PosRelativeToParent:= [rpCenterHorizontal];
   end
   else
   begin
     jTextView1.PosRelativeToParent:= [rpLeft];
   end;
   Self.UpdateLayout;
end;

end.
