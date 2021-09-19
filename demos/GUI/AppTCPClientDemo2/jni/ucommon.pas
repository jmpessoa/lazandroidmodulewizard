unit uCommon;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Graphics, Controls, Forms, Dialogs, ComCtrls, Buttons, Menus,
  LCLType, LCLIntf;

type
  TOnScreenShot = procedure(Sender: TObject; AMs: TMemoryStream) of Object;

type
  { TScreenShot }

  TScreenShot = class(TThread)
  private
    FMS: TMemoryStream;
    FMSComp: TMemoryStream;
    FPixelFormat: TPixelFormat;
    FCompressionQuality: TJPEGQualityRange;
    FOnScreenShot: TOnScreenShot;
    procedure TakeScreenShot;
    procedure DoScreenShot;
  protected
    procedure Execute; override;
  public
    constructor Create(APixelFormat: TPixelFormat; ACompressionQuality: TJPEGQualityRange);
    destructor Destroy; override;
  public
    property OnScreenShot: TOnScreenShot read FOnScreenShot write FOnScreenShot;
  end;

  function MessageDlgEx(const AMsg: String; ADlgType: TMsgDlgType; ABtns: TMsgDlgButtons;
    ABtnCaptions: array of string; AShowBtnGlyph: Boolean; AParent: TForm): TModalResult;

implementation

uses uTCPCryptoCompression;


constructor TScreenShot.Create(APixelFormat: TPixelFormat; ACompressionQuality: TJPEGQualityRange);
begin
  inherited Create(True);
  FPixelFormat := APixelFormat;
  FCompressionQuality := ACompressionQuality;
  FMS := TMemoryStream.Create;
  FMSComp := TMemoryStream.Create;
end;

destructor TScreenShot.Destroy;
begin
  FMS.Free;
  FMSComp.Free;
  inherited Destroy;
end;

procedure TScreenShot.TakeScreenShot;
var
  Bmp: TBitmap;
  Jpg: TJPEGImage;
  ScreenDC: HDC;
  CompRate: Single;
begin
  Bmp := TBitmap.Create;
  try
    ScreenDC := GetDC(0);
    Bmp.PixelFormat := FPixelFormat;
    Bmp.LoadFromDevice(ScreenDC);
    ReleaseDC(0, ScreenDC);
    Jpg := TJpegImage.Create;
    try
      Jpg.CompressionQuality := FCompressionQuality;
      Jpg.Assign(Bmp);
      FMS.Clear;
      Jpg.SaveToStream(FMS);
      CompressStream(FMS, FMSComp, clBestCompression, CompRate);
      FMSComp.Position := 0;
      {$IFDEF UNIX}
      if Assigned(FOnScreenShot) then
         FOnScreenShot(Self, FMSComp);
      {$ENDIF}
    finally
      Jpg.Free;
    end;
  finally
    Bmp.Free;
  end;
end;

procedure TScreenShot.DoScreenShot;
begin
  if Assigned(FOnScreenShot) then
    FOnScreenShot(Self, FMSComp);
end;

procedure TScreenShot.Execute;
begin
  while not Terminated do
  begin
    {$IFDEF UNIX}
      //linux does not like threaded screenshots
      Synchronize(@TakeScreenShot);
    {$ELSE}
      TakeScreenShot;
      Synchronize(@DoScreenShot);
    {$ENDIF}
  end;
end;

function MessageDlgEx(const AMsg: String; ADlgType: TMsgDlgType;
  ABtns: TMsgDlgButtons; ABtnCaptions: array of string; AShowBtnGlyph: Boolean;
  AParent: TForm): TModalResult;
var
  MsgFrm: TForm;
  BitBtn: TBitBtn;
  I: Integer;
  CapCnt: Integer;
begin
  MsgFrm := CreateMessageDialog(AMsg, ADlgType, ABtns);
  try
    MsgFrm.FormStyle := fsSystemStayOnTop;
    if AParent <> nil then
    begin
      MsgFrm.Position := poDefaultSizeOnly;
      MsgFrm.Left := AParent.Left + (AParent.Width - MsgFrm.Width) div 2;
      MsgFrm.Top := AParent.Top + (AParent.Height - MsgFrm.Height) div 2;
    end
    else
      MsgFrm.Position := poWorkAreaCenter;
    CapCnt := 0;
    for I := 0 to MsgFrm.ComponentCount - 1 do
    begin
       if (MsgFrm.Components[I] is TBitBtn) then
       begin
         BitBtn := TBitBtn(MsgFrm.Components[I]);
         if not AShowBtnGlyph then
           BitBtn.GlyphShowMode := gsmNever;
         if Length(ABtnCaptions) > 0 then
         begin
           if CapCnt > High(ABtnCaptions) then
             Break;
           BitBtn.Caption := ABtnCaptions[CapCnt];
           Inc(CapCnt);
         end;
       end;
     end;
    Result := MsgFrm.ShowModal;
  finally
    MsgFrm.Free
  end;
end;

end.

