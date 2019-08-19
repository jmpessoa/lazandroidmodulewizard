{Hint: save all files to location: C:\android\workspace\AppMSSQLJDBCConnectionDemo1\jni }
unit unit1;

{$mode delphi}

interface

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, AndroidWidget, Laz_And_Controls, mssqljdbcconnection;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jButton1: jButton;
    jMsSqlJDBCConnection1: jMsSqlJDBCConnection;
    jTextView1: jTextView;
    procedure jButton1Click(Sender: TObject);
  private
    {private declarations}
  public
    {public declarations}
  end;

var
  AndroidModule1: TAndroidModule1;

implementation
  
{$R *.lfm}
  

{ TAndroidModule1 }

procedure TAndroidModule1.jButton1Click(Sender: TObject);
var
  selecteds: string;
begin

   ShowMessage('Warning: fix information and uncomment the code!!');

(*
   //warning: just dummy information....

   jMsSqlJDBCConnection1.Language:= ;

   jMsSqlJDBCConnection1.ServerIP:= '0.0.0.0';
   jMsSqlJDBCConnection1.DatabaseName:= 'myDataStore.db';
   jMsSqlJDBCConnection1.UserName:= 'admin';
   jMsSqlJDBCConnection1.Password:= '123456';

   if jMsSqlJDBCConnection1.Open() then
   begin

       selecteds:= jMsSqlJDBCConnection1.ExecuteQuery('select * from myTable');
       ShowMessage(selecteds);

       if jMsSqlJDBCConnection1.ExecuteUpdate('insert into myTable ......') then
          ShowMessage('Insert Success!!')
       else
          ShowMessage('Insert Error.....!!');


       jMsSqlJDBCConnection1.Close();
   end
   else  ShowMessage('Sorry... fail to connect...');

*)

end;

end.
