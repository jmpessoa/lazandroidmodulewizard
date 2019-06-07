{Hint: save all files to location: C:\android\workspace\AppMenuDemo2\jni }
unit unit1;

{$mode delphi}

interface

uses
  Classes, SysUtils, AndroidWidget, Laz_And_Controls, menu, And_jni, Spinner;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jImageView1: jImageView;
    jMenu1: jMenu;
    jSpinner1: jSpinner;
    jTextView1: jTextView;
    procedure AndroidModule1ClickOptionMenuItem(Sender: TObject;
      jObjMenuItem: jObject; itemID: integer; itemCaption: string;
      checked: boolean);
    procedure AndroidModule1CreateOptionMenu(Sender: TObject; jObjMenu: jObject);
    procedure jImageView1Click(Sender: TObject);
    procedure jImageView1PopupItemSelected(Sender: TObject; caption: string);
    procedure jSpinner1ItemSelected(Sender: TObject; itemCaption: string; itemIndex: integer);
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
  jMenu1.AddItem(jObjMenu, 101, 'Green', 'bullet_green' {..res/drawable}, mitDefault, misIfRoomWithText);
  jMenu1.AddDropDownItem(jObjMenu, jImageView1.View);
  jMenu1.AddDropDownItem(jObjMenu, jSpinner1.View);
end;

procedure TAndroidModule1.AndroidModule1ClickOptionMenuItem(Sender: TObject;
  jObjMenuItem: jObject; itemID: integer; itemCaption: string; checked: boolean);
begin
  ShowMessage('itemID =' + IntToStr(itemID) + '  ::  ' + itemCaption);
end;

procedure TAndroidModule1.jImageView1Click(Sender: TObject);
begin
  jImageView1.ShowPopupMenu(['Blue', 'Green', 'Red']);
end;

procedure TAndroidModule1.jImageView1PopupItemSelected(Sender: TObject; caption: string);
begin
   ShowMessage(caption);
end;

procedure TAndroidModule1.jSpinner1ItemSelected(Sender: TObject;
  itemCaption: string; itemIndex: integer);
begin
  ShowMessage(itemCaption);
end;

end.
