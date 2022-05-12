{Hint: save all files to location: C:\android\workspace\AppAnimationDemo1\jni }
unit unit2;

{$mode delphi}

interface

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, AndroidWidget, Laz_And_Controls, unit3;
  
type

  { TAndroidModule3 }

  { TAndroidModule2 }

  TAndroidModule2 = class(jForm)
    jButton1: jButton;
    jEditText1: jEditText;
    jEditText2: jEditText;
    jImageView1: jImageView;
    jListView1: jListView;
    jPanel1: jPanel;
    jTextView1: jTextView;
    jTextView2: jTextView;
    jTextView3: jTextView;
    procedure jButton1Click(Sender: TObject);
    procedure jListView1ClickItem(Sender: TObject; itemIndex: integer;
      itemCaption: string);
  private
    {private declarations}
  public
    {public declarations}
  end;

var
  AndroidModule2: TAndroidModule2;

implementation
  
{$R *.lfm}
  

{ TAndroidModule2 }

procedure TAndroidModule2.jListView1ClickItem(Sender: TObject;
  itemIndex: integer; itemCaption: string);
begin
  if AndroidModule3 = nil then  //jForm3
  begin
    gApp.CreateForm(TAndroidModule3, AndroidModule3);
    AndroidModule3.InitShowing;  //do the jForm animation....
  end
  else
  begin
    AndroidModule3.Show;    //do the  jForm animation....
  end;
end;

procedure TAndroidModule2.jButton1Click(Sender: TObject);
begin
   jListView1.Add(jEditText1.Text + '|' + jEditText2.Text)
end;

end.
