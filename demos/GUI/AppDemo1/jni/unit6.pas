{Hint: save all files to location: \jni }
unit unit6;
  
{$mode delphi}
  
interface
  
uses
  Classes, SysUtils, And_jni, And_jni_Bridge, Laz_And_Controls, Laz_And_Controls_Events, AndroidWidget;
  
type

  { TAndroidModule6 }

  TAndroidModule6 = class(jForm)
      jBitmap1: jBitmap;
      jButton1: jButton;
      jButton2: jButton;
      jButton3: jButton;
      jEditText1: jEditText;
      jEditText2: jEditText;
      jImageList1: jImageList;
      jListView1: jListView;
      jTextView1: jTextView;
      jTextView2: jTextView;
      jTextView3: jTextView;
      procedure DataModuleCloseQuery(Sender: TObject; var CanClose: boolean);
      procedure jButton1Click(Sender: TObject);
      procedure jButton2Click(Sender: TObject);
      procedure jButton3Click(Sender: TObject);
      procedure jListView1ClickItem(Sender: TObject; itemIndex: integer;
        itemCaption: string);
      procedure jListView1ClickWidgetItem(Sender: TObject; Item: integer;
        checked: boolean);
    private
      {private declarations}
    public
      {public declarations}
  end;
  
var
  AndroidModule6: TAndroidModule6;

implementation
  
{$R *.lfm}

{ TAndroidModule6 }

procedure TAndroidModule6.DataModuleCloseQuery(Sender: TObject;
  var CanClose: boolean);
begin
   CanClose:= True;
end;

procedure TAndroidModule6.jButton1Click(Sender: TObject);
begin

  jBitmap1.ImageIndex:= 3;   //set image

  if jEditText1.Text = '' then
     jListView1.Add('Hello|Android|World!', jListView1.Delimiter, jListView1.FontColor,
                    jListView1.FontSize, jListView1.WidgetItem,'', jBitmap1.GetJavaBitmap)
  else
    jListView1.Add(jEditText1.Text, jListView1.Delimiter, jListView1.FontColor,
                   jListView1.FontSize, jListView1.WidgetItem,'', jBitmap1.GetJavaBitmap);

  //APIs Demo... change Item index = 2

  jBitmap1.ImageIndex:= 3;  //change image
  jListView1.SetImageByIndex(jBitmap1.GetJavaBitmap, 2);

  jListView1.SetFontColorByIndex(colbrGreen, 2);
  jListView1.SetFontSizeByIndex(16, 2);
  jListView1.SetTextDecoratedByIndex(txtItalicAndBold, 2);

  //or
  //jListView1.SetWidgetByIndex(wgTextView,'hello!',2);

  //or
  //jListView1.SetWidgetByIndex(wgRadioButton, 2); //BUG!

  jListView1.SetWidgetByIndex(wgCheckBox, 2);

  jListView1.SetTextAlignByIndex(alCenter, 2);

  jListView1.SetTextSizeDecoratedByIndex(sdDecreasing, 2);

  jListView1.SetLayoutByIndex(layWidgetTextImage,2);  //cahange layout

end;

procedure TAndroidModule6.jButton2Click(Sender: TObject);
var
  index: integer;
begin
  if jEditText2.Text <> '' then
  begin
     index:= StrToInt(jEditText2.Text);
     if (index < jListView1.Items.Count) and (index >=0) then
     begin
        jListView1.Delete(index);
     end;
  end;
end;

procedure TAndroidModule6.jButton3Click(Sender: TObject);
begin
  jListView1.Clear;
end;

procedure TAndroidModule6.jListView1ClickItem(Sender: TObject;
  itemIndex: integer; itemCaption: string);
var
  strCheck: string;
begin

  if jListView1.IsItemChecked(itemIndex) then strCheck:= 'checked!'
  else strCheck:= 'not checked!';

  ShowMessage(IntToStr(itemIndex)+ ' ['+ jListView1.GetItemText(itemIndex)+ '] :'+ strCheck);
end;

procedure TAndroidModule6.jListView1ClickWidgetItem(Sender: TObject; Item: integer; checked: boolean);
var
  strCheck: string;
begin

  if checked then strCheck:= 'checked!'
  else strCheck:= 'not checked!';

  ShowMessage('Item '+ IntToStr(Item) + ' is ' + strCheck);
end;

end.
