unit uformandroidmanifest;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Buttons,
  ComCtrls;

type

  { TFormAndroidManifest }

  TFormAndroidManifest = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    ListBoxNormal: TListBox;
    ListBoxManifestPermission: TListBox;
    ListBoxDangerous: TListBox;
    SpeedButtonAddNormal: TSpeedButton;
    SpeedButtonAddDangerous: TSpeedButton;
    SpeedButtonRemove: TSpeedButton;
    SpeedButtonInfo: TSpeedButton;
    StatusBar1: TStatusBar;
    procedure SpeedButtonAddDangerousClick(Sender: TObject);
    procedure SpeedButtonAddNormalClick(Sender: TObject);
    procedure SpeedButtonRemoveClick(Sender: TObject);
    procedure SpeedButtonInfoClick(Sender: TObject);
  private

  public

  end;

var
  FormAndroidManifest: TFormAndroidManifest;

implementation

{$R *.lfm}

{ TFormAndroidManifest }

procedure TFormAndroidManifest.SpeedButtonAddDangerousClick(Sender: TObject); //add Dangerous permissinos
begin
  if ListBoxDangerous.ItemIndex >= 0 then
    ListBoxManifestPermission.Items.Insert(0,ListBoxDangerous.Items.Strings[ListBoxDangerous.ItemIndex]);
end;

procedure TFormAndroidManifest.SpeedButtonAddNormalClick(Sender: TObject); //add Normal permissinos
begin
   if ListBoxNormal.ItemIndex >= 0 then
    ListBoxManifestPermission.Items.Insert(0,ListBoxNormal.Items.Strings[ListBoxNormal.ItemIndex]);
end;


procedure TFormAndroidManifest.SpeedButtonRemoveClick(Sender: TObject);  //delete
var
  index: integer;
begin
  index:= ListBoxManifestPermission.ItemIndex;
  if index >= 0 then
     ListBoxManifestPermission.Items.Delete(index);
end;

//https://copyprogramming.com/howto/list-of-run-time-permissions-android
//https://docwiki.embarcadero.com/RADStudio/'Alexandria/en/Uses_Permissions
procedure TFormAndroidManifest.SpeedButtonInfoClick(Sender: TObject);
begin
  ShowMessage('You can learn about how to handling'+sLineBreak+
              'dangerous permissions studying the demos:'+sLineBreak+
              '   "AppBluetoothDemo1", "AppCameraDemo",'+sLineBreak+
              '   "AppContactManagerDemo1! and others...');
end;

end.

