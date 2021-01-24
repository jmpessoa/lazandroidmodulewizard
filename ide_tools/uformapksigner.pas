unit uFormApksigner;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ComCtrls, StdCtrls,
  Buttons;

type

  { TFormApksigner }

  TFormApksigner = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    EditKeyStorePassword: TEdit;
    EditKeyAliasPassword: TEdit;
    EditFirstName: TEdit;
    EditLastName: TEdit;
    EditOrgUnit: TEdit;
    EditOrgName: TEdit;
    EditCity: TEdit;
    EditProvince: TEdit;
    EditCodeCountry: TEdit;
    Label1: TLabel;
    Label10: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    StatusBar1: TStatusBar;

  private

  public

  end;

var
  FormApksigner: TFormApksigner;

implementation

{$R *.lfm}

{ TFormApksigner }


end.

