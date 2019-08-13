unit unit3;
//

{$mode delphi}

interface

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, AndroidWidget, Laz_And_Controls;
  
type

  { TAndroidModule3 }

  TAndroidModule3 = class(jForm)
    jButton1: jButton;
    jImageList1: jImageList;
    jImageView1: jImageView;
    jImageView2: jImageView;
    jImageView3: jImageView;
    jPanel1: jPanel;
    jTextView1: jTextView;
    jTextView2: jTextView;
    procedure AndroidModule3Create(Sender: TObject);
    procedure AndroidModule3JNIPrompt(Sender: TObject);
    procedure jButton1Click(Sender: TObject);
    procedure jPanel1FlingGesture(Sender: TObject; flingGesture: TFlingGesture);
  private
    {private declarations}
    FIterator: integer;
  public
    {public declarations}
  end;

var
  AndroidModule3: TAndroidModule3;

implementation
  
{$R *.lfm}
  

{ TAndroidModule3 }

procedure TAndroidModule3.jButton1Click(Sender: TObject);
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

procedure TAndroidModule3.jPanel1FlingGesture(Sender: TObject;
  flingGesture: TFlingGesture);
begin
    Inc(FIterator);
    if FIterator > 3 then
      FIterator:= 1;

    case FIterator of
      1: jImageView1.BringToFront;  //do the ImageView animation
      2: jImageView2.BringToFront;
      3: jImageView3.BringToFront;
    end;
end;

//JNI Pascal Code   --> Java code ...
procedure TAndroidModule3.AndroidModule3JNIPrompt(Sender: TObject);
begin
  //
end;

//pure pascal code
procedure TAndroidModule3.AndroidModule3Create(Sender: TObject);
begin
  FIterator:= 1;
end;

end.
