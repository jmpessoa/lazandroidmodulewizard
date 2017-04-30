{Hint: save all files to location: C:\adt32\eclipse\workspace\AppSqliteDemo2\jni }
unit unit1;
  
{$mode delphi}
  
interface
  
uses
  Classes, SysUtils, And_jni, And_jni_Bridge, Laz_And_Controls, 
    Laz_And_Controls_Events, AndroidWidget;
  
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
      jImageView1: jImageView;
      jSqliteCursor1: jSqliteCursor;
      jSqliteDataAccess1: jSqliteDataAccess;
      jTextView1: jTextView;
      jTextView2: jTextView;

      procedure AndroidModule1JNIPrompt(Sender: TObject);
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

procedure TAndroidModule1.jButton1Click(Sender: TObject);
begin
  jSqliteDataAccess1.OpenOrCreate(FDatabaseName);  // databasebook.db
  ShowMessage('database Opened or created!');
end;

procedure TAndroidModule1.AndroidModule1JNIPrompt(Sender: TObject);
begin
  FInsertInto:= False;
  FTableName:= 'tablebook';
  FDatabaseName:= jSqliteDataAccess1.DataBaseName;  //databasebook.db
  jImageView1.SetImageByResIdentifier('ic_t4');  // ...res/drawable
end;

procedure TAndroidModule1.jButton2Click(Sender: TObject);
begin
  jSqliteDataAccess1.CreateTable('CREATE TABLE IF  NOT EXISTS '+ FTableName +'(_ID INTEGER PRIMARY KEY AUTOINCREMENT, TITLE   TEXT,AUTHOR TEXT, COUNT INTEGER, FIGURE BLOB);');
  ShowMessage('table book created!');
end;

procedure TAndroidModule1.jButton3Click(Sender: TObject);
var
  arrayInsertQuery: array of string;
  arrayUpdateImageData: array of string;
begin
  if not FInsertInto then
  begin
     SetLength(arrayInsertQuery, 7);

     //warning: insert field_blob value as null and after update it!

     arrayInsertQuery[0]:='INSERT INTO ' + FTableName + '(TITLE, AUTHOR, COUNT, FIGURE) VALUES(''Compilers: Principles, Techniques'',''Aho Sethi Ullman'',3,null)';
     arrayInsertQuery[1]:='INSERT INTO ' + FTableName + '(TITLE, AUTHOR, COUNT, FIGURE) VALUES(''Object-Oriented Analysis and Design'',''Grady Booch'',10,null)';
     arrayInsertQuery[2]:='INSERT INTO ' + FTableName + '(TITLE, AUTHOR, COUNT, FIGURE) VALUES(''Delphi Component Design'',''Danny Thorpe'',12,null)';
     arrayInsertQuery[3]:='INSERT INTO ' + FTableName + '(TITLE, AUTHOR, COUNT, FIGURE) VALUES(''Lazarus - The Complete Guide'',''Canneyt Gartner Heinig Cavalho Ouedraogo'',12,null)';
     arrayInsertQuery[4]:='INSERT INTO ' + FTableName + '(TITLE, AUTHOR, COUNT, FIGURE) VALUES(''The Design of Everyday Things'',''Donald Norman'',6,null)';
     arrayInsertQuery[5]:='INSERT INTO ' + FTableName + '(TITLE, AUTHOR, COUNT, FIGURE) VALUES(''How To Solve It'',''George Polya'',9,null)';
     arrayInsertQuery[6]:='INSERT INTO ' + FTableName + '(TITLE, AUTHOR, COUNT, FIGURE) VALUES(''Algorithms + Data Structures = Programs'',''Niklaus Wirth'',8,null)';
     jSqliteDataAccess1.InsertIntoTableBatch(arrayInsertQuery);

     SetLength(arrayUpdateImageData, 7);
     //internal sintaxe: "UPDATE " + tableName + " SET "+imageFieldName+" = ? WHERE "+keyFieldName+" = ?", {imageValue, keyValue}"
     //exemplo: "UPDATE " + FTableName + " SET "+FIGURE+" = ? WHERE "+_ID+" = ?", {ic_t1, 1}"
     //exemplo: "UPDATE " + FTableName + " SET "+FIGURE+" = ic_t1 WHERE "+_ID+" = 1"
     arrayUpdateImageData[0]:=FTableName+'|FIGURE|_ID|ic_t1|1';  //ic_t1 -->> ...res/drawable
     arrayUpdateImageData[1]:=FTableName+'|FIGURE|_ID|ic_t2|2';
     arrayUpdateImageData[2]:=FTableName+'|FIGURE|_ID|ic_t3|3';
     arrayUpdateImageData[3]:=FTableName+'|FIGURE|_ID|ic_t4|4';
     arrayUpdateImageData[4]:=FTableName+'|FIGURE|_ID|ic_t5|5';
     arrayUpdateImageData[5]:=FTableName+'|FIGURE|_ID|ic_t6|6';
     arrayUpdateImageData[6]:=FTableName+'|FIGURE|_ID|ic_t7|7';
     jSqliteDataAccess1.UpdateImageBatch(arrayUpdateImageData, '|');

     FInsertInto:= True;

     ShowMessage('Ok. Table Inserted!');

     SetLength(arrayInsertQuery, 0);  //free
     SetLength(arrayUpdateImageData, 0);

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
