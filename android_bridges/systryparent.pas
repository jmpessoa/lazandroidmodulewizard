unit systryparent;

{$mode objfpc}{$H+}

interface

uses
  Classes, AndroidWidget, And_jni, commonparent, supportparent;

procedure sysTryNewParent( var FjPRLayout: jObject; FParent: TAndroidWidget; FjEnv: PJNIEnv; refApp: jApp);

implementation

procedure sysTryNewParent( var FjPRLayout: jObject; FParent: TAndroidWidget; FjEnv: PJNIEnv; refApp: jApp);
begin

   if FParent is jForm then Exit;  //default

   if not tryCommonParent(FjPRLayout, FParent, FjEnv, refApp) then
      trySupportParent(FjPRLayout, FParent, refApp);
end;

end.

