{hint: Pascal files location: ...\AppCompatArduinoAflakSerialDemo1\jni }
unit unit1;

{$mode delphi}

interface

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, AndroidWidget, Laz_And_Controls, ujsarduinoaflakserial, And_jni;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    ArduinoAflakSerial1: jsArduinoAflakSerial;
    Button1: jButton;
    EditText1: jEditText;
    TextView1: jTextView;
    TextView2: jTextView;
    TextView3: jTextView;
    TextView4: jTextView;
    procedure AndroidModule1JNIPrompt(Sender: TObject);
    procedure ArduinoAflakSerial1Attached(Sender: TObject; usb: JObject);
    procedure ArduinoAflakSerial1Detached(Sender: TObject);
    procedure ArduinoAflakSerial1MessageReceived(Sender: TObject;
      jbytesReceived: TDynArrayOfJByte);  //array of shortint
    procedure ArduinoAflakSerial1Opened(Sender: TObject);
    procedure ArduinoAflakSerial1StatusChanged(Sender: TObject;
      statusMessage: string);
    procedure Button1Click(Sender: TObject);
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

//ref
//https://hingxyu.medium.com/arduino-android-serial-communication-b72b124142fb

(*  Arduino Side: echoes back whatever it receives on the serial port

void setup() {
  // initialize serial communication at 9600 bits per second:
  Serial.begin(9600);
}
void loop() {
  char incomingByte;
   // If there is a data stored in the serial receive buffer, read it and print it to the serial port as human-readable ASCII text.
  if(Serial.available()){
    incomingByte = Serial.read();
    Serial.print(incomingByte);
  }
}

*)

//arduino plugged in. Here you should call arduino.open(device)
procedure TAndroidModule1.ArduinoAflakSerial1Attached(Sender: TObject; usb: JObject);
begin
   ArduinoAflakSerial1.Open(usb);
end;

procedure TAndroidModule1.AndroidModule1JNIPrompt(Sender: TObject);
begin
   TextView4.SetScrollingMovementMethod();
   TextView4.SetVerticalScrollBarEnabled(True);
end;

//arduino plugged out
procedure TAndroidModule1.ArduinoAflakSerial1Detached(Sender: TObject);
begin
   ShowMessage('Detached: arduino plugged out...');
end;

//arduino sent a message through Serial.print()
procedure TAndroidModule1.ArduinoAflakSerial1MessageReceived(Sender: TObject; jbytesReceived: TDynArrayOfJByte);  //array of shortint
begin
  TextView4.AppendLn('');
  TextView4.AppendLn(ArduinoAflakSerial1.JBytesToString(jbytesReceived));
end;

//connection with arduino opened
procedure TAndroidModule1.ArduinoAflakSerial1Opened(Sender: TObject);
begin
   ShowMessage('Opened: Arduino Connected....');
end;

procedure TAndroidModule1.ArduinoAflakSerial1StatusChanged(Sender: TObject;
  statusMessage: string);
begin
  ShowMessage('status: '+statusMessage);
end;


    { We are using pascal "shortint" to simulate the [Signed] java byte ....
      however "shortint" works in the range "-127 to 128" equal to the byte in java ....
      So every time we assign a value outside this range, for example 192, we get
      the "range check" message...

      How to Fix:

      var
        bufferToSend: array of jbyte; //jbyte = shortint
      begin
        ...........
        bufferToSend[0] := ToSignedByte($C0);    //<-- fixed!
        ........
      end;}

procedure TAndroidModule1.Button1Click(Sender: TObject);
//var
  //data: TDynArrayOfJByte;  //jByte >> signed 8 bits >>   -128 to 127
begin
   ArduinoAflakSerial1.Send(EditText1.Text);

   //or
   //SetLength(data, 4);
   //data[0]:= 10;
   //data[1]:= 11;
   //data[2]:= 12;
   //data[3] := Self.ToSignedByte($C0);    //<-- "range check" fixed!
   //ArduinoAflakSerial1.Send(data);
   //SetLength(data, 0);
end;

end.
