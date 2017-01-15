{Hint: save all files to location: C:\adt32\eclipse\workspace\AppContactManagerDemo1\jni }
unit unit1;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, And_jni_Bridge, Laz_And_Controls,
  Laz_And_Controls_Events, AndroidWidget, contactmanager,
  intentmanager;

type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jAsyncTask1: jAsyncTask;
    jButton1: jButton;
    jButton2: jButton;
    jContactManager1: jContactManager;
    jEditText1: jEditText;
    jEditText2: jEditText;
    jEditText3: jEditText;
    jEditText4: jEditText;
    jEditText5: jEditText;
    jEditText6: jEditText;
    jEditText7: jEditText;
    jEditText8: jEditText;
    jImageView1: jImageView;
    jIntentManager1: jIntentManager;
    jTextView1: jTextView;
    jTextView2: jTextView;
    jTextView3: jTextView;
    jTextView4: jTextView;
    jTextView5: jTextView;
    jTextView6: jTextView;
    jTextView7: jTextView;
    jTextView8: jTextView;
    jTextView9: jTextView;
    procedure AndroidModule1ActivityResult(Sender: TObject;
      requestCode: integer; resultCode: TAndroidResult; intentData: jObject);
    procedure AndroidModule1JNIPrompt(Sender: TObject);
    procedure jAsyncTask1DoInBackground(Sender: TObject; progress: integer; out
      keepInBackground: boolean);
    procedure jAsyncTask1PostExecute(Sender: TObject; progress: integer);
    procedure jButton1Click(Sender: TObject);
    procedure jButton2Click(Sender: TObject);

  private
    {private declarations}
    FPickImage: boolean;
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
  //jIntentManager1.SetAction('android.intent.action.PICK');
  //or jIntentManager1.IntentAction:= iaPick;
  //jIntentManager1.SetMimeType('image/*');      //or 'image/png' etc..  mimetype here must be lowercase!

  jIntentManager1.SetAction('android.media.action.IMAGE_CAPTURE');
  //or jIntentManager1.IntentAction:= iaImageCapture;

  jIntentManager1.StartActivityForResult(1001, 'Take/Pick a Contact Photo');      //user-defined requestCode=1001
end;


procedure TAndroidModule1.AndroidModule1ActivityResult(Sender: TObject;
  requestCode: integer; resultCode: TAndroidResult; intentData: jObject);
begin
  if  requestCode =  1001 then  //user-defined requestCode=1001
  begin
    if resultCode = RESULT_OK then  //ok
    begin
       //jImageView1.SetImageFromIntentResult(intentData);  //PICK from galery
      jImageView1.SetImageThumbnailFromCamera(intentData);  //take from camera
      FPickImage:= True;
    end
    else
    begin
      ShowMessage('Fail/cancel to pick/take a photo ....');
      FPickImage:= False;
    end;
  end;
end;

procedure TAndroidModule1.jButton2Click(Sender: TObject);
begin
  if not jAsyncTask1.Running then
     jAsyncTask1.Execute()
   else
     ShowMessage('Please, wait...');
end;

procedure TAndroidModule1.jAsyncTask1DoInBackground(Sender: TObject; progress: integer;
                                                                   out keepInBackground: boolean);
begin     //do not change/use GUI control here [DoInBackground] !!
  if FPickImage = True then
  begin
      //lock ....
      jContactManager1.AddContact( jEditText1.Text, jEditText2.Text,
                                   jEditText3.Text, jEditText4.Text,
                                   jEditText5.Text, jEditText6.Text,
                                   jEditText7.Text, jEditText8.Text,
                                   jImageView1.GetBitmapImage());

      keepInBackground:= False;  //done!
  end;
end;

procedure TAndroidModule1.jAsyncTask1PostExecute(Sender: TObject; progress: integer);
begin
   ShowMessage('Contact Added! Success !!!');
   jAsyncTask1.Done;
end;

procedure TAndroidModule1.AndroidModule1JNIPrompt(Sender: TObject);
begin
  jEditText1.SetFocus;
end;

end.
