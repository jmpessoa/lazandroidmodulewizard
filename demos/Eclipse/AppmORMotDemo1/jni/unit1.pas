unit unit1;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, And_jni_Bridge, Laz_And_Controls, 
  Laz_And_Controls_Events, AndroidWidget
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
    procedure AndroidModule2Rotate(Sender: TObject; rotate: integer;
      var rstRotate: integer);
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
  Database  := TSQLRestServerDB.Create(Model,gApp.Path.Dat+'/mORMot.db3');
  TSQLRestServerDB(Database).CreateMissingTables;
end;

procedure TAndroidModule2.AndroidModule2Destroy(Sender: TObject);
begin
  Database.Free;
  Model.Free;
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
