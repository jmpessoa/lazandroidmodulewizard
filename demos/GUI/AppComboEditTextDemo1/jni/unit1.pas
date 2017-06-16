{Hint: save all files to location: C:\android-neon\eclipse\workspace\AppComboEditTextDemo1\jni }
unit unit1;

{$mode delphi}

interface

uses
  Classes, SysUtils, AndroidWidget, Laz_And_Controls, comboedittext;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jComboEditText1: jComboEditText;
    jTextView1: jTextView;
    procedure jComboEditText1Click(Sender: TObject);
    procedure jComboEditText1ClickDropDownItem(Sender: TObject;
      itemIndex: integer; itemCaption: string);
    procedure jComboEditText1Enter(Sender: TObject);
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

procedure TAndroidModule1.jComboEditText1Click(Sender: TObject);
begin
   jComboEditText1.ShowDropDown();
end;

procedure TAndroidModule1.jComboEditText1ClickDropDownItem(Sender: TObject;
  itemIndex: integer; itemCaption: string);
begin
  //
end;

procedure TAndroidModule1.jComboEditText1Enter(Sender: TObject);
begin
  ShowMessage('Key Enter/Ok ...');
end;

end.
