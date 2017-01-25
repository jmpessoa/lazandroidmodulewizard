{Hint: save all files to location: C:\android-neon\eclipse\workspace\AppFileProviderDemo1\jni }
unit unit1;

{$mode delphi}

interface

uses
  Classes, SysUtils, AndroidWidget, Laz_And_Controls, fileprovider;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jButton1: jButton;
    jFileProvider1: jFileProvider;
    jImageView1: jImageView;
    jTextView1: jTextView;
    procedure jButton1Click(Sender: TObject);

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

// http://stackoverflow.com/questions/12170386/create-and-share-a-file-from-internal-storage
procedure TAndroidModule1.jButton1Click(Sender: TObject);
begin
  jFileProvider1.SetAuthorities('com.example.appfileproviderdemo1');

  jFileProvider1.FileSource:= srcResDrawable;
  Self.jImageView1.SetImage(jFileProvider1.GetImageContent('ic_launcher.png'));

  jFileProvider1.FileSource:= srcAssets;
  ShowMessage(jFileProvider1.GetTextContent('note1.txt'));

  jFileProvider1.FileSource:= srcResRaw;
  ShowMessage(jFileProvider1.GetTextContent('note2.txt'));

  jFileProvider1.FileSource:= srcInternal;
  ShowMessage(jFileProvider1.GetTextContent('note1.txt'));

end;

end.
