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
    ListView1: jListView;
    TextView1: jTextView;
    procedure AndroidModule1ActivityResult(Sender: TObject;
      requestCode: integer; resultCode: TAndroidResult; intentData: jObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure ListView1ClickItem(Sender: TObject; itemIndex: integer; itemCaption: string);
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

 //get user permission... and an valid "uri"
 procedure RequestCreateFile(_envPath: string; _fileMimeType: string; _fileName: string; _requestCode: integer);
 procedure RequestOpenFile(_envPath: string; _fileMimeType: string; _requestCode: integer);
 procedure RequestOpenDirectory(_envPath: string; _requestCode: integer);

 //handling file by uri....
 function GetBitmapFromUri(_uri: jObject): jObject;
 function GetTextFromUri(_uri: jObject): string;
 procedure TakePersistableUriPermission(_uri: jObject);

 function GetFileList(_treeUri: jObject): TDynArrayOfString; overload;
 function GetFileList(_treeUri: jObject; _fileExtension: string): TDynArrayOfString; overload;

 procedure SaveImageToUri(bitmap: jObject; _toUri: jObject);
 procedure SaveTextToUri(_text: string; _toUri: jObject);

}

procedure TAndroidModule1.AndroidModule1ActivityResult(Sender: TObject;
  requestCode: integer; resultCode: TAndroidResult; intentData: jObject);
var
  treeUri: jObject;
  arrayData: TDynArrayOfString;
  listData: TstringList;
  count, i: integer;
  contentText: string;

  outFileName, outUriValue: string;
begin
   if resultCode = RESULT_OK then
   begin

      if intentData = nil then
      begin
         ShowMessage('Sorry... data nil received...');
         Exit;
      end;

      treeUri:= IntentManager1.GetDataUri(intentData);

      //ShowMessage('dataUri = ' + IntentManager1.GetDataUriAsString(intentData) );

      if treeUri = nil then
      begin
         ShowMessage('Sorry... Uri nil received...');
         Exit;
      end;

      //ShowMessage('treeUri =' +Self.UriToString(treeUri));

      //Self.TakePersistableUriPermission(treeUri); //so, you don't need a new request for user when app resume from background

      if requestCode = 111 then  //create file
      begin
         ShowMessage('Success! Created File!');

         //Add content...
         Self.SaveTextToUri('1. Hello Android 11 World!' + sLineBreak, treeUri);
      end;

      if requestCode = 222 then  //open file
      begin

         //ShowMessage('Success! Open File!');

         contentText:= Self.GetTextFromUri(treeUri); //get content
         ShowMessage(contentText);

         //Add content..
         Self.SaveTextToUri(contentText + '2. New Text Content!' + sLineBreak , treeUri);

         // or....
         //IntentManager1.SetAction(iaView);
         //IntentManager1.SetDataAndType(treeUri, 'text/plain');
         //IntentManager1.StartActivity();

         //or if mimetype is "image/*"
         //ImageView.SetImage(Self.GetBitmapFromUri(treeUri));

         //or
         //IntentManager1.SetAction(iaView);
         //IntentManager1.SetDataAndType(treeUri, 'image/*');
         //IntentManager1.StartActivity();

      end;

      if requestCode = 333 then  //open directory tree
      begin

        arrayData:= Self.GetFileList(treeUri, '.txt'); //filter by file extension

        //or
        //arrayData:= Self.GetFileList(treeUri); // no filter

        listData:= Self.ToStringList(arrayData, ' ');

        count:= listData.Count;
        for i:= 0 to count-1 do
        begin
          listData.GetNameValue(i , outFileName, outUriValue);
          ListView1.Add(outFileName);
          ListView1.SetItemTagString(outUriValue, i); //hiden information
        end;

        SetLength(arrayData, 0);
        listData.Free;

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
                           222);  //handled by "OnActivityResult"

end;

procedure TAndroidModule1.Button3Click(Sender: TObject); //list directory content
begin
    Self.RequestOpenDirectory(Self.GetEnvironmentDirectoryPath(dirDownloads), 333); //handled by "OnActivityResult"
end;

procedure TAndroidModule1.ListView1ClickItem(Sender: TObject; itemIndex: integer; itemCaption: string);
var
  treeUri: jObject;
  contentText: string;
begin
  treeUri:= Self.ParseUri(ListView1.GetItemTagString(itemIndex)); // get hiden information

  contentText:= Self.GetTextFromUri(treeUri); //get file content
  ShowMessage('File: ' +itemCaption + sLineBreak + contentText);  //show content

  //or
  //IntentManager1.SetAction(iaView);
  //IntentManager1.SetDataAndType(treeUri, 'text/plain');  //or 'image/*'  or 'audio/mp3' or 'audio/*' or 'video/mp4'
  //IntentManager1.StartActivity();

end;


end.
