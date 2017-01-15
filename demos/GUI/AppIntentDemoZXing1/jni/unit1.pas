{Hint: save all files to location: C:\adt32\eclipse\workspace\AppIntentDemoZXing1\jni }
unit unit1;

{$mode delphi}

interface

uses
    Classes, SysUtils, And_jni, And_jni_Bridge, Laz_And_Controls,
    Laz_And_Controls_Events, AndroidWidget, intentmanager;

type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jIntentManager1: jIntentManager;
    jListView1: jListView;
    jTextView1: jTextView;
    jTextView2: jTextView;
    procedure AndroidModule1ActivityResult(Sender: TObject;
      requestCode: integer; resultCode: TAndroidResult; intentData: jObject);
    procedure jListView1ClickItem(Sender: TObject; itemIndex: integer;
      itemCaption: string);
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

//ref. http://androidcookbook.com/Recipe.seam?recipeId=3324

procedure TAndroidModule1.jListView1ClickItem(Sender: TObject;
  itemIndex: integer; itemCaption: string);
begin
  //if jListView1.IsItemChecked(Item) then
  //begin
     jIntentManager1.SetAction('com.google.zxing.client.android.SCAN');
     if  jIntentManager1.IsCallable(jIntentManager1.GetIntent()) then
     begin
         //ShowMessage('ZXing App is Installed!! ');

         case itemIndex of
            0: jIntentManager1.PutExtraString('SCAN_MODE', 'PRODUCT_MODE');   //Prod
            1: jIntentManager1.PutExtraString('SCAN_MODE', 'QR_CODE_MODE');   //QR
            2: jIntentManager1.PutExtraString('SCAN_FORMATS', 'CODE_39,CODE_93,CODE_128,DATA_MATRIX,ITF'); //others
         end;

         //ZXing Barcode Scanner to scan for us
         jIntentManager1.StartActivityForResult(0);      //user-defined requestCode= 0

     end
     else  //download ZXing
     begin
        ShowMessage('Try downloading   ZXing App ...');
        if not Self.IsWifiEnabled() then Self.SetWifiEnabled(True);
        jIntentManager1.SetAction(jIntentManager1.GetActionViewAsString());
        //or jIntentManager1.SetAction('android.intent.action.VIEW');
        jIntentManager1.SetDataUri(jIntentManager1.ParseUri('market://search?q=pname:'+'com.google.zxing.client.android'));
        jIntentManager1.StartActivity();
     end;
  //end;
end;

procedure TAndroidModule1.AndroidModule1ActivityResult(Sender: TObject;
  requestCode: integer; resultCode: TAndroidResult; intentData: jObject);
begin
  if  requestCode =  0 then  //user-defined requestCode= 0
  begin
    if resultCode = RESULT_OK then  //ok
    begin
        ShowMessage('FORMAT: '+jIntentManager1.GetExtraString(intentData, 'SCAN_RESULT_FORMAT'));
        ShowMessage('CONTENT: '+jIntentManager1.GetExtraString(intentData, 'SCAN_RESULT'));
    end else ShowMessage('Fail/cancel to scan....');
  end;
end;

end.
