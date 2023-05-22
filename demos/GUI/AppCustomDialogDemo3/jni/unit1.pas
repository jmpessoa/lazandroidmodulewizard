{hint: Pascal files location: ...\AppCustomDialogDemo3\jni }
unit unit1;

{$mode delphi}

interface

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, AndroidWidget, Laz_And_Controls, menu, customdialog, And_jni;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    Button1: jButton;
    CustomDialog1: jCustomDialog;
    Menu1: jMenu;
    Panel1: jPanel;  //'Hint: Panel1.LayoutParamWidth = lpNineTenthsOfParent
    TextView1: jTextView;
    TextView2: jTextView;
    TextView3: jTextView;
    TextView4: jTextView;
    TextView5: jTextView;
    TextView6: jTextView;
    procedure AndroidModule1ClickOptionMenuItem(Sender: TObject;
      jObjMenuItem: jObject; itemID: integer; itemCaption: string; checked: boolean);
    procedure AndroidModule1CreateOptionMenu(Sender: TObject; jObjMenu: jObject);
    procedure Button1Click(Sender: TObject);

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
    //Menu1.ShowOptions(jObjMenu);  //don't handle the icons...
    //or
    Menu1.ShowOptions(jObjMenu, misNever);  //handle the icons...
end;

procedure TAndroidModule1.AndroidModule1ClickOptionMenuItem(Sender: TObject;
  jObjMenuItem: jObject; itemID: integer; itemCaption: string; checked: boolean);
begin
  CustomDialog1.Show('Information', 'ic_launcher');
end;

procedure TAndroidModule1.Button1Click(Sender: TObject);
begin
   ShowMessage('Hint: Panel1.LayoutParamWidth = lpNineTenthsOfParent');
   CustomDialog1.Close;
end;


end.
