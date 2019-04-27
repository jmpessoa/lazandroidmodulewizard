{Hint: save all files to location: C:\adt32\eclipse\workspace\AppListViewDemo\jni }
unit unit1;
  
{$mode delphi}
  
interface
  
uses
  Classes, SysUtils, Laz_And_Controls, AndroidWidget, And_jni, imagefilemanager;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
      jListView3: jListView;

      procedure DataModuleJNIPrompt(Sender: TObject);
      procedure jListView3ClickWidgetItem(Sender: TObject; itemIndex: integer;
        checked: boolean);
      procedure jListView3DrawItemBackColor(Sender: TObject;
        itemIndex: integer; out backColor: TARGBColorBridge);

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

procedure TAndroidModule1.DataModuleJNIPrompt(Sender: TObject);
var
  i : integer;
begin

  for i := 0 to 10 do
  begin
   jListView3.Add('Item ' + intTostr(i));
   jListView3.SetFontSizeByIndex(16,i);
  end;

end;

procedure TAndroidModule1.jListView3ClickWidgetItem(Sender: TObject;
  itemIndex: integer; checked: boolean);
begin
  if jListView3.IsItemChecked(itemIndex) then
  begin
   jListView3.SetFontSizeByIndex(18, itemIndex);
   showmessage('Is Check!')
  end
  else
  begin
   jListView3.SetFontSizeByIndex(16, itemIndex);
   showmessage('Not Check!');
  end;

  jListView3.Refresh;
end;

procedure TAndroidModule1.jListView3DrawItemBackColor(Sender: TObject;
  itemIndex: integer; out backColor: TARGBColorBridge);
begin
  if jListView3.IsItemChecked(itemIndex) then
   backColor := colbrRed;
end;


end.
