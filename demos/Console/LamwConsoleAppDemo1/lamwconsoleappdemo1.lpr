{hint: save all files to location: C:\adt32\eclipse\workspace\LamwConsoleAppDemo1\ }
program lamwconsoleappdemo1;  //[by Lamw: Lazarus Android Module Wizard: 12/30/2015 23:22:38]
  
{$mode delphi}
  
uses
  Classes, SysUtils, CustApp, unit1;
  
type
  
  TAndroidConsoleApp = class(TCustomApplication)
  public
      procedure CreateForm(InstanceClass: TComponentClass; out Reference);
      constructor Create(TheOwner: TComponent); override;
      destructor Destroy; override;
  end;
  
procedure TAndroidConsoleApp.CreateForm(InstanceClass: TComponentClass; out 
  Reference);
var
  Instance: TComponent;
begin
  Instance := TComponent(InstanceClass.NewInstance);
  TComponent(Reference):= Instance;
  Instance.Create(Self);
end;
  
constructor TAndroidConsoleApp.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  StopOnException:=True;
end;
  
destructor TAndroidConsoleApp.Destroy;
begin
  inherited Destroy;
end;
  
var
  AndroidConsoleApp: TAndroidConsoleApp;


  
begin
  AndroidConsoleApp:= TAndroidConsoleApp.Create(nil);
  AndroidConsoleApp.Title:= 'Android Executable Console App';
  AndroidConsoleApp.Initialize;
  AndroidConsoleApp.CreateForm(TAndroidConsoleDataForm1, AndroidConsoleDataForm1
    );
end.
