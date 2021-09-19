unit uTCPFunctions;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Graphics;

  function FormatSize(Size: Int64): String;
  function FormatSpeed(Speed: LongInt): String;
  function SecToHourAndMin(const ASec: LongInt): String;

implementation

function FormatSize(Size: Int64): String;
const
  KB = 1024;
  MB = 1024 * KB;
  GB = 1024 * MB;
begin
  if Size < KB then
    Result := FormatFloat('#,##0 Bytes', Size)
  else if Size < MB then
    Result := FormatFloat('#,##0.0 KB', Size / KB)
  else if Size < GB then
    Result := FormatFloat('#,##0.0 MB', Size / MB)
  else
    Result := FormatFloat('#,##0.0 GB', Size / GB);
end;

function FormatSpeed(Speed: LongInt): String;
const
  KB = 1024;
  MB = 1024 * KB;
  GB = 1024 * MB;
begin
  if Speed < KB then
    Result := FormatFloat('#,##0 bits/s', Speed)
  else if Speed < MB then
    Result := FormatFloat('#,##0.0 kB/s', Speed / KB)
  else if Speed < GB then
    Result := FormatFloat('#,##0.0 MB/s', Speed / MB)
  else
    Result := FormatFloat('#,##0.0 GB/s', Speed / GB);
end;

function SecToHourAndMin(const ASec: LongInt): String;
var
  Hour, Min, Sec: LongInt;
begin
  Hour := Trunc(ASec/3600);
  Min  := Trunc((ASec - Hour*3600)/60);
  Sec  := ASec - Hour*3600 - 60*Min;
  Result := IntToStr(Hour) + 'h: ' + IntToStr(Min) + 'm: ' + IntToStr(Sec) + 's';
end;

end.

