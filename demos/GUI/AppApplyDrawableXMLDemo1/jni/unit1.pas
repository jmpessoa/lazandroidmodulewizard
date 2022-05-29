{hint: Pascal files location: ...\AppApplyDrawableXMLDemo1\jni }
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
    Button1: jButton;
    ImageView3: jImageView;
    EditText1: jEditText;
    ImageView1: jImageView;
    ImageView2: jImageView;
    ImageView4: jImageView;
    ImageView5: jImageView;
    ProgressBar1: jProgressBar;
    TextView1: jTextView;
    TextView2: jTextView;
    procedure AndroidModule1JNIPrompt(Sender: TObject);
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

procedure TAndroidModule1.AndroidModule1JNIPrompt(Sender: TObject);
begin
  TextView1.ApplyDrawableXML('textshape'); //from ...res/drawable
  TextView2.ApplyDrawableXML('text2shape'); //from ...res/drawable

  EditText1.ApplyDrawableXML('editshape'); //from ...res/drawable

  ImageView1.ApplyDrawableXML('imagelayer');  //from ...res/drawable

  //ImageView2.RoundedShape:= True; //by design ->  Object Inspector

  //custom xml Round Corners
  ImageView3.ApplyDrawableXML('imageshapecornersround');  //from ...res/drawable
  ImageView3.SetClipToOutline(True);  //warning need project min device api >= 21

  //default xml Round Corners
  //ImageView4.SetRoundCorner(); //default "image_rounded.xml"  from ...res/drawable/

  //or custom _radius Corners ... not xml need!
  ImageView4.SetRoundCorner(30);

  Button1.ApplyDrawableXML('buttonshape');   //from ...res/drawable

  ProgressBar1.ApplyDrawableXML('progressbarshape');   //from ...res/drawable

end;

procedure TAndroidModule1.jButton1Click(Sender: TObject);
begin
    ImageView5.ApplyDrawableXML('imageshape'); //from ...res/drawable

    //just as a side hint...
    ProgressBar1.Progress:= ProgressBar1.Progress + 10;
    if ProgressBar1.Progress > 50 then ProgressBar1.SetMarkerColor(colbrRed);

end;

end.
