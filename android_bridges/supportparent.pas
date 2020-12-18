unit supportparent;

{$mode objfpc}{$H+}

interface

uses
  Classes, AndroidWidget, And_jni;

  function trySupportParent(var FjPRLayout: jObject; FParent: TAndroidWidget; refApp: jApp): boolean;

implementation

uses
  scoordinatorlayout,
  sdrawerlayout, scollapsingtoolbarlayout, scardview, sappbarlayout,
  stoolbar, stablayout, snestedscrollview, sviewpager;


function trySupportParent(var FjPRLayout: jObject; FParent: TAndroidWidget; refApp: jApp): boolean;
begin

  Result:= False;

  if FParent is jForm then Exit;  //default

  if FParent is jsToolbar then
  begin
    jsToolbar(FParent).Init(refApp);
    FjPRLayout:= jsToolbar(FParent).View;
    Result:= True;
  end  else
  if FParent is jsCoordinatorLayout then
  begin
    if not jVisualControl(FParent).Initialized then jsCoordinatorLayout(FParent).Init(refApp);
    FjPRLayout:= jsCoordinatorLayout(FParent).View;
    Result:= True;
  end else
  if FParent is jsDrawerLayout then
  begin
    if not jVisualControl(FParent).Initialized then jsDrawerLayout(FParent).Init(refApp);
    FjPRLayout:= jsDrawerLayout(FParent).View;
    Result:= True;
  end  else
  if FParent is jsCardView then
  begin
      if not jVisualControl(FParent).Initialized then jsCardView(FParent).Init(refApp);
      FjPRLayout:= jsCardView(FParent).View;
      Result:= True;
  end else
  if FParent is jsAppBarLayout then
  begin
      if not jVisualControl(FParent).Initialized then jsAppBarLayout(FParent).Init(refApp);
      FjPRLayout:= jsAppBarLayout(FParent).View;
      Result:= True;
  end else
  if FParent is jsTabLayout then
  begin
      if not jVisualControl(FParent).Initialized then jsTabLayout(FParent).Init(refApp);
      FjPRLayout:= jsTabLayout(FParent).View;
      Result:= True;
  end else
  if FParent is jsCollapsingToolbarLayout then
  begin
      if not jVisualControl(FParent).Initialized then jsCollapsingToolbarLayout(FParent).Init(refApp);
      FjPRLayout:= jsCollapsingToolbarLayout(FParent).View;
      Result:= True;
  end else
  if FParent is jsNestedScrollView then
  begin
      if not jVisualControl(FParent).Initialized then jsNestedScrollView(FParent).Init(refApp);
      FjPRLayout:= jsNestedScrollView(FParent).View;
      Result:= True;
  end else
  if FParent is jsViewPager then
  begin
      if not jVisualControl(FParent).Initialized then jsViewPager(FParent).Init(refApp);
      FjPRLayout:= jsViewPager(FParent).View;
      Result:= True;
  end;

end;

end.

