{Hint: save all files to location: c:\svn\apps\inapp5\jni }
unit unit1;

{$mode delphi}

interface

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes,
  SysUtils,
  AndroidWidget,
  Laz_And_Controls, cbillingclient, StrUtils;
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jcBillingClient1: jcBillingClient;
    jWebView1: jWebView;
    procedure AndroidModule1JNIPrompt(Sender: TObject);
    procedure jcBillingClient1BillingEvent(Sender: TObject; Event: TBillingEvent
      );
    procedure jcBillingClient1ConsumedData(Sender: TObject;
      Action: TConsumedDataAction);
    procedure jcBillingClient1DeveloperPayload(Sender: TObject;
      Item: TPurchaseItem; out Payload: string);
    procedure jWebView1Status(Sender: TObject; Status: TWebViewStatus;
      URL: String; var CanNavi: Boolean);
  private
    {private declarations}
    FTestConsumedFilename: string;

    function TestHtml: string;
    procedure ListDump(SL: TStringList; HTML: boolean);

  public
    {public declarations}
  end;

var
  AndroidModule1: TAndroidModule1;

implementation
  
{$R *.lfm}

{ TAndroidModule1 }

procedure TAndroidModule1.ListDump(SL: TStringList; HTML: boolean);
  procedure Dump(L: TList; cap, comment: string);
  var i: integer; s: string; BI: TBillingItem;
  begin
    s := IntToStr(L.Count) + ' ' + Cap;
    if HTML then
      s := '<p><table cellspacing=0 cellpadding=10 border=1><tr><td><h3>' + s + '</h3>';
    SL.Add(s);
    SL.Add(comment);
    for i := 0 to L.Count-1 do begin
      BI := TBillingItem(L[i]);
      s := UpperCase(BI.TypeName)+ ' #' + IntToStr(i+1);
      if HTML then s := '<p><b>' + s + '</b>';
      SL.Add(s);
      BI.Dump(SL, HTML);
      if BI is TConsumedItem then
        SL.Add('<p><a href="billing:test=delete_consumed,'+IntToStr(i)+
          '">DELETE THIS CONSUMED ITEM</a>');
    end;
    if HTML then
      SL.Add('</td></tr></table>');
  end;

begin
  Dump(jcBillingClient1.ConsumedList, 'CONSUMED purchases',
    'When a Purchase is consumed it disappears from GooglePlay, '+
    'but the component maintains an independent list, '+
    'saved to a local file between sessions. ' +
    'Google states that the callback of a successful Consume '+
    'may occasionally fail. Therefore, in order not to depend ' +
    'exclusively on those callbacks, '+
    'the component adds a CONSUMED/PENDING object here' +
    'at the beginning of the Consume operation, and later '+
    'changes the status from PENDING to CONSUMED when the callback arrives. '+
    'This way you have the whole picture, and can decide what to do even in ' +
    'corner cases, e.g. when you have a CONSUMED/PENDING object here, ' +
    'but no longer the corresponding Purchase object in the Purchase list. ' +
    '(The purchase item disappeared after calling Consume, '+
    'which indicates a successful Consume, but we never got the ' +
    'actual callback confirmation that would have changed PENDING to CONSUMED.'+
    'In any case, do a lot of tests, make sure your users get what they pay for! '+
    'And remember, THIS CODE IS PROVIDED "AS IS", FOR FREE, WITH NO GUARANTEES!'+
    '');
  Dump(jcBillingClient1.PurchaseList, 'PURCHASES ',
    'This is the detailed list of purchased products, supplied by the ' +
    'GooglePlay app. If AutoAcknowledge is OFF, you can click on ' +
    '"ACKNOWLEDGE THIS" to perform the required acknowledgement. ' +
    '(Google automatically refunds purchases that are not acknowledged ' +
    'within a certain time (normally 3 days, but only a few minutes when using the Test products)' +
    '');
  Dump(jcBillingClient1.InappList, 'INAPP products',
    'This is the detailed list of INAPP products available ' +
    'for sale in this app. This list is generated from the ' +
    'comma-separated list of SKUs that you assign to InappSkus property. ' +
    'After purchase, these products can be consumed, after which the user can buy it again');
  Dump(jcBillingClient1.SubsList, 'SUBS products',
    'This is the detailed list of Subscription products available ' +
    'for sale in this app. This list is generated from the ' +
    'comma-separated list of SKUs that you assign to SubsSkus property. ' +
    'Subscription products are not consumable.');
end;

function TAndroidModule1.TestHtml: string;

  function BgColor: string;
  var i: integer;
  begin
    result := '';
    for i := 0 to jcBillingClient1.PurchaseCount-1 do begin
      if jcBillingClient1.Purchase[i].IsAcknowledgedFalse then begin
        // if there's any purchase that has NOT been
        // acknowledged yet, show yellow background
        result := ' bgcolor="yellow"';
        exit;
      end;
      if jcBillingClient1.Purchase[i].IsAcknowledgedTrue then
        // found an acknowledged purchase, unless there are
        // other unacknowledged ones, show green background
        result := ' bgcolor="lime"';
    end;
  end;

  function ModalPage: string;
  begin
    result := '';
    case Tag of
    11: result := 'PRODUCT CONSUMED';
    12: result := 'CONSUMED PRODUCT DELETED';
    end;
    result :=
      '<html><body bgcolor="#40B0FF"><center><h2>&nbsp;<p>' + result +
      '<p><a href="billing:test=refresh">Continue</a></h2></center></body></html>';
  end;

  var SL: TStringList;

  procedure TableTop(ATItle: string);
  begin
    SL.Add('<p><table cellpadding=10 cellspacing=0 border=1><tr><td>');
    SL.Add('<h3>' + ATitle + '</h3>');
  end;

  procedure TableBtm;
  begin
    SL.Add('</td></tr></table>');
  end;

var i: integer;
begin
  if Tag>10 then begin
    result := ModalPage;
    exit;
  end;

  SL := TStringList.Create;
  SL.Add('<html>');

  SL.Add('<body'+BgColor+'>');

  SL.Add(FormatDateTime('hh:nn:ss', Now));
  SL.Add('Billing Client tester');
  SL.Add('<p>After trying the operations, check the various lists ' +
    'and the logs at the bottom of the page to see what happened.');

  SL.Add('<p><b>Color codes</b>');
  SL.Add('<br>WHITE: No purchases');
  SL.Add('<br>YELLOW: One or more purchases, not yet acknowledged');
  SL.Add('<br>GREEN: One or more acknowledged purchases.');


  SL.Add('<p><a href="billing:test=refresh">Refresh this page</a>');


  SL.Add('<p><b>InappSkus:</b><br> ' + ReplaceStr(jcBillingClient1.InappSkus, ',', '<br>'));
  SL.Add('<p><b>SubsSkus:</b><br> ' + ReplaceStr(jcBillingClient1.SubsSkus, ',', '<br>'));
  SL.Add('<p><b>Consumed:</b> ' + IntToStr(jcBillingClient1.ConsumedCount));

  SL.Add('<br><b>Purchases:</b> ');
  if (jcBillingClient1.PurchaseHash='') then
    SL.Add('Not yet queried')
  else
    SL.Add(IntToStr(jcBillingClient1.PurchaseCount));

  SL.Add('<br><b>INAPP products:</b> ');
  if (jcBillingClient1.InappHash='') then begin
    if jcBillingClient1.InappSkus = '' then
      SL.Add('No InappSkus to query')
    else
      SL.Add('Not yet queried')
  end
  else
    SL.Add(IntToStr(jcBillingClient1.InappCount));

  SL.Add('<br><b>SUBS products:</b> ');
  if (jcBillingClient1.SubsHash='') then begin
    if jcBillingClient1.SubsSkus = '' then
      SL.Add('No SubsSkus to query')
    else
      SL.Add('Not yet queried')
  end else
    SL.Add(IntToStr(jcBillingClient1.SubsCount));

  TableTop('Connect');
  SL.Add('<p><a href="billing:test=connect_aq1">Connect(True)</a>');
  SL.Add('<p>Normally you will call Connect(True) when the app starts, ' +
    'to get all the data initialized, but here, for testing purposes, ' +
    'we let you do it manually by clicking above.');
  TableBtm;

  TableTop('Step-by-step Connect and Query operations.');
  SL.Add('<p>For testing and analysis purposes:');
  SL.Add('<p><a href="billing:test=connect_aq0">Connect(False) no auto-query after connect)</a>');
  SL.Add('<p><a href="billing:test=query_purchases">QueryPurchases</a>');
  SL.Add('<p><a href="billing:test=query_inapp">QueryInappList</a>');
  SL.Add('<p><a href="billing:test=query_subs">QuerySubsList</a>');
  SL.Add('</td></tr></table>');
  TableBtm;

  TableTop('Products overview');

  SL.Add('<b>AutoAcknowledge:</b> ');
  if jcBillingClient1.AutoAcknowledge then begin
    SL.Add('ON [<a href="billing:test=aa0">Turn OFF</a>]');
  end else begin
    SL.Add('OFF [<a href="billing:test=aa1">Turn ON</a>]');
  end;
  SL.Add('<br>Normally AutoAcknowledge should be turned ON, ' +
    'so that all successful Purchases are immediately acknowledged. '+
    'In special cases, and for testing purposes, it can ' +
    'be OFF. Here you must click on "ACKNOWLEDGE THIS" on purchases ' +
    'that still have acknowledged=false');

  SL.Add('<p>ConsumedData file:<br>' + FTestConsumedFilename);
  if FileExists(FTestConsumedFilename) then
    SL.Add('<br>File exists')
  else
    SL.Add('<br>File not found');

  for i := 0 to jcBillingClient1.InappCount-1 do
    SL.Add(jcBillingClient1.Inapp[i].TestBuyLink);
  for i := 0 to jcBillingClient1.SubsCount-1 do
    SL.Add(jcBillingClient1.Subs[i].TestBuyLink);

  TableBtm;

  ListDump(SL, True);

  {
  SL.Add('<p><a href="billing:test=log">Test log</a>');
  SL.Add('<p><a href="billing:test=event">Test event</a>');
  SL.Add('<p><a href="billing:test=error">Test error</a>');
  }
  SL.Add('<p><a href="billing:test=clear">Clear log</a>');

  jcBillingClient1.LogDump(SL, True, False);

  SL.Add('</body></html>');
  result := SL.text;
  SL.Free;
end;

{
function Test(F: jForm; WV: jWebView; InApps, Subs: string): jcBillingClient;
begin
  if TestBC = nil then begin
    TestBC := jcBillingClient.Create(F);
    TestBC.Init;
  end;
  TestBC.InappSkus := InApps;
  TestBC.SubsSkus  := Subs;
  TestBC.TestMode(WV);
  TestBC.TestUpdateUI;
  Result := TestBC;
end;
}

procedure TAndroidModule1.AndroidModule1JNIPrompt(Sender: TObject);
begin

   (*
  // https://developer.android.com/google/play/billing/billing_testing#solo
  cbillingClient.Test(Self, jWebView1,
    // comma-separated INAPP skus to test
    'android.test.purchased,'+
    'android.test.canceled,'+
    'android.test.item_unavailable',
    // comma-separated SUBS skus to test:
    '');
    *)

  FTestConsumedFilename := gApp.Path.dat;

  if not DirectoryExists(FTestConsumedFilename)
    then ForceDirectories(FTestConsumedFilename);

  FTestConsumedFilename := FTestConsumedFilename + '/consumed.xml';


   jcBillingClient1.InappSkus:= 'android.test.purchased,'+
                                'android.test.canceled,'+
                                'android.test.item_unavailable';
   jcBillingClient1.SubsSkus:='';


  //TestBC.TestMode(WV);
  jcBillingClient1.KeepLogs := True;
  jcBillingClient1.Base64PublicKey:= 'DUMMY';
  jcBillingClient1.AutoAcknowledge:= False; // in order to visualize Acknowledge process more easily

  //TestBC.TestUpdateUI;
   jWebView1.LoadFromHtmlString(TestHtml);


end;

procedure TAndroidModule1.jcBillingClient1BillingEvent(Sender: TObject; Event: TBillingEvent);
begin
  //TestUpdateUI;
  jWebView1.LoadFromHtmlString(TestHtml);

  case Event of
  beConsumedOK:
    begin
      jcBillingClient1.Tag := 11; // trigger "Consumed" message page

      //TestUpdateUI;
      jWebView1.LoadFromHtmlString(TestHtml);
    end;
  end;
end;

procedure TAndroidModule1.jcBillingClient1ConsumedData(Sender: TObject;
  Action: TConsumedDataAction);
var SL: TStringList;
begin
  // for testing purposes we save Consumed objects in a pseudo-XML file
  // in the internal app folder. If instead, for example, you want
  // to use a database, simply read or write the ConsumedData string.
  SL := TStringList.Create;
  case Action of
  cdaLoad:
    if FileExists(FTestConsumedFilename) then begin
      SL.LoadFromFile(FTestConsumedFilename);
      jcBillingClient1.ConsumedData := SL.Text;
    end;
  cdaSave:
    begin
      SL.Text := jcBillingClient1.ConsumedData;
      SL.SaveToFile(FTestConsumedFilename);
    end;
  end;
  SL.Free;
end;

procedure TAndroidModule1.jcBillingClient1DeveloperPayload(Sender: TObject;
  Item: TPurchaseItem; out Payload: string);
// Event may be beAcknowledge or beConsume
begin
  if payload <> '' then exit;
  // If this is for a Consume, developerPayload was already set
  // during the prior Acknowledge, in which case we choose not to change it.

  if Item=nil then
    payload := 'NIL object'
  else
    payload := Item.Description;
  payload := 'Test payload for ' + payload +
    ' generated at ' +
    FormatDateTime('YYYY-MM-DD hh:nn:ss', Now);
end;

procedure TAndroidModule1.jWebView1Status(Sender: TObject;
  Status: TWebViewStatus; URL: String; var CanNavi: Boolean);
begin
  CanNavi := False;
  case Status of
  wvOnBefore:
    begin
      jcBillingClient1.DoCmd(URL);
    end;
  wvOnFinish:
    begin
    end;
  wvOnUnknown:
    begin
    end;
  end;
end;

end.
