{Hint: save all files to location: C:\android-neon\eclipse\workspace\AppCustomCameraDemo1\jni }
unit unit1;

{$mode delphi}

interface

uses
  Classes, SysUtils, AndroidWidget, Laz_And_Controls, customcamera, And_jni;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jButton1: jButton;
    jCustomCamera1: jCustomCamera;
    procedure AndroidModule1JNIPrompt(Sender: TObject);
    procedure jButton1Click(Sender: TObject);
    procedure jCustomCamera1PictureTaken(Sender: TObject;
      bitmapPicture: jObject; fullPath: string);
    procedure jCustomCamera1SurfaceChanged(Sender: TObject; width: integer;
      height: integer);
  private
    {private declarations}
  public
    {public declarations}
  end;

var
  AndroidModule1: TAndroidModule1;

implementation
  
{$R *.lfm}
  

{ TAndroidModule1 }


procedure TAndroidModule1.jButton1Click(Sender: TObject);
begin
  //jCustomCamera1.SetEnvironmentStorage(dirDownloads,'folder1');
  //jCustomCamera1.TakePicture();
  jCustomCamera1.TakePicture('MyPicture5.jpg');
end;

procedure TAndroidModule1.jCustomCamera1PictureTaken(Sender: TObject;
  bitmapPicture: jObject; fullPath: string);
begin
   ShowMessage('Path= '+ fullPath);
end;

procedure TAndroidModule1.AndroidModule1JNIPrompt(Sender: TObject);
begin
  jCustomCamera1.SetEnvironmentStorage(dirDownloads,'folder2');
end;

procedure TAndroidModule1.jCustomCamera1SurfaceChanged(Sender: TObject;
  width: integer; height: integer);
begin
  ShowMessage('width = ' + intToStr(width) + '   height = ' + intToStr(height))
end;

end.
