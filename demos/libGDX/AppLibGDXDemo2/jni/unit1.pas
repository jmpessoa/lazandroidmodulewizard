{Hint: save all files to location: C:\android\workspace\AppLibGDXDemo2\jni }
unit unit1;

{$mode delphi}

interface

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, AndroidWidget, GdxForm, gdxorthographiccamera,
  gdxspritebatch, gdxtextureatlas, gdxtextureregion, gdxsprite;
  
type

  { TGdxModule1 }

  TGdxModule1 = class(jGdxForm)
    jGdxOrthographicCamera1: jGdxOrthographicCamera;
    jGdxSprite1: jGdxSprite;
    jGdxSpriteBatch1: jGdxSpriteBatch;
    jGdxTextureAtlas1: jGdxTextureAtlas;
    jGdxTextureRegion1: jGdxTextureRegion;
    procedure GdxModule1Close(Sender: TObject);
    procedure GdxModule1Create(Sender: TObject);
    procedure GdxModule1KeyPressed(Sender: TObject; keyCode: TGdxKeyCode);
    procedure GdxModule1Pause(Sender: TObject);
    procedure GdxModule1Render(Sender: TObject; deltaTime: single);
    procedure GdxModule1Resume(Sender: TObject);
    procedure GdxModule1Show(Sender: TObject);
    procedure GdxModule1TouchUp(Sender: TObject; screenX: integer;
      screenY: integer; pointer: integer; button: integer);

  private
    {private declarations}
  public
    {public declarations}
    ScreenW: integer;
    ScreenH: integer;
    SpriteX: integer;
    SpriteY: integer;
  end;

var
  GdxModule1: TGdxModule1;

implementation
  
{$R *.lfm}
  

{ TGdxModule1 }

procedure TGdxModule1.GdxModule1Show(Sender: TObject);
begin

  ScreenW:= Self.GetWidth();
  ScreenH:= Self.GetHeight();

  jGdxTextureAtlas1.LoadPackFromAssets('emojis.pack');

  jGdxTextureRegion1.SetTextures(jGdxTextureAtlas1.GetJInstance());

  jGdxOrthographicCamera1.SetToOrtho(False, ScreenW, ScreenH);
  jGdxSpriteBatch1.SetProjectionMatrix(jGdxOrthographicCamera1.GetMatrix4Combined());

  jGdxSprite1.SetSprite( jGdxTextureAtlas1.CreateSprite('smile'), 2);

end;

procedure TGdxModule1.GdxModule1TouchUp(Sender: TObject; screenX: integer;
  screenY: integer; pointer: integer; button: integer);
begin
   SpriteX:= screenX;
   SpriteY:= ScreenH - screenY;
   if SpriteY < 0 then SpriteY:= 0;

end;

procedure TGdxModule1.GdxModule1Render(Sender: TObject; deltaTime: single);
begin
  Self.ClearColor(1, 1, 1, 1);
  jGdxSpriteBatch1.BeginBatch();
  jGdxSprite1.Draw(jGdxSpriteBatch1.GetJInstance(), SpriteX, SpriteY); //240, 1100
  jGdxSpriteBatch1.DrawTextureRegion(jGdxTextureRegion1.GetRegion('angry'), 240, 800);
  jGdxSpriteBatch1.DrawTextureRegion(jGdxTextureRegion1.GetRegion('grin'), 240, 600);
  jGdxSpriteBatch1.DrawTextureRegion(jGdxTextureRegion1.GetRegion('sad'), 240, 400);
  jGdxSpriteBatch1.DrawTextureRegion(jGdxTextureRegion1.GetRegion('smile'), 240, 200);
  jGdxSpriteBatch1.EndBatch();
end;

procedure TGdxModule1.GdxModule1Resume(Sender: TObject);
begin
  Self.Show();
end;

procedure TGdxModule1.GdxModule1Create(Sender: TObject);
begin
   SpriteX:= 240;
   SpriteY:= 1100;
end;

procedure TGdxModule1.GdxModule1Close(Sender: TObject);
begin
  jGdxSprite1.Dispose();
  jGdxTextureRegion1.Dispose();
  jGdxSpriteBatch1.Dispose();
  jGdxTextureAtlas1.Dispose();
end;


procedure TGdxModule1.GdxModule1KeyPressed(Sender: TObject; keyCode: TGdxKeyCode);
begin
  if keyCode = kcBackKey then Self.Close();
end;

procedure TGdxModule1.GdxModule1Pause(Sender: TObject);
begin
  //
end;

end.
