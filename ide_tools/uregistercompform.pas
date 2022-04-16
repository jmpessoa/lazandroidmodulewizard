unit uregistercompform;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Buttons, ExtCtrls, ComCtrls;

type

  { TFormRegisterComp }

  TFormRegisterComp = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    EditIconPath: TEdit;
    EditRegisterPath: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    OpenDialog1: TOpenDialog;
    RadioGroup1: TRadioGroup;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    StatusBar1: TStatusBar;
    procedure RadioGroup1SelectionChanged(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
    PathToLAMW: string;
  end;

var
  FormRegisterComp: TFormRegisterComp;

implementation

{$R *.lfm}

{ TFormRegisterComp }

procedure TFormRegisterComp.SpeedButton1Click(Sender: TObject);
begin
  if OpenDialog1.Execute then
  begin
    EditIconPath.Text:= OpenDialog1.FileName;
  end;
end;

procedure TFormRegisterComp.SpeedButton2Click(Sender: TObject);
begin
ShowMessage('About Android Bridges components palettes' + sLineBreak +
            'and Android system builder (Ant/Gradle):' + sLineBreak + sLineBreak +
            '"Android Bridges" support "Ant" and "Gradle"' + sLineBreak +
            '"Android Bridges Extra" support "Ant" and "Gradle"'+ sLineBreak + sLineBreak+
            '"Android Bridges jCenter" support only "Gradle"' + sLineBreak +
            '(here we put bridges for generics "online" libraries)' + sLineBreak + sLineBreak +
            '"Android Bridges AppCompat" support only "Gradle"' + sLineBreak +
            '(here we put bridges for Android AppCompat/Material libraries)');
end;

procedure TFormRegisterComp.RadioGroup1SelectionChanged(Sender: TObject);
var
  index: integer;
begin
  EditRegisterPath.ReadOnly:= False;
  index:= RadioGroup1.ItemIndex;
  case index of
     0: Self.EditRegisterPath.Text:= PathToLAMW +  'regandroidbridge.pas';
     1: Self.EditRegisterPath.Text:= PathToLAMW +  'register_extras.pas';
     2: Self.EditRegisterPath.Text:= PathToLAMW +  'register_support.pas';
     3: Self.EditRegisterPath.Text:= PathToLAMW +  'register_jcenter.pas';
     4: Self.EditRegisterPath.Text:= PathToLAMW +  'register_custom.pas';
     5: Self.EditRegisterPath.Text:= PathToLAMW +  'register_template.pas';
  end;
   EditRegisterPath.ReadOnly:= True;
end;

procedure TFormRegisterComp.SpeedButton3Click(Sender: TObject);
begin
   EditIconPath.Text:= '';
end;

procedure TFormRegisterComp.SpeedButton4Click(Sender: TObject);
begin
  EditRegisterPath.Text:='';
end;

end.

