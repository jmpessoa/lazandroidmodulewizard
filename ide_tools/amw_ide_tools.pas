{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit amw_ide_tools;

{$warn 5023 off : no warning about unused units}
interface

uses
  amw_ide_menu_items, AndroidProjOptions, ApkBuild, uFormBuildFPCCross, 
  uFormGetFPCSource, uformsettingspaths, uFormStartEmulator, ufrmCompCreate, 
  ufrmEditor, uimportcstuff, uimportjavastuff, uimportjavastuffchecked, 
  uregistercompform, uformimportlamwstuff, LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('amw_ide_menu_items', @amw_ide_menu_items.Register);
end;

initialization
  RegisterPackage('amw_ide_tools', @Register);
end.
