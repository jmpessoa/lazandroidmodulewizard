unit uFormBuildFPCCross;

{$mode delphi}

interface

uses
  Classes, SysUtils, FileUtil, LazFileUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  ComCtrls, StdCtrls, Buttons;

{ TFormBuildFPCCross }

type

TBuildMode = (bmArmV6, bmArmV7a, bmX86, bmMipsel, bmAarch64);

  TFormBuildFPCCross = class(TForm)
    Button2: TButton;
    Button3: TButton;
    EditPathToNDK: TEdit;
    EditPathToFpc: TEdit;
    EditPathToFPCTrunk: TEdit;
    EditPathToFPCUnits: TEdit;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    GroupBox4: TGroupBox;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Memo1: TMemo;
    PageControl1: TPageControl;
    Panel3: TPanel;
    RadioGroupInstruction: TRadioGroup;
    SelectDirectoryDialog1: TSelectDirectoryDialog;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    StatusBar1: TStatusBar;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure PageControl1Change(Sender: TObject);
    procedure RadioGroupInstructionClick(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);

  private
    FBuildMode: TBuildMode;
    FPrebuildOSYS: String;
    FPCSysTarget: string;
    FPathToAndroidNDK: string;
    FFPUSet: string;
    FIniFileSection: string;
    FPathToFPCTrunk: string;
    FPathToFPCBin: string;
    FPathToFPCUnit: string;
    FBuildModeIndex: string;
    { private declarations }
  public
    { public declarations }

    procedure LoadSettings(const fileName: string);
    procedure SaveSettings(const fileName: string);
    procedure CopyCrossUnits(const SourceDirName: string;  TargetDirName: string);

    function GetPrebuiltDirectory: string;
    function ReadIniString(Key: string): string;
    procedure WriteIniString(Key, Value: string);

  end;

var
  FormBuildFPCCross: TFormBuildFPCCross;

implementation

{$R *.lfm}

uses
  IDEExternToolIntf, LazIDEIntf, LCLVersion, IniFiles;

{ TFormBuildFPCCross }

function TFormBuildFPCCross.GetPrebuiltDirectory: string;
var
   pathToNdkToolchains46,
   pathToNdkToolchains49,
   pathToNdkToolchains443: string;  //FInstructionSet   [ARM or x86]
   pathToNdkToolchains49aarch64: string;
begin
    Result:= '';

    pathToNdkToolchains443:= FPathToAndroidNDK+DirectorySeparator+'toolchains'+DirectorySeparator+
                                                 'arm-linux-androideabi-4.4.3'+DirectorySeparator+
                                                 'prebuilt'+DirectorySeparator;

    pathToNdkToolchains46:= FPathToAndroidNDK+DirectorySeparator+'toolchains'+DirectorySeparator+
                                              'arm-linux-androideabi-4.6'+DirectorySeparator+
                                              'prebuilt'+DirectorySeparator;

    pathToNdkToolchains49:= FPathToAndroidNDK+DirectorySeparator+'toolchains'+DirectorySeparator+
                                                'arm-linux-androideabi-4.9'+DirectorySeparator+
                                                'prebuilt'+DirectorySeparator;

    pathToNdkToolchains49aarch64:= FPathToAndroidNDK+DirectorySeparator+'toolchains'+DirectorySeparator+
                                                'aarch64-linux-android-4.9'+DirectorySeparator+
                                                'prebuilt'+DirectorySeparator;

   {$ifdef windows}
     Result:=  'windows';
     if DirectoryExists(pathToNdkToolchains49+ 'windows') then
     begin
       Result:= 'windows';
       Exit;
     end;
     if DirectoryExists(pathToNdkToolchains46+ 'windows') then
     begin
       Result:= 'windows';
       Exit;
     end;
     if DirectoryExists(pathToNdkToolchains443+ 'windows') then
     begin
       Result:= 'windows';
       Exit;
     end;
     if DirectoryExists(pathToNdkToolchains49 + 'windows-x86_64') then
     begin
       Result:= 'windows-x86_64';
       Exit;
     end;
     if DirectoryExists(pathToNdkToolchains49aarch64 + 'windows-x86_64') then
     begin
       Result:= 'windows-x86_64';
     end;
   {$else}
     {$ifdef darwin}
        Result:=  'darwin-x86_64';
        if DirectoryExists(pathToNdkToolchains49+ 'darwin-x86_64') then Result:= 'darwin-x86_64';
     {$else}
       Result:=  'linux-x86_64';
       {$ifdef cpu64}
         if DirectoryExists(pathToNdkToolchains49+ 'linux-x86_64') then Result:= 'linux-x86_64';
       {$else}
         if DirectoryExists(pathToNdkToolchains49+ 'linux-x86_32') then
         begin
            Result:= 'linux-x86_32';
            Exit;
         end;
         if DirectoryExists(pathToNdkToolchains46+ 'linux-x86_32') then
         begin
           Result:= 'linux-x86_32';
           Exit;
         end;
         if DirectoryExists(pathToNdkToolchains443+ 'linux-x86_32') then
         begin
           Result:= 'linux-x86_32';
           Exit;
         end;
       {$endif}
     {$endif}
   {$endif}

   if Result = '' then
   begin
       {$ifdef LINUX}
           Result:= 'linux-x86_64';
       {$endif}
       {$ifdef WINDOWS}
           Result:= 'windows';
       {$endif}
       {$ifdef darwin}
           Result:= 'darwin-x86_64';
       {$endif}
   end;

end;

procedure TFormBuildFPCCross.Button2Click(Sender: TObject);
var
   pathToFpcExecutables: string;
   pathToFpcSource: string;
   crossBinDIR: string;
   binutilsPath: string;
   auxStr: string;
   Tool: TIDEExternalToolOptions;
   Params: TStringList;
   strExt, configFile: string;
   p: integer;
   sucess: boolean;
begin

   Button2.Enabled:= False;
   sucess:= True;

   FPathToAndroidNDK:= Trim(EditPathToNDK.Text);
   pathToFpcExecutables:= Trim(EditPathToFpc.Text);
   pathToFpcSource:= Trim(EditPathToFPCTrunk.Text);

   if (FPathToAndroidNDK = '') or  (pathToFpcExecutables = '') or (pathToFpcSource = '') then
   begin
     ShowMessage('Sorry... Empty Info...');
     Button2.Enabled:= True;
     Exit;
   end;

   if FPathToAndroidNDK <> '' then
      FPrebuildOSYS:= GetPrebuiltDirectory();

   configFile:= LazarusIDE.GetPrimaryConfigPath+ DirectorySeparator+ 'LAMW.ini';

   if FileExists(configFile) then
   begin
     with TIniFile.Create(configFile) do
     try
       writeString('NewProject','PathToAndroidNDK', FPathToAndroidNDK);
       writeString('NewProject','PrebuildOSYS', FPrebuildOSYS);
     finally
       Free;
     end;
   end;

   //C:\laz4android\fpc\3.0.0\bin\i386-win32
   p:= Pos(DirectorySeparator+'bin', pathToFpcExecutables);
   auxStr:= Copy(pathToFpcExecutables,1,p);     //C:\laz4android\fpc\3.0.0\
   EditPathToFPCUnits.Text:= auxStr+ 'units';   //C:\laz4android\fpc\3.0.0\units

   strExt:= '';
   {$IFDEF WINDOWS}
   strExt:= '.exe';
   {$ENDIF}

   if (FBuildMode = bmArmV6) or (FBuildMode = bmArmV7a) or (FBuildMode = bmAarch64)  then   //arm
   begin

     //........\toolchains\arm-linux-androideabi-4.9\prebuilt\windows-x86_64\bin
     if FBuildMode <> bmAarch64 then
         binutilsPath:= FPathToAndroidNDK+DirectorySeparator+
                                 'toolchains'+DirectorySeparator+
                                 'arm-linux-androideabi-4.9'+DirectorySeparator+
                                 'prebuilt'+DirectorySeparator+
                                  FPrebuildOSYS+DirectorySeparator+
                                 'bin'

     else //...\toolchains\aarch64-linux-android-4.9\prebuilt\windows-x86_64\bin
        binutilsPath:= FPathToAndroidNDK+DirectorySeparator+
                                 'toolchains'+DirectorySeparator+
                                 'aarch64-linux-android-4.9'+DirectorySeparator+
                                 'prebuilt'+DirectorySeparator+
                                  FPrebuildOSYS+ DirectorySeparator +
                                 'bin';


     if not DirectoryExists(binutilsPath)  then
     begin
        ShowMessage('Directory not exist [1]! :"'+binutilsPath+'"');
        Button2.Enabled:= True;
        Exit;
     end;

     //------ brute force ... set path [below] did not work! why?
     if FBuildMode <> bmAarch64 then
     begin
     CopyFile(binutilsPath+DirectorySeparator+'arm-linux-androideabi-as'+strExt,
              pathToFpcSource+DirectorySeparator+'compiler'+DirectorySeparator+'arm-linux-androideabi-as'+strExt);

     CopyFile(binutilsPath+DirectorySeparator+'arm-linux-androideabi-ld.bfd'+strExt,
              pathToFpcSource+DirectorySeparator+'compiler'+DirectorySeparator+'arm-linux-androideabi-ld.bfd'+strExt);

     CopyFile(binutilsPath+DirectorySeparator+'arm-linux-androideabi-ld'+strExt,
              pathToFpcSource+DirectorySeparator+'compiler'+DirectorySeparator+'arm-linux-androideabi-ld'+strExt);

     CopyFile(binutilsPath+DirectorySeparator+'arm-linux-androideabi-strip'+strExt,
              pathToFpcSource+DirectorySeparator+'compiler'+DirectorySeparator+'arm-linux-androideabi-strip'+strExt);
     end
     else  //aarch64
     begin
       CopyFile(binutilsPath+DirectorySeparator+'aarch64-linux-android-as'+strExt,
                pathToFpcSource+DirectorySeparator+'compiler'+DirectorySeparator+'aarch64-linux-android-as'+strExt);

       CopyFile(binutilsPath+DirectorySeparator+'aarch64-linux-android-ld.bfd'+strExt,
                pathToFpcSource+DirectorySeparator+'compiler'+DirectorySeparator+'aarch64-linux-android-ld.bfd'+strExt);

       CopyFile(binutilsPath+DirectorySeparator+'aarch64-linux-android-ld'+strExt,
                pathToFpcSource+DirectorySeparator+'compiler'+DirectorySeparator+'aarch64-linux-android-ld'+strExt);

       CopyFile(binutilsPath+DirectorySeparator+'aarch64-linux-android-strip'+strExt,
                pathToFpcSource+DirectorySeparator+'compiler'+DirectorySeparator+'aarch64-linux-android-strip'+strExt);

     end;

     Params:= TStringList.Create;
     Params.Delimiter:=' ';

     Tool := TIDEExternalToolOptions.Create;
     try

       Tool.Title := 'Running Extern Tool [make]... ';

       //Tool.EnvironmentOverrides.Add('set path=%path%;'+binutilsPath);  // did not work! why?
       Tool.WorkingDirectory := pathToFpcSource;
       Params.Add('clean');
       Params.Add('crossall');
       Params.Add('crossinstall');

       Params.Add('FPC='+pathToFpcExecutables+DirectorySeparator+'fpc'+strExt);
       {
       if FBuildMode <> bmAarch64 then
         Params.Add('FPC='+pathToFpcExecutables+DirectorySeparator+'fpc'+strExt)
       else
         Params.Add('FPC='+pathToFpcExecutables+DirectorySeparator+'ppcx64'+strExt);
       }
       Params.Add('OS_TARGET=android');

       if FBuildMode <> bmAarch64 then
         Params.Add('CPU_TARGET=arm')
       else
         Params.Add('CPU_TARGET=aarch64');

       //ref. http://wiki.freepascal.org/ARM_compiler_options
       //ref. http://wiki.freepascal.org/Android

       if FBuildMode <> bmAarch64 then
         Params.Add('OPT= "-vw-n-h-l-d-u-t-p-c- -dFPC_ARMHF"')  //Armel means that all floating point values are always passed in integer registers.
       else
         Params.Add('OPT="-vw-n-h-l-d-u-t-p-c- "');

       if FBuildMode = bmArmV6  then
          Params.Add('CROSSOPT="-CpARMv6 -CfSoft"');   //Soft means that all fp operations are performed by software, no FPU support.

       if FBuildMode = bmArmV7a then  //                      //[FPU] vfpv3 means that fp operations are performed by the hardware.
       begin
          if FFPUSet = 'Soft' then
            Params.Add('CROSSOPT="-CpARMv7a -Cf'+FFPUSet+'"')   //-OoFASTMATH to sacrifice precision for performance.
          else
            Params.Add('CROSSOPT="-CaEABI -CpARMv7a -Cf'+FFPUSet+'"');   //-OoFASTMATH to sacrifice precision for performance.
       end;

       if  FBuildMode <> bmAarch64 then
         crossBinDIR:= FPathToAndroidNDK+DirectorySeparator+
                        'toolchains'+DirectorySeparator+
                        'arm-linux-androideabi-4.9'+DirectorySeparator+
                        'prebuilt'+DirectorySeparator+
                         FPrebuildOSYS+DirectorySeparator+
                        'arm-linux-androideabi'+DirectorySeparator+
                        'bin'
       else //aarch64
         crossBinDIR:= FPathToAndroidNDK+DirectorySeparator+
                      'toolchains'+DirectorySeparator+
                      'aarch64-linux-android-4.9'+DirectorySeparator+
                      'prebuilt'+DirectorySeparator+
                       FPrebuildOSYS+DirectorySeparator+
                      'aarch64-linux-android'+DirectorySeparator+
                      'bin';

       if not DirectoryExists(crossBinDIR)  then
       begin
          ShowMessage('Directory not exist [2]! :"'+crossBinDIR+'"');
          Button2.Enabled:= True;
          Exit;
       end;

       Params.Add('CROSSBINDIR='+crossBinDIR);
       Params.Add('INSTALL_PREFIX='+ pathToFpcSource);

       Tool.Executable := AppendPathDelim(pathToFpcExecutables) + 'make'+strExt;
       Tool.CmdLineParams :=  Params.DelimitedText;

       {$IF LCL_FULLVERSION >= 2010000}
       Tool.Parsers.Add(SubToolDefault);
       {$ELSE}
       Tool.Scanners.Add(SubToolDefault);
       {$ENDIF}
       if not RunExternalTool(Tool) then
       begin
         sucess:= False;
         raise Exception.Create('Cannot Running Extern Tool [make]!');
       end;

     finally
       Tool.Free;
       Params.Free;
       if  FBuildMode <> bmAarch64 then
       begin
          if sucess then
          begin
             StatusBar1.SimpleText:='Success! FPC cross Arm [Android] was Build!';
             ShowMessage('Success! FPC cross Arm [Android] was Build!');
          end
          else
          begin
            StatusBar1.SimpleText:='Sorry... Fail to build FPC cross Arm [Android]';
          end;
       end
       else
       begin
         if sucess then
         begin
            ShowMessage('Success! FPC cross aarch64 [Android] was Build!');
            StatusBar1.SimpleText:='Success! FPC cross aarch64 [Android] was Build!';
         end
         else
         begin
           StatusBar1.SimpleText:='Sorry... Fail to build FPC cross aarch64 [Android]';
         end;
       end;
     end;
   end;

   if FBuildMode = bmX86 then   //x86
   begin

     //C:\adt32\ndk10e\toolchains\x86-4.9\prebuilt\windows\bin
     binutilsPath:= FPathToAndroidNDK+DirectorySeparator+
                      'toolchains'+DirectorySeparator+
                      'x86-4.9'+DirectorySeparator+
                      'prebuilt'+DirectorySeparator+
                       FPrebuildOSYS+DirectorySeparator+
                      'bin';

     if not DirectoryExists(binutilsPath)  then
     begin
       ShowMessage('Directory not exist[1]! :"'+binutilsPath+'"');
       Button2.Enabled:= True;
       Exit;
     end;

     //----------brute force ... set path [below] did not work! why?
     CopyFile(binutilsPath+DirectorySeparator+'i686-linux-android-as'+strExt,
              pathToFpcSource+DirectorySeparator+'compiler'+DirectorySeparator+'i686-linux-android-as'+strExt);

     CopyFile(binutilsPath+DirectorySeparator+'i686-linux-android-ld.bfd'+strExt,
                pathToFpcSource+DirectorySeparator+'compiler'+DirectorySeparator+'i686-linux-android-ld.bfd'+strExt);

     CopyFile(binutilsPath+DirectorySeparator+'i686-linux-android-ld'+strExt,
              pathToFpcSource+DirectorySeparator+'compiler'+DirectorySeparator+'i686-linux-android-ld'+strExt);

     CopyFile(binutilsPath+DirectorySeparator+'i686-linux-android-strip'+strExt,
              pathToFpcSource+DirectorySeparator+'compiler'+DirectorySeparator+'i686-linux-android-strip'+strExt);
     //--------------------

     Params:= TStringList.Create;
     Params.Delimiter:=' ';

     Tool := TIDEExternalToolOptions.Create;
     try
       Tool.Title := 'Running Extern [make] Tool ... ';
       Tool.WorkingDirectory := pathToFpcSource;

       Params.Add('clean');
       Params.Add('crossall');
       Params.Add('crossinstall');
       Params.Add('FPC='+pathToFpcExecutables+DirectorySeparator+'fpc'+strExt);
       Params.Add('OS_TARGET=android');
       Params.Add('CPU_TARGET=i386');

       //C:\adt32\ndk10e\toolchains\x86-4.9\prebuilt\windows\i686-linux-android\bin
       crossBinDIR:= FPathToAndroidNDK+DirectorySeparator+
                        'toolchains'+DirectorySeparator+
                        'x86-4.9'+DirectorySeparator+
                        'prebuilt'+DirectorySeparator+
                         FPrebuildOSYS+DirectorySeparator+
                        'i686-linux-android'+DirectorySeparator+
                        'bin';

       if not DirectoryExists(crossBinDIR)  then
       begin
          ShowMessage('Directory not exist[2]! :"'+crossBinDIR+'"');
          Button2.Enabled:= True;
          Exit;
       end;

       Params.Add('CROSSBINDIR='+crossBinDIR);
       Params.Add('INSTALL_PREFIX='+ pathToFpcSource);

       Tool.Executable := pathToFpcExecutables + DirectorySeparator+ 'make'+strExt;
       Tool.CmdLineParams :=  Params.DelimitedText;

       {$IF LCL_FULLVERSION >= 2010000}
       Tool.Parsers.Add(SubToolDefault);
       {$ELSE}
       Tool.Scanners.Add(SubToolDefault);
       {$ENDIF}

       if not RunExternalTool(Tool) then
       begin
         sucess:= False;
         raise Exception.Create('Cannot Run Extern [make] Tool!');
       end;
     finally
       Tool.Free;
       Params.Free;
       if sucess then
       begin
          ShowMessage('Success! FPC cross x86 [Android] was Build!');
          StatusBar1.SimpleText:='Success! FPC cross x86 [Android] was Build!';
       end
       else
       begin
         StatusBar1.SimpleText:='Sorry... Fail to build FPC cross x86 [Android]';
       end;
     end;
   end;

   if FBuildMode = bmMipsel then   //Mipsel
   begin
     //C:\adt32\ndk10e\toolchains\mipsel-linux-android-4.9\prebuilt\windows\bin
     binutilsPath:= FPathToAndroidNDK+DirectorySeparator+
                      'toolchains'+DirectorySeparator+
                      'mipsel-linux-android-4.9'+DirectorySeparator+
                      'prebuilt'+DirectorySeparator+
                       FPrebuildOSYS+DirectorySeparator+
                      'bin';

     if not DirectoryExists(binutilsPath)  then
     begin
       ShowMessage('Directory not exist[1]! :"'+binutilsPath+'"');
       Button2.Enabled:= True;
       Exit;
     end;

     //----------brute force ... set path [below] did not work! why?
     CopyFile(binutilsPath+DirectorySeparator+'mipsel-linux-android-as'+strExt,
              pathToFpcSource+DirectorySeparator+'compiler'+DirectorySeparator+'mipsel-linux-android-as'+strExt);

     CopyFile(binutilsPath+DirectorySeparator+'mipsel-linux-android-ld.bfd'+strExt,
                pathToFpcSource+DirectorySeparator+'compiler'+DirectorySeparator+'mipsel-linux-android-ld.bfd'+strExt);

     CopyFile(binutilsPath+DirectorySeparator+'mipsel-linux-android-ld'+strExt,
              pathToFpcSource+DirectorySeparator+'compiler'+DirectorySeparator+'mipsel-linux-android-ld'+strExt);

     CopyFile(binutilsPath+DirectorySeparator+'mipsel-linux-android-strip'+strExt,
              pathToFpcSource+DirectorySeparator+'compiler'+DirectorySeparator+'mipsel-linux-android-strip'+strExt);
     //--------------------

     Params:= TStringList.Create;
     Params.Delimiter:=' ';

     Tool := TIDEExternalToolOptions.Create;
     try
       Tool.Title := 'Running Extern [make] Tool ... ';
       Tool.WorkingDirectory := pathToFpcSource;

       Params.Add('clean');
       Params.Add('crossall');
       Params.Add('crossinstall');
       Params.Add('FPC='+pathToFpcExecutables+DirectorySeparator+'fpc'+strExt);
       Params.Add('OS_TARGET=android');
       Params.Add('CPU_TARGET=mipsel');

       //C:\adt32\ndk10e\toolchains\mipsel-linux-android-4.9\prebuilt\windows\mipsel-linux-android\bin
       crossBinDIR:= FPathToAndroidNDK+DirectorySeparator+
                        'toolchains'+DirectorySeparator+
                        'mipsel-linux-android-4.9'+DirectorySeparator+
                        'prebuilt'+DirectorySeparator+
                         FPrebuildOSYS+DirectorySeparator+
                        'mipsel-linux-android'+DirectorySeparator+
                        'bin';

       if not DirectoryExists(crossBinDIR)  then
       begin
          ShowMessage('Directory not exist[2]! :"'+crossBinDIR+'"');
          Button2.Enabled:= True;
          Exit;
       end;

       Params.Add('CROSSBINDIR='+crossBinDIR);
       Params.Add('INSTALL_PREFIX='+ pathToFpcSource);

       Tool.Executable := pathToFpcExecutables + DirectorySeparator+ 'make'+strExt;
       Tool.CmdLineParams :=  Params.DelimitedText;

       {$IF LCL_FULLVERSION >= 2010000}
       Tool.Parsers.Add(SubToolDefault);
       {$ELSE}
       Tool.Scanners.Add(SubToolDefault);
       {$ENDIF}


       if not RunExternalTool(Tool) then
       begin
         sucess:= False;
         raise Exception.Create('Cannot Run Extern [make] Tool!');
       end;
     finally
       Tool.Free;
       Params.Free;
       if sucess then
       begin
          ShowMessage('Success! FPC cross Mipsel [Android] was Build!');
          StatusBar1.SimpleText:='Success! FPC cross Mipsel [Android] was Build!';
       end
       else
       begin
         StatusBar1.SimpleText:='Sorry... Fail to build FPC cross Mipsel [Android]';
       end;
     end;
   end;

   Button2.Enabled:= False;

end;

procedure TFormBuildFPCCross.Button3Click(Sender: TObject);
var
  fpcExecutablesPath: string;
  fpcPathTrunk: string;
  strExt: string;
  fpcUnitsPath: string;
  //sysTarget: string;
  binutilsPath: string;
  pathToNDK: string;
  auxList: TStringList;
begin

  Button3.Enabled:= False;
  fpcExecutablesPath:= Trim(EditPathToFpc.Text); //C:\laz4android\fpc\3.0.0\bin\i386-win32

  auxList:= TStringList.Create;
  auxList.Delimiter:= DirectorySeparator;
  auxList.StrictDelimiter:= True;
  auxList.DelimitedText:= fpcExecutablesPath;
  FPCSysTarget:= auxList.Strings[auxList.Count-1];     //i386-win32
  auxList.Free;

  if  FPCSysTarget = '' then
  begin
    ShowMessage('FPC ".exe" directory not found! [ex:"C:\laz4android\fpc\3.0.0\bin\i386-win32"]');
    Button3.Enabled:= True;
    Exit
  end;

  fpcPathTrunk:= Trim(EditPathToFPCTrunk.Text);
  fpcUnitsPath:= Trim(EditPathToFPCUnits.Text);
  pathToNDK:= Trim(EditPathToNDK.Text);

  if (fpcExecutablesPath = '') or  (fpcPathTrunk = '') or (fpcUnitsPath = '') then
  begin
    ShowMessage('Sorry... Empty Info...');
    Button3.Enabled:= True;
    Exit;
  end;

  strExt:= '';
  {$IFDEF WINDOWS}
     strExt:= '.exe';
  {$ENDIF}

  if (FBuildMode = bmArmV6) or (FBuildMode = bmArmV7a) or (FBuildMode = bmAarch64) then  //arm
  begin

    if FBuildMode <> bmAarch64 then  //arm
    begin

      if FileExists(fpcPathTrunk+DirectorySeparator +
                    'bin' + DirectorySeparator +
                     FPCSysTarget + DirectorySeparator +
                    'ppcrossarm' + strExt) then
      begin
         CopyFile(fpcPathTrunk+DirectorySeparator +
                    'bin' + DirectorySeparator +
                     FPCSysTarget + DirectorySeparator +
                    'ppcrossarm' + strExt,           //C:\adt32\fpctrunk300\bin\i386-win32
                   fpcExecutablesPath+DirectorySeparator+'ppcrossarm' + strExt);
      end
      else
      begin
        ShowMessage('Error. '+ fpcPathTrunk+DirectorySeparator +
                    'bin' + DirectorySeparator +
                     FPCSysTarget + DirectorySeparator +
                    'ppcrossarm' + strExt+sLineBreak+
                     '"ppcrossarm" not Exists. Please, you need "Build" it! ');
        Button3.Enabled:= True;
        Exit;
      end;
    end;

    if FBuildMode = bmAarch64 then  //ppcrossa64
    begin

      if FileExists(fpcPathTrunk+DirectorySeparator +
                    'bin' + DirectorySeparator +
                     FPCSysTarget + DirectorySeparator +
                    'ppcrossa64' + strExt) then
      begin
         CopyFile(fpcPathTrunk+DirectorySeparator +
                    'bin' + DirectorySeparator +
                     FPCSysTarget + DirectorySeparator +
                    'ppcrossa64' + strExt,           //C:\adt32\fpctrunk300\bin\i386-win32
                   fpcExecutablesPath+DirectorySeparator+'ppcrossa64' + strExt);
      end
      else
      begin
        ShowMessage('Error. '+ fpcPathTrunk+DirectorySeparator +
                    'bin' + DirectorySeparator +
                     FPCSysTarget + DirectorySeparator +
                    'ppcrossa64' + strExt+sLineBreak+
                    '"ppcrossa64" not Exists. Please, you need "Build" it! ');
        Button3.Enabled:= True;
        Exit;
      end;
    end;

    if FBuildMode <> bmAarch64 then
        binutilsPath:= pathToNDK+DirectorySeparator+
                                  'toolchains'+DirectorySeparator+
                                  'arm-linux-androideabi-4.9'+DirectorySeparator+
                                  'prebuilt'+DirectorySeparator+
                                   FPrebuildOSYS+DirectorySeparator+
                                  'bin'
    else  //aarch64
       binutilsPath:= pathToNDK+DirectorySeparator+
                              'toolchains'+DirectorySeparator+
                              'aarch64-linux-android-4.9'+DirectorySeparator+
                              'prebuilt'+DirectorySeparator+
                               FPrebuildOSYS+DirectorySeparator+
                              'bin';

    if not DirectoryExists(binutilsPath)  then
    begin
       ShowMessage('Directory not exist[1]! :"'+binutilsPath+'"');
       Button3.Enabled:= True;
       Exit;
    end;

    if FBuildMode <> bmAarch64 then
    begin
      CopyFile(binutilsPath+DirectorySeparator+'arm-linux-androideabi-as'+strExt,
               fpcExecutablesPath+DirectorySeparator+'arm-linux-androideabi-as'+strExt);

      CopyFile(binutilsPath+DirectorySeparator+'arm-linux-androideabi-ld.bfd'+strExt,
               fpcExecutablesPath+DirectorySeparator+'arm-linux-androideabi-ld.bfd'+strExt);

      CopyFile(binutilsPath+DirectorySeparator+'arm-linux-androideabi-ld'+strExt,
               fpcExecutablesPath+DirectorySeparator+'arm-linux-androideabi-ld'+strExt);

      CopyFile(binutilsPath+DirectorySeparator+'arm-linux-androideabi-strip'+strExt,
               fpcExecutablesPath+DirectorySeparator+'arm-linux-androideabi-strip'+strExt);

      ForceDirectories(fpcUnitsPath+DirectorySeparator+'arm-android');

      CopyCrossUnits(fpcPathTrunk + DirectorySeparator +
                 'units' + DirectorySeparator+
                 'arm-android',  ////C:\adt32\fpctrunk300\units\arm-android
                 fpcUnitsPath + DirectorySeparator +
                 'arm-android');  //C:\laz4android\fpc\3.1.1\units\arm-android

      ShowMessage('Success! FPC cross arm [android] installed!');
      StatusBar1.SimpleText:='Success! FPC cross Arm [android] Installed!';
    end
    else  //aarch64
    begin
      CopyFile(binutilsPath+DirectorySeparator+'aarch64-linux-android-as'+strExt,
               fpcExecutablesPath+DirectorySeparator+'aarch64-linux-android-as'+strExt);

      CopyFile(binutilsPath+DirectorySeparator+'aarch64-linux-android-ld.bfd'+strExt,
               fpcExecutablesPath+DirectorySeparator+'aarch64-linux-android-ld.bfd'+strExt);

      CopyFile(binutilsPath+DirectorySeparator+'aarch64-linux-android-ld'+strExt,
               fpcExecutablesPath+DirectorySeparator+'aarch64-linux-android-ld'+strExt);

      CopyFile(binutilsPath+DirectorySeparator+'aarch64-linux-android-strip'+strExt,
               fpcExecutablesPath+DirectorySeparator+'aarch64-linux-android-strip'+strExt);

      ForceDirectories(fpcUnitsPath+DirectorySeparator+'aarch64-android');

      CopyCrossUnits(fpcPathTrunk + DirectorySeparator +
                 'units' + DirectorySeparator+
                 'aarch64-android',  ////C:\adt32\fpctrunk300\units\aarch64-android
                 fpcUnitsPath + DirectorySeparator +
                 'aarch64-android');  //C:\laz4android\fpc\3.1.1\units\aarch64-android

      ShowMessage('Success! FPC cross aarch64 [android] installed!');
      StatusBar1.SimpleText:='Success! FPC cross aarch64 [android] Installed!';

    end;

    //Self.Close;
  end;

  if FBuildMode = bmX86 then // x86
  begin
    if FileExists(fpcPathTrunk+DirectorySeparator+
             'bin'+DirectorySeparator +
             FPCSysTarget+DirectorySeparator+
             'ppcross386'+strExt) then
    begin
       CopyFile(fpcPathTrunk+DirectorySeparator+
             'bin'+DirectorySeparator +
             FPCSysTarget+DirectorySeparator+
             'ppcross386'+strExt,
             fpcExecutablesPath+DirectorySeparator+'ppcross386'+strExt);
    end
    else
    begin
       ShowMessage('Error. '+ fpcPathTrunk+DirectorySeparator+
             'bin'+DirectorySeparator +
             FPCSysTarget+DirectorySeparator+
             'ppcross386'+strExt+sLineBreak+
             '"ppcross386" not Exists. Please, you need "Build" it! ');
       Button3.Enabled:= True;
       Exit;
    end;

    binutilsPath:= pathToNDK+DirectorySeparator+
                     'toolchains'+DirectorySeparator+
                     'x86-4.9'+DirectorySeparator+
                     'prebuilt'+DirectorySeparator+
                      FPrebuildOSYS+DirectorySeparator+
                     'bin';

    if not DirectoryExists(binutilsPath)  then
    begin
       ShowMessage('Directory not exist[1]! :"'+binutilsPath+'"');
       Button3.Enabled:= True;
       Exit;
    end;

    CopyFile(binutilsPath+DirectorySeparator+'i686-linux-android-as'+strExt,
               fpcExecutablesPath+DirectorySeparator+'i686-linux-android-as'+strExt);

    CopyFile(binutilsPath+DirectorySeparator+'i686-linux-android-ld.bfd'+strExt,
               fpcExecutablesPath+DirectorySeparator+'i686-linux-android-ld.bfd'+strExt);

    CopyFile(binutilsPath+DirectorySeparator+'i686-linux-android-ld'+strExt,
               fpcExecutablesPath+DirectorySeparator+'i686-linux-android-ld'+strExt);

    CopyFile(binutilsPath+DirectorySeparator+'i686-linux-android-strip'+strExt,
               fpcExecutablesPath+DirectorySeparator+'i686-linux-android-strip'+strExt);

    ForceDirectories(fpcUnitsPath + DirectorySeparator + 'i386-android');

    CopyCrossUnits(fpcPathTrunk + DirectorySeparator +
               'units'+DirectorySeparator+
               'i386-android',    //C:\adt32\fpctrunk300\units\i386-android
               fpcUnitsPath+ DirectorySeparator+
               'i386-android'); // //C:\laz4android\fpc\3.1.1\units\i386-android

    ShowMessage('Success! FPC cross x86 [android] installed!');
    StatusBar1.SimpleText:='Success! FPC cross x86 [android] Installed!';
    //Self.Close;
  end;


  if FBuildMode = bmMipsel then // mipsel
  begin
    if FileExists(fpcPathTrunk+DirectorySeparator+
             'bin'+DirectorySeparator +
             FPCSysTarget+DirectorySeparator+
             'ppcrossmipsel'+strExt) then
    begin
       CopyFile(fpcPathTrunk+DirectorySeparator+
             'bin'+DirectorySeparator +
             FPCSysTarget+DirectorySeparator+
             'ppcrossmipsel'+strExt,
             fpcExecutablesPath+DirectorySeparator+'ppcrossmipsel'+strExt);
    end
    else
    begin
       ShowMessage('Error. '+fpcPathTrunk+DirectorySeparator+
             'bin'+DirectorySeparator +
             FPCSysTarget+DirectorySeparator+
             'ppcrossmipsel'+strExt +sLineBreak+
             '"ppcrossmipsel" not Exists. Please, you need "Build" it! ');
       Button3.Enabled:= True;
       Exit;
    end;

    binutilsPath:= pathToNDK+DirectorySeparator+
                     'toolchains'+DirectorySeparator+
                     'mipsel-linux-android-4.9'+DirectorySeparator+
                     'prebuilt'+DirectorySeparator+
                      FPrebuildOSYS+DirectorySeparator+
                     'bin';

    if not DirectoryExists(binutilsPath)  then
    begin
       ShowMessage('Directory not exist[2]! :"'+binutilsPath+'"');
       Button3.Enabled:= True;
       Exit;
    end;

    CopyFile(binutilsPath+DirectorySeparator+'mipsel-linux-android-as'+strExt,
               fpcExecutablesPath+DirectorySeparator+'mipsel-linux-android-as'+strExt);

    CopyFile(binutilsPath+DirectorySeparator+'mipsel-linux-android-ld.bfd'+strExt,
               fpcExecutablesPath+DirectorySeparator+'mipsel-linux-android-ld.bfd'+strExt);

    CopyFile(binutilsPath+DirectorySeparator+'mipsel-linux-android-ld'+strExt,
               fpcExecutablesPath+DirectorySeparator+'mipsel-linux-android-ld'+strExt);

    CopyFile(binutilsPath+DirectorySeparator+'mipsel-linux-android-strip'+strExt,
               fpcExecutablesPath+DirectorySeparator+'mipsel-linux-android-strip'+strExt);

    ForceDirectories(fpcUnitsPath + DirectorySeparator + 'mipsel-android');

    CopyCrossUnits(fpcPathTrunk + DirectorySeparator +
               'units'+DirectorySeparator+
               'mipsel-android',    //C:\adt32\fpctrunk300\units\mipsel-android
               fpcUnitsPath+ DirectorySeparator+
               'mipsel-android'); // C:\laz4android\fpc\3.1.1\units\mipsel-android

    ShowMessage('Success! FPC cross Mipsel [android] installed!');
    StatusBar1.SimpleText:='Success! FPC cross Mipsel [android] Installed!';
    //Self.Close;
  end;

  Button3.Enabled:= True;

end;

procedure TFormBuildFPCCross.WriteIniString(Key, Value: string);
var
  FIniFile: TIniFile;
begin
  FIniFile := TIniFile.Create(IncludeTrailingPathDelimiter(LazarusIDE.GetPrimaryConfigPath) + 'LAMW.ini');
  if FIniFile <> nil then
  begin
    FIniFile.WriteString(FIniFileSection, Key, Value);
    FIniFile.Free;
  end;
end;

function TFormBuildFPCCross.ReadIniString(Key: string): string;
var
  FIniFile: TIniFile;
begin
  FIniFile := TIniFile.Create(IncludeTrailingPathDelimiter(LazarusIDE.GetPrimaryConfigPath) + 'LAMW.ini');
  if FIniFile <> nil then
  begin
    Result:= FIniFile.ReadString(FIniFileSection, Key, '');
    FIniFile.Free;
  end;
end;

procedure TFormBuildFPCCross.FormActivate(Sender: TObject);
var
  configFile: string;
begin
  FFPUSet:= '';
  PageControl1.PageIndex:= 0;
  configFile:= LazarusIDE.GetPrimaryConfigPath + DirectorySeparator + 'LAMW.ini';
  if FileExists(configFile) then Self.LoadSettings(configFile);
end;

procedure TFormBuildFPCCross.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  Self.SaveSettings(LazarusIDE.GetPrimaryConfigPath +  DirectorySeparator + 'LAMW.ini' );
end;

procedure TFormBuildFPCCross.PageControl1Change(Sender: TObject);
begin

  StatusBar1.SimpleText:='';
  if PageControl1.ActivePageIndex <> 0 then
  begin
    if EditPathToFPCTrunk.Text = '' then
    begin
       ShowMessage('Please, Enter Path to FPC Source [trunk]...');
       PageControl1.ActivePageIndex:= 0;
       Exit;
    end;
    if EditPathToFpc.Text = '' then
    begin
       ShowMessage('Please, Enter Path to FPC [make]...');
       PageControl1.ActivePageIndex:= 0;
       Exit;
    end;
  end;

  if PageControl1.PageIndex = 1 then
  begin
     case FBuildMode of
        bmArmV6: GroupBox3.Caption:= 'Install Cross ArmV6 Android';
        bmArmV7a: GroupBox3.Caption:= 'Install Cross ArmV7a Android';
        bmX86: GroupBox3.Caption:= 'Install Cross x86 Android';
        bmMipsel: GroupBox3.Caption:= 'Install Cross Mipsel Android';
        bmAarch64: GroupBox3.Caption:= 'Install Cross aarch64 Android';
     end;
  end;

end;

procedure TFormBuildFPCCross.RadioGroupInstructionClick(Sender: TObject);
begin

  FFPUSet:= ''; //x86
  case RadioGroupInstruction.ItemIndex of
    0: begin FBuildMode:= bmArmV6;  FFPUSet:='Soft';  end;
    1: begin FBuildMode:= bmArmV7a; FFPUSet:='Soft';  end;
    2: begin FBuildMode:= bmArmV7a; FFPUSet:='VFPv3'; end;
    3: FBuildMode:= bmX86;
    4: FBuildMode:= bmMipsel;
    5: begin FBuildMode:= bmAarch64; FFPUSet:=''; end; //fail to VFPv4!
  end;

    FBuildModeIndex:= IntToStr(RadioGroupInstruction.ItemIndex);

  if FPathToAndroidNDK <> '' then
    FPrebuildOSYS:= GetPrebuiltDirectory();

end;

procedure TFormBuildFPCCross.SpeedButton2Click(Sender: TObject);
begin
  if SelectDirectoryDialog1.Execute then
      EditPathToFPCTrunk.Text:=SelectDirectoryDialog1.FileName;
end;

procedure TFormBuildFPCCross.SpeedButton3Click(Sender: TObject);
begin
  if SelectDirectoryDialog1.Execute then
     EditPathToNDK.Text:=SelectDirectoryDialog1.FileName;
end;

procedure TFormBuildFPCCross.SpeedButton4Click(Sender: TObject);
begin
  if SelectDirectoryDialog1.Execute then
     EditPathToFpc.Text:=SelectDirectoryDialog1.FileName;
end;

procedure TFormBuildFPCCross.SpeedButton5Click(Sender: TObject);
begin
  if SelectDirectoryDialog1.Execute then
     EditPathToFPCUnits.Text:=SelectDirectoryDialog1.FileName;
end;

//ref. http://stackoverflow.com/questions/9278513/lazarus-free-pascal-how-to-recursively-copy-a-source-directory-of-files-to-a
procedure TFormBuildFPCCross.CopyCrossUnits(const SourceDirName: string; TargetDirName: string);
var
  i, NoOfFilesCopiedOK : integer;
  FilesFoundToCopy : TStringList;
  SourceDirectoryAndFileName,
  SubDirStructure, FinalisedDestDir, FinalisedFileName : string;
  count: integer;
  auxPath: string;
begin

  SubDirStructure:= '';
  FinalisedDestDir:= '';

  NoOfFilesCopiedOK:= 0;

  // Ensures the selected source directory is set as the directory to be searched
  // and then fina all the files and directories within, storing as a StringList.

  SetCurrentDir(SourceDirName);
  FilesFoundToCopy := FindAllFiles(SourceDirName, '*', True);

  Memo1.Clear;
  try
    for i := 0 to FilesFoundToCopy.Count -1 do
    begin

      Memo1.Lines.Add(FilesFoundToCopy.Strings[i]);

      SourceDirectoryAndFileName := ChompPathDelim(CleanAndExpandDirectory(FilesFoundToCopy.Strings[i]));

      // Determine the source sub-dir structure, from selected dir downwards
      SubDirStructure := ExtractFileDir(SourceDirectoryAndFileName);
      //fixed
      count:= Length(SourceDirName);
      auxPath:= Copy(SubDirStructure, count+1, length(SubDirStructure) );

      // Now concatenate the original sub directory to the destination directory and form the total path, inc filename
      // Note : Only directories containing files will be recreated in destination. Empty dirs are skipped.
      // Zero byte files are copied, though, even if the directory contains just one zero byte file.

      FinalisedDestDir := TargetDirName + auxPath;
      FinalisedFileName := ExtractFileName(FilesFoundToCopy.Strings[i]);

        // Now create the destination directory structure,
        //if it is not yet created. If it exists, just copy the file.

      if not DirPathExists(FinalisedDestDir) then
      begin
          if not ForceDirectories(FinalisedDestDir) then
            begin
              ShowMessage(FinalisedDestDir+' cannot be created.');
            end;
      end;

       // Now copy the files to the destination dir
      if not FileUtil.CopyFile(SourceDirectoryAndFileName, FinalisedDestDir+DirectorySeparator+FinalisedFileName, true) then
          ShowMessage('Failed to copy file : ' + SourceDirectoryAndFileName)
      else NoOfFilesCopiedOK := NoOfFilesCopiedOK + 1;

    end; //for

    Memo1.Lines.Add('Done. Success !!!');   //need ?

  finally
    FilesFoundToCopy.free;
  end;

end;

procedure TFormBuildFPCCross.LoadSettings(const fileName: string);
var
   buildIndex: integer;
begin
  if FileExists(fileName) then
  begin
    with TIniFile.Create(fileName) do
    try

      FPrebuildOSYS:= ReadString('NewProject','PrebuildOSYS', '');

      FPathToAndroidNDK:= ReadString('NewProject','PathToAndroidNDK', '');
      EditPathToNDK.Text:= FPathToAndroidNDK;

      FPathToFPCTrunk:= ReadString('BuildCross', 'PathToFPCTrunk', '');
      EditPathToFPCTrunk.Text:= FPathToFPCTrunk;

      FPathToFPCBin:= ReadString('BuildCross', 'PathToFPCBin', '');
      EditPathToFpc.Text:= FPathToFPCBin;

      FPathToFPCUnit:= ReadString('BuildCross', 'PathToFPCUnit', '');
      EditPathToFPCUnits.Text:= FPathToFPCUnit;

      Self.FFPUSet:= '';
      FBuildModeIndex:= ReadString('BuildCross', 'BuildModeIndex', '');
      if FBuildModeIndex = '' then FBuildModeIndex:= '0';
      buildIndex:= StrToInt(FBuildModeIndex);
      case buildIndex of
         0: begin FBuildMode:=bmArmV6;  Self.FFPUSet:= 'Soft'; end;
         1: begin FBuildMode:= bmArmV7a; Self.FFPUSet:= 'Soft'; end;
         2: begin FBuildMode:= bmArmV7a; Self.FFPUSet:= 'VFPv3'; end;
         3: FBuildMode:=bmX86;
         4: FBuildMode:=bmMipsel;
         5: FBuildMode:=bmAarch64;
      end;

      if FPrebuildOSYS = '' then
        if FPathToAndroidNDK <> '' then
          FPrebuildOSYS:= GetPrebuiltDirectory();

    finally
      Free;
    end;
  end;
end;

procedure TFormBuildFPCCross.SaveSettings(const fileName: string);
var
  list: TStringList;
begin

   if not FileExists(fileName) then
   begin
     list:= TStringList.Create;
     list.SaveToFile(fileName);
     list.Free;
   end;

   with TInifile.Create(fileName) do
   try

    if EditPathToNDK.Text <> '' then
      WriteString('NewProject', 'PathToAndroidNDK', Trim(EditPathToNDK.Text));

    if FPathToAndroidNDK <> '' then
       FPrebuildOSYS:= GetPrebuiltDirectory();

    if FPrebuildOSYS <> '' then
       WriteString('NewProject', 'PrebuildOSYS', FPrebuildOSYS);

    WriteString('BuildCross', 'PathToFPCTrunk', EditPathToFPCTrunk.Text);
    WriteString('BuildCross', 'PathToFPCBin', EditPathToFpc.Text);
    WriteString('BuildCross', 'PathToFPCUnit', EditPathToFPCUnits.Text);

    case StrToInt(FBuildModeIndex) of
       0: WriteString('BuildCross', 'BuildModeIndex', '0');
       1: WriteString('BuildCross', 'BuildModeIndex', '1');
       2: WriteString('BuildCross', 'BuildModeIndex', '2');
       3: WriteString('BuildCross', 'BuildModeIndex', '3');
       4: WriteString('BuildCross', 'BuildModeIndex', '4');
       5: WriteString('BuildCross', 'BuildModeIndex', '5');
    end;

   finally
    Free;
   end;

end;


end.

