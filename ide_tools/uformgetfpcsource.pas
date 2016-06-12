unit uFormGetFPCSource;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  StdCtrls, Buttons, ExtCtrls;

type

  { TFormGetFPCSource }

  TFormGetFPCSource = class(TForm)
    Button1: TButton;
    ComboBoxFPCTrunk: TComboBox;
    EditPathToFPCTrunk: TEdit;
    EditPathToSVN: TEdit;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox4: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    SelectDirectoryDialog1: TSelectDirectoryDialog;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton6: TSpeedButton;
    StatusBar1: TStatusBar;
    procedure Button1Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton6Click(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  FormGetFPCSource: TFormGetFPCSource;

implementation

{$R *.lfm}

uses
  IDEExternToolIntf, LazIDEIntf{, IniFiles};

{ TFormGetFPCSource }

procedure TFormGetFPCSource.Button1Click(Sender: TObject);
var
  svnBinPath: string;
  fpcTrunkStorePath: string;
  Tool: TIDEExternalToolOptions;
  Params: TStringList;
  strExt: string;
begin

  {$IFDEF LINUX}
    if MessageDlg('Warning...', 'Lamw can not Build/Install cross compiler [until now] on Linux. Continue?',
                   mtConfirmation, [mbYes, mbNo],0) = mrNO then Exit;
  {$ENDIF}

  svnBinPath:= Trim(EditPathToSVN.Text);         //C:\Program Files (x86)\SlikSvn\bin
  fpcTrunkStorePath:= Trim(EditPathToFPCTrunk.Text);  //C:\adt32\fpctrunksource

  if (svnBinPath = '') or  (fpcTrunkStorePath = '') then
  begin
    ShowMessage('Sorry... Empty Info...');
    Exit;
  end;

  ForceDirectories(fpcTrunkStorePath);

  strExt:= '';

  {$IFDEF WINDOWS}
     strExt:= '.exe';
  {$ENDIF}

  Params:= TStringList.Create;
  Params.Delimiter:= ' ';
  Tool := TIDEExternalToolOptions.Create;
  try

    Tool.Title := 'Running Extern [svn] Tool... ';

    //Tool.WorkingDirectory := fpcTrunkStorePath;

    Tool.Executable := svnBinPath + DirectorySeparator+ 'svn'+ strExt;

    Params.Add('co');                    //checkout the latest trunk sources of FPC
    Params.Add(Trim(ComboBoxFPCTrunk.Text)); //http://svn.freepascal.org/svn/fpc/trunk
    Params.Add(fpcTrunkStorePath);       //https://github.com/graemeg/freepascal.git

    Tool.CmdLineParams := Params.DelimitedText;
    Tool.Scanners.Add(SubToolDefault);

    if not RunExternalTool(Tool) then
      raise Exception.Create('Cannot Run Extern [svn] Tool!');

  finally
    Tool.Free;
    Params.Free;
  end;
  StatusBar1.SimpleText:='Success! [Downloaded FPC Trunk]!';
end;

procedure TFormGetFPCSource.SpeedButton1Click(Sender: TObject);
begin
    if SelectDirectoryDialog1.Execute then
     EditPathToSVN.Text:=SelectDirectoryDialog1.FileName;
end;

procedure TFormGetFPCSource.SpeedButton2Click(Sender: TObject);
begin
    if SelectDirectoryDialog1.Execute then
       EditPathToFPCTrunk.Text:=SelectDirectoryDialog1.FileName;
end;

procedure TFormGetFPCSource.SpeedButton6Click(Sender: TObject);
var
  auxStr: string;
begin
  auxStr:='https://sliksvn.com/pub/Slik-Subversion-1.8.11-win32.msi';
  //InputBox('Get svn client', 'You can get a command line svn client from here:', auxStr);
  ShowMessage('Hint: a command line svn client is here:'+ sLineBreak + auxStr);
end;


end.

