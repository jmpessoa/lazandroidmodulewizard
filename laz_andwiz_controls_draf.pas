unit Laz_AndWiz_Controls;

{$mode delphi}

interface

uses
  Classes, SysUtils;

type



implementation

//-------------------------------------------------
   {jControl by jmpessoa}
//--------------------------------------------------
constructor jControl.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FInitialized:= False;
  FEnabled:= False;
  FjObject:= nil;
end;

//
Destructor jControl.Destroy;
begin
  inherited Destroy;
end;

procedure jControl.Init;
begin
  //
end;

procedure jControl.SetEnabled(Value: boolean);
begin
  FEnabled:= Value;
end;

   {jVisualControl}

constructor jVisualControl.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FjPRLayout := nil;  //java parent
  FjObject   := nil; //java object
  FEnabled   := True;
  FVisible   := True;
  FColor     := colbrDefault;
  FFontColor := colbrDefault;
  FFontSize  := 0; //default size!
  FId        := 0; //0: no control anchor on this control! //must be published for data persistence!
  FAnchorId  := -1;  //dummy
  FAnchor    := nil;
  FLParamWidth := lpMatchParent;
  FLParamHeight:= lpWrapContent;
  //FGravity:=[];      TODO!
  FPositionRelativeToAnchor:= [];
  FPositionRelativeToParent:= [];
  FParentPanel:= nil;
end;

//
Destructor jVisualControl.Destroy;
begin
  inherited Destroy;
end;

procedure jVisualControl.SetId(Value: DWord);
begin
  FId:= Value;
end;

procedure jVisualControl.Init;
begin
  inherited Init;
  FjPRLayout:= jForm(Owner).View;  //set parent!
  FOrientation:= jForm(Owner).Orientation;
end;

procedure jVisualControl.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if Operation = opRemove then
  begin
    {checks whether the AComponent parameter is a jVisualControl or any type descending from jVisualControl}
    if (AComponent is jVisualControl) then
    begin

      if AComponent = FParentPanel then
      begin
        FParentPanel:= nil;
        FjPRLayout:= jForm(Owner).View;  //default...
        Exit;
      end;

      if AComponent = FAnchor then
      begin
         FAnchor:= nil;
         FAnchorId:= -1;  //dummy
      end;
    end
  end;
end;

procedure jVisualControl.SetAnchor(Value: jVisualControl);
begin
  if Value <> FAnchor then
  begin
    if Assigned(FAnchor) then
    begin
      FAnchor.RemoveFreeNotification(Self); //remove free notification...
    end;
    FAnchor:= Value;
    if Value <> nil then  //re- add free notification...
    begin
       Value.FreeNotification(Self);
       if not (csDesigning in ComponentState) then Exit;
       if (csLoading in ComponentState) then Exit;
       if  Value.Id = 0 then   //Id must be published for data persistence!
       begin
         Randomize;
         Value.Id:= Random(10000000);  //warning: remember the law of Murphi...
       end;
    end;
  end;
end;


procedure jVisualControl.SetParentPanel(Value: jPanel);
begin
  if Value <> FParentPanel then
  begin
    if Assigned(FParentPanel) then
    begin
       FParentPanel.RemoveFreeNotification(Self); //remove free notification...
    end;
    FParentPanel:= Value;
    if Value <> nil then  //re- add free notification...
    begin
       FjPRLayout:= Value.View;
       Value.FreeNotification(self);
    end;
  end;
end;

procedure jVisualControl.SetParentComponent(Value: TComponent);
begin
   inherited SetParentComponent(Value);
   if Value is jPanel then Self.SetParentPanel(jPanel(Value));
end;

procedure jVisualControl.SetjParent(Value: jObject);
begin
   FjPRLayout:= Value;
end;

procedure jVisualControl.UpdateLayout;
begin
  //dummy...
end;
procedure jVisualControl.SetParamWidth(Value: TLayoutParams);
begin
  FLParamWidth:=Value;
end;

procedure jVisualControl.SetParamHeight(Value: TLayoutParams);
begin
   FLParamHeight:=Value;
end;

{jPanel}

constructor jPanel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FLParamWidth:= lpMatchParent;
  FLParamHeight:= lpMatchParent;
  //Self.Width:= TPlainWidget(AOwner).Width;
  FAcceptChildsAtDesignTime:= True;
end;

destructor jPanel.Destroy;
begin
  if not (csDesigning in ComponentState) then
  begin
    if jForm(Owner).App <> nil then
    begin
      if jForm(Owner).App.Initialized then
      begin
        if FjObject <> nil then
        begin
          jPanel_Free2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject);
          FjObject:= nil;
        end;
      end;
    end;
  end;
  inherited Destroy;
end;

procedure jPanel.Init;
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  if FInitialized  then Exit;
  inherited Init;

  FjObject:= jPanel_Create2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, Self);

  FjRLayout{View}:= jPanel_getView(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject); // Java : Self Layout

  if FParentPanel <> nil then
  begin
   FParentPanel.Init;
   FjPRLayout:= FParentPanel.View;
  end;

  jPanel_setParent(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, FjPRLayout);
  jPanel_setId(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, Self.Id);

  jPanel_setLeftTopRightBottomWidthHeight(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject,
                                           FMarginLeft,FMarginTop,FMarginRight,FMarginBottom,
                                           GetLayoutParams(gApp, FLParamWidth, sdW),
                                           GetLayoutParams(gApp, FLParamHeight, sdH));
  for rToA := raAbove to raAlignRight do
  begin
    if rToA in FPositionRelativeToAnchor then
    begin
      jPanel_addlParamsAnchorRule(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetPositionRelativeToAnchor(rToA));
    end;
  end;
  for rToP := rpBottom to rpCenterVertical do
  begin
     if rToP in FPositionRelativeToParent then
     begin
       jPanel_addlParamsParentRule(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetPositionRelativeToParent(rToP));
     end;
  end;

  if Self.Anchor <> nil then Self.AnchorId:= Self.Anchor.Id
  else Self.AnchorId:= -1;

  jPanel_setLayoutAll(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, Self.AnchorId);

  if FColor <> colbrDefault then
     jView_SetBackGroundColor(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjRLayout{!}, GetARGB(FColor));

  jView_SetVisible(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, FVisible);

  FInitialized:= True;
end;

procedure jPanel.SetjParent(Value: jObject);
begin
  inherited SetjParent(Value);
  if FInitialized then
    jPanel_setParent2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, FjPRLayout);
end;

Procedure jPanel.SetVisible  (Value : Boolean);
begin
  inherited SetVisible(Value);
  if FInitialized then
    jView_SetVisible(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, FVisible);
end;

Procedure jPanel.SetColor(Value: TARGBColorBridge);
begin
  FColor:= Value;
  if (FInitialized = True) and (FColor <> colbrDefault) then
     jView_SetBackGroundColor(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjRLayout{!}, GetARGB(FColor));
end;

Procedure jPanel.Refresh;
begin
  if FInitialized then
     jView_Invalidate(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject);
end;

procedure jPanel.SetParamWidth(Value: TLayoutParams);
var
  side: TSide;
begin
  inherited SetParamWidth(Value);
  if FInitialized then
  begin
     if jForm(Owner).Orientation = gApp.Orientation then side:= sdW
     else side:= sdH;
     jPanel_setLParamWidth2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetLayoutParams(gApp, FLParamWidth, side));
  end;
end;

procedure jPanel.SetParamHeight(Value: TLayoutParams);
var
  side: TSide;
begin
  inherited SetParamHeight(Value);
  if FInitialized then
  begin
    if jForm(Owner).Orientation = gApp.Orientation then side:= sdH
    else side:= sdW;
    jPanel_setLParamHeight2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetLayoutParams(gApp, FLParamHeight, side));
  end;
end;

function jPanel.GetWidth: integer;
begin
   Result:= FWidth;
   if FInitialized then
      Result:= jPanel_getLParamWidth2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject)
end;

function jPanel.GetHeight: integer;
begin
   Result:= FHeight;
   if FInitialized then
      Result:= jPanel_getLParamHeight2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject);
end;

procedure jPanel.ResetRules;
var
   rToP: TPositionRelativeToParent;
   rToA: TPositionRelativeToAnchorID;
begin
   jPanel_resetLParamsRules2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject);
   for rToP := rpBottom to rpCenterVertical do
   begin
      if rToP in FPositionRelativeToParent then
        jPanel_addlParamsParentRule2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetPositionRelativeToParent(rToP));
   end;
   for rToA := raAbove to raAlignRight do
   begin
     if rToA in FPositionRelativeToAnchor then
       jPanel_addlParamsAnchorRule2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetPositionRelativeToAnchor(rToA));
   end;
end;

procedure jPanel.UpdateLayout;
begin
  inherited UpdateLayout;
  ResetRules;    //TODO optimize here: if "only rules_changed" then --> ResetRules
  SetParamWidth(FLParamWidth);
  setParamHeight(FLParamHeight);
  jPanel_setLayoutAll2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, Self.AnchorId);
end;

end.

