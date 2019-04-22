package org.lamw.appexpressiondemo1;

import android.content.Context;
import net.objecthunter.exp4j.ExpressionBuilder;
import net.objecthunter.exp4j.Expression;

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
        mExprBuilder = new ExpressionBuilder(_expression);
    }
   /*.*/public void AddVariables(String[] _variables) {
       mExprBuilder.variables( _variables);
       mExpr = mExprBuilder.build();
   }

    public void SetFormula(String _expression, String[] _variables) {
        mExprBuilder = new ExpressionBuilder(_expression);
        mExprBuilder.variables( _variables);
        mExpr = mExprBuilder.build();
    }
    public void SetValue(String _variable, double _value) {
       mExpr.setVariable( _variable, _value);
   }

   public double Evaluate() {
      return mExpr.evaluate();
   }

}
