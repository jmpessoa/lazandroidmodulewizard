{Hint: save all files to location: C:\adt32\eclipse\workspace\AppTryCode1\jni }
unit unit1;
  
{$mode delphi}
  
interface
  
uses
  Classes, SysUtils, And_jni, And_jni_Bridge, Laz_And_Controls, AndroidWidget, myhello;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
      jButton1: jButton;
      jButton2: jButton;
      jButton3: jButton;
      jButton4: jButton;
      jMyHello1: jMyHello;
      jTextView1: jTextView;

      procedure jButton1Click(Sender: TObject);
      procedure jButton2Click(Sender: TObject);
      procedure jButton3Click(Sender: TObject);
      procedure jButton4Click(Sender: TObject);
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
  ShowMessage(jMyHello1.Hello);
end;

procedure TAndroidModule1.jButton2Click(Sender: TObject);
var
  V1, V2, VR:  TDynArrayOfInteger;
  i, size: integer;
  strRes: string;
begin

  size:= 3;
  SetLength(V1, size);
  V1[0]:= 1;
  V1[1]:= 3;
  V1[2]:= 5;

  SetLength(V2, size);
  V2[0]:= 2;
  V2[1]:= 4;
  V2[2]:= 6;


  VR:= jMyHello1.GetSumIntArray(V1, V2, size);

  strRes:= ' # ';
  for i:= 0 to size-1 do
  begin
     strRes:= strRes +  'VR['+IntToStr(i)+']='+IntToStr(VR[i]) + ' # ';
  end;
  ShowMessage(strRes);

  SetLength(V1, 0);
  SetLength(V2, 0);
  SetLength(VR, 0);

end;

procedure TAndroidModule1.jButton3Click(Sender: TObject);
var
  dynArrayStrData, dyynArrayStrDataUP: TDynArrayOfString;
  i, size: integer;
begin

  SetLength(dynArrayStrData, 2);
  dynArrayStrData[0]:= 'Hello Lazarus';
  dynArrayStrData[1]:= 'Pascal World!';

  dyynArrayStrDataUP:= jMyHello1.ToUpperStringArray(dynArrayStrData);

  size:= Length(dyynArrayStrDataUP);
  for i:= 0 to size-1 do
  begin
    ShowMessage(dyynArrayStrDataUP[i]);
  end;

  SetLength(dynArrayStrData, 0);
  SetLength(dyynArrayStrDataUP, 0);

end;

procedure TAndroidModule1.jButton4Click(Sender: TObject);
var
  strDynArray1, strDynArray2, strDynArrayRes: TDynArrayOfString;
  i, size: integer;
begin

  SetLength(strDynArray1, 2);
  strDynArray1[0]:= 'Lazarus Pascal';
  strDynArray1[1]:= 'for Android World!';

  SetLength(strDynArray2, 2);
  strDynArray2[0]:= 'Lazarus Android Wizard';
  strDynArray2[1]:= 'for RAD!';

  strDynArrayRes:= jMyHello1.ConcatStringArray(strDynArray1, strDynArray2);

  size:= Length(strDynArrayRes);
  for i:= 0 to size-1 do
  begin
    ShowMessage(strDynArrayRes[i]);
  end;

  SetLength(strDynArray1, 0);
  SetLength(strDynArray2, 0);
  SetLength(strDynArrayRes, 0);

end;

end.
