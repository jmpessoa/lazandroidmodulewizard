unit createdirectories;

{$mode objfpc}{$H+}

interface

uses
  Classes,
  FileUtil,
  SysUtils;

procedure CreateDirectoriesFull(path: String; FJavaClassName: String = '');
procedure Cleanup_sh_bat(path: String);
procedure Copy_sh_batToUtils(path: String; T: String);

procedure Delete_sh_bat(path: String; T: String);
procedure CreateDirectoriesUtils(path: String);
procedure CreateDirectoriesBuildModes(path: String);
procedure CreateDirectoriesLibs(path: String);
procedure CreateDirectoriesLamwDesigner(path: String);
procedure CreateDirectoriesJni(path: String);
procedure CreateDirectoriesObj(path: String; FJavaClassName: String = '');
procedure CreateDirectoriesDotSettings(path: String);
procedure CreateDirectoriesRes(path: String);
procedure CreateDirectorieGradle(path: String);
procedure CreateDirectorieAssets(path: String);
procedure CreateDirectorieBin(path: String);
procedure CreateDirectorieGen(path: String);

implementation

procedure Cleanup_sh_bat(path: String);
begin
  Delete_sh_bat(path, '*.sh');
  Delete_sh_bat(path, '*.bat');
end;

procedure CreateDirectoriesFull(path: String; FJavaClassName: String = '');
begin
  if path = '' then
  begin
    Exit;
  end;
  CreateDirectoriesUtils(path);
  CreateDirectoriesBuildModes(path);
  CreateDirectoriesLibs(path);
  CreateDirectoriesLamwDesigner(path);
  CreateDirectoriesJni(path);
  CreateDirectoriesObj(path, FJavaClassName);
  CreateDirectoriesDotSettings(path);
  CreateDirectoriesRes(path);
  CreateDirectorieGradle(path);
  CreateDirectorieAssets(path);
  CreateDirectorieBin(path);
  CreateDirectorieGen(path);
  Delete_sh_bat(path, '*.sh');
  Delete_sh_bat(path, '*.bat');
end;

procedure Delete_sh_bat(path: String; T: String);
var
  SR: TSearchRec;
  I: integer;
begin
  I := FindFirst(path + DirectorySeparator + T, faNormal, SR);
  while I = 0 do
  begin
    if (SR.Attr and faDirectory) <> faDirectory then
    begin
      if not DeleteFile(PChar(path + DirectorySeparator + SR.Name)) then
      begin
        Exit;
      end;
    end;
    I := FindNext(SR);
  end;
end;

procedure Copy_sh_batToUtils(path: String; T: String);
var
  SR: TSearchRec;
  I: integer;
  target: string;
begin
  if T = '*.bat' then
     target := 'windows'
  else
     target := 'unix';

  I := FindFirst(path  + T, faNormal, SR);
  while I = 0 do
  begin
    if (SR.Attr and faDirectory) <> faDirectory then
    begin
      CopyFile(PChar(path + SR.Name),
               PChar(path + 'utils'+ DirectorySeparator + target +DirectorySeparator+  SR.Name));
    end;
    I := FindNext(SR);
  end;
end;

procedure CreateDirectoriesUtils(path: String);
begin
  if not DirectoryExists(path + 'utils') then
      CreateDir(path + DirectorySeparator + 'utils');

  if not DirectoryExists(path + 'utils' + DirectorySeparator + 'windows') then
      CreateDir(path + 'utils' + DirectorySeparator + 'windows');

  if not DirectoryExists(path + 'utils' + DirectorySeparator + 'unix') then
     CreateDir(path + 'utils' + DirectorySeparator + 'unix');
end;

procedure CreateDirectoriesBuildModes(path: String);
begin
  CreateDir(path+DirectorySeparator+'jni'+DirectorySeparator+'build-modes');
end;

procedure CreateDirectoriesLibs(path: String);
begin
  CreateDir(path+DirectorySeparator+'libs');
  CreateDir(path+DirectorySeparator+'libs'+DirectorySeparator+'armeabi');
  CreateDir(path+DirectorySeparator+'libs'+DirectorySeparator+'armeabi-v7a');
  CreateDir(path+DirectorySeparator+'libs'+DirectorySeparator+'x86');
  CreateDir(path+DirectorySeparator+'libs'+DirectorySeparator+'mips');
  CreateDir(path+DirectorySeparator+'libs'+DirectorySeparator+'arm64-v8a');
  CreateDir(path+DirectorySeparator+'libs'+DirectorySeparator+'x86_64');
end;

procedure CreateDirectoriesLamwDesigner(path: String);
begin
  //if not DirectoryExists(path+DirectorySeparator+'lamwdesigner') then
    CreateDir(path+DirectorySeparator+'lamwdesigner');
end;

procedure CreateDirectoriesJni(path: String);
begin
  CreateDir(path+DirectorySeparator+ 'jni');
  CreateDir(path+DirectorySeparator+ 'jni'+DirectorySeparator+'build-modes');
end;

procedure CreateDirectoriesObj(path: String; FJavaClassName: String = '');
begin
  CreateDir(path+DirectorySeparator+'obj');
  CreateDir(path+DirectorySeparator+'obj'+DirectorySeparator+'controls');
  CreateDir(path+ DirectorySeparator + 'obj'+DirectorySeparator+LowerCase(FJavaClassName));
end;

procedure CreateDirectoriesDotSettings(path: String);
begin
  CreateDir(path+DirectorySeparator+'.settings');
end;

procedure CreateDirectoriesRes(path: String);
begin
  CreateDir(path + DirectorySeparator +'res');


  CreateDir(path + DirectorySeparator + 'res' + DirectorySeparator + 'values-v11');
  CreateDir(path + DirectorySeparator+ 'res'+DirectorySeparator+'values-v14');
  CreateDir(path+DirectorySeparator+ 'res'+DirectorySeparator+'layout');
  CreateDir(path+DirectorySeparator+ 'res'+DirectorySeparator+'values-v21');
  ForceDirectories(path + DirectorySeparator + 'res' + DirectorySeparator + 'drawable');
  ForceDirectories(path + DirectorySeparator + 'res' + DirectorySeparator + 'xml');
  ForceDirectories(path + DirectorySeparator + 'res' + DirectorySeparator + 'drawable-hdpi');
  CreateDir(path + DirectorySeparator + 'res'
                                + DirectorySeparator +'drawable-ldpi');

  CreateDir(path + DirectorySeparator + 'res'
                                + DirectorySeparator + 'drawable-mdpi');

  CreateDir(path + DirectorySeparator + 'res'
                                + DirectorySeparator + 'drawable-xhdpi');

  CreateDir(path + DirectorySeparator + 'res'
                                + DirectorySeparator + 'drawable-xxhdpi');

  //Android Studio compatibility
  CreateDir(path + DirectorySeparator + 'res' + DirectorySeparator + 'drawable-v24');

  //mipmap support
  CreateDir(path + DirectorySeparator + 'res' + DirectorySeparator + 'mipmap-xxxhdpi');
  CreateDir(path + DirectorySeparator + 'res' + DirectorySeparator + 'mipmap-xxhdpi');
  CreateDir(path + DirectorySeparator + 'res' + DirectorySeparator + 'mipmap-xhdpi');
  CreateDir(path+DirectorySeparator+ 'res'+DirectorySeparator+'mipmap-hdpi');
  CreateDir(path+DirectorySeparator+ 'res'+DirectorySeparator+'mipmap-anydpi-v26');
  CreateDir(path+DirectorySeparator+ 'res'+DirectorySeparator+'values');
end;

procedure CreateDirectorieGradle(path: String);
begin
  CreateDir(path + DirectorySeparator + 'gradle');
  CreateDir(path + DirectorySeparator + 'gradle' + DirectorySeparator + 'wrapper');
end;

procedure CreateDirectorieAssets(path: String);
begin
  CreateDir(path+ DirectorySeparator + 'assets');
end;

procedure CreateDirectorieBin(path: String);
begin
  CreateDir(path+ DirectorySeparator + 'bin');
end;

procedure CreateDirectorieGen(path: String);
begin
  CreateDir(path+ DirectorySeparator + 'gen');
end;

end.

