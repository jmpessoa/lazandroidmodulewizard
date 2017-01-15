{Hint: save all files to location: C:\adt32\eclipse\workspace\AppSqliteDemo1\jni }
unit unit1;
  
{$mode delphi}
  
interface
  
uses
  Classes, SysUtils, And_jni, And_jni_Bridge, Laz_And_Controls, AndroidWidget;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
      jBitmap1: jBitmap;
      jButton1: jButton;
      jButton2: jButton;
      jButton3: jButton;
      jButton4: jButton;
      jButton5: jButton;
      jButton6: jButton;
      jEditText1: jEditText;
      jImageList1: jImageList;
      jImageView1: jImageView;
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
   FInsertInto:= False;
   FTableName:= 'myTable';
end;

procedure TAndroidModule1.DataModuleJNIPrompt(Sender: TObject);

begin
   (*if you already have a database put it in folder "assets" then:
     Self.CopyFromAssetsToEnvironmentDir('myData.db', Self.GetEnvironmentDirectoryPath(dirDatabase));
     jSqliteDataAccess1.DataBaseName:= 'myData.db';
   *)

   //jSqliteDataAccess1.DataBaseName:= 'myData.db';    //set in design time ...
end;

procedure TAndroidModule1.jButton1Click(Sender: TObject);
begin
  jSqliteDataAccess1.OpenOrCreate(jSqliteDataAccess1.DataBaseName);  // myData.db
  ShowMessage('database opened  or created!');
end;

procedure TAndroidModule1.jButton2Click(Sender: TObject);
begin
  jSqliteDataAccess1.CreateTable('CREATE TABLE IF  NOT EXISTS '+ FTableName +'(_ID INTEGER PRIMARY KEY AUTOINCREMENT, TITLE   TEXT,AUTHOR TEXT, COUNT INTEGER, FIGURE BLOB);');
  ShowMessage('table created!');
end;

(* http://stackoverflow.com/questions/8147440/android-database-transaction
Now there are two main points
If you want to set transaction successful you need to write setTransactionSuccessful() and then endTransaction() after beginTransaction()
If you want to rollback your transaction then you need to endTransaction() without committing the transaction by setTransactionSuccessful().

  jSqliteDataAccess1.BeginTransaction();
  try {
      saveCustomer();
      jSqliteDataAccess1.SetTransactionSuccessful();

  }catch {
      //Error in between database transaction
  }finally {
          jSqliteDataAccess1.EndTransaction();

  }

*)


procedure TAndroidModule1.jButton3Click(Sender: TObject);
begin
  if not FInsertInto then
  begin
     //warning: insert field_blob value as null and after update it!
     jSqliteDataAccess1.InsertIntoTable('INSERT INTO ' + FTableName + '(TITLE, AUTHOR, COUNT, FIGURE) VALUES(''Compilers: Principles, Techniques'',''Aho Sethi Ullman'',3,null)');

     jBitmap1.ImageIndex:= 1;
     //sintaxe: "UPDATE " + tableName + " SET "+imageFieldName+" = ? WHERE "+keyFieldName+" = ?", {imageValue, keyValue}"
     jSqliteDataAccess1.UpdateImage(FTableName, 'FIGURE', '_ID', jBitmap1.GetJavaBitmap{figure}, 1 {_id});

     jSqliteDataAccess1.InsertIntoTable('INSERT INTO ' + FTableName + '(TITLE, AUTHOR, COUNT, FIGURE) VALUES(''Object-Oriented Analysis and Design'',''Grady Booch'',10,null)' );
     jBitmap1.ImageIndex:= 2;
     jSqliteDataAccess1.UpdateImage(FTableName, 'FIGURE', '_ID', jBitmap1.GetJavaBitmap, 2);

     jSqliteDataAccess1.InsertIntoTable('INSERT INTO ' + FTableName + '(TITLE, AUTHOR, COUNT, FIGURE) VALUES(''Delphi Component Design'',''Danny Thorpe'',12,null)');
     jBitmap1.ImageIndex:= 3;
     jSqliteDataAccess1.UpdateImage(FTableName, 'FIGURE', '_ID', jBitmap1.GetJavaBitmap, 3);

     jSqliteDataAccess1.InsertIntoTable('INSERT INTO ' + FTableName + '(TITLE, AUTHOR, COUNT, FIGURE) VALUES(''Lazarus - The Complete Guide'',''Canneyt Gartner Heinig Cavalho Ouedraogo'',12,null)');
     jBitmap1.ImageIndex:= 4;
     jSqliteDataAccess1.UpdateImage(FTableName, 'FIGURE', '_ID', jBitmap1.GetJavaBitmap, 4);

     jSqliteDataAccess1.InsertIntoTable('INSERT INTO ' + FTableName + '(TITLE, AUTHOR, COUNT, FIGURE) VALUES(''The Design of Everyday Things'',''Donald Norman'',6,null)');
     jBitmap1.ImageIndex:= 5;
     jSqliteDataAccess1.UpdateImage(FTableName, 'FIGURE', '_ID', jBitmap1.GetJavaBitmap, 5);

     jSqliteDataAccess1.InsertIntoTable('INSERT INTO ' + FTableName + '(TITLE, AUTHOR, COUNT, FIGURE) VALUES(''How To Solve It'',''George Polya'',9,null)' );
     jBitmap1.ImageIndex:= 6;
     jSqliteDataAccess1.UpdateImage(FTableName, 'FIGURE', '_ID', jBitmap1.GetJavaBitmap, 6);

     jSqliteDataAccess1.InsertIntoTable('INSERT INTO ' + FTableName + '(TITLE, AUTHOR, COUNT, FIGURE) VALUES(''Algorithms + Data Structures = Programs'',''Niklaus Wirth'',8,null)' );
     jBitmap1.ImageIndex:= 7;
     jSqliteDataAccess1.UpdateImage(FTableName, 'FIGURE', '_ID', jBitmap1.GetJavaBitmap, 7);

     FInsertInto:= True;
     ShowMessage('Ok. Table Inserted!');

  end else  ShowMessage('warning: table already was inserted!');
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
   colType: integer;
   intColValue: integer;
   floatColValue: double;
begin
   rowIndex:=  StrToInt(jEditText1.Text);
   maxIndex:= jSqliteDataAccess1.Cursor.GetRowCount-1;
   if rowIndex < 0 then rowIndex:= 0;
   if rowIndex > (maxIndex) then rowIndex:= maxIndex;
   jSqliteDataAccess1.Cursor.MoveToPosition(rowIndex);
   colCount:= jSqliteDataAccess1.Cursor.GetColumnCount;
   for colIndex:= 0 to colCount-1 do
   begin
     case jSqliteDataAccess1.Cursor.GetColType(colIndex) of
       ftInteger:begin
                    intColValue:= jSqliteDataAccess1.Cursor.GetValueAsInteger(colIndex);
                    ShowMessage(jSqliteDataAccess1.Cursor.GetColumName(colIndex)+'='+ IntToStr(intColValue));
                 end;
       ftFloat:begin
                   floatColValue:= jSqliteDataAccess1.Cursor.GetValueAsDouble(colIndex);
                   ShowMessage(jSqliteDataAccess1.Cursor.GetColumName(colIndex)+ '='+ FloatToStrF(floatColValue, ffFixed, 0,2));
                end;
       ftString: ShowMessage(jSqliteDataAccess1.Cursor.GetColumName(colIndex)+'='+ jSqliteDataAccess1.Cursor.GetValueAsString(colIndex));
       ftBlob:   jImageView1.SetImageBitmap(jSqliteDataAccess1.Cursor.GetValueAsBitmap(colIndex));
       ftNull: ShowMessage('warning: NULL found');
     end;
   end;
end;

end.
