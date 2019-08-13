{Hint: save all files to location: C:\android\workspace\AppImageViewListDemo1\jni }
unit unit1;

{$mode delphi}

interface

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, AndroidWidget, Laz_And_Controls;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jButton1: jButton;
    jImageList1: jImageList;
    jImageView1: jImageView;
    jImageView2: jImageView;
    jImageView3: jImageView;
    jPanel1: jPanel;
    jTextView1: jTextView;
    jTextView2: jTextView;
    procedure AndroidModule1Create(Sender: TObject);
    procedure AndroidModule1JNIPrompt(Sender: TObject);
    procedure jButton1Click(Sender: TObject);
    procedure jPanel1FlingGesture(Sender: TObject; flingGesture: TFlingGesture);
  private
    {private declarations}
    FIterator: integer;
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
    Inc(FIterator);
    if FIterator > 3 then
      FIterator:= 1;

    case FIterator of
      1: jImageView1.BringToFront;
      2: jImageView2.BringToFront;
      3: jImageView3.BringToFront;
    end;
end;

procedure TAndroidModule1.jPanel1FlingGesture(Sender: TObject;
  flingGesture: TFlingGesture);
begin
   Inc(FIterator);
    if FIterator > 3 then
      FIterator:= 1;

    case FIterator of
      1: jImageView1.BringToFront;
      2: jImageView2.BringToFront;
      3: jImageView3.BringToFront;
    end;
end;

//JNI pascal/java interaction...
procedure TAndroidModule1.AndroidModule1JNIPrompt(Sender: TObject);
begin
 //
end;

//pure pascal initialize
procedure TAndroidModule1.AndroidModule1Create(Sender: TObject);
begin
   FIterator:= 1;
end;

end.
