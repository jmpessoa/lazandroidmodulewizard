{Hint: save all files to location: C:\adt32\eclipse\workspace\AppListViewDemo\jni }
unit unit1;
  
{$mode delphi}
  
interface
  
uses
  Classes, SysUtils, Laz_And_Controls, AndroidWidget, And_jni, imagefilemanager;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
      jButton1: jButton;
      jButton2: jButton;
      jEditText1: jEditText;
      jImageFileManager1: jImageFileManager;
      jListView1: jListView;
      jListView2: jListView;
      jTextView1: jTextView;

      procedure DataModuleJNIPrompt(Sender: TObject);
      procedure jButton1Click(Sender: TObject);
      procedure jButton2Click(Sender: TObject);
      procedure jListView1ClickItem(Sender: TObject; itemIndex: integer;
        itemCaption: string);
      procedure jListView1ClickWidgetItem(Sender: TObject; Item: integer;
        checked: boolean);
      procedure jListView1DrawItemBitmap(Sender: TObject; itemIndex: integer;
        itemCaption: string; out bimap: JObject);
      procedure jListView1DrawItemTextColor(Sender: TObject;
        itemIndex: integer; itemCaption: string; out textColor: TARGBColorBridge
        );
      procedure jListView1LongClickItem(Sender: TObject; itemIndex: integer;
        itemCaption: string);
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
  i: integer;
begin
  jListView2.FontFace:= ffMonospace;
  for i:=0 to jListView1.Count-1 do
    jListView1.SetImageByIndex('ic_bullets',i); //from .../res 'ic_bullets.png'
end;

procedure TAndroidModule1.jButton1Click(Sender: TObject);
begin
   if jEditText1.Text <> '' then
   begin
     //jListView1.Add(jEditText1.Text);
   //  jListView1.SetImageByIndex('ic_bullets',jListView1.Count-1); //from .../res 'ic_bullets.png'
       jListView2.Add(jEditText1.Text);
   end
   else
     ShowMessage('Please, enter some text!');
end;

procedure TAndroidModule1.jButton2Click(Sender: TObject);
var
  i, itemChecked: integer;
begin

  itemChecked:= -1;
  for i:=0 to jListView1.Count-1 do
  begin
    if jListView1.IsItemChecked(i) then
    begin
      itemChecked:= i;
      Break;
    end;
  end;

  if itemChecked >= 0 then
  begin
    jListView1.Delete(itemChecked);
    ShowMessage('Item index='+IntToStr(itemChecked)+ 'was deleted!')
  end
  else
    ShowMessage('Item Checked not found!');

end;

procedure TAndroidModule1.jListView1ClickItem(Sender: TObject;
  itemIndex: integer; itemCaption: string);
begin
   if jListView1.IsItemChecked(itemIndex) then
     ShowMessage('index = ['+intToStr(itemIndex)+'/'+itemCaption+'] is Cheched!')
  else
     ShowMessage('index = ['+intToStr(itemIndex)+'/'+itemCaption+'] is Not Cheched!');
end;

procedure TAndroidModule1.jListView1ClickWidgetItem(Sender: TObject;
  Item: integer; checked: boolean);
var
  i: integer;
begin
  //ShowMessage();
  for i:=0 to jListView1.Count-1 do
  begin
     if jListView1.IsItemChecked(i) then ShowMessage('Index = ['+intToStr(i)+'] is Cheched!');
  end;

end;

procedure TAndroidModule1.jListView1DrawItemBitmap(Sender: TObject;
  itemIndex: integer; itemCaption: string; out bimap: JObject);
begin
  if  itemIndex = 1 then bimap:= jImageFileManager1.LoadFromResources('ic_launcher');
end;

procedure TAndroidModule1.jListView1DrawItemTextColor(Sender: TObject;
  itemIndex: integer; itemCaption: string; out textColor: TARGBColorBridge);
begin
  if  itemIndex = 1 then textColor:= colbrGreen;
end;

procedure TAndroidModule1.jListView1LongClickItem(Sender: TObject;
  itemIndex: integer; itemCaption: string);
begin
    ShowMessage('LOng: index = ['+intToStr(itemIndex)+'/'+itemCaption+']');
end;

end.
