{Hint: save all files to location: C:\lamw\workspace\AppCalendarViewDemo1\jni }
unit unit1;

{$mode delphi}

interface

uses
  Classes, SysUtils, AndroidWidget, Laz_And_Controls, calendarview;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jCalendarView1: jCalendarView;
    jTextView1: jTextView;
    procedure AndroidModule1JNIPrompt(Sender: TObject);
    procedure jCalendarView1SelectedDayChange(Sender: TObject; year: integer;
      monthOfYear: integer; dayOfMonth: integer);
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
var
  d, m, y, h, min, s : integer;
begin
  self.GetDateTimeDecode(d, m, y, h, min, s);
  jCalendarView1.SetMinDate(y-1, 1, 1);
  jCalendarView1.SetMaxDate(y, 12, 31);

  jCalendarView1.SetDate(y, m, d);

  jTextView1.Text := intToStr(y) + '/' + intToStr(m) + '/' + intToStr(d);
end;

procedure TAndroidModule1.jCalendarView1SelectedDayChange(Sender: TObject;
  year: integer; monthOfYear: integer; dayOfMonth: integer);
begin
  jTextView1.Text := intToStr(year) + '/' + intToStr(monthOfYear) + '/' + intToStr(dayOfMonth);
   ShowMessage('Selected year='+IntToStr(year)+ ' month='+IntTostr(monthOfYear) + ' dayOfMonth='+ IntTostr(dayOfMonth));
end;

end.
