{hint: Pascal files location: ...\AppMenuDemo3\jni }
unit unit1;

{$mode delphi}

interface

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, AndroidWidget, Laz_And_Controls, menu, And_jni;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    Menu1: jMenu;
    TextView1: jTextView;
    procedure AndroidModule1ClickOptionMenuItem(Sender: TObject;
      jObjMenuItem: jObject; itemID: integer; itemCaption: string; checked: boolean);
    procedure AndroidModule1CreateOptionMenu(Sender: TObject; jObjMenu: jObject);
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

procedure TAndroidModule1.AndroidModule1CreateOptionMenu(Sender: TObject; jObjMenu: jObject);
begin
  //Menu1.ShowOptions(jObjMenu); // don't handle icons...
  Menu1.ShowOptions(jObjMenu, misNever); //handle icons...
end;

procedure TAndroidModule1.AndroidModule1ClickOptionMenuItem(Sender: TObject;
  jObjMenuItem: jObject; itemID: integer; itemCaption: string; checked: boolean);
begin
   ShowMessage(itemCaption + ' ['+IntToStr(itemID)+']')
end;

end.
