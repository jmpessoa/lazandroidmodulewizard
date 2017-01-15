{Hint: save all files to location: C:\adt32\eclipse\workspace\AppFlingGestureDemo1\jni }
unit unit1;
  
{$mode delphi}
  
interface
  
uses
  Classes, SysUtils, And_jni, And_jni_Bridge, Laz_And_Controls, 
    Laz_And_Controls_Events, AndroidWidget;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
      jPanel1: jPanel;
      jTextView1: jTextView;
      jTextView2: jTextView;
      jTextView3: jTextView;
      procedure AndroidModule1Create(Sender: TObject);
      procedure AndroidModule1JNIPrompt(Sender: TObject);

      procedure jPanel1FlingGesture(Sender: TObject; flingGesture: TFlingGesture);

    private
      {private declarations}
       FIndex: integer;
       FMessages: array[0..5] of string;
    public
      {public declarations}
  end;
  
var
  AndroidModule1: TAndroidModule1;

implementation
  
{$R *.lfm}

{ TAndroidModule1 }

procedure TAndroidModule1.jPanel1FlingGesture(Sender: TObject; flingGesture: TFlingGesture);
begin
  case flingGesture of

    fliRightToLeft:
    begin
      inc(FIndex);
      if FIndex > 5 then FIndex:=0;
      jTextView3.Text:= FMessages[FIndex];
    end;

    fliLeftToRight:
    begin
      dec(FIndex);
      if FIndex < 0 then FIndex:=5;
      jTextView3.Text:= FMessages[FIndex];
    end;

    fliBottomToTop:
    begin
      inc(FIndex);
      if FIndex > 5 then FIndex:=0;
      jTextView3.Text:= FMessages[FIndex];
    end;

    fliTopToBottom:
    begin
      dec(FIndex);
      if FIndex < 0 then FIndex:=5;
      jTextView3.Text:= FMessages[FIndex];
    end;
  end;
end;

procedure TAndroidModule1.AndroidModule1Create(Sender: TObject);
begin
  FMessages[0]:= '1. All theory is gray, my friend. But forever green is the tree of life.';
  FMessages[1]:= '2. Life belongs to the living, and he who lives must be prepared for changes.';
  FMessages[2]:= '3. Nature goes her own way and all that to us seems an exception is really according to order.';
  FMessages[3]:= '4. In nature we never see anything isolated, but everything in connection with something else which is before it, beside it, under it and over it.';
  FMessages[4]:= '5. There is repetition everywhere, and nothing is found only once in the world.';
  FMessages[5]:= '6. Boldness has genius, power and magic in it.';
  //He who enjoys doing and enjoys what he has done is happy.
  //Difficulties increase the nearer we approach the goal.
  //In the end we retain from our studies only that which we practically apply.
  //Thinking is easy, acting is difficult, and to put one's thoughts into action is the most difficult thing in the world.
  //What is important in life is life, and not the result of life.
  //Life belongs to the living, and he who lives must be prepared for changes
  //Everybody wants to be somebody; nobody wants to grow.
  //Talents are best nurtured in solitude. Character is best formed in the stormy billows of the world.
  //Where there is much light, the shadow is deep.
  //In nature we never see anything isolated, but everything in connection with something else which is before it, beside it, under it and over it.
  //Nature goes her own way and all that to us seems an exception is really according to order.
  //There is repetition everywhere, and nothing is found only once in the world.
  //To understand one thing well is better than understanding many things by halves.
  // A great person attracts great people and knows how to hold them together.
  //Thinking is more interesting than knowing, but less interesting than looking.
  //By seeking and blundering we learn.
  //All theory is gray, my friend. But forever green is the tree of life.
end;

procedure TAndroidModule1.AndroidModule1JNIPrompt(Sender: TObject);
begin
  FIndex:= 0;
  jTextView3.Text:= FMessages[FIndex];
end;

end.
