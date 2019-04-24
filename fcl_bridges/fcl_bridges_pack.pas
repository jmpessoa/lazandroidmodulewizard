{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit fcl_bridges_pack;

{$warn 5023 off : no warning about unused units}
interface

uses
  register_fcl, LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('register_fcl', @register_fcl.Register);
end;

initialization
  RegisterPackage('fcl_bridges_pack', @Register);
end.
