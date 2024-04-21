unit lamwexplorer;

{$mode objfpc}{$H+}

interface

uses
  Classes,
  SysUtils,
  Forms,
  Controls,
  Graphics,
  Dialogs,
  ExtCtrls,
  Menus,

  LazIDEIntf,
  LamwSettings,
  LazFileUtils,
  ProjectIntf,
  ComCtrls,
  ShellCtrls;

type

  { TLExplorer }

  TLExplorer = class(TForm)
    Panel4: TPanel;
    Splitter1: TSplitter;
    PopupMenuList: TPopupMenu;
    MenuOpen: TMenuItem;
    MenuDelete: TMenuItem;
    MenuUpdate: TMenuItem;
    ImageList1: TImageList;
    StatusBar1: TStatusBar;
    TreeShell: TShellTreeView;
    ListShell: TShellListView;
    procedure FormCreate(Sender: TObject);
    procedure ListShellDblClick(Sender: TObject);
    procedure ListShellSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure MenuOpenClick(Sender: TObject);
    procedure MenuDeleteClick(Sender: TObject);
    procedure MenuUpdateClick(Sender: TObject);
  private
    FProjPath: String;
    FSdkPath: String;
    procedure updateTree;
  public

  end;

var
  LExplorer: TLExplorer;

implementation

{$R *.lfm}

{ TLExplorer }

procedure TLExplorer.FormCreate(Sender: TObject);
var
  FProj: TLazProject;
begin
  FProj := LazarusIDE.ActiveProject;

  FProjPath := ExtractFilePath(ChompPathDelim(ExtractFilePath(FProj.MainFile.Filename)));
  FSdkPath := LamwGlobalSettings.PathToAndroidSDK;

  if  Assigned(FProj) and (FProj.CustomData.Values['LAMW'] <> '' ) then
  begin
    TreeShell.Root := FProjPath;
    TreeShell.Select(TreeShell.Items.Item[0]);
  end;
end;

procedure TLExplorer.ListShellDblClick(Sender: TObject);
begin
  MenuOpenClick(nil);
end;

procedure TLExplorer.ListShellSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
  if selected then
  begin
    MenuOpen.Visible := True;
    MenuDelete.Visible := True;
  end else
  begin
    MenuOpen.Visible := False;
    MenuDelete.Visible := False;
  end;
end;

procedure TLExplorer.MenuOpenClick(Sender: TObject);
var
  list: TListItem;
  path: String;
begin
  if ListShell.Selected <> nil then
  begin
    list := ListShell.Selected;
    path := IncludeTrailingPathDelimiter(TreeShell.Selected.GetTextPath) + list.Caption;
    LazarusIDE.DoOpenEditorFile(path, -1, -1,[ofAddToRecent]);
  end;
end;

procedure TLExplorer.MenuDeleteClick(Sender: TObject);
var
  list: TListItem;
  path: String;
begin
  list := ListShell.Selected;
  path := IncludeTrailingPathDelimiter(TreeShell.Selected.GetTextPath) + list.Caption;
  DeleteFile(path);
  updateTree;
end;

procedure TLExplorer.MenuUpdateClick(Sender: TObject);
begin
  updateTree;
end;

procedure TLExplorer.updateTree;
begin
  if TreeShell.Selected.Index = 0 then
  begin
    TreeShell.MoveToNextNode(False);
    TreeShell.MoveToPrevNode(False);
  end else
  begin
    TreeShell.MoveToPrevNode(False);
    TreeShell.MoveToNextNode(False);
  end;
end;

procedure TLExplorer.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  CloseAction := caFree;
  LExplorer := nil;
end;

end.

