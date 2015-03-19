{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit LazAndroidWizardPack;

interface

uses
  AndroidWizard_intf, uformworkspace, uFormAndroidProject, uRegisterForm, 
  FormPathMissing, uFormOSystem, uJavaParser, LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('AndroidWizard_intf', @AndroidWizard_intf.Register);
end;

initialization
  RegisterPackage('LazAndroidWizardPack', @Register);
end.
