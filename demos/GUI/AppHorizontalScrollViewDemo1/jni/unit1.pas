{Hint: save all files to location: C:\adt32\eclipse\workspace\AppHorizontalScrollViewDemo1\jni }
unit unit1;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, And_jni_Bridge, Laz_And_Controls, 
    Laz_And_Controls_Events, AndroidWidget;

type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jHorizontalScrollView1: jHorizontalScrollView;
    jImageList1: jImageList;
    jImageView1: jImageView;
    jImageView10: jImageView;
    jImageView11: jImageView;
    jImageView12: jImageView;
    jImageView13: jImageView;
    jImageView14: jImageView;
    jImageView15: jImageView;
    jImageView16: jImageView;
    jImageView17: jImageView;
    jImageView18: jImageView;
    jImageView2: jImageView;
    jImageView3: jImageView;
    jImageView4: jImageView;
    jImageView5: jImageView;
    jImageView6: jImageView;
    jImageView7: jImageView;
    jImageView8: jImageView;
    jImageView9: jImageView;
    jScrollView1: jScrollView;
    jTextView1: jTextView;
    procedure jHorizontalScrollView1ScrollChanged(Sender: TObject;
      currHor: Integer; currVerti: Integer; prevHor: Integer;
      prevVertical: Integer; position: TScrollPosition; scrolldiff: integer);
    procedure jImageView5Click(Sender: TObject);
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

procedure TAndroidModule1.jImageView5Click(Sender: TObject);
begin
  ShowMessage(jImageList1.GetImageByIndex(jImageView5.ImageIndex));
end;

procedure TAndroidModule1.jHorizontalScrollView1ScrollChanged(Sender: TObject;
  currHor: Integer; currVerti: Integer; prevHor: Integer;
  prevVertical: Integer; position: TScrollPosition; scrolldiff: integer);
begin
  //
end;

end.
