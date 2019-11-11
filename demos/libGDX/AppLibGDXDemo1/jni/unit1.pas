{Hint: save all files to location: C:\android\workspace\AppLibGDXDemo1\jni }
unit unit1;

{$mode delphi}

interface

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, AndroidWidget, GdxForm, gdxtexture, gdxspritebatch,
  gdxorthographiccamera, unit2;
  
type

  { TGdxModule1 }

  TGdxModule1 = class(jGdxForm)
    jGdxOrthographicCamera1: jGdxOrthographicCamera;
    jGdxSpriteBatch1: jGdxSpriteBatch;
    jGdxTexture1: jGdxTexture;
    procedure GdxModule1Close(Sender: TObject);
    procedure GdxModule1KeyPressed(Sender: TObject; keyCode: TGdxKeyCode);
    procedure GdxModule1Pause(Sender: TObject);
    procedure GdxModule1Render(Sender: TObject; deltaTime: single);
    procedure GdxModule1Resume(Sender: TObject);
    procedure GdxModule1Show(Sender: TObject);
    procedure GdxModule1TouchDown(Sender: TObject; screenX: integer;
      screenY: integer; pointer: integer; button: integer);
  private
    {private declarations}
  public
    {public declarations}
  end;

var
  GdxModule1: TGdxModule1;

implementation
  
{$R *.lfm}
  

{ TGdxModule1 }

procedure TGdxModule1.GdxModule1Show(Sender: TObject);
begin

  jGdxTexture1.LoadFromAssets('badlogic.jpg'); //init texture...

  //prepare Form2
  if GdxModule2 = nil then
  begin
    gApp.CreateForm(TGdxModule2, GdxModule2);
    GdxModule2.Init(gApp);
  end;

end;

procedure TGdxModule1.GdxModule1TouchDown(Sender: TObject; screenX: integer;
  screenY: integer; pointer: integer; button: integer);
begin
  GdxModule2.Show();
end;

procedure TGdxModule1.GdxModule1Render(Sender: TObject; deltaTime: single);
begin

   jGdxSpriteBatch1.BeginBatch();

   Self.ClearColor(1,0,0,1);  //rgba red

   jGdxSpriteBatch1.DrawTexture(jGdxTexture1.GetJInstance(), 0,0); //yUp by default...

   jGdxSpriteBatch1.EndBatch();

   //if Self.GetGamePlayingSeconds() >= 4  then GdxModule2.Show();

end;

procedure TGdxModule1.GdxModule1Resume(Sender: TObject);
begin
   Self.Show();
end;

procedure TGdxModule1.GdxModule1Pause(Sender: TObject);
begin
//  jGdxTexture1.Dispose();
  //jGdxSpriteBatch1.Dispose();
end;

procedure TGdxModule1.GdxModule1KeyPressed(Sender: TObject; keyCode: TGdxKeyCode);
begin
 if keyCode = kcBackKey then Self.Close;
end;

procedure TGdxModule1.GdxModule1Close(Sender: TObject);
begin
  jGdxTexture1.Dispose();
  jGdxSpriteBatch1.Dispose();
end;

end.
