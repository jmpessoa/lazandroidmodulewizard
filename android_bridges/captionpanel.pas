unit captionpanel;

{$mode delphi}

interface

uses
  Classes, SysUtils,  AndroidWidget, Laz_And_Controls;

type

  { jCaptionPanel }

  jCaptionPanel = class(jPanel)
  private
     FCaption: jTextView;
     procedure CreateTextView(AOwner: TComponent);
  protected
    procedure Loaded; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
     constructor Create(AOwner: TComponent); override;
  published

  end;

implementation

{ jCaptionPanel }


//ref. https://groups.google.com/forum/#!topic/borland.public.delphi.objectpascal/SDLCJB350b8

constructor jCaptionPanel.Create(AOwner: TComponent);
begin
  inherited;
  FCaption := nil;
  if (csDesigning in ComponentState) then
  begin
     if not (csReading in AOwner.ComponentState) then //this is true when the component is dropped on the form
     begin
        CreateTextView(AOwner);
     end;
  end;
end;

procedure jCaptionPanel.CreateTextView(AOwner: TComponent);
begin
   FCaption:= jTextView.Create(AOwner);
   FCaption.Parent:= Self;
   FCaption.Name:= 'jTextViewCaption'; //giving the field FCaption a "variable" name
end;


procedure jCaptionPanel.Loaded;
var i: Integer;
begin
  inherited;
  for i := 0 to ChildCount - 1 do
  begin
    if Children[i].Name = 'jTextViewCaption' then
    begin
      FCaption:= jTextView(Children[i]); //make FCaption point to the right control
      break;
    end;
  end;

  //if the user removes it at design time.....
  if not assigned(FCaption) then
  begin
     if csDesigning in ComponentState then
     begin
       CreateTextView(Owner); //recreate it
     end;
  end;

end;

procedure jCaptionPanel.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited;
  if not (csDestroying in ComponentState) then
  begin
    if operation = opRemove then
    begin
       if AComponent.Name= 'jTextViewCaption' then //if someone removes the component jTextViewCaption ...
       begin
         FCaption:= nil; //prevent AVs until Loaded recreates it the next time the dfm is being loaded
      end;
    end;
  end;
end;


end.
