{Hint: save all files to location: C:\android-neon\eclipse\workspace\AppDBGridViewDemo1\jni }
unit unitMain;

{$mode delphi}

interface

uses
  Classes, AndroidWidget, Laz_And_Controls, actionbartab,
  And_jni, fileprovider;

  
type
  TAndroidModuleMain = class(jForm)
    ActionBarTab: jActionBarTab;
    btnAddTripData: jButton;
    btnNewTrip: jImageBtn;
    fpData: jFileProvider;
    dbgTrips: jDBListView;
    jPanel6: jPanel;
    jTextView1: jTextView;

    jImageList1: jImageList;
    tmUpdateDelay: jTimer;
    pTrips: jPanel;
    sqlCursor: jSqliteCursor;
    sdaFDR: jSqliteDataAccess;

    procedure btnNewTripClick(Sender: TObject);
    procedure tmUpdateDelayTimer(Sender: TObject);
    procedure Mod_MainActivityCreate(Sender: TObject; {%H-}intentData: jObject);
    procedure Mod_MainCreate(Sender: TObject);
    procedure Mod_MainJNIPrompt(Sender: TObject);
    procedure ActionBarTabTabSelected(Sender: TObject; {%H-}view: jObject; title: string);
    procedure btnAddTripDataClick(Sender: TObject);
  private
    {private declarations}
    FDatabaseName: string;
    AutoUpdate: boolean;
    CurrentTable: string;
    CurrentFields: string;
    CurrentFilter: string;
    CurrentOrder: string;
    CurrentView: jDBListView;
    procedure CreateDatabase;
    procedure OpenDatabase;
  public
    {public declarations}
    function QueryDatabase(TableName, Fields, Filter, OrderBy: string): boolean;
    procedure UpdateView;
  end;


var
  AndroidModuleMain: TAndroidModuleMain;

implementation

uses
  SysUtils;
  
{$R *.lfm}

procedure TAndroidModuleMain.CreateDatabase;
begin
  sdaFDR.OpenOrCreate(FDatabaseName);
  sdaFDR.CreateTable(gApp.GetStringResourceByName('create_trips_table'));
  sdaFDR.CreateTable(gApp.GetStringResourceByName('create_sites_table'));
  sdaFDR.CreateTable(gApp.GetStringResourceByName('create_plants_table'));
  sdaFDR.ExecSQL(gApp.GetStringResourceByName('create_plants_view'));
  sdaFDR.ExecSQL(gApp.GetStringResourceByName('create_taxon_index'));
  sdaFDR.ExecSQL(gApp.GetStringResourceByName('create_habitat_index'));
end;

procedure TAndroidModuleMain.OpenDatabase;
begin
  sdaFDR.OpenOrCreate(FDatabaseName);
  sdaFDR.SetForeignKeyConstraintsEnabled(True);
end;

function TAndroidModuleMain.QueryDatabase(TableName, Fields, Filter, OrderBy: string): boolean;
var
  stmt: string;
begin
  stmt := 'SELECT ' + Fields + ' FROM ' + TableName;
  if Filter <> '' then
    stmt := stmt + ' WHERE ' + Filter;
  if OrderBy <> '' then
    stmt := stmt + ' ORDER BY ' + OrderBy;

  //LogDebug('FDR  ', stmt);
  //OpenDatabase;
  with sdaFDR do
  begin
    // Make sure the results go to the correct jDBGridView.

    //Cursor := CurrentView.DataSource;          // There is only one in this App so no need here

    // On sucessful query completion jSQLiteDataAccess grabs
    // an SQLiteCursor from Java and passes it back to a
    // jSQLiteCursor instance which then passes it back to
    // each of it's registered observers causing their views
    // to be updated. No need for huge amounts of data to be
    // imported from java into Native code and then re-exported.

    // The new jDBGridView component uses a subclassed Java CursorAdapter rather than an ArrayAdapter
    // so will automatically renew the grid's view (actually it's a list of lists) when a new
    // SQLiteCursor is passed in. The newView and bindView implementations use the ViewHolder pattern
    // so are relatively fast and efficient.

    Result := Select(stmt, False);
    Close;
  end;

end;

procedure TAndroidModuleMain.UpdateView;
var
  valid: boolean;
begin

  valid := QueryDatabase(CurrentTable, CurrentFields, CurrentFilter, CurrentOrder);
  if valid then
  begin
    //if CurrentView = gvTrips then
    //  FillVisitBox;                 // Special case 1
  end;
end;
{
function TMod_Main.InsertData(TableName, Fields, Values: string): boolean;
var
  stmt: string;
begin
  Result := True;
  try
    try
      stmt := 'INSERT INTO ' + TableName;
      if Fields <> '' then
        stmt := stmt + ' (' + Fields + ')';
      stmt := stmt + ' VALUES (' + Values + ')';
      sdaFDR.InsertIntoTable(stmt);
    except
      Result := False;
    end;
  finally
    sdaFDR.Close;
  end;
  if AutoUpdate and Result then
    UpdateView;
end;
}

procedure TAndroidModuleMain.Mod_MainCreate(Sender: TObject);
begin
  FDatabaseName := sdaFDR.DataBaseName;
  AutoUpdate := False;
end;

procedure TAndroidModuleMain.Mod_MainActivityCreate(Sender: TObject; intentData: jObject);
begin
 // LogDebug('FDR  ', 'Main Activity Created');
end;

procedure TAndroidModuleMain.btnNewTripClick(Sender: TObject);
begin
  //
end;

procedure TAndroidModuleMain.tmUpdateDelayTimer(Sender: TObject);
begin
  tmUpdateDelay.Enabled:=False;
  UpdateView;
end;

procedure TAndroidModuleMain.Mod_MainJNIPrompt(Sender: TObject);
begin
  // Checks for existence of the file only
  // Does NOT confirm it's a valid DB

  if not sdaFDR.DataBaseExists(FDatabaseName) then
  begin
    CreateDatabase;
  end
  else
  begin
    //FillVisitBox;;
  end;

   ActionBarTab.Add('Trips', pTrips.View);
   Self.SetTabNavigationModeActionBar;  //this is needed!!!     Automatically selects tab at index 0

  //UpdateView;
  //ShowMessage('Ready!');
end;

procedure TAndroidModuleMain.ActionBarTabTabSelected(Sender: TObject; view: jObject;
  title: string);
begin
  if title = 'Trips' then
  begin
    CurrentView := dbgTrips;
    CurrentTable := title;
    CurrentFields :=
      '_id, VisitNo, Destination, strftime("%d-%m-%Y", StartDate), strftime("%d-%m-%Y", EndDate), Members';
    CurrentFilter := '';
    CurrentOrder := '1';
  end;
  //if CurrentView.RowCount = 0 then
     //  UpdateView;
  tmUpdateDelay.Enabled := True;
end;

procedure TAndroidModuleMain.btnAddTripDataClick(Sender: TObject);
var
  Data, row, TableValues: string;
  i, p: integer;
  TableName: string = 'Trips';
  stmtArray: TDynArrayOfString;
begin

  with fpData do
    try
      Init(gApp);
      SetAuthorities(gjAppName);
      Data := GetTextContent('trips.dat');
    finally
      jFree;
    end;

  with TStringList.Create do
  begin
    try
      //SkipLastLineBreak := True;
      Text := Data;
      Data := '';
      SetLength(stmtArray, Count);
      for i := 0 to Count - 1 do
      begin
        row := Strings[i];
        TableValues := 'null,';
        p := pos('|', row);
        while p > 0 do
        begin
          TableValues := TableValues + QuotedStr(copy(row, 1, p - 1)) + ',';
          system.Delete(row, 1, p);
          p := pos('|', row);
        end;
        TableValues := TableValues + QuotedStr(row);
        stmtArray[i] := 'INSERT INTO ' + TableName + ' VALUES (' + TableValues + ')';
      end;
    finally
      Free;
    end;
  end;
  sdaFDR.InsertIntoTableBatch(stmtArray);
  SetLength(stmtArray, 0);
end;

end.
