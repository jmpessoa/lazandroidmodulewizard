unit lamwtoolsoptions;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, LazIDEIntf,
  LCLVersion, IDEOptionsIntf{, IDEOptEditorIntf};


implementation

uses

  {$if (lcl_fullversion > 1090000) }
    IDEOptEditorIntf,
  {$endif}
  LamwSettings;

{$R *.lfm}

type

  { TFormLamwToolsOptions }

  TFormLamwToolsOptions = class(TAbstractIDEOptionsEditor)
    Label1: TLabel;
  private

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    class function SupportedOptionsClass: TAbstractIDEOptionsClass; override;
    function GetTitle: string; override;
    procedure Setup({%H-}ADialog: TAbstractOptionsEditorDialog); override;
    procedure ReadSettings({%H-}AOptions: TAbstractIDEOptions); override;
    procedure WriteSettings({%H-}AOptions: TAbstractIDEOptions); override;
  end;

{ TFormLamwToolsOptions }

constructor TFormLamwToolsOptions.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TFormLamwToolsOptions.Destroy;
begin
  inherited Destroy;
end;

class function TFormLamwToolsOptions.SupportedOptionsClass: TAbstractIDEOptionsClass;
begin
   Result := nil;
end;

function TFormLamwToolsOptions.GetTitle: string;
begin
  Result := '[LAMW] Android Module Wizard';
end;

procedure TFormLamwToolsOptions.Setup(ADialog: TAbstractOptionsEditorDialog);
begin
   //localization
end;

procedure TFormLamwToolsOptions.ReadSettings(AOptions: TAbstractIDEOptions);
begin
   //
end;

procedure TFormLamwToolsOptions.WriteSettings(AOptions: TAbstractIDEOptions);
begin
   //
end;


initialization
  RegisterIDEOptionsEditor(GroupEnvironment, TFormLamwToolsOptions, 2000);

end.

