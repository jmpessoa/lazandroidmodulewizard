{Hint: save all files to location: \jni }
unit unit6;
  
{$mode delphi}
  
interface
  
uses
  Classes, SysUtils, And_jni, And_jni_Bridge, Laz_And_Controls;
  
type

  { TAndroidModule6 }

  TAndroidModule6 = class(jForm)
      jButton1: jButton;
      jButton2: jButton;
      jButton3: jButton;
      jEditText1: jEditText;
      jEditText2: jEditText;
      jListView1: jListView;
      jTextView1: jTextView;
      jTextView2: jTextView;
      jTextView3: jTextView;
      procedure DataModuleCloseQuery(Sender: TObject; var CanClose: boolean);
      procedure DataModuleCreate(Sender: TObject);
      procedure DataModuleJNIPrompt(Sender: TObject);
      procedure DataModuleRotate(Sender: TObject; rotate: integer;
        var rstRotate: integer);
      procedure jButton1Click(Sender: TObject);
      procedure jButton2Click(Sender: TObject);
      procedure jButton3Click(Sender: TObject);
      procedure jListView1ClickItem(Sender: TObject; Item: Integer);
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

procedure TAndroidModule6.DataModuleCreate(Sender: TObject);
begin    //this initialization code is need here to fix Laz4Andoid  *.lfm parse.... why parse fails?
  Self.ActivityMode:= actRecyclable;
  Self.BackgroundColor:= colbrBlack;
  //mode delphi
  Self.OnJNIPrompt:= DataModuleJNIPrompt;
  Self.OnRotate:= DataModuleRotate;
  Self.OnCloseQuery:= DataModuleCloseQuery;
end;

procedure TAndroidModule6.DataModuleJNIPrompt(Sender: TObject);
begin
  Self.Show;
end;

procedure TAndroidModule6.DataModuleRotate(Sender: TObject; rotate: integer; var rstRotate: integer);
begin
  Self.UpdateLayout;
end;

procedure TAndroidModule6.jButton1Click(Sender: TObject);
begin
  if jEditText1.Text <> '' then
    jListView1.Items.Add(jEditText1.Text)
  else
    jListView1.Items.Add('item_'+ IntToStr(Random(100)));
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
        jListView1.Items.Delete(index);
     end;
  end;
end;

procedure TAndroidModule6.jButton3Click(Sender: TObject);
begin
  jListView1.Items.Clear;
end;

procedure TAndroidModule6.jListView1ClickItem(Sender: TObject; Item: Integer);
begin
  ShowMessage(IntToStr(Item));
end;

end.
