{Hint: save all files to location: C:\adt32\eclipse\workspace\AppListViewDemo\jni }
unit unit1;
  
{$mode delphi}
  
interface
  
uses
  Classes, SysUtils, {And_jni, And_jni_Bridge,} Laz_And_Controls, AndroidWidget;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
      jButton1: jButton;
      jButton2: jButton;
      jEditText1: jEditText;
      jListView1: jListView;
      jTextView1: jTextView;
      procedure DataModuleCreate(Sender: TObject);
      procedure DataModuleJNIPrompt(Sender: TObject);
      procedure jButton1Click(Sender: TObject);
      procedure jButton2Click(Sender: TObject);
      procedure jListView1ClickCaptionItem(Sender: TObject; Item: integer;
        caption: string);
      procedure jListView1ClickWidgetItem(Sender: TObject; Item: integer;
        checked: boolean);
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

procedure TAndroidModule1.DataModuleCreate(Sender: TObject);
begin
   //
end;

procedure TAndroidModule1.DataModuleJNIPrompt(Sender: TObject);
var
  i: integer;
begin
  for i:=0 to jListView1.Count-1 do
    jListView1.SetImageByIndex('ic_bullets',i);
end;

procedure TAndroidModule1.jButton1Click(Sender: TObject);
begin
   if jEditText1.Text <> '' then
     jListView1.Add(jEditText1.Text)
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

procedure TAndroidModule1.jListView1ClickCaptionItem(Sender: TObject;
  Item: integer; caption: string);
begin
  if jListView1.IsItemChecked(Item) then
     ShowMessage('index = ['+intToStr(Item)+'/'+caption+'] is Cheched!')
  else
     ShowMessage('index = ['+intToStr(Item)+'/'+caption+'] is Not Cheched!');
end;

procedure TAndroidModule1.jListView1ClickWidgetItem(Sender: TObject;
  Item: integer; checked: boolean);
var
  i: integer;
begin
  //ShowMessage();
  for i:=0 to jListView1.Count-1 do
  begin
     if jListView1.IsItemChecked(i) then ShowMessage('just index = ['+intToStr(i)+'] is Cheched!');
  end;
end;

end.
