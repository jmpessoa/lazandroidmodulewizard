{Hint: save all files to location: C:\android-neon\eclipse\workspace\AppNumberPickerDemo1\jni }
unit unit1;

{$mode delphi}

interface

uses
  Classes, SysUtils, AndroidWidget, Laz_And_Controls, numberpicker;

type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jButton1: jButton;
    jButton2: jButton;
    jNumberPickerDialog1: jNumberPickerDialog;
    jTextView1: jTextView;
    procedure jButton1Click(Sender: TObject);
    procedure jButton2Click(Sender: TObject);
    procedure jNumberPickerDialog1NumberPicker(Sender: TObject;
      oldValue: integer; newValue: integer);
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
  jNumberPickerDialog1.SetTitle('Pick Number:');
  jNumberPickerDialog1.ClearDisplayedValues(); //here just to take care of "this" app logic ...
  jNumberPickerDialog1.MinValue:= 0;   //here just to take care of "this" app logic ...
  jNumberPickerDialog1.MaxValue:= 10;  //here just to take care of "this" app logic ...
  //jNumberPickerDialog1.Value:= 5;   //set in designer time
  jNumberPickerDialog1.Show();
end;

procedure TAndroidModule1.jButton2Click(Sender: TObject);
var
  values: TDynArrayOfString;
begin
  SetLength(values, 4);
  values[0]:= 'Hello';
  values[1]:= 'World';
  values[2]:= 'Android';
  values[3]:= 'Pascal';
  jNumberPickerDialog1.SetTitle('Pick Number by Label:');
  jNumberPickerDialog1.SetDisplayedValues(values);
  jNumberPickerDialog1.Show();
  SetLength(values, 0);
end;

procedure TAndroidModule1.jNumberPickerDialog1NumberPicker(Sender: TObject;
  oldValue: integer; newValue: integer);
begin
  ShowMessage('newVlaue='+ IntToStr(newValue));
end;

end.
