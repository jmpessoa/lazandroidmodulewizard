{Hint: save all files to location: \jni }
unit unit5;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, And_jni_Bridge, Laz_And_Controls, 
    Laz_And_Controls_Events, AndroidWidget;

type

  { TAndroidModule5 }

  TAndroidModule5 = class(jForm)
    jButton1: jButton;
    procedure jButton1Click(Sender: TObject);
  private
    {private declarations}
  public
    {public declarations}
  end;

var
  AndroidModule5: TAndroidModule5;

implementation

{$R *.lfm}

{ TAndroidModule5 }

procedure TAndroidModule5.jButton1Click(Sender: TObject);
var
   baseform: jForm;
begin
    baseform:= jForm(gApp.Forms.Stack[Self.FormBaseIndex].Form);
    ShowMessage(baseform.Name);
    ShowMessage(IntToStr(baseform.Tag));
    ShowMessage('jForm 5 Hello!');
end;

end.
