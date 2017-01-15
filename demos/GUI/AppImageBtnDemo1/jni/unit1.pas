{Hint: save all files to location: C:\android-neon\eclipse\workspace\AppImageBtnDemo1\jni }
unit unit1;

{$mode delphi}

interface

uses
  Classes, SysUtils, AndroidWidget, Laz_And_Controls;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jButton1: jButton;
    jImageBtn1: jImageBtn;
    jImageBtn2: jImageBtn;
    jImageList1: jImageList;
    jTextView1: jTextView;
    procedure jButton1Click(Sender: TObject);
    procedure jImageBtn1Click(Sender: TObject);
    procedure jImageBtn2Click(Sender: TObject);
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
  ShowMessage('Button Clicked!');
end;

procedure TAndroidModule1.jImageBtn1Click(Sender: TObject);
begin
   ShowMessage('Image Btn 1 Clicked!');
end;

procedure TAndroidModule1.jImageBtn2Click(Sender: TObject);
begin
    ShowMessage('Image Btn 2 Clicked!');
end;

end.
