unit ufrmEditor;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LazFileUtils, IniFiles, Forms, Controls, Graphics, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls, Buttons, IDEIntf, ProjectIntf, LazIDEIntf,
  LCLIntf, AndroidXMLResString;

type

  { TfrmEditor }    //by  thierrydijoux

  TEditorType = (etResString, etManifest, etBuild);

  TEditMode = (emAdd, emEdit, emNone);

  TfrmEditor = class(TForm)
    bbClose: TBitBtn;
    bbOk: TBitBtn;
    bbCancel: TBitBtn;
    bbSave: TBitBtn;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    edtWorkpspacePath: TEdit;
    edtName: TEdit;
    edtValue: TEdit;
    ImageList1: TImageList;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    lvResources: TListView;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    pnlRight: TPanel;
    pnlResString: TPanel;
    sddPath: TSelectDirectoryDialog;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    tbAction: TToolBar;
    tbOpen: TToolButton;
    tbNew: TToolButton;
    tbAdd: TToolButton;
    tbEdit: TToolButton;
    ToolButton1: TToolButton;
    tbDelete: TToolButton;
    tbUp: TToolButton;
    tbDown: TToolButton;
    ToolButton2: TToolButton;
    procedure bbCancelClick(Sender: TObject);
    procedure bbOkClick(Sender: TObject);
    procedure bbCloseClick(Sender: TObject);
    procedure bbSaveClick(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure lvResourcesColumnClick(Sender: TObject; Column: TListColumn);
    procedure lvResourcesDblClick(Sender: TObject);
    procedure Panel1Resize(Sender: TObject);

    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure tbAddClick(Sender: TObject);
    procedure tbDeleteClick(Sender: TObject);
    procedure tbDownClick(Sender: TObject);
    procedure tbEditClick(Sender: TObject);
    procedure tbOpenClick(Sender: TObject);
    procedure tbUpClick(Sender: TObject);
  private
    { private declarations }
    ResXml: TXMLResString;
    EditMode: TEditMode;
    FFileName: string;
    SavedName: string;

    EditorType: TEditorType;

    ProjectPath: string;
    RESProjectPath: string;    //by jmpessoa
    PathToWorkspace: string;   //by jmpessoa
    FullFileName: string;

    procedure EditRes;
    procedure SetButtonMode;
    procedure ExchangeItems(AListView: TListView; const i, j: Integer);
  public
    { public declarations }
    constructor Create(AEditorType: TEditorType; TheOwner: TComponent = nil); overload;
    property FileName: string read FFileName write FFileName;
  end;

  procedure GetSubDirectories(const directory : string; list : TStrings);

var
  frmEditor: TfrmEditor;

implementation

{$R *.lfm}

procedure TfrmEditor.ExchangeItems(AListView: TListView; const i, j: Integer);
var
  tempLI: TListItem;
begin
  with AListView do
  begin
    Items.BeginUpdate;
    try
      tempLI := TListItem.Create(AListView.Items);
      tempLI.Assign(Items.Item[i]);
      Items.Item[i].Assign(Items.Item[j]);
      Items.Item[j].Assign(tempLI);
      tempLI.Free;
    finally
      Items.EndUpdate
    end;
  end;
end;

procedure TfrmEditor.SetButtonMode;
begin
  tbAdd.Enabled:= EditMode = emNone;
  tbEdit.Enabled:= EditMode = emNone;
  tbDelete.Enabled:= EditMode = emNone;
  tbOpen.Enabled:= EditMode = emNone;
  tbNew.Enabled:= EditMode = emNone;
  tbUp.Enabled:= EditMode = emNone;
  tbDown.Enabled:= EditMode = emNone;
  lvResources.Enabled:= EditMode = emNone;
  edtName.Enabled:= EditMode <> emNone;
  edtValue.Enabled:= EditMode <> emNone;
  bbOk.Enabled:= EditMode <> emNone;
  bbCancel.Enabled:= EditMode <> emNone;
end;

procedure TfrmEditor.EditRes;
begin
  if lvResources.ItemIndex < 0 then Exit;
  EditMode:= emEdit;
  SetButtonMode;
  SavedName:= ResXml.NameFromIndex[lvResources.ItemIndex];
  edtName.Text:= ResXml.NameFromIndex[lvResources.ItemIndex];
  edtValue.Text:= ResXml.ValueFromIndex[lvResources.ItemIndex];
  edtValue.SetFocus;
end;

constructor TfrmEditor.Create(AEditorType: TEditorType; TheOwner: TComponent = nil);
begin
  inherited Create(TheOwner);
  EditMode:= emNone;
  EditorType:=  AEditorType; //by jmpessoa

  SetButtonMode;

  //pnlResString.Visible:= AEditorType = etResString;
//  pnlManifest.Visible:= AEditorType = etManifest;
end;

procedure TfrmEditor.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  CloseAction:= caFree;
end;

procedure TfrmEditor.FormCloseQuery(Sender: TObject; var CanClose: boolean);
Var
  Response: integer;
begin
  if Assigned(ResXml) then
  begin
    if not ResXml.Saved then
    begin
      Response:= MessageDlg('Save', 'Do you want to save your changes ?', mtConfirmation,
                            [mbYes, mbNo, mbCancel],0);
      if Response = mrYes then ResXml.Save;
    end;
    CanClose:= Response <> mrCancel;
  end;
end;

procedure TfrmEditor.FormCreate(Sender: TObject);
var
  AmwFile: string;
begin
  EditMode:= emNone;

  EditorType:= etResString;

  SetButtonMode;
  AmwFile:= AppendPathDelim(LazarusIDE.GetPrimaryConfigPath) + 'JNIAndroidProject.ini';
   if FileExistsUTF8(AmwFile) then
   begin
       with TIniFile.Create(AmwFile) do  // Try to use settings from Android module wizard
       try
         PathToWorkspace:=  ReadString('NewProject', 'PathToWorkspace', ''); //by jmpessoa
         ProjectPath:= ReadString('NewProject', 'FullProjectName', '');      //by jmpessoa
       finally
         Free
       end;
   end
end;

procedure TfrmEditor.bbOkClick(Sender: TObject);
Var
  i: integer;
begin
  i:= -1;
  if EditMode = emAdd then
  begin
    ResXml.Add(edtName.Text, edtValue.Text);
    lvResources.AddItem(edtName.Text, nil);
  end
  else
  begin
    i:= ResXml.FindByName(edtName.Text);
    if i = -1 then
    begin
      ResXml.Delete(ResXml.FindByName(SavedName));
      ResXml.Add(edtName.Text, edtValue.Text);
    end
    else
      ResXml.ValueFromIndex[i]:= edtValue.Text;
  end;
  edtName.Clear;
  edtValue.Clear;
  SavedName:= '';
  EditMode:= emNone;
  SetButtonMode;
end;

procedure TfrmEditor.bbCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmEditor.bbSaveClick(Sender: TObject);
begin
  ResXml.Save;
end;

procedure TfrmEditor.ComboBox1Change(Sender: TObject);
begin
    if ComboBox1.ItemIndex > -1 then
  begin
    ProjectPath:= ComboBox1.Items.Strings[ComboBox1.ItemIndex];
    RESProjectPath:= ProjectPath + DirectorySeparator + 'res';
    FullFileName:=RESProjectPath+DirectorySeparator+'values'+DirectorySeparator+'strings.xml';
  end;
end;

procedure TfrmEditor.ComboBox2Change(Sender: TObject);  //by jmpessoa
begin

  if ComboBox2.ItemIndex <> 0 then ShowMessage('Sorry, not Implemented yet!');
  ComboBox2.ItemIndex:= 0;  //force default!
  {TODO:
  case ComboBox2.ItemIndex of
    0: begin
          EditorType:= etResString;
          FullFileName:=RESProjectPath+DirectorySeparator+'values'+DirectorySeparator+'strings.xml';
       end;
    1: begin
          EditorType:= etManifest;
          FullFileName:=ProjectPath+DirectorySeparator+'AndroidManifest.xml';
       end;
    2: begin
         EditorType:= etBuild;
         FullFileName:=ProjectPath+DirectorySeparator+'build.xml';
       end;
  end;
  }
end;

procedure TfrmEditor.bbCancelClick(Sender: TObject);
begin
  SavedName:= '';
  edtName.Clear;
  edtValue.Clear;
  EditMode:= emNone;
  SetButtonMode;
end;

procedure TfrmEditor.FormDestroy(Sender: TObject);
begin
  if Assigned(ResXml) then
    ResXml.Free;
  frmEditor:= nil;
end;

procedure TfrmEditor.FormShow(Sender: TObject); //by jmpessoa
begin
  edtWorkpspacePath.Text:= PathToWorkspace;
  ComboBox1.Items.Clear;
  if PathToWorkspace <> '' then
  begin
    GetSubDirectories(PathToWorkspace, ComboBox1.Items);
    if ProjectPath <> '' then
    begin
      ComboBox1.Text:= ProjectPath;
      RESProjectPath:= ProjectPath + DirectorySeparator + 'res';
      FullFileName:=RESProjectPath+DirectorySeparator+'values'+DirectorySeparator+'strings.xml';
    end;
  end;
end;

procedure TfrmEditor.lvResourcesColumnClick(Sender: TObject; Column: TListColumn);
begin
  with lvResources do
  begin
    if SortDirection = sdAscending then
      SortDirection:= sdDescending
    else
      SortDirection:= sdAscending;
    SortColumn:= 0;
  end;
end;

procedure TfrmEditor.lvResourcesDblClick(Sender: TObject);
begin
  EditRes;
end;

procedure TfrmEditor.Panel1Resize(Sender: TObject);
begin
  lvResources.Column[0].Width:= lvResources.Width - 4;
end;

procedure TfrmEditor.SpeedButton1Click(Sender: TObject);
begin
  sddPath.Title:= 'Select Projects Workspace Path';
  if Trim(edtWorkpspacePath.Text) <> '' then
    if DirPathExists(edtWorkpspacePath.Text) then
      sddPath.InitialDir:= edtWorkpspacePath.Text;
  if sddPath.Execute then
  begin
     PathToWorkspace:= sddPath.FileName;
     edtWorkpspacePath.Text:= PathToWorkspace;
     ComboBox1.Items.Clear;
     GetSubDirectories(PathToWorkspace, ComboBox1.Items);
     ComboBox1.ItemIndex:= -1;
     ComboBox1.Text:='';
  end;
end;

procedure TfrmEditor.SpeedButton2Click(Sender: TObject);
begin
  PathToWorkspace:= edtWorkpspacePath.Text;   //change Workspace...
  ComboBox1.Items.Clear;
  GetSubDirectories(PathToWorkspace, ComboBox1.Items);
  ComboBox1.Text:='';
end;

procedure TfrmEditor.tbAddClick(Sender: TObject);
begin
  EditMode:= emAdd;
  SetButtonMode;
  edtName.Clear;
  edtValue.Clear;
  edtName.SetFocus;
end;

procedure TfrmEditor.tbDeleteClick(Sender: TObject);
begin
  ResXml.Delete(ResXml.FindByName(ResXml.NameFromIndex[lvResources.ItemIndex]));
  lvResources.Items.Delete(lvResources.ItemIndex);
end;

procedure TfrmEditor.tbDownClick(Sender: TObject);
Var
  ItemPos: integer;
begin
  with lvResources do
  begin
    if (ItemIndex + 1 > lvResources.Items.Count-1) or (SelCount = 0) then Exit;
    ItemPos:= ItemIndex;
    ExchangeItems(lvResources, Selected.Index, Selected.Index + 1);
    Items.Item[ItemPos + 1].Selected:= True;
  end;
end;

procedure TfrmEditor.tbEditClick(Sender: TObject);
begin
  EditRes;
end;

procedure TfrmEditor.tbOpenClick(Sender: TObject);
var
  i: integer;
begin

  if FullFileName <> '' then
  begin

      if not Assigned(ResXml) then
      begin
          ResXml:= TXMLResString.Create(FullFileName);
          ResXml.Open(FullFileName);
      end
      else
      begin
         ResXml.Free;
         ResXml:= TXMLResString.Create(FullFileName);
         ResXml.Open(FullFileName);
      end;

      if Pos('strings.xml', FullFileName) > 0 then
      begin
       for i:= 0 to ResXml.Count-1 do
           lvResources.AddItem(ResXml.NameFromIndex[i], nil);
      end;

      //TODO:
      (*
      //https://developer.android.com/training/basics/actionbar/styling.html#AndroidThemes
      if Pos('AndroidManifest.xml', FullFileName) > then
      begin
         <uses-sdk android:minSdkVersion="10" android:targetSdkVersion="17"/>
         <application android:theme="@android:style/Theme.Holo.Light" ... />
      end;

      if Pos('build.xml', FullFileName) > then
      begin
         <property name="sdk.dir" location="C:\adt32\sdk"/>
         <property name="target"  value="android-17"/>
      end;
      *)

  end;

end;

procedure TfrmEditor.tbUpClick(Sender: TObject);
Var
  ItemPos: integer;
begin
  with lvResources do
  begin
    if (ItemIndex -1 < 0) or (SelCount = 0) then Exit;
    ItemPos:= ItemIndex;
    ExchangeItems(lvResources, Selected.Index, Selected.Index - 1);
    Items.Item[ItemPos - 1].Selected:= True;
  end;
end;

//helper... by jmpessoa
//http://delphi.about.com/od/delphitips2008/qt/subdirectories.htm
//fils the "list" TStrings with the subdirectories of the "directory" directory
//Warning: if not  subdirectories was found return empty list [list.count = 0]!
procedure GetSubDirectories(const directory : string; list : TStrings);
var
   sr : TSearchRec;
begin
   try
     if FindFirst(IncludeTrailingPathDelimiter(directory) + '*.*', faDirectory, sr) < 0 then Exit
     else
     repeat
       if ((sr.Attr and faDirectory <> 0) and (sr.Name <> '.') and (sr.Name <> '..')) then
       begin
           List.Add(IncludeTrailingPathDelimiter(directory) + sr.Name);
       end;
     until FindNext(sr) <> 0;
   finally
     SysUtils.FindClose(sr) ;
   end;
end;


end.
