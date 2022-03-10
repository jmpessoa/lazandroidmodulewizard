{hint: Pascal files location: ...\AppBGRABitmapDemo1\jni }
unit unit1;

{$mode delphi}

interface

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, AndroidWidget, Laz_And_Controls,
  BGRABitmap, BGRABitmapTypes, FPWriteBMP, FPCanvas, FPImage, FPImgCanv;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    Button1: jButton;
    ImageView1: jImageView;
    jBitmap1: jBitmap;
    procedure AndroidModule1JNIPrompt(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    {private declarations}
  public
    {public declarations}
  end;

var
  AndroidModule1: TAndroidModule1;
  current_color: Integer;

implementation
  
{$R *.lfm}
  

{ TAndroidModule1 }

procedure TAndroidModule1.Button1Click(Sender: TObject);
var
  bmp: TBGRABitmap;
  p: PBGRAPixel;
  memory_stream: TMemoryStream;
  bmp_writer: TFPWriterBMP;
  image_width, image_height, pixel_number, number_of_pixels: Integer;
  image_byte_array: array of Byte;
  pixel_color_value: Byte;


begin

  image_width := 512;
  image_height := 512;
  number_of_pixels := image_width * image_height;

  SetLength(image_byte_array, number_of_pixels div SizeOf(Byte));

  for pixel_number := number_of_pixels-1 downto 0 do
  begin
    image_byte_array[pixel_number] := pixel_color_value;
    inc(pixel_color_value);
  end;


  bmp := TBGRABitmap.Create(image_width, image_height);
   try
     p := bmp.Data;
     for pixel_number := bmp.NbPixels-1 downto 0 do
     begin

      if(current_color = 1) then
      begin
        p^.red := image_byte_array[pixel_number];
        p^.green := Byte(0);
        p^.blue := Byte(0);
      end
      else if(current_color = 2) then
      begin
        p^.red := Byte(0);
        p^.green := image_byte_array[pixel_number];
        p^.blue := Byte(0);
      end
      else if(current_color = 3) then
      begin
        p^.red := Byte(0);
        p^.green := Byte(0);
        p^.blue := image_byte_array[pixel_number];
      end;

        inc(p);
     end;
     bmp.InvalidateBitmap;
     bmp_writer := TFPWriterBMP.Create;
     try
       memory_stream := TMemoryStream.Create;
       try
           bmp_writer.ImageWrite(memory_stream, bmp);
           jBitmap1.LoadFromStream(memory_stream);
           ImageView1.SetImage(jBitmap1.GetImage());
       finally
         memory_stream.Free;
       end;
     finally
       bmp_writer.Free;
     end;
   finally
     bmp.Free;
   end;


   inc(current_color);
   if(current_color > 3) then
   current_color := 1;


end;

procedure TAndroidModule1.AndroidModule1JNIPrompt(Sender: TObject);
begin

    current_color := 1;

end;

end.
