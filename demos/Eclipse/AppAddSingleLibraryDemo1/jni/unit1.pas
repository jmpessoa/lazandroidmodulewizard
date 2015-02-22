{Hint: save all files to location: C:\adt32\eclipse\workspace\AppAddSingleLibraryDemo1\jni }
unit unit1;
  
{$mode delphi}
  
interface
  
uses
  Classes, SysUtils, And_jni, And_jni_Bridge, Laz_And_Controls, 
    Laz_And_Controls_Events, AndroidWidget, helloadder;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
      jButton1: jButton;
      jHelloAdder1: jHelloAdder;
      jTextView1: jTextView;
      procedure jButton1Click(Sender: TObject);
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
var
  str: string;
begin
  ShowMessage('jHelloAdder1.Add(5,12)= '+IntToStr(jHelloAdder1.Add(5,12)));

  str:= 'Hello World!';
  ShowMessage('jHelloAdder1.StringUpperCase('+str+')= '+jHelloAdder1.StringUpperCase(str));

end;

end.
