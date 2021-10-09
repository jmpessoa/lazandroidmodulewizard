{hint: Pascal files location: ...\AppModbusDemo1\jni }
unit unit1;

{$mode delphi}

interface

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, AndroidWidget, Laz_And_Controls, modbus;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jButton1: jButton;
    jButton2: jButton;
    jEditText1: jEditText;
    jEditText2: jEditText;
    jImageView1: jImageView;
    jModbus1: jModbus;
    jTextView1: jTextView;
    jTextView2: jTextView;
    jTextView3: jTextView;
    procedure jButton1Click(Sender: TObject);
    procedure jButton2Click(Sender: TObject);
    procedure jImageView1Click(Sender: TObject);
    procedure jModbus1Connect(Sender: TObject; success: boolean; msg: string);
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

procedure TAndroidModule1.jModbus1Connect(Sender: TObject; success: boolean;
  msg: string);
begin
  if success then
  begin
    jImageView1.ImageIdentifier:= 'connect_down_48';
    ShowMessage('Success On Init! [' + msg + ']')
  end
  else
    ShowMessage('Fail  On Init .... ' + msg)
end;


procedure TAndroidModule1.jImageView1Click(Sender: TObject);
begin
  jModbus1.Connect(jEditText1.Text, StrToInt(jEditText2.Text)); //_hostIP: string; _portNumber: integer
end;

procedure TAndroidModule1.jButton1Click(Sender: TObject);
begin
  if jModbus1.IsConnected() then
  begin
    jModbus1.ReadCoil(1, 1, 2);    //_slaveId: integer; _start: integer; _len: integer
  end;
end;

procedure TAndroidModule1.jButton2Click(Sender: TObject);
begin
  if jModbus1.IsConnected() then
  begin
    jModbus1.WriteCoil(1, 1, True);   // _slaveId: integer; _offset: integer; _value: boolean
  end;
end;

end.
