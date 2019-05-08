{Hint: save all files to location: C:\android\workspace\AppCompatContinuousScrollableImageViewDemo1\jni }
unit unit1;

{$mode delphi}

interface

uses
  Classes, SysUtils, AndroidWidget, Laz_And_Controls,
  scontinuousscrollableimageview;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jPanel1: jPanel;
    jsContinuousScrollableImageView1: jsContinuousScrollableImageView;
    jsContinuousScrollableImageView2: jsContinuousScrollableImageView;
    jsContinuousScrollableImageView3: jsContinuousScrollableImageView;
    jTextView1: jTextView;
    procedure jsContinuousScrollableImageView1Click(Sender: TObject);

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

//https://github.com/Cutta/ContinuousScrollableImageView
procedure TAndroidModule1.jsContinuousScrollableImageView1Click(Sender: TObject);
begin
   ShowMessage('ref.  https://github.com/Cutta/ContinuousScrollableImageView');
   //jsContinuousScrollableImageView1.Direction:= sdLeft;
end;

end.
