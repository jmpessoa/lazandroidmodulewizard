unit register_libgdx;
  
{$mode objfpc}{$H+}
  
interface
  
uses
  Classes,
  gdxsprite,
  gdxtextureregion,
  gdxtextureatlas,
  gdxshaperenderer,
  gdxviewport,
  gdxbitmapfont,
  gdxorthographiccamera,
  gdxtexture,
  gdxspritebatch,
  GdxForm,
  SysUtils,
  LResources;
  
Procedure Register;
  
implementation
  
Procedure Register;
begin
  {$I jgdxsprite_icon.lrs}
  {$I jgdxtextureregion_icon.lrs}
  {$I jgdxtextureatlas_icon.lrs}
  {$I jgdxshaperenderer_icon.lrs}
  {$I jgdxviewport_icon.lrs}
  {$I jgdxbitmapfont_icon.lrs}
  {$I jgdxorthographiccamera_icon.lrs}
  {$I jgdxtexture_icon.lrs}
  {$I jgdxspritebatch_icon.lrs}
  RegisterComponents('Android Bridges libGDX',
    [
      jGdxSprite,
      jGdxTextureRegion,
      jGdxTextureAtlas,
      jGdxShapeRenderer,
      jGdxViewport,
      jGdxBitmapFont,
      jGdxOrthographicCamera,
      jGdxTexture,
      jGdxSpriteBatch
    ]
  );
  RegisterClasses([jGdxForm]);
  RegisterNoIcon([jGdxForm]);
end;
  
end.
