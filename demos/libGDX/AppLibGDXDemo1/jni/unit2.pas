{Hint: save all files to location: C:\android\workspace\AppLibGDXDemo1\jni }
unit unit2;

{$mode delphi}

interface

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, AndroidWidget, GdxForm, gdxorthographiccamera,
  gdxbitmapfont, gdxspritebatch, gdxtexture;
  
type

  { TGdxModule2 }

  TGdxModule2 = class(jGdxForm)
    jGdxBitmapFont1: jGdxBitmapFont;
    jGdxOrthographicCamera1: jGdxOrthographicCamera;
    jGdxSpriteBatch1: jGdxSpriteBatch;
    jGdxTexture1: jGdxTexture;
    procedure GdxModule2Close(Sender: TObject);
    procedure GdxModule2KeyPressed(Sender: TObject; keyCode: TGdxKeyCode);
    procedure GdxModule2Render(Sender: TObject; deltaTime: single);
    procedure GdxModule2Resume(Sender: TObject);
    procedure GdxModule2Show(Sender: TObject);
  private
    {private declarations}
  public
    {public declarations}
  end;

var
  GdxModule2: TGdxModule2;

implementation
  
{$R *.lfm}
  

{ TGdxModule2 }

procedure TGdxModule2.GdxModule2Show(Sender: TObject);
begin
   jGdxTexture1.LoadFromAssets('lemur_laptop.jpg');
   jGdxOrthographicCamera1.SetToOrtho(False, Self.GetWidth(), Self.GetHeight());
   jGdxBitmapFont1.SetColor(0.0, 0.0, 1.0, 1.0); //blue
   jGdxBitmapFont1.SetScaleXY(5);
end;

procedure TGdxModule2.GdxModule2Render(Sender: TObject; deltaTime: single);
begin
   Self.ClearColor(1, 1, 0, 1); //yellow
   jGdxSpriteBatch1.SetProjectionMatrix(jGdxOrthographicCamera1.GetMatrix4Combined());
   jGdxSpriteBatch1.BeginBatch();

   jGdxSpriteBatch1.DrawTexture(jGdxTexture1.GetJInstance(), Self.GetWidth()/3 , Self.GetHeight()/4); //yUp by default...

   jGdxBitmapFont1.DrawText(jGdxSpriteBatch1.GetJInstance(), 'Hello World!', Self.GetWidth()/3 , Self.GetHeight()/2);

   jGdxSpriteBatch1.EndBatch();
end;

procedure TGdxModule2.GdxModule2KeyPressed(Sender: TObject; keyCode: TGdxKeyCode);
begin
  if keyCode = kcBackKey then Self.Close;
end;

procedure TGdxModule2.GdxModule2Close(Sender: TObject);
begin
  jGdxBitmapFont1.Dispose();
  jGdxTexture1.Dispose();
  jGdxSpriteBatch1.Dispose();
end;

procedure TGdxModule2.GdxModule2Resume(Sender: TObject);
begin
  Self.Show();
end;


end.
