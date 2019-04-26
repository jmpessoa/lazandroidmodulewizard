{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit tfpandroidbridge_pack;

{$warn 5023 off : no warning about unused units}
interface

uses
  regandroidbridge, And_jni, And_jni_Bridge, Laz_And_Controls, And_log, 
  And_log_h, register_extras, Laz_And_Controls_Events, AndroidWidget, 
  Laz_And_jni_Controls, register_support, commonparent, supportparent, 
  systryparent, register_jcenter, LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('regandroidbridge', @regandroidbridge.Register);
  RegisterUnit('register_extras', @register_extras.Register);
  RegisterUnit('register_support', @register_support.Register);
  RegisterUnit('register_jcenter', @register_jcenter.Register);
end;

initialization
  RegisterPackage('tfpandroidbridge_pack', @Register);
end.
