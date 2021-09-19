unit uTCPCryptoCompression;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, BlowFish, Base64, SHA1, PasZLib, ZBase;

type
  TCompressionLevel = (clNoCompression, clBestSpeed, clDefaultCompression, clBestCompression);

  function Encrypt(const AKey, AText: String): String;
  function Decrypt(const AKey, AText: String): String;
  function SHA1Hash(const AText: String): String;
  function CompressStream(ASrc, ADst: TMemoryStream; ACompressionLevel: TCompressionLevel; out ACompressionRate: Single): Boolean;
  function DecompressStream(ASrc, ADst: TMemoryStream): Boolean;

implementation

function Encrypt(const AKey, AText: String): String;
var
  SS: TStringStream;
  BES: TBlowFishEncryptStream;
begin
  Result := '';
  if Trim(AText) = '' then
    Exit;
  SS := TStringStream.Create('');
  try
    BES := TBlowFishEncryptStream.Create(AKey, SS);
    try
      BES.Write(Pointer(AText)^, Length(AText));
    finally
      BES.Free;
    end;
    Result := EncodeStringBase64(SS.DataString);
  finally
    SS.Free;
  end;
end;

function Decrypt(const AKey, AText: String): String;
var
  SS: TStringStream;
  BDS: TBlowFishDeCryptStream;
  Str, Txt: String;
begin
  Result := '';
  if Trim(AText) = '' then
    Exit;
  Str := '';
  Txt := DecodeStringBase64(AText);
  SS := TStringStream.Create(Txt);
  try
    BDS := TBlowFishDeCryptStream.Create(AKey, SS);
    try
      SetLength(Str, SS.Size);
      BDS.Read(Pointer(Str)^, SS.Size);
      Result := Str;
    finally
      BDS.Free;
    end;
  finally
    SS.Free;
  end;
end;

function SHA1Hash(const AText: String): String;
begin
  Result := SHA1Print(SHA1String(AText));
end;

function CompressStream(ASrc, ADst: TMemoryStream; ACompressionLevel: TCompressionLevel;
  out ACompressionRate: Single): Boolean;
const
  CompValue: array[TCompressionLevel] of Integer = (Z_NO_COMPRESSION, Z_BEST_SPEED, Z_DEFAULT_COMPRESSION, Z_BEST_COMPRESSION);
var
  ZStream: Z_Stream;
begin
  Result := False;
  ACompressionRate := 0.00;
  ASrc.Position := 0;
  ADst.SetSize(ASrc.Size);
  ZStream.Next_In := ASrc.Memory;
  ZStream.Avail_In := ASrc.Size;
  ZStream.Next_Out := ADst.Memory;
  ZStream.Avail_Out := ADst.Size;
  if DeflateInit2(ZStream, CompValue[ACompressionLevel], Z_DEFLATED, -MAX_WBITS, MAX_MEM_LEVEL, Z_DEFAULT_STRATEGY) < Z_OK then
    Exit;
  if Deflate(ZStream, Z_FINISH) < Z_OK then
    Exit;
  Result := not (DeflateEnd(ZStream) < 0);
  if Result then
  begin
    ADst.SetSize(ZStream.Total_Out);
    ADst.Position := 0;
    if ZStream.Total_In > 0 then
      ACompressionRate := 100*ZStream.Total_Out/ZStream.Total_In;
  end;
end;

function DecompressStream(ASrc, ADst: TMemoryStream): Boolean;
var
  ZStream: Z_Stream;
begin
  Result := False;
  ASrc.Position := 0;
  ADst.SetSize(ASrc.Size);
  ZStream.Next_In := ASrc.Memory;
  ZStream.Avail_In := ASrc.Size;
  ZStream.Next_Out := ADst.Memory;
  ZStream.Avail_Out := ADst.Size;
  if InflateInit2(ZStream, -MAX_WBITS) < 0 then
    Exit;
  while Inflate(ZStream, Z_NO_FLUSH) = Z_OK do
  begin
    ADst.SetSize(ADst.Size + ASrc.Size);
    ZStream.Next_Out := ADst.Memory + ZStream.Total_Out;
    ZStream.Avail_Out := ASrc.Size;
  end;
  Result := not (InflateEnd(ZStream) < 0);
  if Result then
  begin
    ADst.SetSize(ZStream.Total_Out);
    ADst.Position := 0;
    Result := ASrc.Size <= ADst.Size;
  end;
end;

end.

