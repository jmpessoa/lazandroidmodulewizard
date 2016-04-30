{Hint: save all files to location: C:\adt32\eclipse\workspace\AppAutoCompleteTextViewDemo1\jni }
unit unit1;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, And_jni_Bridge, Laz_And_Controls, 
    Laz_And_Controls_Events, AndroidWidget, autocompletetextview;

type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jAutoTextView1: jAutoTextView;
    jButton1: jButton;
    jEditText1: jEditText;
    jTextView1: jTextView;
    procedure AndroidModule1BackButton(Sender: TObject);
    procedure AndroidModule1SpecialKeyDown(Sender: TObject; keyChar: char;
      keyCode: integer; keyCodeString: string; var mute: boolean);
    procedure jAutoTextView1Click(Sender: TObject);
    procedure jAutoTextView1ClickDropDownItem(Sender: TObject;
      itemIndex: integer; itemCaption: string);
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

procedure TAndroidModule1.jAutoTextView1Click(Sender: TObject);
begin
  //ShowMessage('Click me ....');
  jAutoTextView1.ShowDropDown();
end;

procedure TAndroidModule1.AndroidModule1BackButton(Sender: TObject);
begin
  ShowMessage('Hello Home!');
end;

procedure TAndroidModule1.AndroidModule1SpecialKeyDown(Sender: TObject;
  keyChar: char; keyCode: integer; keyCodeString: string; var mute: boolean);
begin
   ShowMessage(keyCodeString);
end;


procedure TAndroidModule1.jAutoTextView1ClickDropDownItem(Sender: TObject;
  itemIndex: integer; itemCaption: string);
begin
  ShowMessage('Caption= ' + itemCaption + '  ::  Index= ' + IntToStr(itemIndex));
end;

end.
