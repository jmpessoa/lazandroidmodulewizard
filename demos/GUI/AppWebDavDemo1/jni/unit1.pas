// *****************************************************************************
// *****************************************************************************
//
//   The demo program is controlled by the "Web DAV Dialog" button on the main
// page and the pop-up menu on the "Load File" download page.
//   After selection, the Check Box "WebDAV"
// download page searches for files in FHostFDir on the FHostName server. The
// bottom status line displays the result of the file search operations. If the
// search is successful, the list of files will appear in the middle of the
// download page. To select operations with a specific file, select it and call
// the pop-up menu. The operations of deleting from the server, copying and
// moving to the local storage on the device should become available.
//   Select "Copy to local storage". A dialog with the same name appears. Click
// Ok and the process of copying the file to the device starts, displaying the
// progress and current percentage of completion. The file appears in the local
// storage, and the download page will show the files in the local storage. The
// commands in the reverse direction from the local storage to the server work
// in a similar way.
//
// *****************************************************************************
// *****************************************************************************

{hint: Pascal files location: ...\AppWebDAVDemo1\jni }

unit unit1;

{$mode delphi}

interface

uses
  cthreads,
  Classes, SysUtils, AndroidWidget, Laz_And_Controls, unit2, And_jni;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jButton1   : jButton;
    jPanel1    : jPanel;
    jPanel2    : jPanel;
    jTextView1 : jTextView;
    ImageView1 : jImageView;
    procedure AndroidModule1ActivityCreate(Sender: TObject; intentData: jObject);
    procedure jButton1Click(Sender: TObject);
  private
    {private declarations}
  public
    {public declarations}
    OpenD      : TDialCtrlLAMW;

    procedure        _Load_;
    procedure   Ctrls_Load_Close(Sender: TObject; Enter:Boolean);
  end;

var
  AndroidModule1: TAndroidModule1;

implementation
  
{$R *.lfm}
  

{ TAndroidModule1 }

procedure TAndroidModule1.jButton1Click(Sender: TObject);
begin
 _Load_;
end;{TAndroidModule1.jButton1Click}

procedure TAndroidModule1.AndroidModule1ActivityCreate(Sender: TObject;
  intentData: jObject);
begin
  CreateFileLoaderForm;             // Activity "Load/Save"
  OpenD      := TDialCtrlLAMW.Create(FileLoaderForm, False);
                                    // Create Open dialog
end;{TAndroidModule1.AndroidModule1ActivityCreate}

procedure TAndroidModule1._Load_;   // in GUI thread
begin
  OpenD.Filter      := 'Image (*.jpg)|*.jpg';
  OpenD.FilterIndex := 1;
  OpenD.OnClose     := Ctrls_Load_Close;
  OpenD.Show;
end;{TAndroidModule1._Load_}

procedure  TAndroidModule1.Ctrls_Load_Close(Sender: TObject; Enter:Boolean);
var                        FileName : String;
begin
  If Enter then
    begin
                           FileName :=  OpenD.FileName;
       jTextView1.Text  := FileName;
       ImageView1.SetImage(FileName);
    end;
end;{TAndroidModule1.Ctrls_Load_Close}


end.

