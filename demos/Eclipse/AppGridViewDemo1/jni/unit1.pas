{Hint: save all files to location: C:\adt32\eclipse\workspace\AppGridViewDemo1\jni }
unit unit1;
  
{$mode delphi}
  
interface
  
uses
  Classes, SysUtils, And_jni, And_jni_Bridge, Laz_And_Controls, 
    Laz_And_Controls_Events, AndroidWidget, gridview;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
      jButton1: jButton;
      jGridView1: jGridView;
      jTextView1: jTextView;
      procedure jButton1Click(Sender: TObject);
      procedure jGridView1Click(Sender: TObject; position: integer; caption: string);
    private
      {private declarations}
       FCount: integer;
    public
      {public declarations}
  end;
  
var
  AndroidModule1: TAndroidModule1;

implementation
  
{$R *.lfm}

{ TAndroidModule1 }

procedure TAndroidModule1.jGridView1Click(Sender: TObject; position: integer; caption: string);
begin
   ShowMessage(caption);
end;

procedure TAndroidModule1.jButton1Click(Sender: TObject);
begin
   inc(FCount);
   jGridView1.Add('Item_'+IntToStr(FCount), 'ic_launcher');  //from:  ../res/drawable
end;

end.
