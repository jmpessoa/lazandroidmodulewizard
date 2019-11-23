{Hint: save all files to location: C:\android\workspace\AppGifAnimationDemo1\jni }
unit unit1;

{$mode delphi}

interface

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, AndroidWidget, Laz_And_Controls, gif;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jButton1: jButton;
    jButton2: jButton;
    jGif1: jGif;
    jImageView1: jImageView;
    jTextView1: jTextView;
    procedure AndroidModule1JNIPrompt(Sender: TObject);
    procedure jButton1Click(Sender: TObject);
    procedure jButton2Click(Sender: TObject);
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
  jImageView1.SetImageDrawable(jGif1.LoadFromAssets('logo.gif'));
end;

procedure TAndroidModule1.jButton1Click(Sender: TObject);
begin
  jGif1.Stop();
end;

procedure TAndroidModule1.jButton2Click(Sender: TObject);
begin
   jGif1.Start();
end;

end.
