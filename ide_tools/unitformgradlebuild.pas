unit unitFormGradleBuild;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TFormGradleBuild }

  TFormGradleBuild = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    ListBoxBuildTool: TListBox;
    ListBoxMinSdk: TListBox;
    procedure FormActivate(Sender: TObject);
    procedure ListBoxBuildToolClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
      MinSdkVersion: string;
      TargetSdkVersion: string;
      PathToSdk: string;
      PackageName: string;
  end;

var
  FormGradleBuild: TFormGradleBuild;

implementation

{$R *.lfm}

{ TFormGradleBuild }

procedure TFormGradleBuild.FormActivate(Sender: TObject);
var
  lisDir: TStringList;
  i: integer;
  auxStr1, numberAsString: string;
  builderNumber: integer;
begin

  lisDir:= TStringList.Create;
  FindAllDirectories(lisDir, IncludeTrailingPathDelimiter(PathToSdk)+'build-tools', False);
  if lisDir.Count > 0 then
  begin
    for i:= 0 to lisDir.Count-1 do
    begin
       auxStr1:= ExtractFileName(lisDir.Strings[i]);
       if Pos('W', auxStr1) = 0 then   //drop 'android-4.4W'
       begin
         auxStr1 := Copy(auxStr1, LastDelimiter('-', auxStr1) + 1, MaxInt);
         numberAsString:= StringReplace(auxStr1,'.', '', [rfReplaceAll]);
         builderNumber:=  StrToInt(Trim(numberAsString));
         if builderNumber >= 2112 then
         begin
           Self.ListBoxBuildTool.Items.Add(auxStr1);
         end;
       end;
    end;
  end;

  lisDir.Clear;
  FindAllDirectories(lisDir, IncludeTrailingPathDelimiter(PathToSdk)+'platforms', False);
  if lisDir.Count > 0 then
  begin
    for i:= 0 to lisDir.Count-1 do
    begin
      auxStr1:= ExtractFileName(lisDir.Strings[i]);
      auxStr1 := Copy(auxStr1, LastDelimiter('-', auxStr1) + 1, MaxInt);
      builderNumber:=  StrToInt(Trim(auxStr1));
      if builderNumber > 12 then   //LAMW support only  api >= 13 ...
        Self.ListBoxMinSdk.Items.Add(auxStr1);
    end;
  end;
  lisDir.Free;

end;

procedure TFormGradleBuild.ListBoxBuildToolClick(Sender: TObject);
var
  i: integer;
  aux: string;
  numberAsString: string;
  builderNumber: integer;
begin
   i:= Self.ListBoxBuildTool.ItemIndex;
   aux:= Self.ListBoxBuildTool.Items.Strings[i];

   numberAsString:= StringReplace(aux,'.', '', [rfReplaceAll]);
   builderNumber:=  StrToInt(Trim(numberAsString));

   if (builderNumber >= 2112) and (builderNumber < 2302) then
   begin
      ShowMessage('plugin = 2.0.0    gradle = 2.10');
   end;

   if (builderNumber >= 2302) and (builderNumber < 2500) then
   begin
      ShowMessage('plugin = 2.2.0    gradle = 2.14.1');
   end;

   if (builderNumber >= 2500) and (builderNumber < 2602) then   //<<---- default
   begin
      ShowMessage('plugin = 2.3.3    gradle = 3.3');
   end;

   if builderNumber >= 2602 then
   begin
      ShowMessage('plugin = 3.0.0    gradle = 4.1');
   end;

end;

end.

