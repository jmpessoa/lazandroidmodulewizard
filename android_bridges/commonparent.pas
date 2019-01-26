unit commonparent;

{$mode objfpc}{$H+}

interface

uses
  Classes, AndroidWidget, And_jni, And_jni_Bridge;

function tryCommonParent( var FjPRLayout: jObject; FParent: TAndroidWidget; FjEnv: PJNIEnv; refApp: jApp): boolean;

implementation

uses
  Laz_And_Controls, customdialog, viewflipper, toolbar, radiogroup, framelayout, linearlayout;

function tryCommonParent( var FjPRLayout: jObject; FParent: TAndroidWidget; FjEnv: PJNIEnv; refApp: jApp): boolean;
begin

 Result:= False;

 if FParent is jForm then Exit;  //default

 if FParent is jPanel then
 begin
   if not jVisualControl(FParent).Initialized then jPanel(FParent).Init(refApp);
   FjPRLayout:= jPanel(FParent).View;
   Result:= True;
 end else
 if FParent is jScrollView then
 begin
   if not jVisualControl(FParent).Initialized then jScrollView(FParent).Init(refApp);
   FjPRLayout:= jScrollView_getView(FjEnv, jScrollView(FParent).jSelf);
   Result:= True;
 end else
 if FParent is jHorizontalScrollView then
 begin
   if not jVisualControl(FParent).Initialized then jHorizontalScrollView(FParent).Init(refApp);
   FjPRLayout:= jHorizontalScrollView_getView(FjEnv, jHorizontalScrollView(FParent).jSelf);
   Result:= True;
 end  else
 if FParent is jCustomDialog then
 begin
   if not jVisualControl(FParent).Initialized then jCustomDialog(FParent).Init(refApp);
   FjPRLayout:= jCustomDialog(FParent).View;
   Result:= True;
 end else
 if FParent is jViewFlipper then
 begin
   if not jVisualControl(FParent).Initialized then jViewFlipper(FParent).Init(refApp);
   FjPRLayout:= jViewFlipper(FParent).View;
   Result:= True;
 end else
 if FParent is jToolbar then
 begin
   if not jVisualControl(FParent).Initialized then jToolbar(FParent).Init(refApp);
   FjPRLayout:= jToolbar(FParent).View;
   Result:= True;
 end  else
 if FParent is jRadioGroup then
 begin
     if not jVisualControl(FParent).Initialized then jRadioGroup(FParent).Init(refApp);
     FjPRLayout:= jRadioGroup(FParent).View;
     Result:= True;
 end else
 if FParent is jFrameLayout then
  begin
    if not jVisualControl(FParent).Initialized then jFrameLayout(FParent).Init(refApp);
    FjPRLayout:= jFrameLayout(FParent).View;
    Result:= True;
  end else
  if FParent is jLinearLayout then
  begin
    if not jVisualControl(FParent).Initialized then jLinearLayout(FParent).Init(refApp);
    FjPRLayout:= jLinearLayout(FParent).View;
    Result:= True;
  end;

end;

end.

