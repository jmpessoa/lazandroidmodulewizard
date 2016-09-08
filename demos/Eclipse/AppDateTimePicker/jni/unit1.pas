{Hint: save all files to location: C:\adt32\eclipse\workspace\AppDateTimePicker\jni }
unit unit1;
  
{$mode delphi}
  
interface
  
uses
  Classes, SysUtils, And_jni, And_jni_Bridge, Laz_And_Controls,
  Laz_And_Controls_Events, AndroidWidget, datepickerdialog, timepickerdialog,
  chronometer;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
      jButton1: jButton;
      jButton2: jButton;
      jButton3: jButton;
      jButton4: jButton;
      jDatePickerDialog1: jDatePickerDialog;
      jTextView1: jTextView;
      jTimePickerDialog1: jTimePickerDialog;
      procedure jButton1Click(Sender: TObject);
      procedure jButton2Click(Sender: TObject);
      procedure jButton3Click(Sender: TObject);
      procedure jButton4Click(Sender: TObject);
      procedure jDatePickerDialog1DatePicker(Sender: TObject; year: integer;
        monthOfYear: integer; dayOfMonth: integer);
      procedure jTimePickerDialog1TimePicker(Sender: TObject;
        hourOfDay: integer; minute: integer);
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
   jTimePickerDialog1.Show();
end;

procedure TAndroidModule1.jButton2Click(Sender: TObject);
begin
  jDatePickerDialog1.Show();
end;

procedure TAndroidModule1.jButton3Click(Sender: TObject);
begin
  jTimePickerDialog1.Show(15, 15);
end;

procedure TAndroidModule1.jButton4Click(Sender: TObject);
begin
  jDatePickerDialog1.Show(2015, 2, 3);
end;

procedure TAndroidModule1.jDatePickerDialog1DatePicker(Sender: TObject;
  year: integer; monthOfYear: integer; dayOfMonth: integer);
begin
   ShowMessage('year: '+ IntToStr(year) +
               ' monthOfYear: '+ IntToStr(monthOfYear)+
               ' dayOfMonth: '+ IntToStr(dayOfMonth));
end;

procedure TAndroidModule1.jTimePickerDialog1TimePicker(Sender: TObject;
  hourOfDay: integer; minute: integer);
begin
     ShowMessage('hourOfDay: '+ IntToStr(hourOfDay) +
                 ' minute: '+ IntToStr(minute));
end;

end.
