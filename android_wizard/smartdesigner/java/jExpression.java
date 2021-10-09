package org.lamw.appexpressiondemo1;

import android.content.Context;
import android.util.Log;
import android.widget.Toast;
import net.objecthunter.exp4j.ExpressionBuilder;
import net.objecthunter.exp4j.Expression;
import net.objecthunter.exp4j.ValidationResult;

/*Draft java code by "Lazarus Android Module Wizard" [4/10/2019 2:32:24]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jControl LAMW template*/

//https://www.objecthunter.net/exp4j/
public class jExpression {

    private long pascalObj = 0;        //Pascal Object
    private Controls controls  = null; //Java/Pascal [events] Interface ...
    private Context  context   = null;

    Expression mExpr;
    ExpressionBuilder mExprBuilder;

    double mExprValue;

    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...

    public jExpression(Controls _ctrls, long _Self) {
       //super(??);
       context   = _ctrls.activity;
       pascalObj = _Self;
       controls  = _ctrls;
    }

    public void jFree() {
      //free local objects...
    }

  //write others [public] methods code here......
  //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...

    /*.*/public void SetFormula(String _expression) {
        try {
            mExprBuilder = new ExpressionBuilder(_expression);
        } catch (IllegalArgumentException e) {
            mExpr = null;
            Toast toast = Toast.makeText(controls.activity, "Error on Formula! ["+e.getMessage()+"]", Toast.LENGTH_LONG);
            if (toast != null) {
                //toast.setGravity(Gravity.BOTTOM, 0, 0);
                toast.show();
            }
            Log.e("LAMW", "Exception on Builder Formula!", e);
        }
    }
   /*.*/public void AddVariables(String[] _variables) {
       try {
           mExprBuilder.variables( _variables);
           mExpr = mExprBuilder.build();
       } catch (IllegalArgumentException e) {
           mExpr = null;
           Toast toast = Toast.makeText(controls.activity, "Error on Formula! ["+e.getMessage()+"]", Toast.LENGTH_LONG);
           if (toast != null) {
               //toast.setGravity(Gravity.BOTTOM, 0, 0);
               toast.show();
           }
           Log.e("LAMW", "Exception on Builder Formula!", e);
       }
   }

    public void SetFormula(String _expression, String[] _variables) { //thanks to @guaracy
        try {
            mExprBuilder = new ExpressionBuilder(_expression);
            mExprBuilder.variables( _variables);
            mExpr = mExprBuilder.build();
        } catch (IllegalArgumentException e) {
            mExpr = null;
            Toast toast = Toast.makeText(controls.activity, "Error on Formula! ["+e.getMessage()+"]", Toast.LENGTH_LONG);
            if (toast != null) {
                //toast.setGravity(Gravity.BOTTOM, 0, 0);
                toast.show();
            }
            Log.e("LAMW", "Exception on Builder Formula!", e);
        }
    }

    public void SetValue(String _variable, double _value) {
       mExpr.setVariable( _variable, _value);
   }

   public double Evaluate() {
       if (mExpr != null) {
           if (IsExpressionValid(false)) {
               try {
                   mExprValue = mExpr.evaluate();
               } catch (ArithmeticException e) {
                   Toast toast = Toast.makeText(controls.activity, e.getMessage(), Toast.LENGTH_LONG);
                   if (toast != null) {
                       //toast.setGravity(Gravity.BOTTOM, 0, 0);
                       toast.show();
                   }
                   Log.e("LAMW", "Evaluate ArithmeticException", e);
               }
           }
           else {
               Toast toast = Toast.makeText(controls.activity, "Error! Expression Invalid!", Toast.LENGTH_LONG);
               if (toast != null) {
                   //toast.setGravity(Gravity.BOTTOM, 0, 0);
                   toast.show();
               }
           }
       }
       return mExprValue;
   }

    public boolean CanEvaluate(boolean _checkVariableSet) {

        boolean r = false;

        if (mExpr != null) {
            if (IsExpressionValid(_checkVariableSet)) {
                try {
                    mExprValue = mExpr.evaluate();
                    r = true;
                } catch (ArithmeticException e) {
                    Toast toast = Toast.makeText(controls.activity, e.getMessage(), Toast.LENGTH_LONG);
                    if (toast != null) {
                        //toast.setGravity(Gravity.BOTTOM, 0, 0);
                        toast.show();
                    }
                    Log.e("LAMW", "Evaluate ArithmeticException", e);
                    return false;
                }
            }
            else {
                Toast toast = Toast.makeText(controls.activity, "Error! Expression Invalid!", Toast.LENGTH_LONG);
                if (toast != null) {
                    //toast.setGravity(Gravity.BOTTOM, 0, 0);
                    toast.show();
                }
            }
        }
        return true;
    }

    public double GetValue() {
       return mExprValue;
    }

   //false --> Validate an expression before variables have been set, i.e. skip checking if all variables have been set.
   public boolean IsExpressionValid(boolean _checkVariablesSet) {
         boolean r = false;
         if (mExpr != null) {
             ValidationResult val = mExpr.validate(_checkVariablesSet);
             r = val.isValid();
         }
         return r;
   }

}
