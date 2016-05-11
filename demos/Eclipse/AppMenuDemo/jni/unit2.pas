{Hint: save all files to location: \jni }
unit unit2;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, And_jni_Bridge, Laz_And_Controls, 
  Laz_And_Controls_Events, AndroidWidget, menu;

type

  { TAndroidModule2 }

  TAndroidModule2 = class(jForm)
    jButton1: jButton;
    jButton2: jButton;
    jMenu1: jMenu;
    jTextView1: jTextView;
    procedure AndroidModule2BackButton(Sender: TObject);
    procedure AndroidModule2ClickOptionMenuItem(Sender: TObject;
      jObjMenuItem: jObject; itemID: integer; itemCaption: string;
      checked: boolean);
    procedure AndroidModule2Close(Sender: TObject);
    procedure AndroidModule2CreateOptionMenu(Sender: TObject; jObjMenu: jObject);

    procedure AndroidModule2JNIPrompt(Sender: TObject);
    procedure AndroidModule2SpecialKeyDown(Sender: TObject; keyChar: char;
      keyCode: integer; keyCodeString: string; var mute: boolean);
    procedure jButton1Click(Sender: TObject);
    procedure jButton2Click(Sender: TObject);
  private
    {private declarations}
    FSaveBarSubTitle: string;
  public
    {public declarations}
  end;

var
  AndroidModule2: TAndroidModule2;

implementation

{$R *.lfm}

{ TAndroidModule2 }

//NOTE: jForm2.ActivityMode = actRecyclable  !!!!!

procedure TAndroidModule2.AndroidModule2JNIPrompt(Sender: TObject);
begin
  FSaveBarSubTitle:= Self.GetSubTitleActionBar();
  Self.SetSubTitleActionBar('jForm [2]');
  jMenu1.Clear();  //clean up ...
  jMenu1.InvalidateOptionsMenu();  //fire OnCreateOptionsMenu --> OnPrepareOptionsMenu to do form2 menu ...
end;

procedure TAndroidModule2.AndroidModule2SpecialKeyDown(Sender: TObject;
  keyChar: char; keyCode: integer; keyCodeString: string; var mute: boolean);
begin
  ShowMessage(keyCodeString);
end;

procedure TAndroidModule2.AndroidModule2CreateOptionMenu(Sender: TObject; jObjMenu: jObject);
var
  i: integer;
begin
     for i:= 0 to jMenu1.Options.Count-1 do
     begin
       jMenu1.AddItem(jObjMenu, 3000+i {itemID}, jMenu1.Options.Strings[i], jMenu1.IconIdentifiers.Strings[i] {..res/drawable-xxx}, mitDefault, misIfRoomWithText);
     end;
end;

procedure TAndroidModule2.AndroidModule2ClickOptionMenuItem(Sender: TObject;
  jObjMenuItem: jObject; itemID: integer; itemCaption: string; checked: boolean);
begin
  ShowMessage(itemCaption);
end;

procedure TAndroidModule2.AndroidModule2BackButton(Sender: TObject);
begin
  ShowMessage('Back to jForm1');
end;

procedure TAndroidModule2.jButton1Click(Sender: TObject);
begin
   ShowMessage('HINT: jForm2.ActivityMode=actRecyclable');
end;

procedure TAndroidModule2.jButton2Click(Sender: TObject);
begin
  Self.Close;
end;

procedure TAndroidModule2.AndroidModule2Close(Sender: TObject);
begin
   jMenu1.Clear();  //clean up ...
   Self.SetSubTitleActionBar(FSaveBarSubTitle);
end;

end.
