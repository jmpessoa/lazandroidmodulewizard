{hint: Pascal files location: ...\\jni }
unit unit1;

{$mode delphi}

interface

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
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
