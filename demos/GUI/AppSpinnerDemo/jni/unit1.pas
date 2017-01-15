{Hint: save all files to location: C:\adt32\eclipse\workspace\AppSpinnerDemo\jni }
unit unit1;
  
{$mode delphi}
  
interface
  
uses
  Classes, SysUtils, And_jni, And_jni_Bridge, Laz_And_Controls, 
    Laz_And_Controls_Events, AndroidWidget, spinner;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
      jButton1: jButton;
      jButton2: jButton;
      jEditText1: jEditText;
      jSpinner1: jSpinner;
      jSpinner2: jSpinner;
      jTextView1: jTextView;
      jTextView2: jTextView;
      jTextView3: jTextView;
      procedure AndroidModule1Create(Sender: TObject);
      procedure jButton1Click(Sender: TObject);
      procedure jButton2Click(Sender: TObject);
      procedure jSpinner1ItemSelected(Sender: TObject; caption: string;
        position: integer);
      procedure jSpinner2ItemSelected(Sender: TObject; caption: string;
        position: integer);
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

procedure TAndroidModule1.jSpinner1ItemSelected(Sender: TObject; caption: string; position: integer);
begin
  ShowMessage(caption);
end;

procedure TAndroidModule1.jSpinner2ItemSelected(Sender: TObject;
  caption: string; position: integer);
begin
   case position of
     0: jButton1.FontColor:= colbrYellow;
     1: jButton1.FontColor:= colbrRed;
     2: jButton1.FontColor:= colbrBlue;
     3: jButton1.FontColor:= colbrGreen;
   end;
end;

procedure TAndroidModule1.jButton1Click(Sender: TObject);
begin
  ShowMessage('caption='+jSpinner1.GetSelectedItem() + ' :  Index='+IntToStr(jSpinner1.GetSelectedItemPosition()));
end;

procedure TAndroidModule1.jButton2Click(Sender: TObject);
begin
   jEditText1.Editable:= not jEditText1.Editable;
   ShowMessage(Self.GetDeviceID);
   ShowMessage(Self.GetDevicePhoneNumber);
   ShowMessage(IntToStr(jSpinner1.Count));
end;

procedure TAndroidModule1.AndroidModule1Create(Sender: TObject);
begin
  //FCount = 0;
end;

end.
