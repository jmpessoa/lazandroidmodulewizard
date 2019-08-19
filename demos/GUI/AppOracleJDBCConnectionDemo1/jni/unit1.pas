{Hint: save all files to location: C:\android\workspace\AppOracleJDBCConnectionDemo1\jni }
unit unit1;

{$mode delphi}

interface

uses
  Classes, SysUtils, AndroidWidget, Laz_And_Controls, oraclejdbcconnection;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jButton1: jButton;
    jOracleJDBCConnection1: jOracleJDBCConnection;
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

   ShowMessage('warning: fix information and uncomment the code!!');

   jOracleJDBCConnection1.Driver:= 'oracle.jdbc.driver.OracleDriver'; //OK !!!
   jOracleJDBCConnection1.Language:= slEnglish; //OK!!!

   //warning: just dummy information....
   (*
   jOracleJDBCConnection1.Url:= 'jdbc:oracle:thin:@192.168.43.47:1521:XE'; //change here!
   jOracleJDBCConnection1.UserName:= 'root';    //change here!
   jOracleJDBCConnection1.Password:= '123456';  // change here!

   if jOracleJDBCConnection1.Open() then
   begin

       selecteds:= jOracleJDBCConnection1.ExecuteQuery('select * from student');
       ShowMessage(selecteds);

       if jOracleJDBCConnection1.ExecuteUpdate('insert into student ......') then
          ShowMessage('Insert Success!!')
       else
          ShowMessage('Insert Error.....!!');


       jOracleJDBCConnection1.Close();

   end;
   *)

end;

end.
