{Hint: save all files to location: C:\android-neon\eclipse\workspace\AppSqliteDemo3\jni }
unit unit1;

{$mode delphi}

interface

uses
  Classes, SysUtils, AndroidWidget, Laz_And_Controls;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jButton1: jButton;
    jSqliteCursor1: jSqliteCursor;
    jSqliteDataAccess1: jSqliteDataAccess;
    jTextView1: jTextView;
    procedure AndroidModule1Create(Sender: TObject);
    procedure jButton1Click(Sender: TObject);
  private
    {private declarations}
  public
    {public declarations}
    FTableName: string;
  end;

var
  AndroidModule1: TAndroidModule1;

implementation
  
{$R *.lfm}
  

{ TAndroidModule1 }

//NOTE: pre-build database "myData.db" was copied to "....assets/databases"

(*
AppSQliteDemo3  <<--- demo for "assets" support... [thanks to Renabor!]
		NOTE: how to store your pre-build database:
			..../assets   <<--- put your database file here [default]
				/databases  <<--- OR put your file here [default, too!]
				/myCustomFolderName  <<-- ????? OR put your file here [not default!]

				if you prefere "myCustomName" as folder name then call:
					jSqliteDataAccess1.SetAssetsSearchFolder("myCustomFolderName");
					in "OnJNIPrompt" event.
*)

procedure TAndroidModule1.jButton1Click(Sender: TObject);
var
  rows: TStringList;
  i: integer;
begin
  if FTableName <> '' then
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
end;

procedure TAndroidModule1.AndroidModule1Create(Sender: TObject);
begin
    FTableName:= 'myTable';
end;

end.
