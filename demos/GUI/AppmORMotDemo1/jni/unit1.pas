unit unit1;

{$mode delphi}

interface

uses
  Classes, SysUtils, Laz_And_Controls, AndroidWidget
  ,SynCommons
  ,mORMot
  ,mORMotSQLite3, SynSQLite3Static
  ,SampleData
  ;

type

  { TAndroidModule2 }

  TAndroidModule2 = class(jForm)
    NewButton: jButton;
    QueryButton: jButton;
    NameInput: jEditText;
    MessageInput: jEditText;
    jImageList1: jImageList;
    jImageView1: jImageView;
    jPanel1: jPanel;
    jPanel2: jPanel;
    jTextView1: jTextView;
    jTextView2: jTextView;
    NameLabel: jTextView;
    MessageLabel: jTextView;
    procedure AndroidModule2Create(Sender: TObject);
    procedure AndroidModule2Destroy(Sender: TObject);
    procedure AndroidModule2JNIPrompt(Sender: TObject);
    procedure AndroidModule2Rotate(Sender: TObject; {%H-}rotate: integer;
      var {%H-}rstRotate: integer);
    procedure NewButtonClick(Sender: TObject);
    procedure QueryButtonClick(Sender: TObject);
  private
    {private declarations}
    Database: TSQLRest;
    Model: TSQLModel;
  public
    {public declarations}
  end;

var
  AndroidModule2: TAndroidModule2;

implementation

{$R *.lfm}

{ TAndroidModule2 }

procedure TAndroidModule2.NewButtonClick(Sender: TObject);
var
  Rec: TSQLSampleRecord;
begin
  Rec := TSQLSampleRecord.Create;
  try
    Rec.Name := StringToUTF8(NameInput.Text);
    Rec.Question := StringToUTF8(MessageInput.Text);
    if Database.Add(Rec,true)=0 then
      ShowMessage('Error adding the data') else begin
      NameInput.Text := '';
      MessageInput.Text := '';
      NameInput.SetFocus;
    end;
  finally
    Rec.Free;
  end;
end;

procedure TAndroidModule2.AndroidModule2Create(Sender: TObject);
begin
  Model     := CreateSampleModel; // from SampleData unit
end;

procedure TAndroidModule2.AndroidModule2Destroy(Sender: TObject);
begin
  Database.Free;
  Model.Free;
end;

procedure TAndroidModule2.AndroidModule2JNIPrompt(Sender: TObject);
begin
  // make a storage choice 1..3 ; best : 2 ; for now, choose Download to be able to inspect db3-file !
  //Database  := TSQLRestServerDB.Create(Model,'/storage/emulated/0/Download/mORMot.db3');
  //Database  := TSQLRestServerDB.Create(Model,GetInternalAppStoragePath+'/mORMot.db3');
  Database  := TSQLRestServerDB.Create(Model,GetEnvironmentDirectoryPath(dirDownloads)+'/mORMot.db3');
  TSQLRestServerDB(Database).CreateMissingTables;
end;

procedure TAndroidModule2.AndroidModule2Rotate(Sender: TObject;
  rotate: integer; var rstRotate: integer);
begin
  Self.UpdateLayout;
end;

procedure TAndroidModule2.QueryButtonClick(Sender: TObject);
var
  Rec: TSQLSampleRecord;
begin
  Rec := TSQLSampleRecord.Create(Database,'Name=?',[StringToUTF8(NameInput.Text)]);
  try
    if Rec.ID=0 then
      MessageInput.Text := 'Not found' else
      MessageInput.Text := UTF8ToString(Rec.Question);
  finally
    Rec.Free;
  end;
end;

end.
