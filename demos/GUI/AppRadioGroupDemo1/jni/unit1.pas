{Hint: save all files to location: C:\adt32\eclipse\workspace\AppRadioGroupDemo1\jni }
unit unit1;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, And_jni_Bridge, Laz_And_Controls, 
    Laz_And_Controls_Events, AndroidWidget, radiogroup;

type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jButton1: jButton;
    jRadioButton1: jRadioButton;
    jRadio2: jRadioButton;
    jRadio3: jRadioButton;
    jRadioButton4: jRadioButton;
    jRadioGroup1: jRadioGroup;
    jTextView1: jTextView;
    procedure AndroidModule1JNIPrompt(Sender: TObject);
    procedure jButton1Click(Sender: TObject);
    procedure jRadioButton1Click(Sender: TObject);
    procedure jRadioButton2Click(Sender: TObject);
    procedure jRadioGroup1CheckedChanged(Sender: TObject;
      checkedIndex: integer; checkedCaption: string);

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


procedure TAndroidModule1.jRadioButton1Click(Sender: TObject);
begin
   // ShowMessage('1 Click'); //ok!
end;

procedure TAndroidModule1.AndroidModule1JNIPrompt(Sender: TObject);
begin
  jRadioGroup1.CheckedIndex:= 2;  // <<-- initialize here!!
end;

procedure TAndroidModule1.jButton1Click(Sender: TObject);
begin
  ShowMessage('CheckedIndex = '+IntToStr(jRadioGroup1.CheckedIndex) + ' :: caption = '+ jRadioGroup1.GetChekedRadioButtonCaption());
end;

procedure TAndroidModule1.jRadioButton2Click(Sender: TObject);
begin
    //  ShowMessage('2 Click'); //ok
end;

procedure TAndroidModule1.jRadioGroup1CheckedChanged(Sender: TObject;
  checkedIndex: integer; checkedCaption: string);
begin
   ShowMessage('CheckedIndex = '+IntToStr(checkedIndex) + '  :: '+  checkedCaption);
end;

end.
