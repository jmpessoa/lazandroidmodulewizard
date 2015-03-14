{Hint: save all files to location: C:\adt32\eclipse\workspace\AppAddSingleLibraryDemo1\jni }
unit unithelloadder;
  
{$mode delphi}
  
interface
  
uses
  Classes, SysUtils, jni;
  
const
  gNoGUIjClassPath: string='';
  gNoGUIjClass: JClass=nil;
  gNoGUIPDalvikVM: PJavaVM=nil;
  
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
