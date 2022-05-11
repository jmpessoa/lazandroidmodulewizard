unit systryparent;

{$mode objfpc}{$H+}

interface

uses
  Classes, AndroidWidget, And_jni, commonparent, supportparent;

procedure sysTryNewParent( var FjPRLayout: jObject; FParent: TAndroidWidget );

implementation

procedure sysTryNewParent( var FjPRLayout: jObject; FParent: TAndroidWidget );
begin

   if FParent is jForm then Exit;  //default

   if not tryCommonParent(FjPRLayout, FParent) then
      trySupportParent(FjPRLayout, FParent);
end;

end.

