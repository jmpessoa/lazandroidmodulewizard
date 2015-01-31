{Hint: save all files to location: C:\adt32\eclipse\workspace\AppTryCode3\jni }
unit unit1;
  
{$mode delphi}
  
interface
  
uses
  Classes, SysUtils, And_jni, And_jni_Bridge, Laz_And_Controls, AndroidWidget, textfilemanager,
  dumpjavamethods;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
      jButton1: jButton;
      jButton2: jButton;
      jButton3: jButton;
      jDumpJavaMethods1: jDumpJavaMethods;
      jEditText1: jEditText;
      jListView1: jListView;
      jRadioButton1: jRadioButton;
      jRadioButton2: jRadioButton;
      jRadioButton3: jRadioButton;
      jRadioButton4: jRadioButton;
      jTextFileManager1: jTextFileManager;
      jTextView1: jTextView;
      jTextView2: jTextView;
      jTextView3: jTextView;
      procedure DataModuleCreate(Sender: TObject);
      procedure DataModuleDestroy(Sender: TObject);
      procedure DataModuleJNIPrompt(Sender: TObject);
      procedure jButton1Click(Sender: TObject);
      procedure jButton2Click(Sender: TObject);
      procedure jButton3Click(Sender: TObject);
      procedure jRadioButton1Click(Sender: TObject);
      procedure jRadioButton2Click(Sender: TObject);
      procedure jRadioButton3Click(Sender: TObject);
      procedure jRadioButton4Click(Sender: TObject);
    private
      {private declarations}
        FListClassImpl: TStringList;
        FListDrafJavaClass: TStringList;
        FBaseClassName: string;
        FBaseControlType: string;
        FObjectModel: string;
        procedure InsertJControlCodeTemplate(controlType: string; className: string; objectModel: string);
    public
      {public declarations}
  end;
  
var
  AndroidModule1: TAndroidModule1;

implementation
  
{$R *.lfm}

{ TAndroidModule1 }

procedure TAndroidModule1.DataModuleCreate(Sender: TObject);
begin
   FListClassImpl:= TStringList.Create;
   FListDrafJavaClass:= TStringList.Create;
   FBaseControlType:= 'jControl';
   FObjectModel:= 'Composition';
   Self.OnJNIPrompt:= DataModuleJNIPrompt;
end;

procedure TAndroidModule1.DataModuleJNIPrompt(Sender: TObject);
begin
   Self.Show;
end;

procedure TAndroidModule1.DataModuleDestroy(Sender: TObject);
begin
   FListDrafJavaClass.Free;
   FListClassImpl.Free;
end;

procedure TAndroidModule1.jButton1Click(Sender: TObject);
var
  headerList: TStringList;
  i: integer;
  auxList: TStringList;
begin

  if jEditText1.Text <> '' then
    jDumpJavaMethods1.FullJavaClassName:= jEditText1.Text
  else
    jDumpJavaMethods1.FullJavaClassName:= 'android.media.MediaPlayer';

  auxList:= TStringList.Create;
  auxList.StrictDelimiter:= True;
  auxList.Delimiter:= '.';
  auxList.DelimitedText:= jDumpJavaMethods1.FullJavaClassName;

  FBaseClassName:= auxList.Strings[auxList.Count-1]; //MediaPlayer;

  auxList.Free;

  jDumpJavaMethods1.ObjReferenceName:= 'm'+FBaseClassName;

  jDumpJavaMethods1.SetDelimiter('|');

  jDumpJavaMethods1.Extract();

  headerList:= TStringList.Create;
  headerList.StrictDelimiter:= True;
  headerList.Delimiter:= '|';
  headerList.DelimitedText:= jDumpJavaMethods1.GetMethodHeaderList();

  for i:=0 to headerList.Count-1 do
  begin
    jListView1.Add(headerList.Strings[i]);
    //ShowMessage(headerList.Strings[i]);
  end;

  headerList.Free;

end;

procedure TAndroidModule1.jButton2Click(Sender: TObject);
var
  count, i: integer;
begin
  count:= jListView1.Count;
  for i:= 0 to count-1 do
  begin
     if  not jListView1.IsItemChecked(i) then
        jDumpJavaMethods1.MaskMethodHeaderByIndex(i); //remove item!
  end;
  FListClassImpl.Clear;
  FListClassImpl.StrictDelimiter:= True;
  FListClassImpl.Delimiter:= '|';
  FListClassImpl.DelimitedText:= jDumpJavaMethods1.GetNoMaskedMethodImplementationList();
  InsertJControlCodeTemplate(FBaseControlType, FBaseClassName, FObjectModel);
  jTextFileManager1.SaveToFile(FListDrafJavaClass.Text, 'j'+FBaseClassName+'.java');
  jTextFileManager1.CopyToClipboard(FListDrafJavaClass.Text);
  ShowMessage('Saved to data/data/apptrycode3/MediaPlayer.java!');
  ShowMessage('Copied To Device Clipboard!');  //jTextFileManager1.PasteFromClipboard()
end;

procedure TAndroidModule1.jButton3Click(Sender: TObject);
var
  count, i: integer;
begin
  count:= jListView1.Count;
  for i:= 0 to count-1 do
  begin
     if  not jListView1.IsItemChecked(i) then
        jDumpJavaMethods1.MaskMethodHeaderByIndex(i); //remove item!
  end;
  FListClassImpl.Clear;
  FListClassImpl.StrictDelimiter:= True;
  FListClassImpl.Delimiter:= '|';
  FListClassImpl.DelimitedText:= jDumpJavaMethods1.GetNoMaskedMethodImplementationList();
  InsertJControlCodeTemplate(FBaseControlType, FBaseClassName, FObjectModel);
  jTextFileManager1.SaveToSdCard(FListDrafJavaClass.Text, 'j'+FBaseClassName+'.java');
  jTextFileManager1.CopyToClipboard(FListDrafJavaClass.Text);
  ShowMessage('Saved to sdcard/jMediaPlayer.java');
  ShowMessage('Copied To Device Clipboard');  //jTextFileManager1.PasteFromClipboard()
end;

procedure TAndroidModule1.jRadioButton1Click(Sender: TObject);
begin
   jRadioButton2.Checked:= False;
   FBaseControlType:= 'jControl';
end;

procedure TAndroidModule1.jRadioButton2Click(Sender: TObject);
begin
  jRadioButton1.Checked:= False;
  FBaseControlType:= 'jVisualControl';
  jRadioButton4.Checked:= True;;
  jRadioButton4Click(nil);
end;

procedure TAndroidModule1.jRadioButton3Click(Sender: TObject);
begin
  jRadioButton4.Checked:= False;
  FObjectModel:= 'Composition';
end;

procedure TAndroidModule1.jRadioButton4Click(Sender: TObject);
begin
  jRadioButton3.Checked:= False;
  FObjectModel:= 'Inheritance';
end;

procedure TAndroidModule1.InsertJControlCodeTemplate(controlType: string; className: string; objectModel: string);
var
  i: integer;
begin
   FListDrafJavaClass.Clear;
   if Pos('jControl', controlType) > 0 then
   begin
     FListDrafJavaClass.Add(' ');
     FListDrafJavaClass.Add('/*Draft java code by "Lazarus Android Module Wizard" ['+DateTimeToStr(Now)+']*/');
     FListDrafJavaClass.Add('/*https://github.com/jmpessoa/lazandroidmodulewizard*/');
     FListDrafJavaClass.Add('/*jControl template*/');
     FListDrafJavaClass.Add(' ');

     if FObjectModel = 'Composition' then
        FListDrafJavaClass.Add('class j'+className+' /*extends ...*/ {')
     else
        FListDrafJavaClass.Add('class j'+className+' extends '+className+'{');

     FListDrafJavaClass.Add('  ');
     FListDrafJavaClass.Add('    private long     pascalObj = 0;      // Pascal Object');
     FListDrafJavaClass.Add('    private Controls controls  = null;   // Control Class -> Java/Pascal Interface ...');
     FListDrafJavaClass.Add('    private Context  context   = null;');

     if FObjectModel = 'Composition' then
        FListDrafJavaClass.Add('    private '+className+' m'+className+'= null;');

     FListDrafJavaClass.Add('  ');
     FListDrafJavaClass.Add('    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...');
     FListDrafJavaClass.Add('  ');
     FListDrafJavaClass.Add('    public j'+className+'(Controls _ctrls, long _Self) { //Add more others news "_xxx" params if needed!');
     FListDrafJavaClass.Add('       //super(_ctrls.activity);');
     FListDrafJavaClass.Add('       context   = _ctrls.activity;');
     FListDrafJavaClass.Add('       pascalObj = _Self;');
     FListDrafJavaClass.Add('       controls  = _ctrls;');

     if FObjectModel = 'Composition' then
        FListDrafJavaClass.Add('       m'+className+ ' = New '+className+'();');

     FListDrafJavaClass.Add('    }');
     FListDrafJavaClass.Add('  ');
     FListDrafJavaClass.Add('    public void jFree() {');
     FListDrafJavaClass.Add('      //free local objects...');
     if FObjectModel = 'Composition' then
        FListDrafJavaClass.Add('       m'+className+ ' = null;');

     FListDrafJavaClass.Add('    }');
     FListDrafJavaClass.Add('  ');
     FListDrafJavaClass.Add('  //write others [public] methods code here......');
     FListDrafJavaClass.Add('  //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...');
     FListDrafJavaClass.Add('  ');
     for i:= 0 to FListClassImpl.Count-1 do
     begin
        FListDrafJavaClass.Add(FListClassImpl.Strings[i]);
        FListDrafJavaClass.Add('  ');
     end;
     FListDrafJavaClass.Add('}');
   end;

   if Pos('jVisualControl', controlType) > 0 then
   begin
     FListDrafJavaClass.Add(' ');
     FListDrafJavaClass.Add('/*Draft java code by "Lazarus Android Module Wizard" ['+DateTimeToStr(Now)+']*/');
     FListDrafJavaClass.Add('/*https://github.com/jmpessoa/lazandroidmodulewizard*/');
     FListDrafJavaClass.Add('/*jVisualControl template*/');
     FListDrafJavaClass.Add('  ');
     FListDrafJavaClass.Add('class j'+className+' extends TextView /*dummy*/ { //please, fix what GUI object will be extended!');
     FListDrafJavaClass.Add('   ');
     FListDrafJavaClass.Add('   private long       pascalObj = 0;    // Pascal Object');
     FListDrafJavaClass.Add('   private Controls   controls  = null; // Control Class for events');
     FListDrafJavaClass.Add('   ');
     FListDrafJavaClass.Add('   private Context context = null;');
     FListDrafJavaClass.Add('   private ViewGroup parent   = null;         // parent view');
     FListDrafJavaClass.Add('   private RelativeLayout.LayoutParams lparams; // layout XYWH ');
     FListDrafJavaClass.Add('   private OnClickListener onClickListener;   // click event');
     FListDrafJavaClass.Add('   private Boolean enabled  = true;           // click-touch enabled!');
     FListDrafJavaClass.Add('   private int lparamsAnchorRule[] = new int[30];');
     FListDrafJavaClass.Add('   private int countAnchorRule = 0;');
     FListDrafJavaClass.Add('   private int lparamsParentRule[] = new int[30];');
     FListDrafJavaClass.Add('   private int countParentRule = 0;');
     FListDrafJavaClass.Add('   private int lparamH = 100;');
     FListDrafJavaClass.Add('   private int lparamW = 100;');
     FListDrafJavaClass.Add('   private int marginLeft = 0;');
     FListDrafJavaClass.Add('   private int marginTop = 0;');
     FListDrafJavaClass.Add('   private int marginRight = 0;');
     FListDrafJavaClass.Add('   private int marginBottom = 0;');
     FListDrafJavaClass.Add('   private boolean mRemovedFromParent = false;');
     FListDrafJavaClass.Add('  ');
     FListDrafJavaClass.Add('   //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...');
     FListDrafJavaClass.Add('  ');
     FListDrafJavaClass.Add('   public j'+className+'(Controls _ctrls, long _Self) { //Add more others news "_xxx"p arams if needed!');
     FListDrafJavaClass.Add('      super(_ctrls.activity);');
     FListDrafJavaClass.Add('      context   = _ctrls.activity;');
     FListDrafJavaClass.Add('      pascalObj = _Self;');
     FListDrafJavaClass.Add('      controls  = _ctrls;');
     FListDrafJavaClass.Add('   ');
     FListDrafJavaClass.Add('      lparams = new RelativeLayout.LayoutParams(lparamW, lparamH);');
     FListDrafJavaClass.Add('   ');
     FListDrafJavaClass.Add('      onClickListener = new OnClickListener(){');
     FListDrafJavaClass.Add('      /*.*/public void onClick(View view){  //please, do not remove /*.*/ mask for parse invisibility!');
     FListDrafJavaClass.Add('              if (enabled) {');
     FListDrafJavaClass.Add('                 controls.pOnClick(pascalObj, Const.Click_Default); //JNI event onClick!');
     FListDrafJavaClass.Add('              }');
     FListDrafJavaClass.Add('           };');
     FListDrafJavaClass.Add('      };');
     FListDrafJavaClass.Add('      setOnClickListener(onClickListener);');
     FListDrafJavaClass.Add('   } //end constructor');
     FListDrafJavaClass.Add('   ');
     FListDrafJavaClass.Add('   public void jFree() {');
     FListDrafJavaClass.Add('      if (parent != null) { parent.removeView(this); }');
     FListDrafJavaClass.Add('      //free local objects...');
     FListDrafJavaClass.Add('      lparams = null;');
     FListDrafJavaClass.Add('      setOnClickListener(null);');
     FListDrafJavaClass.Add('   }');
     FListDrafJavaClass.Add('  ');
     FListDrafJavaClass.Add('   public void SetViewParent(ViewGroup _viewgroup) {');
     FListDrafJavaClass.Add('      if (parent != null) { parent.removeView(this); }');
     FListDrafJavaClass.Add('      parent = _viewgroup;');
     FListDrafJavaClass.Add('      parent.addView(this,lparams);');
     FListDrafJavaClass.Add('      mRemovedFromParent = false;');
     FListDrafJavaClass.Add('   }');
     FListDrafJavaClass.Add('  ');
     FListDrafJavaClass.Add('   public void RemoveFromViewParent() {');
     FListDrafJavaClass.Add('      if (!mRemovedFromParent) {');
     FListDrafJavaClass.Add('         this.setVisibility(android.view.View.INVISIBLE);');
     FListDrafJavaClass.Add('         if (parent != null)');
     FListDrafJavaClass.Add('             parent.removeView(this);');
     FListDrafJavaClass.Add('	      mRemovedFromParent = true;');
     FListDrafJavaClass.Add('	   }');
     FListDrafJavaClass.Add('   }');
     FListDrafJavaClass.Add('  ');
     FListDrafJavaClass.Add('   public View GetView() {');
     FListDrafJavaClass.Add('      return this;');
     FListDrafJavaClass.Add('   }');
     FListDrafJavaClass.Add('  ');
     FListDrafJavaClass.Add('   public void SetLParamWidth(int _w) {');
     FListDrafJavaClass.Add('      lparamW = _w;');
     FListDrafJavaClass.Add('   }');
     FListDrafJavaClass.Add('  ');
     FListDrafJavaClass.Add('   public void SetLParamHeight(int _h) {');
     FListDrafJavaClass.Add('      lparamH = _h;');
     FListDrafJavaClass.Add('   }');
     FListDrafJavaClass.Add('  ');
     FListDrafJavaClass.Add('   public void SetLeftTopRightBottomWidthHeight(int _left, int _top, int _right, int _bottom, int _w, int _h) {');
     FListDrafJavaClass.Add('      marginLeft = _left;');
     FListDrafJavaClass.Add('      marginTop = _top;');
     FListDrafJavaClass.Add('      marginRight = _right;');
     FListDrafJavaClass.Add('      marginBottom = _bottom;');
     FListDrafJavaClass.Add('      lparamH = _h;');
     FListDrafJavaClass.Add('      lparamW = _w;');
     FListDrafJavaClass.Add('   }');
     FListDrafJavaClass.Add('  ');
     FListDrafJavaClass.Add('   public void AddLParamsAnchorRule(int _rule) {');
     FListDrafJavaClass.Add('      lparamsAnchorRule[countAnchorRule] = _rule;');
     FListDrafJavaClass.Add('      countAnchorRule = countAnchorRule + 1;');
     FListDrafJavaClass.Add('   }');
     FListDrafJavaClass.Add('  ');
     FListDrafJavaClass.Add('   public void AddLParamsParentRule(int _rule) {');
     FListDrafJavaClass.Add('      lparamsParentRule[countParentRule] = _rule;');
     FListDrafJavaClass.Add('      countParentRule = countParentRule + 1;');
     FListDrafJavaClass.Add('   }');
     FListDrafJavaClass.Add('  ');
     FListDrafJavaClass.Add('  ');
     FListDrafJavaClass.Add('   public void SetLayoutAll(int _idAnchor) {');
     FListDrafJavaClass.Add('  	   lparams.width  = lparamW;');
     FListDrafJavaClass.Add('	   lparams.height = lparamH;');
     FListDrafJavaClass.Add('	   lparams.setMargins(marginLeft,marginTop,marginRight,marginBottom);');
     FListDrafJavaClass.Add('	   if (_idAnchor > 0) {');
     FListDrafJavaClass.Add('	     for (int i=0; i < countAnchorRule; i++) {');
     FListDrafJavaClass.Add('		lparams.addRule(lparamsAnchorRule[i], _idAnchor);');
     FListDrafJavaClass.Add('	     }');
     FListDrafJavaClass.Add('	   }');
     FListDrafJavaClass.Add('      for (int j=0; j < countParentRule; j++) {');
     FListDrafJavaClass.Add('         lparams.addRule(lparamsParentRule[j]);');
     FListDrafJavaClass.Add('      }');
     FListDrafJavaClass.Add('      this.setLayoutParams(lparams);');
     FListDrafJavaClass.Add('   }');
     FListDrafJavaClass.Add('  ');
     FListDrafJavaClass.Add('   public void ClearLayoutAll() {');
     FListDrafJavaClass.Add('	   for (int i=0; i < countAnchorRule; i++) {');
     FListDrafJavaClass.Add('  	     lparams.removeRule(lparamsAnchorRule[i]);');
     FListDrafJavaClass.Add('      }');
     FListDrafJavaClass.Add('  ');
     FListDrafJavaClass.Add('	   for (int j=0; j < countParentRule; j++) {');
     FListDrafJavaClass.Add('        lparams.removeRule(lparamsParentRule[j]);');
     FListDrafJavaClass.Add('	   }');
     FListDrafJavaClass.Add('	   countAnchorRule = 0;');
     FListDrafJavaClass.Add('	   countParentRule = 0;');
     FListDrafJavaClass.Add('   }');
     FListDrafJavaClass.Add(' ');
     FListDrafJavaClass.Add('  ');
     FListDrafJavaClass.Add('   public void SetId(int _id) { //wrapper method pattern ...');
     FListDrafJavaClass.Add('      this.setId(_id);');
     FListDrafJavaClass.Add('   }');
     FListDrafJavaClass.Add('  ');
     FListDrafJavaClass.Add('  //write others [public] methods code here......');
     FListDrafJavaClass.Add('  //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...');
     FListDrafJavaClass.Add('  ');
     for i:= 0 to FListClassImpl.Count-1 do
     begin
        FListDrafJavaClass.Add(FListClassImpl.Strings[i]);
        FListDrafJavaClass.Add('  ');
     end;
     FListDrafJavaClass.Add('} //end class');
   end;
end;

end.
