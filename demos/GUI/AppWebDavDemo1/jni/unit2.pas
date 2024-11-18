unit unit2;

{$mode delphi}

interface

uses
  cthreads, syncobjs, Classes, SysUtils, AndroidWidget, Laz_And_Controls,
  Spinner, captionpanel, And_jni, customdialog, webdav,
  contextmenu, intentmanager, webdavcontrol;

type
// *****************************************************************************
// ***************************** TFileLoaderForm *******************************
// *****************************************************************************
  TEnvDirsSet     = Set of TEnvDirectory;
  TClosProc       = procedure(Sender: TObject; Enter:Boolean) of Object;

  TFileLoaderForm =
    Class(jForm)
        CaptP: jCaptionPanel;
//---------------------- File operation custom dialog --------------------------
        DialF             : jCustomDialog;
          DialF_MainP     : jPanel;
            DialF_PrgrP   : jPanel;
              DialF_FName : jTextView;
              DialF_PrgrB : jProgressBar;
              DialF_Label : jTextView;
            DialF_ButtP   : jPanel;
              DialF_OkBut : jButton;
        Timer             : jTimer;
//------------------------------------------------------------------------------
        Intnt: jIntentManager;
        jCMnu: jContextMenu;

        StatM: jTextView;
        jWebF: jCheckBox;

        jTextViewCaption: jTextView;

        MainP: jPanel;
        FName: jEditText;
        FType: jSpinner;
        FList: jListView;
        _Ok_B: jButton;
        CnclB: jButton;

        jWDav: jWebDav;

        procedure CnclBClick(Sender: TObject);

        procedure DialFBackKeyPressed(Sender: TObject; title: string);
        procedure DialFShow(Sender: TObject; dialog: jObject; title: string);
        procedure DialF_OkButClick(Sender: TObject);

        procedure FListClickItem(Sender: TObject; itemIndex: Integer;
                                 itemCaption: String);
        procedure FNameEnter(Sender: TObject);
        procedure FTypeItemSelected(Sender: TObject; itemCaption: String;
                                 itemIndex: Integer);
        procedure jWebFClick(Sender: TObject);

        procedure FileLoaderFormBackButton (Sender: TObject);
        procedure FileLoaderFormClickContextMenuItem(Sender: TObject;
          jObjMenuItem: jObject; itemID: Integer; itemCaption: String;
          checked: Boolean);
        procedure FileLoaderFormCreate(Sender: TObject);
        procedure FileLoaderFormCreateContextMenu(Sender: TObject;
          jObjMenu: jObject);
        procedure FileLoaderFormJNIPrompt  (Sender: TObject);
        procedure FileLoaderFormRequestPermissionResult(Sender: TObject;
                                 requestCode: Integer; manifestPermission: String;
                                 grantResult: TManifestPermissionResult);
        procedure FileLoaderFormShow(Sender: TObject);
        procedure _Ok_BClick(Sender: TObject);
        procedure jWDav_SetUserInfo;

      private
        {private declarations}
        F_OnClse     : TClosProc;
        F_NewFlt     : String;
        F_Filter     : String;
        F_FileNm     : String;
        F_Titles     : String;
        F_WrtExtStor : Boolean;
        F_CopyOn     : Boolean;
        F_Result     : Boolean;
        F_SaverOn    : Boolean;
        F_WebDAV     : TWebDavParser;
        F_SaveFName  : String;
        F_ResultStr  : String;
        F_ExhCmnd    : Integer;
        F_ExhPrgrVal : Integer;

        procedure  SetTitle      (ATitle    : String);                  virtual;
        procedure  SetFilter     (AFilter   : String);                  virtual;
        procedure  SetNewFlt     (ANewFlt   : String);                  virtual;

        function   GetFilterIndex           : Integer;                  virtual;
        procedure  SetFilterIndex(AInndex   : Integer);                 virtual;
        function   GetFileName              : String;                   virtual;
        procedure  SetFileName   (AFileName : String);                  virtual;

        function   GetFNameEditable         : Boolean;
        function   GetFNameValid            : Boolean;

        procedure  Delete_Local;
        procedure  DeleteWebDAV;
        function   CopyToWebDAV             : Boolean;
        procedure  MoveToWebDAV;
        function   CopyTo_Local             : Boolean;
        procedure  MoveTo_Local;
        function   SendTo_Email  (EMailAdr  : String = '') : Boolean;
        function   SendTo_WhApp  (WhAppPhN  : String = '') : Boolean;

        function   CopyCurFileToDir         (CopyPath,
                                             CopyName : String;
                                         var CurrName : String) : Boolean;
        procedure  OnStartExchFile;
        procedure  OnStop_ExchFile;

        procedure  PrgrsExchngFile(Sender:TObject; Position : Integer;
                                                   Size     : Integer);
        procedure  StartUpLoadFile;
        procedure  ResltUpLoadFile(Sender:TObject; ResStr   : String);
        procedure  DoResltUpLoadFile;

        procedure  StartDnLoadFile;
        procedure  ResltDnLoadFile(Sender:TObject; ResStr   : String);
        procedure  DoResltDnLoadFile;

        procedure  UpDateProgrInfo;
        function   GetFileProviderSharePath                 : String;

      public
        {public declarations}
        procedure  CallBackNotify(Sender: TObject);
        procedure  DoShow;

        procedure  FndFlsWeb(                 Folder, Mask : String);
        procedure  FindFiles(                 Folder, Mask : String);  overload;
        procedure  FindFiles(Dirs:TEnvDirsSet;        Mask : String);  overload;
        procedure  FindFiles(                         Mask : String);  overload;
        procedure  FindFiles;                                          overload;

        procedure  StatWebDAV(Cmd :String; Res:Boolean; Ret:String = '');

        procedure  CopyAllFilesFromAssetToInternalAppStorage;
        procedure  RequestRuntimePermission_WRITE_EXTERNAL_STORAGE;
//------------------------------------------------------------------------------
        property   Title       : String                      write SetTitle;
        property   Filter      : String  read F_Filter       write SetFilter;
        property   FilterIndex : Integer read GetFilterIndex write SetFilterIndex;
        property   FileName    : String  read GetFileName    write SetFileName;
        property   SaverOn     : Boolean read F_SaverOn      write F_SaverOn;
        property   WebDAV      : TWebDavParser
                                         read F_WebDAV       write F_WebDAV;
    end;

// *****************************************************************************
// ***************************** TTimrCtrlLAMW *********************************
// *****************************************************************************
  TTimeProc       = procedure of Object;
  TTimeCtrlLAMW   =
    Class(TObject)
      private
        F_Timer   : jTimer;
        F_OnTime  : TTimeProc;
        F_CritS   : TCriticalSection;
        F_Syncro  : Boolean;
        function    GetEnabled      : Boolean;
        procedure   SetEnabled(Enbl : Boolean);
      public
        constructor Create     (A_Timer : jTimer );
        procedure   OnTimer    (Sender  : TObject);
        procedure   Synchronize(AMethod : TTimeProc);
        property    Timer   : jTimer    read F_Timer    write F_Timer;
        property    OnTime  : TTimeProc read F_OnTime   write F_OnTime;
        property    Enabled : Boolean   read GetEnabled write SetEnabled;
    end;


var
  FileLoaderForm  : TFileLoaderForm;

procedure   CreateFileLoaderForm;  // creating a file loader form

type
// *****************************************************************************
// ***************************** TDialCtrlLAMW *********************************
// *****************************************************************************
  TDialCtrlLAMW     =
    Class(TObject)
      private
        F_Dialog  : TFileLoaderForm;
        F_Title   : String;
        F_InitDir : String;
        F_Saver   : Boolean;
      public
        constructor Create (ADialog : TFileLoaderForm;
                            A_Saver : Boolean);
        procedure   SetTitle      (Titl:String);                        virtual;
        function    GetFilter          :String;                         virtual;
        procedure   SetFilter     (Filt:String);                        virtual;
        function    GetFilterIndex     :Integer;                        virtual;
        procedure   SetFilterIndex(Indx:Integer);                       virtual;
        function    GetInitialDir      :String;                         virtual;
        procedure   SetInitialDir (IDir:String);                        virtual;
        function    GetFileName        :String;                         virtual;
        procedure   SetFileName   (Name:String);                        virtual;

        procedure   Show;                                               virtual;
        procedure   SetOnClose    (AOnClose:TClosProc);                 virtual;

        property    Dialog      : TFileLoaderForm read  F_Dialog write F_Dialog;
        property    Filter      : String          read  GetFilter
                                                  write SetFilter;
        property    FilterIndex : Integer         read  GetFilterIndex
                                                  write SetFilterIndex;
        property    InitialDir  : String          read  GetInitialDir
                                                  write SetInitialDir;
        property    FileName    : String          read  GetFileName
                                                  write SetFileName;
        property    OnClose     : TClosProc       write SetOnClose;
    end;


implementation

{$R *.lfm}

// *****************************************************************************
// ***************************** TFileLoaderForm *******************************
// *****************************************************************************
procedure  TFileLoaderForm.SetFilter(AFilter:String);
var  SList:TStringList; I:Integer;
begin
  If AFilter=F_Filter then Exit;
  try
    F_Filter              := AFilter;
    SList                 := TStringList.Create;
    SList.Delimiter       := '|';
    SList.StrictDelimiter := True;
    SList.DelimitedText   := Filter;

        FType.Clear;
    For  I:=0 to SList.Count-1 do
      If (I and $00001 = 0)and(SList.Strings[I] <> '') then
        FType.Add(SList.Strings[I]); // even substrings
  finally
    SList.Free;
  end;
end;{TFileLoaderForm.SetFilter}

procedure  TFileLoaderForm.SetNewFlt(ANewFlt:String);
begin
  F_NewFlt := ANewFlt;
end;{TFileLoaderForm.SetNewFlt}

procedure  TFileLoaderForm.StatWebDAV(Cmd :String; Res:Boolean; Ret:String);
var        T, S:String;
begin
  If Res then S:='| '+Cmd+' Ok:' else S:='| '+Cmd+' Er:'+Ret;
  T:=StatM.Text; T:=T+S+F_WebDAV.StatusLine;
  If 100<Length(T) then T:=Copy(T, Length(T)-100, Length(T));
     StatM.Text:=T;
end;{TFileLoaderForm.StatWebDAV}

procedure  TFileLoaderForm.jWDav_SetUserInfo;
begin
  jWDav.SetUserNameAndPassword(F_WebDAV.UserName, F_WebDAV.Password);
  jWDav.SetHostNameAndPort    (F_WebDAV.HostName, F_WebDAV.HostPort);
end;{TFileLoaderForm.jWDav_SetUserInfo;}

procedure  TFileLoaderForm.FndFlsWeb(Folder, Mask:String);
var Ext, ResStr:String; I:Integer; Ok:Boolean;
begin
//------------------------------------------------------------------------------
          jWDav_SetUserInfo;
  ResStr:=jWDav.PROPFIND(Folder);// ResStr - unparsed server response string
//------------------------------------------------------------------------------
                   Ok := F_WebDAV.CheckResponseCode   (ResStr, [201, 207]);
  StatWebDAV('PF', Ok);
  If               Ok then
    begin                        // ResStr - server response body string
                         Folder :=        F_WebDAV.HostName + Folder;
      F_WebDAV.XMLStrToDavResources(ResStr);
      For I:=0 to  F_WebDAV.WDResourceList.Count-1 do
        begin
                   Ext:=ExtractFileExt   (F_WebDAV.WDResourceList[I]{%H-}.DisplayName);
          If 0<Pos(Ext, Mask) then
             FList.Add  (Folder+PathDelim+F_WebDAV.WDResourceList[I]{%H-}.DisplayName);
        end;
    end
end;{TFileLoaderForm.FndFlsWeb}

procedure  TFileLoaderForm.FindFiles(Folder, Mask:String);
var SrR:TSearchRec; DosError:Integer;
begin
        DosError:=SysUtils.FindFirst(Folder+PathDelim+Mask, faAnyFile, SrR);
  While DosError=0 do
    begin
      If SrR.Attr and faDirectory <> 0 then  //  Directory
        If (SrR.Name<>'.') and (SrR.Name<>'..') then
                           FindFiles(Folder+PathDelim+SrR.Name, Mask)
                                                else
                                       else  //  File
                           FList.Add(Folder+PathDelim+SrR.Name);
        DosError:=SysUtils.FindNext (SrR);
    end;          SysUtils.FindClose(SrR);
end;{TFileLoaderForm.FindFiles}

procedure  TFileLoaderForm.FindFiles(Dirs:TEnvDirsSet;          Mask:String);
var    I:TEnvDirectory; MList:TStringList;  J:Integer;
begin
  For  I:=Low(I) to High(I) do
    If I in Dirs then
      begin
        try
          MList                 := TStringList.Create;
          MList.Delimiter       := ';';
          MList.StrictDelimiter := True;
          MList.DelimitedText   := Mask;
          For J:=0 to MList.Count-1 do
            If MList.Strings[J] <> '' then
              FindFiles(GetEnvironmentDirectoryPath(I), MList.Strings[J]);
        finally
          MList.Free;
        end;
      end;
end;{TFileLoaderForm.FindFiles}

procedure  TFileLoaderForm.FindFiles(Mask:String);
var               Dirs : TEnvDirsSet;
begin
  If jWebF.Checked then
    begin
        FndFlsWeb(F_WebDAV.HostFDir, Mask);
        FName.Text    := '';
        _Ok_B.Enabled := False;
    end            else
    begin
      If F_WrtExtStor then
                  Dirs := [dirDownloads, dirInternalAppStorage]
                      else
                  Dirs := [              dirInternalAppStorage];
        FindFiles(Dirs,              Mask);
    end;
end;{TFileLoaderForm.FindFiles}

procedure  TFileLoaderForm.FindFiles;
var SList:TStringList; I,J,K:Integer;
begin
  try
    SList                 := TStringList.Create;
    SList.Delimiter       := '|';
    SList.StrictDelimiter := True;
    SList.DelimitedText   := Filter;
    FList.Clear;
    J                     := 0;
    K                     := FType.SelectedIndex;
    For  I:=0 to SList.Count-1 do
      If(I and $00001 = 1)and(SList.Strings[I] <> '') then
        begin                        // odd substrings
           If  J=K then
               begin
                 FindFiles   (SList.Strings[I]);
                 Break;
               end;
           Inc(J);
        end;
  finally
    SList.Free;
  end;
end;{TFileLoaderForm.FindFiles;}

procedure  TFileLoaderForm.CopyAllFilesFromAssetToInternalAppStorage;
var DynA:TDynArrayOfString;  I, Count:Integer;
begin
  If F_CopyOn then Exit;
  DynA  := Self.GetAssetContentList('');
              Count := Length(DynA);
  For I:=0 to Count-1 do Self.CopyFromAssetsToInternalAppStorage(DynA[I]);
     F_CopyOn := True;
  SetLength(DynA, 0);
end;{TFileLoaderForm.CopyAllFilesFromAssetToInternalAppStorage;}

procedure  TFileLoaderForm.RequestRuntimePermission_WRITE_EXTERNAL_STORAGE;
var   manifestPermissions: Array of String;
begin
  If IsRuntimePermissionNeed then   // that is, target API >= 23  - Android 6
    begin
      SetLength(manifestPermissions{%H-}, 1);
     // hint: if you  get "write" permission then you have "read", too!
      manifestPermissions[0]:='android.permission.WRITE_EXTERNAL_STORAGE';
                                    // from AndroodManifest.xml
      Self.RequestRuntimePermission(manifestPermissions, 701);
      SetLength(manifestPermissions,      0);
    end;
end;{TFileLoaderForm.RequestRuntimePermission_WRITE_EXTERNAL_STORAGE}

procedure  TFileLoaderForm.CallBackNotify(Sender: TObject);
begin
  If Assigned(F_OnClse) then F_OnClse    (Sender, F_Result);
end;{TFileLoaderForm.CallBackNotify}

procedure  TFileLoaderForm.DoShow;
begin
  Self.InitShowing;
end;{TFileLoaderForm.DoShow;}

procedure  TFileLoaderForm.SetTitle      (ATitle    : String);
begin
  jTextViewCaption.Text := ATitle;
end;{TFileLoaderForm.SetTitle}

function   TFileLoaderForm.GetFilterIndex           : Integer;
begin
  Result:=FType.SelectedIndex;
end;{TFileLoaderForm.GetFilterIndex}

procedure  TFileLoaderForm.SetFilterIndex(AInndex   : Integer);
begin
//        FType.SelectedIndex:=AInndex;
end;{TFileLoaderForm.SetFilterIndex}

function   TFileLoaderForm.GetFileName              : String;
begin
  Result:=F_FileNm;
end;{TFileLoaderForm.GetFileName}

procedure  TFileLoaderForm.SetFileName   (AFileName : String);
begin
          F_FileNm:=  AFileName;
end;{TFileLoaderForm.SetFileName}

procedure  TFileLoaderForm.FileLoaderFormJNIPrompt(Sender: TObject);
begin
  CopyAllFilesFromAssetToInternalAppStorage;
//------------------------------------------------------------------------------
  If F_FileNm<>'' then FName.Text := F_FileNm;
  If F_Titles<>'' then Title      := F_Titles;

  If F_NewFlt<>'' then
    begin
      Filter := F_NewFlt; F_NewFlt := '';
    end           else
      Filter := 'Image (*.jpg)|*.jpg';
//------------------------------------------------------------------------------
  RequestRuntimePermission_WRITE_EXTERNAL_STORAGE;
  jCMnu.RegisterForContextMenu(FList.View);
end;{VersLoaderFormJNIPrompt}

procedure TFileLoaderForm.FileLoaderFormRequestPermissionResult(
  Sender: TObject; RequestCode: Integer; ManifestPermission: String;
  GrantResult: TManifestPermissionResult);
begin
  Case RequestCode of
    701 : begin
           F_WrtExtStor := grantResult = PERMISSION_GRANTED;
           FindFiles;
         end;
  end;
end;{TFileLoaderForm.VersLoaderFormRequestPermissionResult}

procedure TFileLoaderForm.FileLoaderFormShow(Sender: TObject);
begin
  If F_SaverOn then FName.SetFocus
               else FName.Text:='';
  FName.Editable := GetFNameEditable;
  _Ok_B.Enabled  := GetFNameValid;
  jWebF.Enabled  := Self.IsConnected;
  jWebF.Checked  := False;
end;{TFileLoaderForm.VersLoaderFormShow}

procedure TFileLoaderForm._Ok_BClick(Sender: TObject);
begin
  F_Result:=True;
  Self.Close;
end;{TFileLoaderForm._Ok_BClick}

procedure TFileLoaderForm.CnclBClick(Sender: TObject);
begin
  F_Result:=False;
  Self.Close;
end;{TFileLoaderForm.CnclBClick}

procedure TFileLoaderForm.FListClickItem(Sender: TObject;
  ItemIndex: Integer; ItemCaption: String);
begin
  F_FileNm      := ItemCaption;
  If jWebF.Checked then Exit;
  FName.Text    := ItemCaption;
  _Ok_B.Enabled := GetFNameValid;
end;{TFileLoaderForm.FListClickItem}

procedure TFileLoaderForm.FNameEnter(Sender: TObject);
begin
     _Ok_B.Enabled := GetFNameValid;
  If _Ok_B.Enabled then F_FileNm:=FName.Text;
end;{TFileLoaderForm.FNameEnter}

procedure TFileLoaderForm.FTypeItemSelected(Sender: TObject;
  ItemCaption: String; ItemIndex: Integer);
begin
  FindFiles;
end;{TFileLoaderForm.FTypeItemSelected}

procedure TFileLoaderForm.jWebFClick(Sender: TObject);
begin
  FindFiles;
end;{TFileLoaderForm.jWebFClick}

procedure TFileLoaderForm.FileLoaderFormBackButton(Sender: TObject);
begin
  F_Result:=False;
  Self.Close;
end;{TFileLoaderForm.VersLoaderFormBackButton}

procedure TFileLoaderForm.FileLoaderFormCreate(Sender: TObject);
begin
  F_WebDAV := TWebDavParser.Create;
end;{TFileLoaderForm.VersLoaderFormCreate}

const                                            mnuDelete_Local = 100;
                                                 mnuDeleteWebDAV = 101;
                                                 mnuCopyToWebDAV = 102;
                                                 mnuMoveToWebDAV = 103;
                                                 mnuCopyTo_Local = 104;
                                                 mnuMoveTo_Local = 105;
                                                 mnuSendTo_Email = 106;
                                                 mnuSendTo_WhApp = 107;

                          maxMenItem = 7;
  mnuPopUpMenu : Array[0..maxMenItem] of
    Record Nm: String;                       ID: Integer;         Web: Boolean end =
         ((Nm: 'Delete from local storage';  ID: mnuDelete_Local; Web: False),
          (Nm: 'Delete from WebDAV storage'; ID: mnuDeleteWebDAV; Web: True ),
          (Nm: 'Copy to WebDAV storage';     ID: mnuCopyToWebDAV; Web: False),
          (Nm: 'Move to WebDAV storage';     ID: mnuMoveToWebDAV; Web: False),
          (Nm: 'Copy to local storage';      ID: mnuCopyTo_Local; Web: True ),
          (Nm: 'Move to local storage';      ID: mnuMoveTo_Local; Web: True ),
          (Nm: 'Send to EMail';              ID: mnuSendTo_Email; Web: False),
          (Nm: 'Send to WhatsApp';           ID: mnuSendTo_WhApp; Web: False));

function  FindPopUpMenuID(AName:String; AWeb:Boolean):Integer;
var   I:Integer;
begin
  For I:=0 to maxMenItem do With  mnuPopUpMenu[I] do
    If (Nm=AName)and(Web=AWeb) then begin Result:=ID; Exit; end;
                                          Result:=0;
end;{FindPopUpMenuID}

function  FindPopUpMenuSt(AID : Integer):String;
var   I:Integer;
begin
  For I:=0 to maxMenItem do With  mnuPopUpMenu[I] do
    If AID=ID                  then begin Result:=Nm; Exit; end;
                                          Result:='';
end;{FindPopUpMenuSt}

procedure TFileLoaderForm.FileLoaderFormCreateContextMenu(Sender: TObject;
     jObjMenu: jObject);
var I:Integer; WebOn:Boolean;
begin
  If (jObjMenu <> Nil) and (F_FileNm <> '') then
    begin
          jCMnu.SetHeader(jObjMenu, ExtractFileName(F_FileNm), '');
          jCMnu.Options.Clear;
               WebOn  := jWebF.Checked;
          For I:=0 to maxMenItem  do With  mnuPopUpMenu[I] do
            If WebOn=Web then jCMnu.Options.Add(Nm);

      For I:=0 to jCMnu.Options.Count-1 do
        begin
          jCMnu.AddItem(jObjMenu,
            FindPopUpMenuID(jCMnu.Options.Strings[I], WebOn),
                            jCMnu.Options.Strings[I], mitDefault);
        end;
    end;
end;{TFileLoaderForm.VersLoaderFormCreateContextMenu}

procedure TFileLoaderForm.FileLoaderFormClickContextMenuItem(Sender: TObject;
  jObjMenuItem: jObject; itemID: Integer; itemCaption: String; Checked: Boolean);
begin

                             F_ExhCmnd := itemID; // command from menu
  DialF.Show(FindPopUpMenuSt(F_ExhCmnd));
end;{TFileLoaderForm.VersLoaderFormClickContextMenuItem}

procedure  TFileLoaderForm.Delete_Local;
begin
  If SysUtils.DeleteFile(F_FileNm) then
    begin FindFiles; FName.Text:=''; _Ok_B.Enabled := False; end;
end;{TFileLoaderForm.Delete_Local}

procedure  TFileLoaderForm.DeleteWebDAV;
var    DelFName,ResStr :String; I:Integer; Ok:Boolean;
begin
       DelFName:=ExtractFileName(F_FileNm);
  For I:=0 to   F_WebDAV.WDResourceList.   Count-1 do
    If DelFName=F_WebDAV.WDResourceList[I]{%H-}.DisplayName then
      begin
                  jWDav_SetUserInfo;
        ResStr := jWDav.DELETE(F_WebDAV.WDResourceList[I]{%H-}.Href);
                         Ok:=F_WebDAV.CheckResponseCode(ResStr,[200, 204, 207]);
        StatWebDAV('DL', Ok);
        If               Ok then FindFiles;
        Exit;
      end;
end;{TFileLoaderForm.DeleteWebDAV}

function  TFileLoaderForm.CopyToWebDAV:Boolean;
var   RemFName,ResStr :String;
begin
         Result:=SysUtils.FileExists(F_FileNm);
  If     Result then
    begin
      RemFName:=F_WebDAV.EncodeUTF8URI(F_WebDAV.HostFDir+PathDelim+
                                                    ExtractFileName(F_FileNm));
                jWDav_SetUserInfo;
      ResStr := jWDav.PUT(RemFName, F_FileNm);

         Result:=F_WebDAV.CheckResponseCode   (ResStr, [201]);
         StatWebDAV('PT', Result);
      If Result then
        begin
          jWebF.Checked := True;
          FindFiles;
        end;
    end;
end;{TFileLoaderForm.CopyToWebDAV;}

procedure  TFileLoaderForm.MoveToWebDAV;
var                                        SaveName : String;
begin
                                           SaveName := F_FileNm;
  If CopyToWebDAV then SysUtils.DeleteFile(SaveName);
end;{TFileLoaderForm.MoveToWebDAV;}

function  TFileLoaderForm.CopyTo_Local : Boolean;
var      CopFName,ResStr:String; I:Integer;       Dir:TEnvDirectory;
begin
         CopFName:=ExtractFileName(F_FileNm);
    For I:=0 to   F_WebDAV.WDResourceList.   Count-1 do
      If CopFName=F_WebDAV.WDResourceList[I]{%H-}.DisplayName then
        begin
                                                  Dir := dirInternalAppStorage;
                    jWDav_SetUserInfo;

          ResStr := jWDav.GET(F_WebDAV.WDResourceList[I]{%H-}.Href,
                      GetEnvironmentDirectoryPath(Dir)+PathDelim+CopFName);
                    DialF_PrgrB.Stop;
                    DialF.Close;

             Result := F_WebDAV.CheckResponseCode   (ResStr, [200, 204]);
             StatWebDAV('GT', Result);
          If Result then
            begin
              jWebF.Checked  := False;
              FindFiles;
              FName.Text     := '';
               _Ok_B.Enabled := False;
            end;
          Exit;
        end;  Result:=False;
end;{TFileLoaderForm.CopyTo_Local;}

procedure  TFileLoaderForm.MoveTo_Local;
var   SaveName : String;
begin
      SaveName:=F_FileNm;
  If CopyTo_Local then
    begin
      F_FileNm:=SaveName;
      DeleteWebDAV;
    end;
end;{TFileLoaderForm.MoveTo_Local;}

procedure TFileLoaderForm.DialFShow(Sender: TObject; dialog: jObject; title: string);
begin
          F_ExhPrgrVal        := 0;
          DialF_FName.Text    := ExtractFileName(F_FileNm);
          DialF_PrgrB.Stop;
          DialF_Label.Text    := ' ';
          DialF_OkBut.Enabled := True;
          DialF.Cancelable    := False;
          Self.UpdateLayout;
end;{TFileLoaderForm.DialFShow}

procedure TFileLoaderForm.DialF_OkButClick(Sender: TObject);
begin
  Case F_ExhCmnd of
    mnuDelete_Local :
      begin
        DialF.Close;
        Delete_Local;  // delete file from local storage
      end;

    mnuDeleteWebDAV :
      begin
        DialF.Close;
        DeleteWebDAV;  // delete file from WebDAV storage
      end;

    mnuSendTo_Email :
      begin
        DialF.Close;
        SendTo_Email;  // send file to E-Mail
      end;

    mnuSendTo_WhApp :
      begin
        DialF.Close;
        SendTo_WhApp;  // send file to WhApp
      end;

    mnuCopyToWebDAV,   // copy file from local to WebDAV
    mnuMoveToWebDAV :  // move file from local to WebDAV
        StartUpLoadFile;

    mnuCopyTo_Local,   // copy file from WebDAV to local storage
    mnuMoveTo_Local :  // move file from WebDAV to local storage
        StartDnLoadFile;

    else DialF.Close;
  end;
end;{TFileLoaderForm.DialF_OkButClick}

procedure TFileLoaderForm.DialFBackKeyPressed(Sender: TObject; title: string);
begin
  If  DialF_OkBut.Enabled then
    begin
      DialF.Close;
    end;
end;{TFileLoaderForm.DialFBackKeyPressed}

//-------------------- UpLoadFile и DnLoadFile ---------------------------------

var          vlfTimeCtrlLAMW : TTimeCtrlLAMW = Nil;
                                      // local synchronizer with GUI thread

function     GetTimeCtrlLAMW : TTimeCtrlLAMW;
begin
 If Assigned(vlfTimeCtrlLAMW) then else
             vlfTimeCtrlLAMW := TTimeCtrlLAMW.Create(FileLoaderForm.Timer);
 Result :=   vlfTimeCtrlLAMW;
end;{GetTimeCtrlLAMW}


procedure  TFileLoaderForm.OnStartExchFile;
begin
  F_SaveFName                 := F_FileNm;
  DialF_OkBut.Enabled         := False;
  DialF_PrgrB.Start;
  GetTimeCtrlLAMW.Enabled     := True;
end;{TFileLoaderForm.OnStartExchFile;}


procedure  TFileLoaderForm.OnStop_ExchFile;
begin
  GetTimeCtrlLAMW.Enabled     := False;
  DialF_PrgrB.Stop;
  DialF.Close;
end;{TFileLoaderForm.OnStop_ExchFile;}

// PrgrsExchngFile is called from Java threads inside UpLoadFile and DnLoadFile

procedure  TFileLoaderForm.PrgrsExchngFile(Sender:TObject; Position : Integer;
                                                          Size     : Integer);
var   OldVal : Integer;
begin
      OldVal :=     Self.F_ExhPrgrVal;
  If (0<Size)and(0<=Position)and(Position<=Size)
            then Self.F_ExhPrgrVal := (100*Int64(Position)) div Size
            else Self.F_ExhPrgrVal :=   0;
  If      100 <  Self.F_ExhPrgrVal  then Self.F_ExhPrgrVal := 100;

  If (OldVal <>  Self.F_ExhPrgrVal) then
    GetTimeCtrlLAMW.Synchronize(Self.UpDateProgrInfo);
end;{TFileLoaderForm.PrgrsExchngFile}

procedure  TFileLoaderForm.UpDateProgrInfo;
begin
  DialF_PrgrB.Progress :=          F_ExhPrgrVal;
  DialF_Label.Text     := IntToStr(F_ExhPrgrVal);
end;{TFileLoaderForm.UpDateProgrInfo}

function   TFileLoaderForm.GetFileProviderSharePath : String;
begin
//----------- "$(ProjectDir)/res/xml/support_provider_paths.xml" ---------------
//----------- <cache-path name="sharedimages" path="share/" />   ---------------
  Result := GetEnvironmentDirectoryPath(dirCache) + PathDelim + 'share';
end;{TFileLoaderForm.GetFileProviderSharePath}

procedure  TFileLoaderForm.StartUpLoadFile;
var   RemFName : String;
begin
  If     SysUtils.FileExists       (F_FileNm) then
    begin
      RemFName:=F_WebDAV.EncodeUTF8URI(F_WebDAV.HostFDir+PathDelim+
                                                    ExtractFileName(F_FileNm));
      OnStartExchFile;
      jWDav_SetUserInfo;
      jWDav.OnWebDavGetProgress  := PrgrsExchngFile;
      jWDav.OnWebDavGetResultStr := ResltUpLoadFile;
      jWDav.UpLoadFile(RemFName,    F_FileNm);
    end;
end;{TFileLoaderForm.StartUpLoadFile;}

// ResltUpLoadFile is called from a Java thread inside UpLoadFile

procedure  TFileLoaderForm.ResltUpLoadFile(Sender:TObject; ResStr:String);
begin
  F_ResultStr := ResStr;
  GetTimeCtrlLAMW.Synchronize(Self.DoResltUpLoadFile);
end;{TFileLoaderForm.ResltUpLoadFile}

procedure  TFileLoaderForm.DoResltUpLoadFile;
var  Ok : Boolean;
begin
     OnStop_ExchFile;
     Ok := F_WebDAV.CheckResponseCode(F_ResultStr, [201]);
     StatWebDAV('PT', Ok, F_ResultStr);
  If Ok then
   begin
     If F_ExhCmnd = mnuMoveToWebDAV then SysUtils.DeleteFile(F_SaveFName);
     jWebF.Checked := True;
     FindFiles;
   end; F_ExhCmnd := 0;
end;{TFileLoaderForm.DoResltUpLoadFile;}

procedure  TFileLoaderForm.StartDnLoadFile;
var    CopFName:String; I:Integer;    Dir : TEnvDirectory;
begin
       CopFName:=ExtractFileName(F_FileNm);
  For I:=0 to   F_WebDAV.WDResourceList.   Count-1 do
    If CopFName=F_WebDAV.WDResourceList[I]{%H-}.DisplayName then
      begin
        OnStartExchFile;
                                      Dir := dirInternalAppStorage;
        jWDav_SetUserInfo;
        jWDav.OnWebDavGetProgress  := PrgrsExchngFile;
        jWDav.OnWebDavGetResultStr := ResltDnLoadFile;

        jWDav.DnLoadFile(F_WebDAV.WDResourceList[I]{%H-}.Href,
          GetEnvironmentDirectoryPath(Dir)+PathDelim+CopFName);
        Exit;
      end;
end;{TFileLoaderForm.StartDnLoadFile}

// ReslDnLoadFile is called from a Java thread inside DnLoadFile

procedure  TFileLoaderForm.ResltDnLoadFile(Sender:TObject; ResStr:String);
begin
  F_ResultStr := ResStr;
  GetTimeCtrlLAMW.Synchronize(Self.DoResltDnLoadFile);
end;{TFileLoaderForm.ResltDnLoadFile}

procedure  TFileLoaderForm.DoResltDnLoadFile;
var   Ok : Boolean;
begin
      OnStop_ExchFile;
      Ok := F_WebDAV.CheckResponseCode (F_ResultStr, [200, 204]);
      StatWebDAV('GT', Ok, F_ResultStr);
  If  Ok then
    begin
      jWebF.Checked := False;
      FindFiles;
      FName.Text    := '';
      _Ok_B.Enabled := False;
      If F_ExhCmnd = mnuMoveTo_Local then
        begin
          F_FileNm  := F_SaveFName;
          DeleteWebDAV;
        end;
    end;  F_ExhCmnd := 0;
end;{TFileLoaderForm.DoResltDnLoadFile;}

//------------------------------------------------------------------------------

function   TFileLoaderForm.SendTo_Email(EMailAdr : String) : Boolean;
var I : Integer; URI : jObject; CurrName, SharePath : String;
begin
         Result := SysUtils.FileExists(F_FileNm);
  If     Result then
    begin
                                    SharePath := GetFileProviderSharePath;
         Result := CopyCurFileToDir(SharePath, F_FileNm, CurrName{%H-});
      If Result then
        begin
//---------- Get URI for use in "org.lamw.appwebdavdemo1.fileprovider" ---------
          URI := Intnt.FileProviderGetUriForFile(SharePath+PathDelim+CurrName);

//---------- Mailto: Subject, Body and attach file URI -------------------------
          Intnt.SetAction  (Intnt.GetActionSendToAsString());
          Intnt.SetDataUri (Intnt.GetMailtoUri(EMailAdr));
          Intnt.PutExtraMailSubject('Data "'+CurrName+'"'     );
          Intnt.PutExtraMailBody   ('Data "'+CurrName+'" from LAMW program.');
          Intnt.AddFlag(ifGrantReadUriPermission);
          Intnt.PutExtraFile(URI);

//---------- Set Read & Write URI Permission for all Intent Packages -----------
          Intnt.GetShareItemsClear;
          For I := 0 to Intnt.GetShareItemsCount() - 1 do
            Intnt.SetShareItemPackageUriPermission(I, URI, 0);

//---------- Resolve and start Activity ----------------------------------------
             Result := Intnt.ResolveActivity;
          If Result then
             Intnt.StartActivity(' Send Email from LAMW ')
                    else
             ShowMessage('Sorry, not find an application that fulfills the requirement ...');
        end;
    end;
end;{TFileLoaderForm.SendTo_Email}

function   TFileLoaderForm.SendTo_WhApp(WhAppPhN  : String) : Boolean;
var I : Integer; URI : jObject;  SharePath, WhatsUp, CurrName : String;
begin
//----------- "$(ProjectDir)/AndroidManifest.xml"  (API>=30) -------------------
//                             <queries>
//                               <package android:name="com.whatsapp" />
//                               <package android:name="com.whatsapp.w4b" />
//                             </queries>
//------------------------------------------------------------------------------
                                            WhatsUp := 'com.whatsapp';
         Result := Intnt.IsPackageInstalled(WhatsUp);
  If     Result then else
    begin
                                            WhatsUp := 'com.whatsapp.w4b';
         Result := Intnt.IsPackageInstalled(WhatsUp);
      If Result then else Exit;
    end;
         Result := SysUtils.FileExists(F_FileNm);
  If     Result then
    begin
                                    SharePath := GetFileProviderSharePath;
         Result := CopyCurFileToDir(SharePath, F_FileNm, CurrName{%H-});
      If Result then
        begin
//---------- Get URI for use in "org.lamw.appwebdavdemo1.fileprovider" ---------
          URI := Intnt.FileProviderGetUriForFile(SharePath+PathDelim+CurrName);

//---------- "android.intent.action.SEND" --------------------------------------
          Intnt.SetAction(Intnt.GetActionSendAsString());
          Intnt.SetPackage                 (WhatsUp);
          Intnt.AddFlag(ifGrantReadUriPermission);
          Intnt.PutExtraFile(URI);
          Intnt.SetMimeType('image/jpg');

//---------- Set Read & Write URI Permission for Package "com.whatsapp" --------
          Intnt.GetShareItemsClear;
          For I := 0 to Intnt.GetShareItemsCount() - 1 do
            Intnt.SetShareItemPackageUriPermission(I, URI, 0);

             Result := Intnt.ResolveActivity;
          If Result then
             Intnt.StartActivity
                    else
             ShowMessage('Sorry, not find an application that fulfills the requirement ...');
        end;
    end;
end;{TFileLoaderForm.SendTo_WhApp}


function   TFileLoaderForm.CopyCurFileToDir        (CopyPath,
                                                    CopyName : String;
                                                var CurrName : String) : Boolean;
begin
  If DirectoryExists(CopyPath) then else
               MkDir(CopyPath);

  CurrName :=ExtractFileName  (CopyName);

  If Pos(CopyPath, CopyName) <> 1
    then Result:=Self.CopyFile(CopyName, CopyPath + PathDelim + CurrName)
    else Result:=True;
end;{TFileLoaderForm.CopyCurFileToDir}

function   TFileLoaderForm.GetFNameEditable : Boolean;
begin
     Result:=F_SaverOn;
end;{TFileLoaderForm.GetFNameEditable}

function   TFileLoaderForm.GetFNameValid    : Boolean;
begin
     Result:=FName.Text<>'';
  If Result and F_SaverOn then
     Result:= Self.DirectoryExists(ExtractFileDir(FName.Text));
end;{TFileLoaderForm.GetFNameValid}

// *****************************************************************************
// ***************************** TTimrCtrlLAMW *********************************
// *****************************************************************************
constructor TTimeCtrlLAMW.Create(A_Timer : jTimer);
begin
              F_Timer         := A_Timer;
              F_OnTime        := Nil;
              F_CritS         := TCriticalSection.Create;
              F_Timer.OnTimer := Self.OnTimer;
              F_Timer.Interval:= 10;
              F_Timer.Enabled := True;
end;{TTimeCtrlLAMW.Create}

procedure   TTimeCtrlLAMW.OnTimer(Sender  : TObject);
begin
  If Assigned(F_OnTime) then
    begin
              F_OnTime;            // call procedure F_OnTime in the main thread
              F_OnTime := Nil;     // F_OnTime re-call block
              F_Syncro := False;   // sign of the end of synchronization
    end                 else
//            F_Syncro := False;   // sign of the end of synchronization
end;{TTimeCtrlLAMW.OnTimer}

procedure   TTimeCtrlLAMW.Synchronize(AMethod : TTimeProc);
begin
              F_CritS.Enter;       // entering a critical section of code
              F_OnTime := AMethod; // setting procedure for main thread
              F_Syncro := True;    // synchronization progress indicator
  While       F_Syncro do Sleep(0);// waiting for synchronization to complete
              F_CritS.Leave;       // exit from critical section of code
end;{TTimeCtrlLAMW.Synchronize}

function    TTimeCtrlLAMW.GetEnabled      : Boolean;
begin
  Result :=   F_Timer.Enabled;
end;

procedure   TTimeCtrlLAMW.SetEnabled(Enbl : Boolean);
begin
             F_Timer.Enabled :=      Enbl;
end;

// *****************************************************************************
// ***************************** TDialCtrlLAMW *********************************
// *****************************************************************************
procedure   CreateFileLoaderForm;
begin
  gApp.CreateForm               (TFileLoaderForm, FileLoaderForm);
  FileLoaderForm.SetCloseCallBack(FileLoaderForm.CallBackNotify, FileLoaderForm);
  FileLoaderForm.PromptOnBackKey  := False;
  FileLoaderForm.F_SaverOn        := False;
end;{CreateFileLoaderForm}

constructor TDialCtrlLAMW.Create (  ADialog : TFileLoaderForm;
                                    A_Saver : Boolean);
begin
  F_Dialog:= ADialog;
  F_Saver := A_Saver;
end;{TDialCtrlLAMW.Create}

procedure   TDialCtrlLAMW.SetTitle      (Titl:String);
begin
  F_Title := Titl;
end;{TDialCtrlLAMW.SetTitle}

function    TDialCtrlLAMW.GetFilter          :String;
begin
  Result:=Dialog.Filter;
end;{TDialCtrlLAMW.GetFilter}

procedure   TDialCtrlLAMW.SetFilter     (Filt:String);
begin
          Dialog.F_NewFlt:=Filt;
end;{TDialCtrlLAMW.SetFilter}

function    TDialCtrlLAMW.GetFilterIndex     :Integer;
begin
  Result:=Dialog.FilterIndex;
end;{TDialCtrlLAMW.GetFilterIndex}

procedure   TDialCtrlLAMW.SetFilterIndex(Indx:Integer);
begin
          Dialog.FilterIndex:=Indx;
end;{TDialCtrlLAMW.SetFilterIndex}

function    TDialCtrlLAMW.GetInitialDir      :String;
begin
  Result:=F_InitDir;
end;{TDialCtrlLAMW.GetInitialDir}

procedure   TDialCtrlLAMW.SetInitialDir (IDir:String);
begin
          F_InitDir := IDir;
end;{TDialCtrlLAMW.SetInitialDir}

function    TDialCtrlLAMW.GetFileName        :String;
begin
  Result:=Dialog.FileName;
end;{TDialCtrlLAMW.GetFileName}

procedure   TDialCtrlLAMW.SetFileName   (Name:String);
begin
          Dialog.FileName:=Name;
end;{TDialCtrlLAMW.SetFileName}

procedure   TDialCtrlLAMW.Show;
begin
  If F_Title<>'' then Dialog.F_Titles := F_Title;
                      Dialog.SaverOn  := F_Saver;
                      Dialog.DoShow;
end;{TDialCtrlLAMW.Show;}

procedure   TDialCtrlLAMW.SetOnClose    (AOnClose:TClosProc);
begin
                      Dialog.F_OnClse := AOnClose;
end;{TDialCtrlLAMW.SetOnClose}




end.
