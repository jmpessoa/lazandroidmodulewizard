{Hint: save all files to location: C:\lamw\workspace\AppCompatRecyclerViewDemo1\jni }
unit unit1;

{$mode delphi}

interface

uses
  Classes, SysUtils, AndroidWidget, Laz_And_Controls, srecyclerview, ratingbar,
  switchbutton;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jCheckBox1: jCheckBox;
    jImageView1: jImageView;
    jPanel1: jPanel;
    jRatingBar1: jRatingBar;
    jsRecyclerView1: jsRecyclerView;
    jSwitchButton1: jSwitchButton;
    jTextView1: jTextView;
    jTextView2: jTextView;
    jTextView3: jTextView;
    procedure AndroidModule1Create(Sender: TObject);
    procedure AndroidModule1JNIPrompt(Sender: TObject);
    procedure jsRecyclerView1ItemClick(Sender: TObject; itemPosition: integer);
    procedure jsRecyclerView1ItemWidgetClick(Sender: TObject;
      itemPosition: integer; widget: TItemContentFormat; widgetId: integer;
      status: TItemWidgetStatus);

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

procedure TAndroidModule1.AndroidModule1JNIPrompt(Sender: TObject);
begin
  //jsRecyclerView1.SetClipToPadding(False);
  jsRecyclerView1.SetItemContentLayout(jPanel1.View,  True {cardview});   //custom item view!

  //jsRecyclerView1.SetItemContentDelimiter('|');    //default

  //the sequence maps the order of the content added on  "jsRecyclerView1.Add(....)"
  //jsRecyclerView1.SetItemContentFormat('IMAGE|TEXT|TEXT|CHECK|RATING|SWITCH');

  //or
  jsRecyclerView1.ClearItemContentFormat; // Need for reinit activity
  jsRecyclerView1.AddItemContentFormat(cfPanel);
  jsRecyclerView1.AddItemContentFormat(cfImage);
  jsRecyclerView1.AddItemContentFormat(cfText);   // one text
  jsRecyclerView1.AddItemContentFormat(cfText);   // another text
  jsRecyclerView1.AddItemContentFormat(cfCheck);
  jsRecyclerView1.AddItemContentFormat(cfRating);
  jsRecyclerView1.AddItemContentFormat(cfSwitch);
  jsRecyclerView1.SetItemContentFormat();

  jsRecyclerView1.Add( intToStr(GetARGBJava(Fcustomcolor, colbrWhite)) + '@20|don_quixote@drawable|Do you see friend Sancho...|thirty or forty hulking giants?|OK@0|2.5|ON:OFF@0');
  jsRecyclerView1.Add( intToStr(GetARGBJava(Fcustomcolor, colbrWhite)) + '@20|lance.png@assets|Take care...|there are not giants but windmills...|OK@0|3.5|Sound@0');

  (*Notes:

  .Image source [possibility] example:

        lance.png@assets            <---- project folder  "assets"
        ic_launcher@drawable      <---- project folder  "res/drawable" dont use the file extension!!!
        url@http://icons.iconarchive.com/icons/alecive/flatwoken/128/Apps-Google-Chrome-App-List-icon.png    <-- get from url/location
        picture21.png@download         <----- device folder download [need run time permission!]
        image007.png@sdcard            <----- device sdcard [need run time permission!]

   .Check: OK@1 --> set caption=OK  and:  1=checked, 0=unchecked      --initial state
   .Rating: 2.5 --> stars settings     --initial state
   .Switch: OFF:ON@0 --> set slide text ("OFF" or "ON" by state) and:  0=unchecked/Off  --initial state
   .Switch: Sound@1 --> set caption=Sound  and: 1=checked/On    --initial state
  *)

end;

procedure TAndroidModule1.jsRecyclerView1ItemClick(Sender: TObject;
  itemPosition: integer);
begin

  ShowMessage('itemIndex = ' + IntToStr(itemPosition) );

  ShowMessage( jsRecyclerView1.GetWidgetText(itemPosition, cfText, jTextView1.Id) + #13#10 +
               jsRecyclerView1.GetWidgetText(itemPosition, cfText, jTextView2.Id));

  jsRecyclerView1.SetItemBackgroundColor(itemPosition, colbrRed, 20);
  jsRecyclerView1.Refresh(itemPosition);

end;

procedure TAndroidModule1.jsRecyclerView1ItemWidgetClick(Sender: TObject;
  itemPosition: integer; widget: TItemContentFormat; widgetId: integer;
  status: TItemWidgetStatus);
begin
  case widget of
      cfImage: begin ShowMessage('widget = cfImage');  end;
      cfCheck: begin ShowMessage('widget = cfCheck'); end;
      cfRating: begin ShowMessage('widget = cfRating'); end;
   end;

   ShowMessage(jsRecyclerView1.GetWidgetText(itemPosition, cfText, jTextView1.Id) +
               '  itemPosition = '+ IntToStr(itemPosition));

   case status of
       wsNone: begin ShowMessage('status = wsNone');  end;
       wsChecked: begin ShowMessage('status = wsChecked'); end;
   end;
end;

end.
