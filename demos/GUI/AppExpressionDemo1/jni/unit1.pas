{Hint: save all files to location: C:\android\workspace\AppExpressionDemo1\jni }
unit unit1;

{$mode delphi}

interface

uses
  Classes, SysUtils, AndroidWidget, expression, Laz_And_Controls;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jButton1: jButton;
    jEditText1: jEditText;
    jEditText2: jEditText;
    jExpression1: jExpression;
    jImageBtn1: jImageBtn;
    jListView1: jListView;
    jTextView1: jTextView;
    jTextView2: jTextView;
    jTextView3: jTextView;
    procedure AndroidModule1JNIPrompt(Sender: TObject);
    procedure jButton1Click(Sender: TObject);
    procedure jImageBtn1Click(Sender: TObject);
    procedure jListView1DrawItemWidgetText(Sender: TObject; itemIndex: integer;
      widgetText: string; out newWidgetText: string);
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

(*

ref. https://www.objecthunter.net/exp4j/

Built-in functions

abs: absolute value
acos: arc cosine
asin: arc sine
atan: arc tangent
cbrt: cubic root
ceil: nearest upper integer
cos: cosine
cosh: hyperbolic cosine
exp: euler's number raised to the power (e^x)
floor: nearest lower integer
log: logarithmus naturalis (base e)
log10: logarithm (base 10)
log2: logarithm (base 2)
sin: sine
sinh: hyperbolic sine
sqrt: square root
tan: tangent
tanh: hyperbolic tangent
signum: signum function
*)

procedure TAndroidModule1.jButton1Click(Sender: TObject);
var
  variables: array of string;
  count, i: integer;
  exprValue: double;
  strNumber: string;
begin

   count:= jListView1.Count;

   SetLength(variables, count);

   for i:= 0 to count-1 do
   begin
     variables[i]:= jListView1.GetItemText(i);
   end;

   jExpression1.SetFormula(Trim(jEditText1.Text), variables);
   //jExpression1.SetFormula('3 * sin(y) - 2 / (x - 2)', ['x', 'y']);


   for i:= 0 to count-1 do
   begin
       strNumber:= Trim(jListView1.GetWidgetText(i));
       if strNumber <> '' then
         jExpression1.SetValue(variables[i], StrToFloat(strNumber))
       else
         jExpression1.SetValue(variables[i], 0);
   end;
   //jExpression1.SetValue('x', 2.3);
   //jExpression1.SetValue('y', 3.14);

   exprValue:= jExpression1.Evaluate();

   ShowMessage(FloatToStr(exprValue));

   SetLength(variables, 0);

end;

procedure TAndroidModule1.AndroidModule1JNIPrompt(Sender: TObject);
begin
   jListView1.SetWidgetInputTypeIsCurrency(True);
end;

procedure TAndroidModule1.jImageBtn1Click(Sender: TObject);
begin
   jListView1.Add(Trim(jEditText2.Text));
end;

procedure TAndroidModule1.jListView1DrawItemWidgetText(Sender: TObject;
  itemIndex: integer; widgetText: string; out newWidgetText: string);
begin
  if itemIndex =  0 then newWidgetText:= '2.3';
  if itemIndex =  1 then newWidgetText:= '3.14';
end;

end.
