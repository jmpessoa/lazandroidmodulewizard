{Hint: save all files to location: C:\adt32\eclipse\workspace\AppSensorDemo2\jni }
unit unit1;
  
{$mode delphi}
  
interface
  
uses
  Classes, SysUtils, And_jni, And_jni_Bridge, Laz_And_Controls, 
    Laz_And_Controls_Events, AndroidWidget, sensormanager;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
      jListView1: jListView;
      jSensorManager1: jSensorManager;
      jTextView1: jTextView;
      jTextView2: jTextView;
      procedure AndroidModule1Close(Sender: TObject);
      procedure AndroidModule1CloseQuery(Sender: TObject; var CanClose: boolean);
      procedure jListView1ClickItem(Sender: TObject; itemIndex: integer;
        itemCaption: string);
      procedure jSensorManager1Changed(Sender: TObject; sensor: jObject;
        sensorType: TSensorType; values: array of single; timestamp: int64);
      procedure jSensorManager1Listening(Sender: TObject; sensor: jObject;
        sensorType: TSensorType);
      procedure jSensorManager1UnListening(Sender: TObject;
        sensorType: TSensorType; sensorName: string);
    private
      {private declarations}
    public
      function GetSensorType(Item: integer): TSensorType;
      {public declarations}
  end;
  
var
  AndroidModule1: TAndroidModule1;

implementation
  
{$R *.lfm}

{ TAndroidModule1 }

function TAndroidModule1.GetSensorType(Item: integer): TSensorType;
begin
  case Item of
    0: Result:= stAccelerometer;
    1: Result:= stLight;
    2: Result:= stPressure;
    3: Result:= stProximity;
    4: Result:= stRelativeHumidity;
    5: Result:= stAmbientTemperature;
  end;
end;

procedure TAndroidModule1.jListView1ClickItem(Sender: TObject;
  itemIndex: integer; itemCaption: string);
var
  sensorType: TSensorType;
begin
  sensorType:= GetSensorType(itemIndex);
  if jSensorManager1.SensorExists(sensorType) then
  begin
    ShowMessage('Listening ... '+ jSensorManager1.GetSensorName(jSensorManager1.GetSensor(sensorType)) );
    jSensorManager1.RegisterListeningSensor(sensorType)
  end
  else
    ShowMessage('Sorry, Sensor not found in Device!');
end;

procedure TAndroidModule1.jSensorManager1Changed(Sender: TObject;
  sensor: jObject; sensorType: TSensorType; values: array of single;
  timestamp: int64);
var
   valuesLength: integer;
begin
   valuesLength:= Length(values);
   case sensorType of
      stAccelerometer: begin
                         (* All values are in SI units (m/s2)
                         values[0]: Acceleration [minus] Gx on the x-axis  - table plane
                         values[1]: Acceleration [minus] Gy on the y-axis  - vertical axis
                         values[2]: Acceleration [minus] Gz on the z-axis  - z table plane  *)
                         ShowMessage('Accelerometer :: valuesLength='+IntToStr(valuesLength));
                         ShowMessage('Accelerometer x = '+FloatToStr(values[0])+' (m/s2)');
                         ShowMessage('Accelerometer y = '+FloatToStr(values[1])+' (m/s2)');
                         ShowMessage('Accelerometer z = '+FloatToStr(values[2])+' (m/s2)');
                        //ref. using: http://code.tutsplus.com/tutorials/using-the-accelerometer-on-android--mobile-22125
                      end;
      stLight: begin
                  ShowMessage('Light :: valuesLength='+IntToStr(valuesLength));
                  ShowMessage('Light = '+FloatToStr(values[0])+' (lux)');
               end;
      stPressure: begin
                    ShowMessage('Pressure :: valuesLength='+IntToStr(valuesLength));
                    ShowMessage('Atmospheric Pressure = '+FloatToStr(values[0])+' (hPa) [millibar]'); //Atmospheric pressure in hPa (millibar)
                    ShowMessage('Altitude = '+FloatToStr(jSensorManager1.GetAltitude(values[0])));
                  end;
      stProximity: begin
                     ShowMessage('Proximity :: valuesLength='+IntToStr(valuesLength));
                     ShowMessage('Proximity = '+FloatToStr(values[0])+' (cm) [max perception...]');
                  end;
      stRelativeHumidity: begin
                            ShowMessage('RelativeHumidity :: valuesLength='+IntToStr(valuesLength));
                            ShowMessage('RelativeHumidity = '+FloatToStr(values[0])+' (%)');
                          end;
      stAmbientTemperature: begin
                              ShowMessage('AmbientTemperature :: valuesLength='+IntToStr(valuesLength));
                              ShowMessage('AmbientTemperature = '+FloatToStr(values[0])+'(Grau Celsius)');
                            end;
   end;
   jSensorManager1.UnregisterListenerSensor(sensor)  //just simplistic logic ...
end;

procedure TAndroidModule1.jSensorManager1Listening(Sender: TObject;
  sensor: jObject; sensorType: TSensorType);
begin
  ShowMessage('Listening ... ['+jSensorManager1.GetSensorName(sensor)+']' );
end;

procedure TAndroidModule1.jSensorManager1UnListening(Sender: TObject;
  sensorType: TSensorType; sensorName: string);
begin
   ShowMessage('UnListening ... ('+ sensorName+')');
end;

procedure TAndroidModule1.AndroidModule1Close(Sender: TObject);
begin
   //jSensorManager1.StopListeningAll();
end;

procedure TAndroidModule1.AndroidModule1CloseQuery(Sender: TObject;
  var CanClose: boolean);
begin
  jSensorManager1.StopListeningAll(); //finalize jni process here ....
  CanClose:= True;
end;

end.
