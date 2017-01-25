{Hint: save all files to location: C:\android-neon\eclipse\workspace\AppFileProviderClientDemo1\jni }
unit unit1;

{$mode delphi}

interface

uses
  Classes, SysUtils, AndroidWidget, Laz_And_Controls, fileprovider;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jButton1: jButton;
    jButton2: jButton;
    jButton3: jButton;
    jButton4: jButton;
    jFileProvider1: jFileProvider;
    jImageView1: jImageView;
    jTextView1: jTextView;
    procedure jButton1Click(Sender: TObject);
    procedure jButton2Click(Sender: TObject);
    procedure jButton3Click(Sender: TObject);
    procedure jButton4Click(Sender: TObject);
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
  jFileProvider1.FileSource:= srcAssets;
  jFileProvider1.SetAuthorities('com.example.appfileproviderdemo1');
  ShowMessage(jFileProvider1.GetTextContent('note1.txt'));
end;

procedure TAndroidModule1.jButton2Click(Sender: TObject);
begin
  jFileProvider1.FileSource:= srcResRaw;
  jFileProvider1.SetAuthorities('com.example.appfileproviderdemo1');
  ShowMessage(jFileProvider1.GetTextContent('note2.txt'));
end;

procedure TAndroidModule1.jButton3Click(Sender: TObject);
begin
  jFileProvider1.FileSource:= srcInternal;
  jFileProvider1.SetAuthorities('com.example.appfileproviderdemo1');
  ShowMessage(jFileProvider1.GetTextContent('note1.txt'));
end;

procedure TAndroidModule1.jButton4Click(Sender: TObject);
begin
  jFileProvider1.FileSource:= srcResDrawable;
  jFileProvider1.SetAuthorities('com.example.appfileproviderdemo1');
  jImageView1.SetImage(jFileProvider1.GetImageContent('ic_launcher.png'));
end;



end.
