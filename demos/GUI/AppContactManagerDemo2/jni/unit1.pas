{Hint: save all files to location: C:\adt32\eclipse\workspace\AppContactManagerDemo2\jni }
unit unit1;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, And_jni_Bridge, Laz_And_Controls, 
    Laz_And_Controls_Events, AndroidWidget, contactmanager, imagefilemanager;

type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jButton1: jButton;
    jContactManager1: jContactManager;
    jImageFileManager1: jImageFileManager;
    jListView1: jListView;
    jProgressBar1: jProgressBar;
    jTextView1: jTextView;
    procedure AndroidModule1Create(Sender: TObject);
    procedure AndroidModule1JNIPrompt(Sender: TObject);
    procedure jButton1Click(Sender: TObject);
    procedure jContactManager1GetContactsFinished(Sender: TObject;
      count: integer);
    procedure jContactManager1GetContactsProgress(Sender: TObject;
      contactInfo: string; contactShortInfo: string;
      contactPhotoUriAsString: string; contactPhoto: jObject;
      progress: integer; out continueListing: boolean);
    procedure jListView1ClickItem(Sender: TObject; itemIndex: integer;
      itemCaption: string);
  private
    {private declarations}
    FInProgress: boolean;
  public
    {public declarations}
  end;

var
  AndroidModule1: TAndroidModule1;

implementation

{$R *.lfm}

{ TAndroidModule1 }

procedure TAndroidModule1.jButton1Click(Sender: TObject);
begin
  if not FInProgress then
  begin
     jButton1.Text:= 'Listing.. [wait]';
     jProgressBar1.Start;
     FInProgress:= True;
     jListView1.Clear;
     jContactManager1.GetContactsAsync('|'); //handled by OnGetContactsProgress ...
  end
  else ShowMessage('Please, wait....');
end;

procedure TAndroidModule1.jContactManager1GetContactsFinished(Sender: TObject; count: integer);
begin
  ShowMessage('Contacts count = '+ IntToStr(count));
  jButton1.Text:= 'List All Contacts';
  FInProgress:= False;
  jProgressBar1.Stop;
end;

procedure TAndroidModule1.jContactManager1GetContactsProgress(Sender: TObject;
  contactInfo: string; contactShortInfo: string;
  contactPhotoUriAsString: string; contactPhoto: jObject; progress: integer;
  out continueListing: boolean);
begin
   jListView1.Add(contactInfo,'|',colbrDefault{fontColor default},0{fontSize default},wgNone,'',contactPhoto);

  //jListView1.Add(contactInfo, '|'); //only text ....
  //jListView1.Add(contactShortInfo, '|'); //only text .... short info

  //continueListing = True //default <<----

  jProgressBar1.Progress:= jProgressBar1.Progress +1;
  if jProgressBar1.Progress >= jProgressBar1.Max then jProgressBar1.Progress:= 0;
end;

procedure TAndroidModule1.jListView1ClickItem(Sender: TObject;
  itemIndex: integer; itemCaption: string);
var
  //i: integer;
  captionParts: TStringList;
  contactInfoParts: TStringList;
  contactDisplayName: string;
begin

  //ShowMessage(caption);

  captionParts:= TStringList.Create;
  captionParts.Delimiter:= '|';
  captionParts.StrictDelimiter:= True;
  captionParts.DelimitedText:= itemCaption; //displayName|mobile|phone [Home]|phone [Work]|email|email|email|orgName|jobtitle| ...

  //ShowMessage(caption);
  {
  for i:=0 to infoParts.Count-1 do
  begin
     ShowMessage(captionParts.Strings[i]);
  end;
  }

   contactDisplayName:= captionParts.Strings[0];

   //jContactManager1.UpdateHomePhoneNumber(contactDisplayName, '06634014037');
  //jContactManager1.UpdateHomeEmail(contactDisplayName, 'jmp@hello.org.br');
  //jContactManager1.UpdateOrganization(contactDisplayName, 'FUFMT', 'Eng.');


  //just test 1!
  contactInfoParts:= TStringList.Create;
  contactInfoParts.Delimiter:= '|';
  contactInfoParts.StrictDelimiter:= True;

  //format: displayName|mobile|phone [Home]|phone [Work]|email|email|email|orgName|jobtitle| ... |photoUriAsString
  contactInfoParts.DelimitedText:= jContactManager1.GetContactInfo(contactDisplayName, '|');

  //just test 2!
  if contactInfoParts.Strings[contactInfoParts.Count-1] = ':)' then  // ':)' -->dummy [not valid photoUriAsString]
  begin
     jListView1.SetImageByIndex(jImageFileManager1.LoadFromResources('ic_launcher'), itemIndex);

     //if contact is in SIM card not will update photo ...
    jContactManager1.UpdatePhoto(contactDisplayName, jImageFileManager1.LoadFromResources('ic_launcher'));

      //Try again .. just test 3! //now there is a valid photoUriAsString [or not --> SIM card !]
    ShowMessage(jContactManager1.GetContactInfo(contactDisplayName, '|'));

  end;
  captionParts.Free;
  contactInfoParts.Free;
end;

procedure TAndroidModule1.AndroidModule1Create(Sender: TObject);
begin
  FInProgress:= False;
end;

procedure TAndroidModule1.AndroidModule1JNIPrompt(Sender: TObject);
begin
  jListView1.DispatchOnDrawItemBitmap(False);  //better performace!
  jListView1.DispatchOnDrawItemTextColor(False);  //better performace!
end;

end.
