unit createfiles;

{$mode objfpc}{$H+}

interface

uses
  {$ifdef unix}BaseUnix,{$endif}
  Classes,
  SysUtils;

// somente exemplo
procedure Create_sh_bat(list: TStringList; path: String; name: String; FileExtension: String; isDeli: Boolean = false);

//Create_sh_bat(auxList, PathToAndroidProject, '', '');


implementation


procedure Create_sh_bat(list: TStringList; path: String; name: String; FileExtension: String; isDeli: Boolean = false);
var
  system: String;
  pathProject: String;
begin
  case FileExtension of
  '.bat':
    system := 'windows';
  '.sh':
    system := 'unix';
  end;

  if isDeli then
  begin
    pathProject := path + 'utils' + DirectorySeparator + system + DirectorySeparator + name + FileExtension;
  end else
  begin
    pathProject := path + DirectorySeparator + 'utils' + DirectorySeparator
                        + system + DirectorySeparator + name + FileExtension;
  end;

  list.SaveToFile(pathProject);
  {$ifdef Unix}
    FpChmod(pathProject, &751);
  {$endif}
end;


end.

