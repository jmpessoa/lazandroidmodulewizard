{Hint: save all files to location: C:\adt32\eclipse\workspace\AppSqliteDemo1\jni }
unit unit1;
  
{$mode delphi}
  
interface
  
uses
  Classes, SysUtils, And_jni, And_jni_Bridge, Laz_And_Controls;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
      jButton1: jButton;
      jButton2: jButton;
      jButton3: jButton;
      jButton4: jButton;
      jButton5: jButton;
      jButton6: jButton;
      jEditText1: jEditText;
      jSqliteCursor1: jSqliteCursor;
      jSqliteDataAccess1: jSqliteDataAccess;
      jTextView1: jTextView;
      jTextView2: jTextView;
      procedure DataModuleCreate(Sender: TObject);
      procedure DataModuleJNIPrompt(Sender: TObject);
      procedure jButton1Click(Sender: TObject);
      procedure jButton2Click(Sender: TObject);
      procedure jButton3Click(Sender: TObject);
      procedure jButton4Click(Sender: TObject);
      procedure jButton5Click(Sender: TObject);
      procedure jButton6Click(Sender: TObject);
    private
      {private declarations}
       FInsertInto: boolean;
       FTableName: string;
       FDatabaseName: string;
    public
      {public declarations}
  end;
  
var
  AndroidModule1: TAndroidModule1;

implementation
  
{$R *.lfm}

{ TAndroidModule1 }

procedure TAndroidModule1.DataModuleCreate(Sender: TObject);
begin
  Self.OnJNIPrompt:= DataModuleJNIPrompt;
end;

procedure TAndroidModule1.DataModuleJNIPrompt(Sender: TObject);
begin
  FInsertInto:= False;
  FTableName:= 'myTable';
  FDatabaseName:= jSqliteDataAccess1.DataBaseName;
  Self.Show;
end;

procedure TAndroidModule1.jButton1Click(Sender: TObject);
begin
  jSqliteDataAccess1.OpenOrCreate(FDatabaseName);  // myData.db
  ShowMessage('database created!');
end;

procedure TAndroidModule1.jButton2Click(Sender: TObject);
begin
   jSqliteDataAccess1.CreateTable('CREATE TABLE IF  NOT EXISTS '+ FTableName +'(_ID INTEGER PRIMARY KEY, TITLE TEXT, AUTHOR TEXT, COUNT INTEGER);');
   ShowMessage('table created!');
end;

procedure TAndroidModule1.jButton3Click(Sender: TObject);
begin
  if not FInsertInto then
  begin
    jSqliteDataAccess1.InsertIntoTable('INSERT INTO ' + FTableName + '(TITLE, AUTHOR, COUNT) VALUES(''Compilers: Principles, Techniques'',''Aho Sethi Ullman'',3)');
    jSqliteDataAccess1.InsertIntoTable('INSERT INTO ' + FTableName + '(TITLE, AUTHOR, COUNT) VALUES(''Object-Oriented Analysis and Design'',''Grady Booch'',10)' );
    jSqliteDataAccess1.InsertIntoTable('INSERT INTO ' + FTableName + '(TITLE, AUTHOR, COUNT) VALUES(''Delphi Component Design'',''Danny Thorpe'',12)');
    jSqliteDataAccess1.InsertIntoTable('INSERT INTO ' + FTableName + '(TITLE, AUTHOR, COUNT) VALUES(''Lazarus - The Complete Guide'',''Canneyt Gartner Heinig Cavalho Ouedraogo'',12)');
    jSqliteDataAccess1.InsertIntoTable('INSERT INTO ' + FTableName + '(TITLE, AUTHOR, COUNT) VALUES(''The Design of Everyday Things'',''Donald Norman'',6)');
    jSqliteDataAccess1.InsertIntoTable('INSERT INTO ' + FTableName + '(TITLE, AUTHOR, COUNT) VALUES(''How To Solve It'',''George Polya'',9)' );
    jSqliteDataAccess1.InsertIntoTable('INSERT INTO ' + FTableName + '(TITLE, AUTHOR, COUNT) VALUES(''Algorithms + Data Structures = Programs'',''Niklaus Wirth'',8)' );
    FInsertInto:= True;
    ShowMessage('Ok. Table Inserted!');
  end else  ShowMessage('warning: table was inserted!');

end;

procedure TAndroidModule1.jButton4Click(Sender: TObject);
var
  rows: TStringList;
  i: integer;
begin
   rows:= TStringList.Create;
   rows.StrictDelimiter:= True;
   rows.Delimiter:= jSqliteDataAccess1.RowDelimiter;
   rows.DelimitedText:= jSqliteDataAccess1.Select('SELECT * FROM '+  FTableName);

   for i:= 0 to rows.Count-1 do
   begin
     ShowMessage(rows.Strings[i]);
   end;

   rows.Free;
end;

procedure TAndroidModule1.jButton5Click(Sender: TObject);
var
  rowCount: integer;
begin
   rowCount:= jSqliteDataAccess1.Cursor.GetRowCount;
   ShowMessage('rowCount= '+ IntToStr(rowCount));
   jEditText1.Text:= IntToStr(rowCount-1); //max index!
end;

procedure TAndroidModule1.jButton6Click(Sender: TObject);
var
   rowIndex, colCount, colIndex, maxIndex: integer;
begin

   rowIndex:=  StrToInt(jEditText1.Text);
   maxIndex:= jSqliteDataAccess1.Cursor.GetRowCount-1;

   if rowIndex < 0 then rowIndex:= 0;
   if rowIndex > (maxIndex) then rowIndex:= maxIndex;

   jSqliteDataAccess1.Cursor.MoveToPosition(rowIndex);

   colCount:= jSqliteDataAccess1.Cursor.GetColumnCount;

   for colIndex:= 0 to colCount-1 do
   begin
      ShowMessage(jSqliteDataAccess1.Cursor.GetColumName(colIndex)+'='+
                  jSqliteDataAccess1.Cursor.GetValueAsString(colIndex));
   end;

end;

end.
