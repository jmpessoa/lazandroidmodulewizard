unit AndroidXMLResString;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, laz2_XMLWrite, laz2_XMLRead, laz2_Dom;

Type

{
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <string name="hello">Hello!</string>
    <string name="Toto">toto!</string>
</resources>
}

  TXMLResString = class
  private
    FSaved: Boolean;
    function GetCount: integer;
    function GetValueFromIndex(AIndex: integer): string;
    procedure SetValueFromIndex(AIndex: integer; AValue: string);
    function GetNameFromIndex(AIndex: integer): string;
    procedure SetNameFromIndex(AIndex: integer; AValue: string);
  protected
    FFileName: string;
    FStringRes: TStringList;
  public
    constructor Create(AFileName: string = '');
    destructor Destroy; override;
    procedure Open; overload;
    procedure Open(AFileName: string); overload;
    procedure Save;
    function Add(AName, AValue: string): integer;
    function FindByName(AName: string): integer;
    procedure Delete(AIndex: integer);
    property Count: integer read GetCount;
    property Saved: boolean read FSaved;
    property ValueFromIndex[AIndex: Integer]: string read GetValueFromIndex write SetValueFromIndex;
    property NameFromIndex[Index: Integer]: string read GetNameFromIndex write SetNameFromIndex;
  end;

implementation

{ TXMLResString }

procedure TXMLResString.Delete(AIndex: integer);
begin
  FStringRes.Delete(AIndex);
end;

function TXMLResString.FindByName(AName: string): integer;
Var
  i: integer;
begin
  Result:= -1;
  for i:= 0 to FStringRes.Count -1 do
  begin
    if FStringRes.Names[i] = AName then
    begin
      Result:= i;
      Break;
    end;
  end;
end;

function TXMLResString.Add(AName, AValue: string): integer;
begin
  Result:= -1;
  if FindByName(AName) > -1 then
    Exit
  else
    Result:= FStringRes.Add(AName + '=' + AValue);

  FSaved:= False;
end;

procedure TXMLResString.SetNameFromIndex(AIndex: integer; AValue: string);
begin
  FStringRes.Strings[AIndex]:= AValue + '=' + FStringRes.ValueFromIndex[AIndex];
  FSaved:= False;
end;

function TXMLResString.GetNameFromIndex(AIndex: integer): string;
begin
  Result:= FStringRes.Names[AIndex];
end;

procedure TXMLResString.SetValueFromIndex(AIndex: integer; AValue: string);
begin
  FStringRes.ValueFromIndex[AIndex]:= AValue;
  FSaved:= False;
end;

function TXMLResString.GetValueFromIndex(AIndex: integer): string;
begin
  Result:= FStringRes.ValueFromIndex[AIndex];
end;

function TXMLResString.GetCount: integer;
begin
  Result:= FStringRes.Count;
end;

procedure TXMLResString.Open(AFileName: string);
begin
  FFileName:= AFileName;
  Open;
end;

procedure TXMLResString.Open;
Var
  Res: TDOMNode;
  XmlRes: TXMLDocument;
begin

  if Pos('strings.xml', FFileName) > 0 then
  begin
    ReadXMLFile(XmlRes, FFileName);
    try
      FStringRes.Clear;
      Res:= XmlRes.DocumentElement.FirstChild;
      while Assigned(Res) do
      begin
        FStringRes.Add(Res.Attributes.Item[0].NodeValue + '=' + Res.ChildNodes.Item[0].NodeValue);
        Res:= Res.NextSibling;
      end;
      FSaved:= True;
    finally
      XmlRes.Free
    end;
  end;

  //TODO:
  (*
  if Pos('AndroidManifest.xml', FFileName) > 0 then
  begin

  end;

  if Pos('build.xml', FFileName) > 0 then
  begin

  end;

  *)

end;

procedure TXMLResString.Save;
Var
  NewXml: TXMLDocument;
  Child: TDOMNode;
  NewRes: TDOMElement;
  i: integer;
begin
  NewXml:= TXMLDocument.Create;
  Child:= NewXml.CreateElement('resources');
  NewXml.AppendChild(Child);

  for i:= 0 to FStringRes.Count -1 do
  begin
    NewRes:= NewXml.CreateElement('string');
    NewRes.SetAttribute('name', FStringRes.Names[i]);
    NewRes.AppendChild(NewXml.CreateTextNode(FStringRes.ValueFromIndex[i]));
    Child.AppendChild(NewRes);
  end;

  WriteXMLFile(NewXml, FFileName);
  NewXml.Free;
  FSaved:= True;
end;

constructor TXMLResString.Create(AFileName: string = '');
begin
  FStringRes:= TStringList.Create;
  if AFileName <> '' then
    FFileName:= AFileName;
end;

destructor TXMLResString.Destroy;
begin
  FStringRes.Free;
end;

end.
