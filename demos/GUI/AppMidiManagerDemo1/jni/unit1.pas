{Hint: save all files to location: C:\SVN\micrologus\Client\Apps\AppMidiManagerDemo1\jni }
//by Marco Bramardi
unit unit1;

{$mode delphi}

interface

uses
  Classes,
  SysUtils,
  midimanager,
  AndroidWidget,
  Laz_And_Controls;

const
  Octaves = 2;

type
  { TAndroidModule1 }
  TAndroidModule1 = class(jForm)
    MM: jMidiManager;
    jWebView1: jWebView;
    procedure AndroidModule1ActivityResume(Sender: TObject);
    procedure jWebView1Status(Sender: TObject; Status: TWebViewStatus; URL: String;
      Var CanNavi: Boolean);
  private
    //DeviceID: string; // remember
    procedure LoadHtmlPage;
    function  ProcessURL(URL: string): boolean;
    procedure PlayRandomNote;
  end;

var
  AndroidModule1: TAndroidModule1;

implementation
  
{$R *.lfm}

uses
  strUtils {base64};

{ TAndroidModule1 }

procedure TAndroidModule1.AndroidModule1ActivityResume(Sender: TObject);
begin
  LoadHtmlPage;
end;

procedure TAndroidModule1.jWebView1Status(Sender: TObject; Status: TWebViewStatus;
  URL: String; Var CanNavi: Boolean);
begin
  if status=wvOnBefore then begin
    canNavi := False; // don't let the WebView try to load a page from the internet
    if URL<>'' then
      if ProcessURL(URL) then exit;
    LoadHtmlPage; // refresh page
  end;
end;

procedure TAndroidModule1.LoadHtmlPage;
var HTML: TStringList;

  function FixHTML(const s: string): string;
  begin
    result := AnsiReplaceStr(s, '<', '&lt');
    result := AnsiReplaceStr(result, '>', '&gt');
    result := AnsiReplaceStr(result, char(9), '   ');
  end;

  procedure DumpLists;
  begin
    HTML.Add('<hr>');

    HTML.Add('<p>MidiManager.Status = ' + IntToStr(MM.GetStatus));
    HTML.Add('<p>GetDeviceCount = ' + IntToStr(MM.GetDeviceCount(True, True)));

    HTML.Add('<pre>');
    HTML.Add('<b>Full information on all devices in different formats:</b>');

    HTML.Add('<p><b>TEXT</b>');
    HTML.Add(MM.GetDeviceInfo(diAllText));

    HTML.Add('<p><b>XML</b>');
    HTML.Add(FixHTML(MM.GetDeviceInfo(diAllXML)));

    HTML.Add('<p><b>JSON</b>');
    HTML.Add(FixHTML(MM.GetDeviceInfo(diAllJSON)));

    HTML.Add('<p><b>Input (app --&gt; device) ports only:</b>');

    HTML.Add('<p><b>TEXT</b>');
    HTML.Add(FixHTML(MM.GetDeviceInfo(diInputsText)));

    HTML.Add('<p><b>XML</b>');
    HTML.Add(FixHTML(MM.GetDeviceInfo(diInputsXML)));

    HTML.Add('<p><b>JSON</b>');
    HTML.Add(FixHTML(MM.GetDeviceInfo(diInputsJSON)));

    HTML.Add('<p><b>Output (app &lt;-- device) ports only:</b>');

    HTML.Add('<p><b>TEXT</b>');
    HTML.Add(FixHTML(MM.GetDeviceInfo(diOutputsText)));

    HTML.Add('<p><b>XML</b>');
    HTML.Add(FixHTML(MM.GetDeviceInfo(diOutputsXML)));

    HTML.Add('<p><b>JSON</b>');
    HTML.Add(FixHTML(MM.GetDeviceInfo(diOutputsJSON)));
  end;

  procedure OpenCloseLinks;
  var SL: TStringList; id, i, c: integer; MyTitle, MyId: string;
  begin
    HTML.add('<a href="do:refresh">REFRESH THIS PAGE</a>');
    SL := TStringList.Create;
    SL.Text := MM.GetDeviceInfo(diInputsText);
    c := StrToInt('0' + SL.Values['port_count']);
    if c = 0 then begin
      HTML.add('<p><b>No MIDI devices found</b>. ');
      HTML.add('<p>There are no available MIDI devices to test the system.');
    end else begin
      for i := 0 to c-1 do begin
        MyId := SL.Values['port_' + IntToStr(i) + '_MyId'];
        MyTitle := SL.Values['port_' + IntToStr(i) + '_Title'];
        HTML.add('<p><b>MIDI device "' + MyTitle + '" ('+MyId+')</b>');
        if MM.Active and (MyId = MM.MyID) then begin
          HTML.Add('<br><b>Device is OPEN</b> ');;
          HTML.Add('<b><a href="do:CloseDevice">CLOSE THIS DEVICE</a></b>');
        end
        else
        if not MM.Active then
          HTML.add('<br><b><a href="do:OpenInput=' + MyId + '">OPEN THIS DEVICE</a></b>');
      end;
      if MM.Active then begin
        HTML.add('<p><b><a href=do:PlayRandomNote>PLAY A RANDOM NOTE</a></b></p>');
      end;
    end;
    SL.Free; //https://play.google.com/store/apps/details?id=net.volcanomobile.opl3midisynth&hl=en
    HTML.add('<p>If there are no MIDI devices installed, or if the ones that are installed don''t work, ' +
    ' open Google''s PlayStore and install the free app "General MIDI Synthesizer" '+
    ' by "Volcano Mobile", which we tested successfully, '+
    ' and then refresh this page and try again.');
  end;

begin
  HTML := TStringList.Create;
  HTML.Add('<html>');
  HTML.Add('<body>');
  HTML.Add(FormatDateTime('hh:nn:ss', Now));
  HTML.Add('<h2>AppMidiManagerTest1</h2>');
  OpenCloseLinks;
  DumpLists;
  HTML.Add('</body>');
  HTML.Add('</html>');
  jWebView1.LoadFromHtmlString(HTML.Text);
//  jWebView1.ScrollTo(0,0);
  HTML.Free;
end;

function TAndroidModule1.ProcessURL(URL: string): boolean;
begin
  result := False;
  if pos('do:', URL) = 1 then
    delete(URL, 1, pos(':',URL));
  if pos('OpenInput=', URL) = 1 then
    MM.OpenInput(copy(URL, pos('=',URL)+1,10));
  if pos('CloseDevice', URL) = 1 then
    MM.Close;
  if pos('PlayRandomNote',URL)>0 then begin
    result := True;
    PlayRandomNote;
  end;
end;

procedure TAndroidModule1.PlayRandomNote;
var N: integer;
begin
  if not MM.Active then exit;
  MM.SetChPatch(1, random(80)); // select a random patch among the first 80
  MM.SetChVol(1, 90);  // channel 1 volume 90
  N := 48 + random(25); // choose a random note between C4 and C6;
  MM.PlayChNoteVol(1, N, 80);  // play the note
  Sleep(500);  // wait a little
  MM.PlayChNoteVol(1, N, 0); // silence the note
end;

end.
