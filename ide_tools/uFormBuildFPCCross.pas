unit uFormBuildFPCCross;

{$mode delphi}

interface

uses
  Classes, SysUtils, FileUtil, LazFileUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  ComCtrls, StdCtrls, Buttons;

{ TFormBuildFPCCross }

type

TBuildMode = (bmArmV6, bmArmV7a, bmX86, bmMipsel);

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
    { private declarations }
  public
    { public declarations }

    procedure LoadSettings(const fileName: string);
    procedure SaveSettings(const fileName: string);
    procedure CopyCrossUnits(const SourceDirName: string;  TargetDirName: string);

    function GetPrebuiltArmDirectory: string;

  end;

var
  FormBuildFPCCross: TFormBuildFPCCross;

implementation

{$R *.lfm}

uses
  IDEExternToolIntf, LazIDEIntf, IniFiles;

{ TFormBuildFPCCross }

function TFormBuildFPCCross.GetPrebuiltArmDirectory: string;
var
   pathToNdkToolchainsArm: string;
begin
   Result:= '';
   if FPathToAndroidNDK = '' then Exit;

   pathToNdkToolchainsArm:= FPathToAndroidNDK+DirectorySeparator+'toolchains'+DirectorySeparator+
                                                'arm-linux-androideabi-4.9'+DirectorySeparator+
                                                'prebuilt'+DirectorySeparator;

   {$ifdef windows}  //C:\adt32\ndk10e\toolchains\arm-linux-androideabi-4.9\prebuilt\windows
     if DirectoryExists(pathToNdkToolchainsArm+ 'windows') then
     begin
       Result:= 'windows';
       Exit;
     end;
     {$ifdef win64}
       if DirectoryExists(pathToNdkToolchainsArm + 'windows-x86_64') then Result:= 'windows-x86_64';
     {$endif}
   {$else}
     {$ifdef darvin}
        if DirectoryExists(pathToNdkToolchainsArm+ 'darwin-x86_64') then Result:= 'darwin-x86_64';
     {$else}
       {$ifdef cpu64}
         if DirectoryExists(pathToNdkToolchainsArm+ 'linux-x86_64') then Result:= 'linux-x86_64';
       {$else}
         if DirectoryExists(pathToNdkToolchainsArm+ 'linux-x86_32') then Result:= 'linux-x86_32';
       {$endif}
     {$endif}
   {$endif}
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
begin
   Button2.Enabled:= False;

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
      FPrebuildOSYS:= GetPrebuiltArmDirectory();

   configFile:= LazarusIDE.GetPrimaryConfigPath+ DirectorySeparator+ 'JNIAndroidProject.ini';

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

   //FBuildMode:= TBuildMode(RadioGroupInstruction.ItemIndex);

   if (FBuildMode = bmArmV6) or (FBuildMode = bmArmV7a)  then   //asm
   begin

      //C:\adt32\ndk10e\toolchains\arm-linux-androideabi-4.9\prebuilt\windows\bin
     binutilsPath:= FPathToAndroidNDK+DirectorySeparator+
                                 'toolchains'+DirectorySeparator+
                                 'arm-linux-androideabi-4.9'+DirectorySeparator+
                                 'prebuilt'+DirectorySeparator+
                                  FPrebuildOSYS+DirectorySeparator+
                                 'bin';

     if not DirectoryExists(binutilsPath)  then
     begin
        ShowMessage('Directory not exist! :"'+binutilsPath+'"');
        Button2.Enabled:= True;
        Exit;
     end;

     //------ brute force ... set path [below] did not work! why?
     CopyFile(binutilsPath+DirectorySeparator+'arm-linux-androideabi-as'+strExt,
              pathToFpcSource+DirectorySeparator+'compiler'+DirectorySeparator+'arm-linux-androideabi-as'+strExt);

     CopyFile(binutilsPath+DirectorySeparator+'arm-linux-androideabi-ld.bfd'+strExt,
              pathToFpcSource+DirectorySeparator+'compiler'+DirectorySeparator+'arm-linux-androideabi-ld.bfd'+strExt);

     CopyFile(binutilsPath+DirectorySeparator+'arm-linux-androideabi-ld'+strExt,
              pathToFpcSource+DirectorySeparator+'compiler'+DirectorySeparator+'arm-linux-androideabi-ld'+strExt);

     CopyFile(binutilsPath+DirectorySeparator+'arm-linux-androideabi-strip'+strExt,
              pathToFpcSource+DirectorySeparator+'compiler'+DirectorySeparator+'arm-linux-androideabi-strip'+strExt);
     //------------------

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
       Params.Add('OS_TARGET=android');
       Params.Add('CPU_TARGET=arm');

       //ref. http://wiki.freepascal.org/ARM_compiler_options
       //ref. http://wiki.freepascal.org/Android

       Params.Add('OPT="-dFPC_ARMEL"');  //Armel means that all floating point values are always passed in integer registers.

       if FBuildMode = bmArmV7a then  //                      //[FPU] vfpv3 means that fp operations are performed by the hardware.
          Params.Add('CROSSOPT="-CpARMv7a -Cf'+FFPUSet+'"')   //-OoFASTMATH to sacrifice precision for performance.
       else //default
          Params.Add('CROSSOPT="-CpARMv6 -CfSoft"');   //Softfp means that all fp operations are performed by software, no FPU support.

       //C:\adt32\ndk10e\toolchains\arm-linux-androideabi-4.9\prebuilt\windows\arm-linux-androideabi\bin
       crossBinDIR:= FPathToAndroidNDK+DirectorySeparator+
                        'toolchains'+DirectorySeparator+
                        'arm-linux-androideabi-4.9'+DirectorySeparator+
                        'prebuilt'+DirectorySeparator+
                         FPrebuildOSYS+DirectorySeparator+
                        'arm-linux-androideabi'+DirectorySeparator+
                        'bin';

       if not DirectoryExists(crossBinDIR)  then
       begin
          ShowMessage('Directory not exist! :"'+crossBinDIR+'"');
          Button2.Enabled:= True;
          Exit;
       end;

       Params.Add('CROSSBINDIR='+crossBinDIR);
       Params.Add('INSTALL_PREFIX='+ pathToFpcSource);

       Tool.Executable := AppendPathDelim(pathToFpcExecutables) + 'make'+strExt;
       Tool.CmdLineParams :=  Params.DelimitedText;
       Tool.Scanners.Add(SubToolDefault);

       if not RunExternalTool(Tool) then
         raise Exception.Create('Cannot Running Extern Tool [make]!');

     finally
       Tool.Free;
       Params.Free;
       StatusBar1.SimpleText:='Success! FPC cross x86 [Android] was Build!';
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
       ShowMessage('Directory not exist! :"'+binutilsPath+'"');
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
          ShowMessage('Directory not exist! :"'+crossBinDIR+'"');
          Button2.Enabled:= True;
          Exit;
       end;

       Params.Add('CROSSBINDIR='+crossBinDIR);
       Params.Add('INSTALL_PREFIX='+ pathToFpcSource);

       Tool.Executable := pathToFpcExecutables + DirectorySeparator+ 'make'+strExt;
       Tool.CmdLineParams :=  Params.DelimitedText;
       Tool.Scanners.Add(SubToolDefault);

       if not RunExternalTool(Tool) then
         raise Exception.Create('Cannot Run Extern [make] Tool!');

     finally
       Tool.Free;
       Params.Free;
       StatusBar1.SimpleText:='Success! FPC cross x86 [Android] was Build!';
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
       ShowMessage('Directory not exist! :"'+binutilsPath+'"');
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
          ShowMessage('Directory not exist! :"'+crossBinDIR+'"');
          Button2.Enabled:= True;
          Exit;
       end;

       Params.Add('CROSSBINDIR='+crossBinDIR);
       Params.Add('INSTALL_PREFIX='+ pathToFpcSource);

       Tool.Executable := pathToFpcExecutables + DirectorySeparator+ 'make'+strExt;
       Tool.CmdLineParams :=  Params.DelimitedText;
       Tool.Scanners.Add(SubToolDefault);

       if not RunExternalTool(Tool) then
         raise Exception.Create('Cannot Run Extern [make] Tool!');

     finally
       Tool.Free;
       Params.Free;
       StatusBar1.SimpleText:='Success! FPC cross Mipsel [Android] was Build!';
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
  FPCSysTarget:= auxList.Strings[auxList.Count-1];
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

  //linux
  strExt:= '';
  {$IFDEF WINDOWS}
     strExt:= '.exe';
  {$ENDIF}

  if (FBuildMode = bmArmV6) or (FBuildMode = bmArmV7a) then  //arm
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
      ShowMessage('Error. '+ sLineBreak+ fpcPathTrunk+DirectorySeparator+'compiler'+DirectorySeparator +'ppcrossarm'+strExt
                   +sLineBreak+'ppcrossarm not Exists. Please, you need "Build" it! ');
      Button3.Enabled:= True;
      Exit;
    end;

    binutilsPath:= pathToNDK+DirectorySeparator+
                                  'toolchains'+DirectorySeparator+
                                  'arm-linux-androideabi-4.9'+DirectorySeparator+
                                  'prebuilt'+DirectorySeparator+
                                   FPrebuildOSYS+DirectorySeparator+
                                  'bin';

    if not DirectoryExists(binutilsPath)  then
    begin
       ShowMessage('Directory not exist! :"'+binutilsPath+'"');
       Button3.Enabled:= True;
       Exit;
    end;

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

    ShowMessage('FPC cross arm [android] installed!');
    StatusBar1.SimpleText:='Success! FPC cross Arm [android] Installed!';
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
       ShowMessage('Error. '+ sLineBreak+ fpcPathTrunk+DirectorySeparator+'compiler'+DirectorySeparator +'ppcross386'+strExt
                   +sLineBreak+'ppcross386 not Exists. Please, you need "Build" it! ');
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
       ShowMessage('Directory not exist! :"'+binutilsPath+'"');
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

    ShowMessage('FPC cross x86 [android] installed!');
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
       ShowMessage('Error. '+ sLineBreak+ fpcPathTrunk+DirectorySeparator+'compiler'+DirectorySeparator +'ppcrossmipsel'+strExt
                   +sLineBreak+'ppcrossmipsel not Exists. Please, you need "Build" it! ');
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
       ShowMessage('Directory not exist! :"'+binutilsPath+'"');
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

    ShowMessage('FPC cross Mipsel [android] installed!');
    StatusBar1.SimpleText:='Success! FPC cross Mipsel [android] Installed!';
    //Self.Close;
  end;

  Button3.Enabled:= True;

end;

procedure TFormBuildFPCCross.FormActivate(Sender: TObject);
var
  configFile: string;
begin
  PageControl1.PageIndex:= 0;
  configFile:= LazarusIDE.GetPrimaryConfigPath + DirectorySeparator + 'JNIAndroidProject.ini';

  if FileExists(configFile) then
     Self.LoadSettings(configFile);

//  RadioGroupInstruction.ItemIndex:= 0;
  FBuildMode:= bmArmV6;

end;

procedure TFormBuildFPCCross.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  Self.SaveSettings(LazarusIDE.GetPrimaryConfigPath +  DirectorySeparator + 'JNIAndroidProject.ini' );
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
  end;

  if FPathToAndroidNDK <> '' then
    FPrebuildOSYS:= GetPrebuiltArmDirectory();

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
begin
  if FileExists(fileName) then
  begin
    with TIniFile.Create(fileName) do
    try
      FPathToAndroidNDK:= ReadString('NewProject','PathToAndroidNDK', '');
      FPrebuildOSYS:= ReadString('NewProject','PrebuildOSYS', '');
      EditPathToNDK.Text:= FPathToAndroidNDK;

      if FPrebuildOSYS = '' then
        if FPathToAndroidNDK <> '' then
          FPrebuildOSYS:= GetPrebuiltArmDirectory();

    finally
      Free;
    end;
  end;
end;

procedure TFormBuildFPCCross.SaveSettings(const fileName: string);
var
  list: TStringList;
begin
  if FileExists(fileName) then
  begin
    with TInifile.Create(fileName) do
    try
      WriteString('NewProject', 'pathToAndroidNDK', EditPathToNDK.Text);
    finally
      Free;
    end;
  end
  else
  begin
     list:= TStringList.Create;
     list.SaveToFile(fileName);
     list.Free;
     with TInifile.Create(fileName) do
     try

      if EditPathToNDK.Text <> '' then
        WriteString('NewProject', 'PathToAndroidNDK', Trim(EditPathToNDK.Text));


      if FPathToAndroidNDK <> '' then
         FPrebuildOSYS:= GetPrebuiltArmDirectory();

      if FPrebuildOSYS <> '' then
         WriteString('NewProject', 'PrebuildOSYS', FPrebuildOSYS);

     finally
      Free;
     end;
  end;
end;


end.

