{Hint: save all files to location: C:\adt32\eclipse\workspace\AppSensorDemo1\jni }
unit unit1;
  
{$mode delphi}
  
interface
  
uses
  Classes, SysUtils, And_jni, And_jni_Bridge, Laz_And_Controls, 
    Laz_And_Controls_Events, AndroidWidget, sensormanager;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
      jButton1: jButton;
      jListView1: jListView;
      jSensorManager1: jSensorManager;
      jTextView1: jTextView;
      procedure jButton1Click(Sender: TObject);
      procedure jListView1ClickItem(Sender: TObject; itemIndex: integer;
        itemCaption: string);
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

//Hint ref: http://developer.android.com/reference/android/hardware/SensorEvent.html
procedure TAndroidModule1.jButton1Click(Sender: TObject);
var
   listNames: TDynArrayOfString;
   listTypes: TDynArrayOfInteger;
   count,i: integer;
begin
    listNames:= jSensorManager1.GetDeviceSensorsNames();
    listTypes:= jSensorManager1.GetDeviceSensorsTypes();
    count:= Length(listNames);
    for i:=0 to count-1 do
    begin
      jListView1.Add(listNames[i] +' ['+IntToStr(listTypes[i])+']');
    end;
    SetLength(listNames,0);
    SetLength(listTypes,0);
end;

procedure TAndroidModule1.jListView1ClickItem(Sender: TObject;
  itemIndex: integer; itemCaption: string);
var
    sensorName: string;
    index: integer;
    sensor: jObject;
begin
    index:= Pos('[', itemCaption);
    sensorName:= Copy(itemCaption, 1, index-2);
    sensor:= jSensorManager1.GetSensor(sensorName);
    ShowMessage(jSensorManager1.GetSensorVendor(sensor));
end;

end.
