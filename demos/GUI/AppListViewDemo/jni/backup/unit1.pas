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
      jCanvas1: jCanvas;
      jEditText1: jEditText;
      jImageFileManager1: jImageFileManager;
      jListView1: jListView;
      jListView2: jListView;
      jListView3: jListView;

      jTextView1: jTextView;

      procedure AndroidModule1Create(Sender: TObject);
      procedure DataModuleJNIPrompt(Sender: TObject);
      procedure jButton1AfterDispatchDraw(Obj: TObject; canvas: JObject;
        tag: integer);
      procedure jButton1BeforeDispatchDraw(Obj: TObject; canvas: JObject;
        tag: integer);
      procedure jButton1Click(Sender: TObject);
      procedure jButton2Click(Sender: TObject);
      procedure jEditText1LostFocus(Sender: TObject; text: string);
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
      procedure jListView2AfterDispatchDraw(Obj: TObject; canvas: JObject;
        tag: integer);
      procedure jListView2BeforeDispatchDraw(Obj: TObject; canvas: JObject;
        tag: integer);
      procedure jListView2ClickItem(Sender: TObject; itemIndex: integer;
        itemCaption: string);
      procedure jListView2ClickWidgetItem(Sender: TObject; itemIndex: integer;
        checked: boolean);
      procedure jListView2ScrollStateChanged(Sender: TObject;
        firstVisibleItem: integer; visibleItemCount: integer;
        totalItemCount: integer; lastItemReached: boolean);
      procedure jListView3AfterDispatchDraw(Obj: TObject; canvas: JObject;
        tag: integer);
      procedure jListView3BeforeDispatchDraw(Obj: TObject; canvas: JObject;
        tag: integer);
      procedure jListView3ClickItem(Sender: TObject; itemIndex: integer;
        itemCaption: string);
      procedure jTextView1AfterDispatchDraw(Obj: TObject; canvas: JObject;
        tag: integer);
    private
      {private declarations}
    public
      {public declarations}
       Procedure WidgeItemLostFocus(Sender: TObject; itemIndex: integer; widgetText: string);
  end;
  
var
  AndroidModule1: TAndroidModule1;

implementation
  
{$R *.lfm}

{ TAndroidModule1 }

Procedure TAndroidModule1.WidgeItemLostFocus(Sender: TObject; itemIndex: integer; widgetText: string);
begin
  ShowMessage(widgetText);
end;

procedure TAndroidModule1.DataModuleJNIPrompt(Sender: TObject);
var
  i: integer;
begin
  jListView2.FontFace:= ffMonospace;
  for i:=0 to jListView1.Count-1 do
    jListView1.SetImageByIndex('ic_bullets',i); //from .../res 'ic_bullets.png'

  jListView3.Add('111111');
  jListView3.Add('222222');
  jListView3.Add('333333');

end;

procedure TAndroidModule1.jButton1AfterDispatchDraw(Obj: TObject;
  canvas: JObject; tag: integer);
begin
  jCanvas1.SetCanvas(canvas);
  jCanvas1.drawRect(40, 40, jButton1.Width-40, jButton1.Height-40);
end;

procedure TAndroidModule1.jButton1BeforeDispatchDraw(Obj: TObject;
  canvas: JObject; tag: integer);
begin
  //jCanvas1.SetCanvas(canvas);
  //jCanvas1.drawRect(10, 10, jButton1.Width-10, jButton1.Height-10);
end;

procedure TAndroidModule1.AndroidModule1Create(Sender: TObject);
begin
  jListView2.OnWidgeItemLostFocus:= WidgeItemLostFocus;
end;

procedure TAndroidModule1.jButton1Click(Sender: TObject);
begin
   if jEditText1.Text <> '' then
   begin
       //jListView1.Add(jEditText1.Text);
       //jListView1.SetImageByIndex('ic_bullets',jListView1.Count-1); //from .../res 'ic_bullets.png'
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

procedure TAndroidModule1.jEditText1LostFocus(Sender: TObject; text: string);
begin
  ShowMessage(text);
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

procedure TAndroidModule1.jListView2AfterDispatchDraw(Obj: TObject;
  canvas: JObject; tag: integer);
begin

end;

procedure TAndroidModule1.jListView2BeforeDispatchDraw(Obj: TObject;
  canvas: JObject; tag: integer);
begin

end;

procedure TAndroidModule1.jListView2ClickItem(Sender: TObject;
  itemIndex: integer; itemCaption: string);
begin
   ShowMessage(jListView2.GetWidgetText(itemIndex));
end;

procedure TAndroidModule1.jListView2ClickWidgetItem(Sender: TObject;
  itemIndex: integer; checked: boolean);
begin
   //Self.ToggleSoftInput();
  //ShowMessage('Ok');
  jListView2.Tag:= itemIndex;
  //jNumberPicker1.Show('Qantidade');
end;

procedure TAndroidModule1.jListView2ScrollStateChanged(Sender: TObject;
  firstVisibleItem: integer; visibleItemCount: integer;
  totalItemCount: integer; lastItemReached: boolean);
begin
  if lastItemReached then ShowMessage('last!');
end;

procedure TAndroidModule1.jListView3AfterDispatchDraw(Obj: TObject;
  canvas: JObject; tag: integer);
begin
  //jCanvas1.SetCanvas(canvas);
  //jCanvas1.drawRect(100, 100, 400, 400);
end;

procedure TAndroidModule1.jListView3BeforeDispatchDraw(Obj: TObject;
  canvas: JObject; tag: integer);
begin
  jCanvas1.SetCanvas(canvas);
  jCanvas1.drawRect(3, 3, jListView3.Width-6, jListView3.Height-3);
end;

procedure TAndroidModule1.jListView3ClickItem(Sender: TObject;
  itemIndex: integer; itemCaption: string);
begin
  jListView3.SetItemTagString('Hello', itemIndex);
  jListView3.SetWidgetCheck(True, itemIndex);
  ShowMessage(jListView3.GetItemTagString(itemIndex));
end;

(*
procedure TAndroidModule1.jNumberPicker1NumberPicker(Sender: TObject;
  oldValue: integer; newValue: integer);
begin
  jListView2.SetWidgetTextByIndex(IntToStr(newValue), jListView2.Tag);
end;
  *)
procedure TAndroidModule1.jTextView1AfterDispatchDraw(Obj: TObject;
  canvas: JObject; tag: integer);
begin
  jCanvas1.SetCanvas(canvas);
  jCanvas1.drawRect(10, 10, jTextView1.Width-6, jTextView1.Height-6);
end;


end.
