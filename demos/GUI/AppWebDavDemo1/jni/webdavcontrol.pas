
// *****************************************************************************
// *****************************************************************************
//
//                   WebDavControl (RFC 2518) for LAMW
//
//    The WebDavControl unit and the TWebDavParser class are required to
//  manage the WebDAV client and process the results of interaction with
//  the WebDAV server.
//
// *****************************************************************************
// *****************************************************************************

unit WebDavControl;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fgl;

type
// *****************************************************************************
// ***************************** TWDResource ***********************************
// *****************************************************************************
  TWDResource     =
    Class
      private
        FHref                  : String;
        FStatusCode            : Integer;
        FContentLength         : Int64;
        FCreationDate          : TDateTime;
        FLastmodified          : TDateTime;
        FDisplayName           : String;
        FContentType           : String;
        FCollection            : Boolean;
      public
        property Href          : String    read FHref          write FHref;
        property StatusCode    : Integer   read FStatusCode    write FStatusCode;
        property ContentLength : Int64     read FContentLength write FContentLength;
        property CreationDate  : TDateTime read FCreationDate  write FCreationDate;
        property Lastmodified  : TDateTime read FLastmodified  write FLastmodified;
        property DisplayName   : String    read FDisplayName   write FDisplayName;
        property ContentType   : String    read FContentType   write FContentType;
        property Collection    : Boolean   read FCollection    write FCollection;
    end;

// *****************************************************************************
// ***************************** TWDResourceList *******************************
// *****************************************************************************
  TWDResourceList = specialize TFPGObjectList<TWDResource>;

// *****************************************************************************
// ***************************** TWebDavParser *********************************
// *****************************************************************************
  TWebDavParser   =
        Class
          private
            FErrorCode             : Integer;
            FErrorStr              : String;
            FUserName              : String;
            FPassword              : String;
            FHostName              : String;
            FHostPort              : Integer;
            FHostFDir              : String;
            FServerHTTPVersion     : String;
            FResponseStatusText    : String;
            FResponseHeaders       : TStrings;
            FWDResourceList        : TWDResourceList;
          public
            constructor  Create;
            destructor   Destroy;                                      override;
            function     ParseStatusLine    (AStatusLine : String) : Integer;
            procedure    Error              (AErrorCode  : Integer;
                                             AErrorStr   : String);
            function     ReadString     (var AResponse   : String;
                                         var ALine       : String) : Boolean;
            function     ReadResponseHeaders
                                        (var AResponse   : String) : Integer;

            function     IsResponseCodeValid(Code        : Integer;
                                             Codes       : Array of Integer)
                                                                   : Boolean;
            function     CheckResponseCode
                                        (var AResponse   : String;
                                             Codes       : Array of Integer)
                                                                   : Boolean;

            function     EncodeUTF8URI  (const URI       : String) : String;

            function     GetRequestURL  (const   Element : String;
                                             EncodePath  : Boolean): String;


            procedure    ParseWebDavResources
                                        (const AXMLStr   : String;
                                               Resources : TWDResourceList);

            procedure    XMLStrToDavResources
                                        (const AXMLStr   : String);

            function     GetStatusLine         : String;


            procedure    GetFileSize    (      Sender    : TObject;
                                               ResLine   : string;
                                           var outReturn : integer);

            property     UserName              : String
                             read FUserName        write FUserName;
            property     Password              : String
                             read FPassword        write FPassword;
            property     HostName              : String
                             read FHostName        write FHostName;
            property     HostPort              : Integer
                             read FHostPort        write FHostPort;
            property     HostFDir              : String
                             read FHostFDir        write FHostFDir;
            property     WDResourceList        : TWDResourceList
                             read FWDResourceList  write FWDResourceList;
            property     ResponseStatusText    : String
                             read FResponseStatusText;
            property     ResponseHeaders       : TStrings
                             read FResponseHeaders write FResponseHeaders;
            property     StatusLine            : String
                             read GetStatusLine;
        end;

const ErrInvalidProtocolVersion = -1;
      ErrInvalidStatusCode      = -2;


implementation

uses laz2_XMLRead, laz2_DOM, unixutil;

constructor TWebDavParser.Create;
begin
  FResponseHeaders := TStringList.Create;
  FResponseHeaders.NameValueSeparator:=':';
  FWDResourceList  := TWDResourceList.Create(True);

//------------------------------------------------------------------------------
  FUserName        := 'leopreo@gmail.com';
  FPassword        := 'xmh4kh14oz80v82m';
  FHostName        := 'app.koofr.net';
  FHostPort        := 443;
  FHostFDir        := '/dav/Koofr/LAMW';

//-----------------------------------------------------------------------------
//  https://app.koofr.net is one of the available free servers. It does not
//  always work stably. You can register to debug your programs on
//  any other WebDAV server. FHostName in the program is always entered without
//  the prefix  "https://".
end;{TWebDavParser.Create;}

destructor  TWebDavParser.Destroy;
begin
  FResponseHeaders.Free;
  FWDResourceList. Free;
end;{TWebDavParser.Destroy;}

procedure   TWebDavParser.Error(AErrorCode : Integer;
                                AErrorStr  : String);
begin
  FErrorCode := AErrorCode;
  FErrorStr  := AErrorStr;
end;{TWebDavParser.Error}

function GetNextWord(var S : String) : String;
const WhiteSpace = [' ',#9];
var  P : Integer;
begin
  While (Length(S)>0) and (S[1] in WhiteSpace) do Delete(S, 1, 1);
     P:=Pos(' ', S);
  If P=0 then P:=Pos(#9, S);
  If P=0 then P:=Length (S)+1;
  Result:=Copy(S, 1, P-1);
  Delete      (S, 1, P  );
end;{GetNextWord}

function   TWebDavParser.ParseStatusLine  (AStatusLine: String): Integer;
var S : String;
begin
  S:=UpperCase(GetNextWord(AStatusLine));
  If (Copy(S,1,5)<>'HTTP/') then
    begin
      Error(ErrInvalidProtocolVersion, S);
      Result:=-1;
      Exit;
    end;
  System.Delete           (S, 1, 5);
  FServerHTTPVersion :=    S;
  S := GetNextWord        (AStatusLine);
     Result:=StrToIntDef  (S, -1);
  If Result=-1 then
    begin
      Error(ErrInvalidStatusCode, S);
      Exit;
    end;
  FResponseStatusText:=AStatusLine;
end;{TWebDavParser.ParseStatusLine}

function  TWebDavParser.ReadString(var AResponse : String;
                                   var ALine     : String):Boolean;
var    P : Integer;
begin
       P := Pos(#13#10, AResponse);
  If 0<P then
    begin
      ALine     := Copy(AResponse, 1,   P-1              );
      AResponse := Copy(AResponse, P+2, Length(AResponse));
    end;
 Result  :=    0<Length(AResponse);
end;{TWebDavParser.ReadString}

function  TWebDavParser.ReadResponseHeaders(var AResponse:String): Integer;
var                            Line : String;
begin
  If Not ReadString(AResponse, Line) then
    begin
      Result:=0;
      Exit;
    end;
      Result:=ParseStatusLine (Line);
    FResponseHeaders.Clear;
    FResponseHeaders.Add      (Line);
  While ReadString(AResponse,  Line) and (Line<>'') do
    FResponseHeaders.Add      (Line);
end;{TWebDavParser.ReadResponseHeaders}

function TWebDavParser.IsResponseCodeValid(Code  : Integer;
                                           Codes : Array of Integer) : Boolean;
var          I:Integer;
begin
  For        I:=Low(Codes) to High(Codes) do
    If Codes[I]=Code then
      begin
         Result:=True; Exit;
      end;
         Result:=False;
end;{TWebDavParser.IsResponseCodeValid}

function TWebDavParser.CheckResponseCode(var AResponse   : String;
                                             Codes       : Array of Integer)
                                                                     : Boolean;
begin
  Result:=IsResponseCodeValid(ReadResponseHeaders (AResponse), Codes);
end;{TWebDavParser.CheckResponseCode}

function TWebDavParser.GetStatusLine : String;
begin
  If 0<FResponseHeaders.Count then Result := FResponseHeaders.Strings[0]
                              else Result := 'Nil';
end;{TWebDavParser.GetStatusLine}

type              TSpecials = Set of AnsiChar;
const
  URLSpecialChar: TSpecials =
    [#$00..#$20, '<', '>', '"', '%', '+', '{', '}', '|', '\', '^', '[', ']', '`',
                                                                     #$7F..#$FF];

function TWebDavParser.EncodeUTF8URI(const URI: String): String;
var   I: Integer; Char: AnsiChar;
begin
            Result := '';
  For I := 1 to Length(URI) do
    begin
      If (URI[I] in URLSpecialChar) then
        begin
          For Char in UTF8String(URI[I]) do
                      // https://wiki.freepascal.org/Unicode_Support_in_Lazarus
            Result := Result + '%' + IntToHex(Ord(Char), 2);
                      // enumerator for all AnsiChar characters of a strin
        end                         else
            Result := Result + URI[I];
   end;
end;{TWebDavParser.EncodeUTF8URI}

function TWebDavParser.GetRequestURL(const       Element : String;
                                     EncodePath: Boolean): string;
var      URI   : String;
begin
  If Length(Element) > 0 then
    begin
         URI   := Element;
      If EncodePath then      Result := EncodeUTF8URI(URI)
                    else      Result :=               URI;
    end                  else Result := '';
end;{TWebDavParser.GetRequestURL}


{ Support functions }

function SeparateLeft(const    Value, Delimiter: String): String;
var  X: Integer;
begin
     X := Pos(Delimiter,       Value);
  If X < 1 then Result :=      Value
           else Result := Copy(Value, 1, X - 1);
end;{SeparateLeft}

function SeparateRight(const   Value, Delimiter: String): String;
var  X: Integer;
begin
     X := Pos(Delimiter,       Value);
  If X > 0 then X := X +       Length(Delimiter) - 1;
                Result := Copy(Value, X + 1, Length(Value) - X);
end;{SeparateRight}


{from unit synautil; http://www.ararat.cz/synapse/}


function TimeZoneBias: integer;
{$IFNDEF WIN32}
  {$IFNDEF FPC}
var
  t: TTime_T;
  UT: TUnixTime;
 begin
   __time(@T);
   localtime_r(@T, UT);
   Result := ut.__tm_gmtoff div 60;
  {$ELSE}
begin
  Result := TZSeconds div 60;
  {$ENDIF}
{$ELSE}
var
  zoneinfo: TTimeZoneInformation;
  bias: Integer;
begin
  case GetTimeZoneInformation(Zoneinfo) of
    2:
      bias := zoneinfo.Bias + zoneinfo.DaylightBias;
    1:
      bias := zoneinfo.Bias + zoneinfo.StandardBias;
  else
    bias := zoneinfo.Bias;
  end;
  Result := bias * (-1);
{$ENDIF}
end;{TimeZoneBias}

function DecodeTimeZone(Value: String; var Zone: Integer): Boolean;
var x: integer; zh, zm: integer; s: String;
begin
  Result := False;
  s      := Value;
  If (Pos('+', s) = 1) or (Pos('-',s) = 1) then
    begin
      If s = '-0000' then Zone := TimeZoneBias
                     else
        If Length(s) > 4 then
          begin
            zh   := StrToIntdef(s[2] + s[3], 0);
            zm   := StrToIntdef(s[4] + s[5], 0);
            Zone := zh * 60 + zm;
            If s[1] = '-' then Zone := Zone * (-1);
          end;
      Result := True;
    end                                    else
    begin
                         x := 32767;
      If s = 'NZDT' then x :=  13;
      If s = 'IDLE' then x :=  12;
      If s = 'NZST' then x :=  12;
      If s = 'NZT'  then x :=  12;
      If s = 'EADT' then x :=  11;
      If s = 'GST'  then x :=  10;
      If s = 'JST'  then x :=   9;
      If s = 'CCT'  then x :=   8;
      If s = 'WADT' then x :=   8;
      If s = 'WAST' then x :=   7;
      If s = 'ZP6'  then x :=   6;
      If s = 'ZP5'  then x :=   5;
      If s = 'ZP4'  then x :=   4;
      If s = 'BT'   then x :=   3;
      If s = 'EET'  then x :=   2;
      If s = 'MEST' then x :=   2;
      If s = 'MESZ' then x :=   2;
      If s = 'SST'  then x :=   2;
      If s = 'FST'  then x :=   2;
      If s = 'CEST' then x :=   2;
      If s = 'CET'  then x :=   1;
      If s = 'FWT'  then x :=   1;
      If s = 'MET'  then x :=   1;
      If s = 'MEWT' then x :=   1;
      If s = 'SWT'  then x :=   1;
      If s = 'UT'   then x :=   0;
      If s = 'UTC'  then x :=   0;
      If s = 'GMT'  then x :=   0;
      If s = 'WET'  then x :=   0;
      If s = 'WAT'  then x :=  -1;
      If s = 'BST'  then x :=  -1;
      If s = 'AT'   then x :=  -2;
      If s = 'ADT'  then x :=  -3;
      If s = 'AST'  then x :=  -4;
      If s = 'EDT'  then x :=  -4;
      If s = 'EST'  then x :=  -5;
      If s = 'CDT'  then x :=  -5;
      If s = 'CST'  then x :=  -6;
      If s = 'MDT'  then x :=  -6;
      If s = 'MST'  then x :=  -7;
      If s = 'PDT'  then x :=  -7;
      If s = 'PST'  then x :=  -8;
      If s = 'YDT'  then x :=  -8;
      If s = 'YST'  then x :=  -9;
      If s = 'HDT'  then x :=  -9;
      If s = 'AHST' then x := -10;
      If s = 'CAT'  then x := -10;
      If s = 'HST'  then x := -10;
      If s = 'EAST' then x := -10;
      If s = 'NT'   then x := -11;
      If s = 'IDLW' then x := -12;
      If x <> 32767 then
        begin
          Zone        := x * 60;
          Result      := True;
        end;
    end;
end;{DecodeTimeZone}

function FetchBin(var Value: string; const Delimiter: string): string;
var   s: string;
begin
  Result := SeparateLeft (Value, Delimiter);
      s  := SeparateRight(Value, Delimiter);
  If  s   = Value then Value := ''
                  else Value := s;
end;{FetchBin}

function TrimSPLeft(const S: string): string;
var I, L: Integer;
begin
  Result := '';
  If S = '' then Exit;
  L := Length(S);
  I := 1;
  While (I <= L) and (S[I] = ' ') do Inc(I);
  Result := Copy(S, I, Maxint);
end;{TrimSPLeft}

function TrimSPRight(const S: string): string;
var I: Integer;
begin
  Result := '';
  If S = '' then Exit;
  I := Length(S);
  While (I > 0) and (S[I] = ' ') do Dec(I);
  Result := Copy(S, 1, I);
end;{TrimSPRight}

function TrimSP(const S: string): string;
begin
  Result := TrimSPLeft(s);
  Result := TrimSPRight(Result);
end;

function RPosEx(const Sub, Value: string; From: integer): Integer;
var n: Integer; l: Integer;
begin
  Result := 0;
  l      := Length(Sub);
  For n := From - l + 1 downto 1 do
    begin
      If Copy(Value, n, l) = Sub then
        begin
          Result := n;
          break;
        end;
    end;
end;{RPosEx}

function RPos(const Sub, Value: String): Integer;
begin
  Result := RPosEx(Sub, Value, Length(Value));
end;{RPos}

function Fetch(var Value: string; const Delimiter: string): string;
begin
  Result := FetchBin(Value,  Delimiter);
  Result := TrimSP  (Result);
  Value  := TrimSP  (Value);
end;{Fetch}

function ReplaceString(Value, Search, Replace: AnsiString): AnsiString;
var x, l, ls, lr: Integer;
begin
  If (Value = '') or (Search = '') then
    begin
      Result := Value;
      Exit;
    end;
  ls := Length(Search);
  lr := Length(Replace);
  Result := '';
  x := Pos(Search, Value);
  While x > 0 do
    begin
      {$IFNDEF CIL}
      l := Length(Result);
      SetLength(Result, l + x - 1);
      Move(Pointer(Value)^, Pointer(@Result[l + 1])^, x - 1);
      {$ELSE}
      Result:=Result+Copy(Value,1,x-1);
      {$ENDIF}
      {$IFNDEF CIL}
      l := Length(Result);
      SetLength(Result, l + lr);
      Move(Pointer(Replace)^, Pointer(@Result[l + 1])^, lr);
      {$ELSE}
      Result:=Result+Replace;
      {$ENDIF}
      Delete(Value, 1, x - 1 + ls);
      x := Pos(Search, Value);
    end;
  Result := Result + Value;
end;{ReplaceString}

var
{:can be used for your own months strings for @link(getmonthnumber)}
  CustomMonthNames : Array       [1..12] of String;

var
  MyMonthNames     : Array[0..6, 1..12]  of AnsiString =
    (
    ('Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',  // rewrited by system locales
     'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'),
    ('Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',  // English
     'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'),
    ('jan', 'fév', 'mar', 'avr', 'mai', 'jun',  // French
     'jul', 'aoû', 'sep', 'oct', 'nov', 'déc'),
    ('jan', 'fev', 'mar', 'avr', 'mai', 'jun',  // French#2
     'jul', 'aou', 'sep', 'oct', 'nov', 'dec'),
    ('Jan', 'Feb', 'Mar', 'Apr', 'Mai', 'Jun',  // German
     'Jul', 'Aug', 'Sep', 'Okt', 'Nov', 'Dez'),
    ('Jan', 'Feb', 'Mär', 'Apr', 'Mai', 'Jun',  // German#2
     'Jul', 'Aug', 'Sep', 'Okt', 'Nov', 'Dez'),
    ('Led', 'Úno', 'Bøe', 'Dub', 'Kvì', 'Èen',  // Czech
     'Èec', 'Srp', 'Záø', 'Øíj', 'Lis', 'Pro')
      );

function GetMonthNumber(Value: AnsiString): integer;
var   n: integer;
  function TestMonth(Value: AnsiString; Index: Integer): Boolean;
  var n: integer;
  begin
    Result := False;
    For n := 0 to 6 do
      If Value = AnsiUppercase(MyMonthNames[n, Index]) then
        begin
          Result := True;
          Break;
        end;
  end;
begin
  Result := 0;
  Value  := AnsiUppercase(Value);
  For n := 1 to 12 do
    If TestMonth(Value, n) or (Value = AnsiUppercase(CustomMonthNames[n])) then
      begin
        Result := n;
        Break;
      end;
end;{GetMonthNumber}

function GetTimeFromStr(Value: string): TDateTime;
var   x: integer;
begin
      x := rpos(':', Value);
  If (x > 0) and ((Length(Value) - x) > 2) then Value := Copy(Value, 1, x + 2);
  Value := ReplaceString(Value, ':', DefaultFormatSettings.TimeSeparator);
  Result := -1;
  try
    Result := StrToTime(Value);
  except
    on Exception do ;
  end;
end;{GetTimeFromStr}

function DecodeRfcDateTime(Value: String): TDateTime;
var day, month, year: Word; zone: integer; x, y: integer; s: string; t: TDateTime;
begin
// ddd, d mmm yyyy hh:mm:ss
// ddd, d mmm yy   hh:mm:ss
// ddd, mmm d yyyy hh:mm:ss
// ddd  mmm dd     hh:mm:ss yyyy
// Sun, 06 Nov 1994 08:49:37 GMT    ; RFC 822, updated by RFC 1123
// Sunday, 06-Nov-94 08:49:37 GMT   ; RFC 850, obsoleted by RFC 1036
// Sun Nov  6 08:49:37 1994         ; ANSI C's asctime() Format

  Result := 0;
  If Value = '' then Exit;
  day   := 0;
  month := 0;
  year  := 0;
  zone  := 0;
  Value := ReplaceString(Value, ' -', ' #' );
  Value := ReplaceString(Value, '-',  ' '  );
  Value := ReplaceString(Value, ' #', ' -' );

  While Value <> '' do
    begin
     s := Fetch(Value, ' ');
     s := uppercase(s);
     // timezone
     If DecodetimeZone(s, x) then
       begin
         zone := x;
         continue;
       end;
     x := StrToIntDef(s, 0);
     // day or year
     If x > 0 then
       If (x < 32) and (day = 0) then
         begin
           day := x;
           continue;
         end                     else
         begin
           If (year = 0) and ((month > 0) or (x > 12)) then
             begin
               year := x;
               If year < 32   then year := year + 2000;
               If year < 1000 then year := year + 1900;
               continue;
             end;
         end;
     // time
     If rpos(':', s) > Pos(':', s) then
       begin
            t := GetTimeFromStr(s);
         If t <> -1 then Result := t;
         continue;
       end;
     //timezone daylight saving time
     If s = 'DST' then
       begin
         zone := zone + 60;
         continue;
       end;
     // month
    y := GetMonthNumber(s);
     If (y > 0) and (month = 0) then month := y;
   end;

   If year = 0   then year  := 1980;
   If month < 1  then month := 1;
   If month > 12 then month := 12;
   If day < 1    then day   := 1;
            x := MonthDays[IsLeapYear(year), month];
   If day > x then day := x;

   Result := Result + Encodedate(year, month, day);
   zone := zone - TimeZoneBias;
   x := zone div 1440;
   Result := Result - x;
   zone := zone mod 1440;
   t := EncodeTime(Abs(zone) div 60, Abs(zone) mod 60, 0, 0);
   If zone < 0 then   t := 0 - t;
   Result := Result - t;
 end;{DecodeRfcDateTime}


procedure TWebDavParser.ParseWebDavResources(const AXMLStr: String;
                                                   Resources: TWDResourceList);
var XMLDoc: TXMLDocument;
  ResponseNode, ChildNode, PropNodeChild, PropertyNode: TDOMNode;
  S, Su, Value: String;

  procedure ReadXMLString      (Value: string);
  var S:  TStringStream;
  begin
      S:= TStringStream.Create(Value);
    try
      ReadXMLFile(XMLDoc, S);
    finally
      S.Free;
    end;
  end;

begin
  ReadXMLString(AXMLStr);
  try
    // Select the first node d: response
                   ResponseNode := XMLDoc.DocumentElement.FirstChild;
    // ResponseNode:=XMLDoc.DocumentElement.ChildNodes.First;
    While Assigned(ResponseNode) do
      begin
        // Create a new resource record in the list
        Resources.Add(TWDResource.Create);
        // Iterate over the child nodes d: response
                       ChildNode := ResponseNode.FirstChild;
        // ChildNode:=ResponseNode.ChildNodes.First;
        While Assigned(ChildNode) do
          begin
            If LowerCase(ChildNode.NodeName) = 'd:href' then
              Resources.Last.Href := ChildNode.TextContent
        // .Text
                                                        else
        // Find node with the resource properties
              If LowerCase(ChildNode.NodeName) = 'd:propstat' then
                 begin
        // Select the first child node, usually - it is d:status
                                  PropNodeChild := ChildNode.FirstChild;
        // .First;
                   While Assigned(PropNodeChild) do
                     begin
        // Read the status code
                       If LowerCase(PropNodeChild.NodeName) = 'd:status' then
                         begin
                           Value := PropNodeChild.TextContent;
        //.Text;
                           S     := Trim(SeparateRight(Value, ' '));
                           Su    := Trim(SeparateLeft (S,     ' '));
                           Resources.Last.StatusCode := StrToIntDef(Su, 0);
                         end                                  else
        // Find node d: prop - are passed on its child nodes
                         If LowerCase(PropNodeChild.NodeName) = 'd:prop' then
                           begin
                                            PropertyNode := PropNodeChild.FirstChild;
        // .First;
                             While Assigned(PropertyNode) do
                               begin
                                 If LowerCase(PropertyNode.NodeName) = 'd:creationdate'     then
                                    Resources.Last.CreationDate  := 0                       else
        // PropertyNode.TextContent not used
                                 If LowerCase(PropertyNode.NodeName) = 'd:displayname'      then
                                    Resources.Last.DisplayName   :=
                                      PropertyNode.TextContent
                                                                                            else
                                 If LowerCase(PropertyNode.NodeName) = 'd:getcontentlength' then
                                    Resources.Last.ContentLength :=
                                      StrToInt64(PropertyNode.TextContent)
                                                                                            else
                                 If LowerCase(PropertyNode.NodeName) = 'd:getlastmodified'  then
                                    Resources.Last.Lastmodified  :=
                                      DecodeRfcDateTime(PropertyNode.TextContent)
       // DecodeRfcDateTime(PropertyNode.TextContent) Fri, 15 Jul 2016 08:33:34 GMT
                                                                                            else
                                 If LowerCase(PropertyNode.NodeName) = 'd:resourcetype'     then
                                    Resources.Last.Collection    :=
                                      PropertyNode.ChildNodes.Count > 0;
       // Select the next child node have d: prop
                                            PropertyNode := PropertyNode.NextSibling;
                               end;
                           end;
       // Select the next child node have d: propstat
                                        PropNodeChild := PropNodeChild.NextSibling;
                     end;
                 end;
       // Select the next child node have d: response
            ChildNode := ChildNode.NextSibling;
          end;
      // Select the next node d: response
        ResponseNode := ResponseNode.NextSibling;
      end;
  finally
    XMLDoc.Free;
    XMLDoc := Nil;
  end;
end;{TWebDavParser.ParseWebDavResources}

procedure    TWebDavParser.XMLStrToDavResources
                (const AXMLStr   : String);
begin
                                FWDResourceList.Clear;
  ParseWebDavResources(AXMLStr, FWDResourceList);
end;{TWebDavParser.XMLStrToDavResources}


procedure    TWebDavParser.GetFileSize    (      Sender    : TObject;
                                                 ResLine   : string;
                                             var outReturn : integer);
var S:ShortString; Size, Code :Integer;
begin
  If CheckResponseCode   (ResLine, [200, 204]) then
    begin
      If (0< FResponseHeaders.Count) then
        begin
             S := FResponseHeaders.Values['Content-Length'];
          If S <> '' then
            begin
              Val(S, Size, Code);
              If Code=0 then
                begin
                  outReturn := Size;
                  Exit;
                end;
            end;
        end;
    end;
                  outReturn := 0;
end;{TWebDavParser.GetFileSize}

var   N: integer;

 initialization

  For N :=  1 to 12 do
    begin
      CustomMonthNames[N] := DefaultFormatSettings.ShortMonthNames[N];
      MyMonthNames [0, N] := DefaultFormatSettings.ShortMonthNames[N];
    end;

end.

