{Hint: save all files to location: C:\android\workspace\AppNetApiDemo1\jni }
unit unit1;

{$mode delphi}

interface

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, AndroidWidget, Laz_And_Controls, netapi;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jButton1: jButton;
    jNetApi1: jNetApi;
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

{NOTE: We are using pascal "shortint" [jbyte] to simulate the [Signed] java byte,
  however "shortint" works in the range "-127 to 128" equal to the byte in java!
  So every time we assign a value outside this range, for example 192 ($CC), we get
  the compile "range check" message...

  How to Fix: (using "ToSignedByte" form method ..)

  var
     bufferToSend1: TDynArrayOfJByte;  //jbyte = shortint

    //or
    //bufferToSend2: array of jbyte; //jbyte = shortint

  begin
    ...........
    SetLenght(bufferToSend1, 10);

    bufferToSend1[0] := ToSignedByte($C0);    //<-- fixed!
    ........
  end;}


procedure TAndroidModule1.jButton1Click(Sender: TObject);
var
  systemInfo: TDynArrayOfJByte;   //JByte = Pascal shortInt !!!
  devAdr: byte;  //pascal byte "range check" message ...
  countInfo: integer;
begin

   (*  fix the IP/Port and devAdr and uncoment the test code...
   jNetApi1.OpenDevice('192.168.1.250', 60000);

   devAdr:= $FF;  //ddevAdr is pascal byte, so not need [ToSignedByte] convert to range [-127, 128]

   //IMPORTANT: "get" array/buffer parameters need memory allocation!
   SetLength(systemInfo, 9); //9 Bytes

   jNetApi1.GetDeviceSystemInfo(devAdr, systemInfo);

   countInfo:= Length(systemInfo);  //1:SoftVer 2:HardVer 3 - 9:DeviceSN

   ShowMessage('countInfo = ' + IntToStr(countInfo) + ' bytes');

   jNetApi1.CloseDevice();
   *)

  ShowMessage('fix the IP/Port and devAdr and uncoment the test code...');

end;

(*
/**
 * Java interface to Natives methods that are implemented by the native-library "libNetApi.so"
 * which is packaged with this application.
 */
/******** Func: Open Device  *******************************/
//  Param: pucIPAddress: IP Address  example: "192.168.1.250"
//         iPort: IP Port example: 60000
//  Return: Success return 1, failed return 0
/*********************************************************/
static public native boolean NetApiOpenDevice(String  ip, int iPort);
/******** Func: Close Device *******************************/
//  Param: None
//  Return: Success return 1, failed return 0
/*********************************************************/
static public native void NetApiCloseDevice();
/******** Func: GetDeviceInfo. 9Bytes**********/
//  Param: bDevAdr: 0xFF
//         pucSystemInfo: SysInfo  9Bytes 1:SoftVer 2:HardVer 3 - 9:DeviceSN
//  Return: Success return 1, failed return 0
/*********************************************************/
static public native boolean NetApiGetDeviceSystemInfo(byte bDevAdr, byte pucSystemInfo[]);
/******** Func: Get Device One Param**********/
//  Param: bDevAdr: 0xFF
//         pucDevParamAddr: Param Addr
//         pValue: Return Param Value
//  Return: Success return 1, failed return 0
/*********************************************************/
static public native boolean NetApiReadDeviceOneParam(byte bDevAdr,byte pucDevParamAddr,byte pValue[]);
/******** Func: Set Device One Param**********/
//  Param: bDevAdr: 0xFF
//         pucDevParamAddr: Param Addr
//         bValue: Param
//  Return: Success return 1, failed return 0
/*********************************************************/
static public native boolean NetApiSetDeviceOneParam(byte bDevAdr,byte pucDevParamAddr,byte pValue);
/******** Func: Stop all RF reading**********/
//  Param: bDevAdr: 0xFF
//  Return: Success return 1, failed return 0
/*********************************************************/
static public native boolean NetApiStopRead(byte bDevAdr);
/******** Func: Start all RF reading**********/
//  Param: bDevAdr: 0xFF
//  Return: Success return 1, failed return 0
/*********************************************************/
static public native boolean NetApiStartRead(byte bDevAdr);
/******** Func: Inventory EPC**********/
//  Param: bDevAdr: 0xFF
//         pBuffer: Get Buffer
//         Totallen: Get Buffer Length
//         CardNum: Tag Number
//  Return: Success return 1, failed return 0
/*********************************************************/
static public native boolean NetApiInventoryG2(byte bDevAdr, byte[] pBuffer, int[] Totallen, int[] CardNum);
/******** Func: Write EPC**********/
//  Param: bDevAdr: 0xFF
//         Password: Password (4 bytes)
//         WriteEPC: Write Data
//         WriteEPClen: Write Length
//  Return: Success return 1, failed return 0
/*********************************************************/
static public native boolean NetApiWriteEPCG2(byte bDevAdr, byte[] Password, byte[] WriteEPC, byte WriteEPClen);
/******** Func: Read Card**********/
//  Param: bDevAdr: 0xFF
//         Password: Password (4 bytes)
//         Mem:      0:Reserved 1:EPC 2:TID 3:USER
//         WordPtr:  Start Address
//         ReadEPClen: Read Length
//         Data: Read Data
//  Return: Success return 1, failed return 0
/*********************************************************/
static public native boolean NetApiReadCardG2(byte bDevAdr, byte[] Password, byte Mem, byte WordPtr, byte ReadEPClen, byte[] Data);
/******** Func: Write Card**********/
//  Param: bDevAdr: 0xFF
//         Password: Password (4 bytes)
//         Mem:      0:Reserved 1:EPC 2:TID 3:USER
//         WordPtr:  Start Address
//         WriteEPC: Write Data
//         WriteEPClen: Write Length
//  Return: Success return 1, failed return 0
/*********************************************************/
static public native boolean NetApiWriteCardG2(byte bDevAdr, byte[] Password, byte Mem, byte WordPtr, byte Writelen, byte[] Writedata);
/******** Func: RelayOn**********/
//  Param: bDevAdr: 0xFF
//  Return: Success return 1, failed return 0
/*********************************************************/
static public native boolean NetApiRelayOn(byte bDevAdr);
/******** Func: RelayOff**********/
//  Param: bDevAdr: 0xFF
//  Return: Success return 1, failed return 0
/*********************************************************/
static public native boolean NetApiRelayOff(byte bDevAdr);
/******** Func: ClearTagBuf(ActiveMode)**********/
//  Param: None
//  Return: Success return 1, failed return 0
/*********************************************************/
static public native boolean NetApiClearTagBuf();
/******** Func: GetTagBuf(ActiveMode)**********/
//  Param:
//         pBuf: Get Buffer
//         pLength: Get Buffer Length
//         pTagNumber: Tag Number
//  Return: Success return 1, failed return 0
/*********************************************************/
static public native byte NetApiGetTagBuf(byte[] pBuf, int[] pLength, int[] pTagNumber);
/******** Func: SetFreq**********/
//  Param: bDevAdr: 0xFF
//         pFreq: Set 2bytes Freq Value
//pFreq[0]   pFreq[1]
//0x31        0x80     //US Freq
//0x4E        0x00     //Europe
//0x2C        0xA3     //China
//0x29        0x9D     //Korea
//0x2E        0x9F     //Australia
//0x4E        0x00     //New Zealand
//0x4E        0x00     //India
//0x2C        0x81     //Singapore
//0x2C        0xA3     //Hongkong
//0x31        0xA7     //Taiwan
//0x31        0x80     //Canada
//0x31        0x80     //Mexico
//0x31        0x99     //Brazil
//0x1C        0x99     //Israel
//0x24        0x9D     //South Africa
//0x2C        0xA3     //Thailand
//0x28        0xA1     //Malaysia
//0x29        0x9D     //Japan
//  Return: Success return 1, failed return 0
/*********************************************************/
static public native boolean NetApiSetFreq(byte bDevAdr, byte[] pFreq);
/******** Func: ReadFreq**********/
//  Param: bDevAdr: 0xFF
//         pFreq: return 2bytes Freq Value
//pFreq[0]   pFreq[1]
//0x31        0x80     //US Freq
//0x4E        0x00     //Europe
//0x2C        0xA3     //China
//0x29        0x9D     //Korea
//0x2E        0x9F     //Australia
//0x4E        0x00     //New Zealand
//0x4E        0x00     //India
//0x2C        0x81     //Singapore
//0x2C        0xA3     //Hongkong
//0x31        0xA7     //Taiwan
//0x31        0x80     //Canada
//0x31        0x80     //Mexico
//0x31        0x99     //Brazil
//0x1C        0x99     //Israel
//0x24        0x9D     //South Africa
//0x2C        0xA3     //Thailand
//0x28        0xA1     //Malaysia
//0x29        0x9D     //Japan
//  Return: Success return 1, failed return 0
/*********************************************************/
static public native boolean NetApiReadFreq(byte bDevAdr, byte[] pFreq);
*)

end.
