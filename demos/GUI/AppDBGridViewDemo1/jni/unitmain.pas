{Hint: save all files to location: C:\android-neon\eclipse\workspace\AppDBGridViewDemo1\jni }
unit unitMain;

{$mode delphi}

interface

uses
  Classes, AndroidWidget, Laz_And_Controls, actionbartab,
  fileprovider;

  
type

  { TAndroidModuleMain }

  TAndroidModuleMain = class(jForm)
    ActionBarTab: jActionBarTab;
    btnAddTripData: jButton;
    btnNewTrip: jImageBtn;
    dbgTrips: jDBListView;
    jFileProvider1: jFileProvider;
    jPanel6: jPanel;
    jTextView1: jTextView;

    jImageList1: jImageList;
    pTrips: jPanel;
    sqlCursor: jSqliteCursor;
    sdaFDR: jSqliteDataAccess;

    procedure AndroidModuleMainRequestPermissionResult(Sender: TObject;
      requestCode: integer; manifestPermission: string;
      grantResult: TManifestPermissionResult);
    procedure btnNewTripClick(Sender: TObject);

    procedure Mod_MainJNIPrompt(Sender: TObject);
    procedure btnAddTripDataClick(Sender: TObject);
    procedure CopyDataFromAssetsToDatabase();
  private
    {private declarations}

    function  CreateOrOpenDatabase(dataBaseName: string): boolean;
  public
    {public declarations}
    function QueryDatabase(TableName, Fields, Filter, OrderBy: string): boolean;
    procedure TryUpdateView;
  end;


var
  AndroidModuleMain: TAndroidModuleMain;

implementation

uses
  SysUtils;
  
{$R *.lfm}

function TAndroidModuleMain.CreateOrOpenDatabase(dataBaseName: string): boolean;
begin

  //intern dabase dont need read/write permission....
  sdaFDR.OpenOrCreate(dataBaseName);

  //CREATE TABLE IF NOT EXISTS
  sdaFDR.CreateTable(gApp.GetStringResourceByName('create_trips_table')); //from AppDBGridViewDemo1\res\values

  Result:= True;
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

  with sdaFDR do
  begin
    // Make sure the results go to the correct jDBListView.

    //Cursor := CurrentView.DataSource; // There is only one in this App so no need here

    // On sucessful query completion jSQLiteDataAccess grabs
    // an SQLiteCursor from Java and passes it back to a
    // jSQLiteCursor instance which then passes it back to
    // each of it's registered observers causing their views
    // to be updated. No need for huge amounts of data to be
    // imported from java into Native code and then re-exported.

    // The jDBListView component uses a subclassed Java CursorAdapter rather than an ArrayAdapter
    // so will automatically renew the grid's view (actually it's a list of lists) when a new
    // SQLiteCursor is passed in. The newView and bindView implementations use the ViewHolder pattern
    // so are relatively fast and efficient.

    Result := Select(stmt, False);  //auto update grid view  !!!!

    Close;
  end;

end;

procedure TAndroidModuleMain.TryUpdateView;
var
  CurrentFields: string;
  CurrentFilter: string;
  CurrentOrder: string;
  Currenttable: string;
begin
  Currenttable:= 'Trips';

  CurrentFields :=
      '_id, VisitNo, Destination, strftime("%d-%m-%Y", StartDate), strftime("%d-%m-%Y", EndDate), Members';
  CurrentFilter := '';
  CurrentOrder := '1';

  QueryDatabase(Currenttable, CurrentFields, CurrentFilter, CurrentOrder);
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

  TryUpdateView;
end;
}


procedure TAndroidModuleMain.btnNewTripClick(Sender: TObject);
begin
  //InsertData
  ShowMessage('Sorry ... Not implemented yet...')
end;

procedure TAndroidModuleMain.AndroidModuleMainRequestPermissionResult(
  Sender: TObject; requestCode: integer; manifestPermission: string;
  grantResult: TManifestPermissionResult);
begin
  (*
  case requestCode of
     1811:begin
              if grantResult = PERMISSION_GRANTED  then
                ShowMessage('Success! ['+manifestPermission+'] Permission grant!!! ' )
              else  //PERMISSION_DENIED
                ShowMessage('Sorry... ['+manifestPermission+'] Permission not grant... ' );
          end;
  end;
  *)
end;

procedure TAndroidModuleMain.Mod_MainJNIPrompt(Sender: TObject);
begin

  ActionBarTab.Add('Trips', pTrips.View);
  CreateOrOpenDatabase(sdaFDR.DataBaseName);   //sdaFDR.DataBaseName:= mydata1.db  ...set in design time....
  TryUpdateView;  //in the first app launch table is empty....


  (*  for "assets"  and "internal"  app files we dont need run time permission,,,,
  if IsRuntimePermissionNeed() then   // that is, target API >= 23  - Android 6
  begin
     //hint: if you  get "write" permission then you have "read", too!
     Self.RequestRuntimePermission('android.permission.WRITE_EXTERNAL_STORAGE', 1811);
  end
  *)


end;

procedure TAndroidModuleMain.CopyDataFromAssetsToDatabase();
var
  row, TableValues, dataText: string;
  i, p: integer;
  TableName: string;
  stmtArray: TDynArrayOfString;
begin

  jFileProvider1.SetAuthorities(Self.PackageName);

  //load from assets don't need runtime permission...
  jFileProvider1.FileSource:= srcAssets;
  dataText:= jFileProvider1.GetTextContent('trips.dat');

  TableName:= 'Trips';

  with TStringList.Create do
  begin
    try

      Text:= dataText;

      SetLength(stmtArray, Count);

      if Count > 0 then
      begin
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

        sdaFDR.InsertIntoTableBatch(stmtArray);

        TryUpdateView; //Refresh grid view....

      end
      else ShowMessage('Sorry .. Data content empty...');

    finally
      SetLength(stmtArray, 0);
      Free;
    end;

  end;

end;

procedure TAndroidModuleMain.btnAddTripDataClick(Sender: TObject);
begin
   ShowMessage('Add  Data....');
   CopyDataFromAssetsToDatabase();
end;

end.
