{hint: Pascal files location: ...\AppBatteryManagerDemo1\jni }
unit unit1;

{$mode delphi}

interface

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, AndroidWidget, Laz_And_Controls, batterymanager;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jBatteryManager1: jBatteryManager;
    jButton1: jButton;
    jTextView1: jTextView;
    procedure jBatteryManager1Charging(Sender: TObject;
      batteryAtPercentLevel: integer; pluggedBy: TChargePlug);
    procedure jBatteryManager1DisCharging(Sender: TObject;
      batteryAtPercentLevel: integer);
    procedure jBatteryManager1Full(Sender: TObject;
      batteryAtPercentLevel: integer);
    procedure jBatteryManager1NotCharging(Sender: TObject;
      batteryAtPercentLevel: integer);
    procedure jBatteryManager1Unknown(Sender: TObject;
      batteryAtPercentLevel: integer);
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

procedure TAndroidModule1.jBatteryManager1Charging(Sender: TObject;
  batteryAtPercentLevel: integer; pluggedBy: TChargePlug);
begin
   case pluggedBy of
      cpUSB: ShowMessage('Charging... by USB: '+IntToStr(batteryAtPercentLevel)+'%');
      cpAC:  ShowMessage('Charging... by AC: '+IntToStr(batteryAtPercentLevel)+'%');
      cpUnknown: ShowMessage('Charging... : '+IntToStr(batteryAtPercentLevel)+'%');
   end;
end;

procedure TAndroidModule1.jBatteryManager1DisCharging(Sender: TObject;
  batteryAtPercentLevel: integer);
begin
  ShowMessage('DisCharging... : '+IntToStr(batteryAtPercentLevel)+'%');
end;

procedure TAndroidModule1.jBatteryManager1Full(Sender: TObject;
  batteryAtPercentLevel: integer);
begin
  ShowMessage('Full... : '+IntToStr(batteryAtPercentLevel)+'%');
end;

procedure TAndroidModule1.jBatteryManager1NotCharging(Sender: TObject;
  batteryAtPercentLevel: integer);
begin
  ShowMessage('NotCharging... : '+IntToStr(batteryAtPercentLevel)+'%');
end;

procedure TAndroidModule1.jBatteryManager1Unknown(Sender: TObject;
  batteryAtPercentLevel: integer);
begin
 ShowMessage('Unknown... : '+IntToStr(batteryAtPercentLevel)+'%');
end;

procedure TAndroidModule1.jButton1Click(Sender: TObject);
begin
   ShowMessage('Battery = '+ IntToStr(jBatteryManager1.GetBatteryPercent())+'%')
end;

end.
