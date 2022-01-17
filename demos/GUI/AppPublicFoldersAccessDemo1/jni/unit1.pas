{hint: Pascal files location: ...\AppPublicFoldersAccessDemo1\jni }
unit unit1;

{$mode delphi}

interface

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, AndroidWidget, Laz_And_Controls, intentmanager, And_jni;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    Button1: jButton;
    Button2: jButton;
    Button3: jButton;
    IntentManager1: jIntentManager;
    TextView1: jTextView;
    procedure AndroidModule1ActivityResult(Sender: TObject;
      requestCode: integer; resultCode: TAndroidResult; intentData: jObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    {private declarations}
  public
    {public declarations}
  end;

var
  AndroidModule1: TAndroidModule1;

implementation
  
{$R *.lfm}
  

{ TAndroidModule1 }

{

ref: https://developer.android.com/training/data-storage/shared/documents-files#java
ref: https://petrakeas.medium.com/android-10-11-storage-cheat-sheet-76866a989df4


 Android 11 - Api 30  has restricted developers to access devices folders (ex: "Download, Documents, ..., etc")
 Developers no longer have access to a file via its path. Instead, you need to use via “Uri“.

 LAMW: NEW jForm Uri based Api!

 //get user permission... and an uri
 procedure RequestCreateFile(_uriAsString: string; _fileMimeType: string; _fileName: string; _requestCode: integer);
 procedure RequestOpenFile(_uriAsString: string; _fileMimeType: string; _fileName: string; _requestCode: integer);
 procedure RequestOpenDirectory(_uriAsString: string; _requestCode: integer);

 //handling file by uri....
 function GetUriMetaData(_uri: jObject): TDynArrayOfString;
 function GetBitmapFromUri(_uri: jObject): jObject;
 function GetTextFromUri(_uri: jObject): string;
 procedure TakePersistableUriPermission(_uri: jObject);
 procedure SaveImageToUri(bitmap: jObject; _toUri: jObject);
 procedure SaveTextToUri(_text: string; _toUri: jObject);

}

procedure TAndroidModule1.AndroidModule1ActivityResult(Sender: TObject;
  requestCode: integer; resultCode: TAndroidResult; intentData: jObject);
var
  uri: jObject;
  arrayData: TDynArrayOfString;
  count, i: integer;
  contentText: string;
begin
   if resultCode = RESULT_OK then
   begin

      if  intentData = nil then
      begin
         ShowMessage('Sorry... data nil received...');
         Exit;
      end;

      uri:= IntentManager1.GetDataUri(intentData);

      if uri = nil then
      begin
         ShowMessage('Sorry... Uri nil received...');
         Exit;
      end;

      ShowMessage('Uri =' +Self.UriToString(uri));


      //Self.TakePersistableUriPermission(uri); //so, you don't need a new request for user when app resume from background


      if requestCode = 111 then  //create file
      begin
         ShowMessage('Success! Created File!');
         Self.SaveTextToUri('1. Hello Android 11 World!' + sLineBreak, uri);
      end;

      if requestCode = 222 then  //open file
      begin

         ShowMessage('Success! Open File!');

         contentText:= Self.GetTextFromUri(uri);
         ShowMessage(contentText);

         Self.SaveTextToUri(contentText + '2. New Text Content!' + sLineBreak , uri);

         //or if mimetype is "image/*"
         //ImageView.SetImage(Self.GetBitmapFromUri(uri));

         // or....
         //IntentManager1.SetAction(iaView);
         //IntentManager1.SetDataAndType(uri, 'text/plain');
         //IntentManager1.StartActivity();


      end;

      if requestCode = 333 then  //open directory tree
      begin


        arrayData:= Self.GetUriMetaData(uri);

        count:= Length(arrayData);

         ShowMessage('Success! Open Directory "count = '+ IntToStr(count)+'"' );

        for i:= 0 to count-1 do
        begin
           ShowMessage(arrayData[i]);
        end;

        SetLength(arrayData, 0);

      end;

   end;
end;


procedure TAndroidModule1.Button1Click(Sender: TObject);
begin
   Self.RequestCreateFile(Self.GetEnvironmentDirectoryPath(dirDownloads),
                          'text/plain',        //or other:  image/png or application/pdf  ... etc..
                          'hello.txt', 111);   //handled by "OnActivityResult"
end;

procedure TAndroidModule1.Button2Click(Sender: TObject);
begin
   Self.RequestOpenFile(Self.GetEnvironmentDirectoryPath(dirDownloads),
                          'text/plain',
                          'myhello.txt', 222);  //handled by "OnActivityResult"

end;

procedure TAndroidModule1.Button3Click(Sender: TObject);
begin
    Self.RequestOpenDirectory(Self.GetEnvironmentDirectoryPath(dirDownloads), 333); //handled by "OnActivityResult"
end;

end.
