{Hint: save all files to location: C:\adt32\eclipse\workspace\AppNoGUIDemo1\jni }
unit unit1;
  
{$mode delphi}
  
interface
  
uses
  Classes, SysUtils, jni;
  
const
  gjClassPath: string='';
  gjClass: JClass=nil;
  gPDalvikVM: PJavaVM=nil;
  
type
  TNoGUIAndroidModule1 = class(TDataModule)
    private
      {private declarations}
    public
      {public declarations}
  end;
  
var
  NoGUIAndroidModule1: TNoGUIAndroidModule1;

implementation
  
{$R *.lfm}

end.
