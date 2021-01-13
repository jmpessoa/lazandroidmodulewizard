{Hint: save all files to location: C:\lamw\workspace\AppCompatAdMobDemo1\jni }
unit unit1;

{$mode delphi}

interface

uses
  Classes, SysUtils, AndroidWidget, Laz_And_Controls, sadmob, And_jni,
  scardview, stoolbar, snavigationview, sdrawerlayout, snestedscrollview,
  srecyclerview;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    btReward: jButton;
    btBanner: jButton;
    jButton2: jButton;
    btInter: jButton;
    jsAdMob1: jsAdMob;
    jsAdMob2: jsAdMob;
    lbInfo: jTextView;
    procedure AndroidModule1ActivityCreate(Sender: TObject; intentData: jObject
      );
    procedure AndroidModule1Rotate(Sender: TObject; rotate: TScreenStyle);
    procedure AndroidModule1Show(Sender: TObject);
    procedure btBannerClick(Sender: TObject);
    procedure btInterClick(Sender: TObject);
    procedure btRewardClick(Sender: TObject);
    procedure jButton2Click(Sender: TObject);
    procedure jsAdMob1AdMobClicked(Sender: TObject; admobType: TAdMobType);
    procedure jsAdMob1AdMobClosed(Sender: TObject; admobType: TAdMobType);
    procedure jsAdMob1AdMobFailedToLoad(Sender: TObject; admobType: TAdMobType;
      errorCode: integer);
    procedure jsAdMob1AdMobInitializationComplete(Sender: TObject);
    procedure jsAdMob1AdMobLeftApplication(Sender: TObject;
      admobType: TAdMobType);
    procedure jsAdMob1AdMobLoaded(Sender: TObject; admobType: TAdMobType);
    procedure jsAdMob1AdMobOpened(Sender: TObject; admobType: TAdMobType);
    procedure jsAdMob1AdMobRewardedFailedToShow(Sender: TObject;
      errorCode: integer);
    procedure jsAdMob1AdMobRewardedUserEarned(Sender: TObject);
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
//hint: [must!] using  "AppCompat"  theme!!!
procedure TAndroidModule1.btBannerClick(Sender: TObject);
begin
 ShowMessage('wait... AdMob is Running...');

 jsAdMob1.AdMobBannerRun();
 jsAdMob2.AdMobBannerRun();
 jsAdmob1.AdMobInterCreateAndLoad();
 jsAdmob1.AdMobRewardedCreateAndLoad();
end;

procedure TAndroidModule1.btInterClick(Sender: TObject);
begin
  if jsAdMob1.AdMobInterIsLoaded() then
   jsAdmob1.AdMobInterShow()
  else
   showmessage('Not AdMobInterIsLoaded!');
end;

procedure TAndroidModule1.btRewardClick(Sender: TObject);
begin
  if jsAdMob1.AdMobRewardedIsLoaded() then
   jsAdmob1.AdMobRewardedShow()
  else
   showmessage('Not AdMobRewardedIsLoaded!');
end;

procedure TAndroidModule1.jButton2Click(Sender: TObject);
begin
  jsAdMob2.AdMobBannerStop();
end;

procedure TAndroidModule1.jsAdMob1AdMobClicked(Sender: TObject;
  admobType: TAdMobType);
begin
  if admobType = adsBanner then
   showmessage('AdMobClicked adsBanner')
  else if admobType = adsInterstitial then
    showmessage('AdMobClicked adsInterstitial')
  else
    showmessage('AdMobClicked adsRewarded');
end;

procedure TAndroidModule1.jsAdMob1AdMobClosed(Sender: TObject;
  admobType: TAdMobType);
begin
  if admobType = adsBanner then
   showmessage('AdMobClosed adsBanner')
  else if admobType = adsInterstitial then
    showmessage('AdMobClosed adsInterstitial')
  else
  begin
    showmessage('AdMobClosed adsRewarded');
    jsAdMob1.AdMobRewardedCreateAndLoad();
  end;
end;

procedure TAndroidModule1.jsAdMob1AdMobFailedToLoad(Sender: TObject;
  admobType: TAdMobType; errorCode: integer);
begin
  if admobType = adsBanner then
   showmessage('AdMobFailedToLoad adsBanner')
  else if admobType = adsInterstitial then
    showmessage('AdMobFailedToLoad adsInterstitial')
  else
    showmessage('AdMobFailedToLoad adsRewarded');
end;

procedure TAndroidModule1.jsAdMob1AdMobInitializationComplete(Sender: TObject);
begin
  showmessage('Initialization Complete!');
end;

procedure TAndroidModule1.jsAdMob1AdMobLeftApplication(Sender: TObject;
  admobType: TAdMobType);
begin
  if admobType = adsBanner then
   showmessage('AdMobLeftApplication adsBanner')
  else if admobType = adsInterstitial then
    showmessage('AdMobLeftApplication adsInterstitial')
  else
    showmessage('AdMobLeftApplication adsRewarded');
end;

procedure TAndroidModule1.jsAdMob1AdMobLoaded(Sender: TObject;
  admobType: TAdMobType);
begin
  if admobType = adsBanner then
   showmessage('AdMobLoaded adsBanner')
  else if admobType = adsInterstitial then
    showmessage('AdMobLoaded adsInterstitial')
  else
    showmessage('AdMobLoaded adsRewarded');
end;

procedure TAndroidModule1.jsAdMob1AdMobOpened(Sender: TObject;
  admobType: TAdMobType);
begin
  if admobType = adsBanner then
   showmessage('AdMobOpened adsBanner')
  else if admobType = adsInterstitial then
    showmessage('AdMobOpened adsInterstitial')
  else
    showmessage('AdMobOpened adsRewarded');
end;

procedure TAndroidModule1.jsAdMob1AdMobRewardedFailedToShow(Sender: TObject;
  errorCode: integer);
begin
  showmessage('AdMobRewardedFailedToShow');
end;

procedure TAndroidModule1.jsAdMob1AdMobRewardedUserEarned(Sender: TObject);
begin
  showmessage('Reward user earned');
end;

procedure TAndroidModule1.AndroidModule1ActivityCreate(Sender: TObject;
  intentData: jObject);
begin
 // AdMobInit should only be called once for the same id
 // This is the most time consuming when initializing AdMob
 // It is usually placed in the OnCreate event
 jsAdMob1.AdMobInit();

 jsAdMob1.AdMobBannerSetId('ca-app-pub-3940256099942544/6300978111');  //warning: just test key!!!!
 jsAdMob1.AdMobInterSetId('ca-app-pub-3940256099942544/1033173712');   //warning: just test key!!!!
 jsAdMob1.AdMobRewardedSetId('ca-app-pub-3940256099942544/5224354917');//warning: just test key!!!!

 jsAdMob2.AdMobBannerSetId('ca-app-pub-3940256099942544/6300978111'); //warning: just test key!!!!
end;

procedure TAndroidModule1.AndroidModule1Rotate(Sender: TObject;
  rotate: TScreenStyle);
begin
  updateLayout;
  jsAdMob1.AdMobBannerUpdate();
  jsAdMob2.AdMobBannerUpdate();
end;

procedure TAndroidModule1.AndroidModule1Show(Sender: TObject);
begin
  lbInfo.Text := 'Try to rotate screen after load AdMob!!!' + #13#10 +
                 'See "AndroidManifest.xml" to add id' + #13#10;
end;

end.
