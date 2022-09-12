package org.lamw.appcompatktoybuttondemo1;

import android.graphics.Canvas
import android.graphics.Color
import android.graphics.Paint
import android.graphics.RectF
import android.util.Log
import android.util.TypedValue
import android.view.MotionEvent
import android.view.View
import android.view.ViewGroup
import androidx.appcompat.widget.AppCompatButton

/*Draft Kotlin code by "Lazarus Android Module Wizard" [9/10/2022 20:28:46]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*LAMW Kotlin jVisualControl template*/

//ref
//https://github.com/bachiri/CustomButtonsAndroid
class KToyButton(_ctrls: Controls, _self: Long) : AppCompatButton(_ctrls.activity) {
 
    private var pascalObj: Long = 0        // Pascal Object
    private var controls: Controls? = null //Java/Pascal [events] Interface ...
    private val LAMWCommon: jCommons
 
    private val onClickListener: OnClickListener   // click event
    private var clicktouchEnable: Boolean = true           // clicktouch enabled!

    private var btnW: Int = 0
    private var btnH: Int = 0
    private var pressedColor: Int = 0
    private var unPressedColor: Int = 0
    private var savedColor: Int = 0
    private var roundRadius: Int = 0
    private var btnRadius: Int = 0
    private var shapeType: Int = 0   // 0:rectangle 1: circle

    private var paint: Paint = Paint()
    private var rectF: RectF = RectF()

    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
    init {
       pascalObj = _self
       controls = _ctrls
       LAMWCommon = jCommons(this, context, pascalObj)
 
       onClickListener = OnClickListener {
               if (clicktouchEnable) {
                  controls?.pOnClickGeneric(pascalObj) //JNI event onClick handled by Pascal side!
               }
       }

       setOnClickListener(onClickListener)

        //https://schibsted.com/blog/illuminate-path-using-kotlin-build-new-android-custom-components/
        //https://github.com/bachiri/CustomButtonsAndroid/tree/master/custombuttons/src/main/res/values

        //pressedColor = Color.LTGRAY
        //unPressedColor = Color.LTGRAY

        shapeType =  0 //0: rect  1: circle
        btnRadius = 3
        roundRadius = 32

        paint.color = unPressedColor
        paint.style = Paint.Style.FILL
        paint.isAntiAlias = true
        paint.textSize = 70.0F

        this.setWillNotDraw(false)
        this.isClickable = true

        this.text = "KToyButton"

    }
 
    fun kFree() {
       //free local objects...
   	 setOnClickListener(null)
	 LAMWCommon.free()
    }
  
    fun SetViewParent(_viewgroup: ViewGroup?) {
	 LAMWCommon.setParent(_viewgroup)
    }
 
    fun GetParent(): ViewGroup {
       return LAMWCommon.getParent()
    }
 
    fun RemoveFromViewParent() {
   	 LAMWCommon.removeFromViewParent()
    }
 
    fun GetView(): View {
       return this
    }
 
    fun SetLParamWidth(_w: Int) {
   	 LAMWCommon.setLParamWidth(_w)
    }
 
    fun SetLParamHeight(_h: Int) {
   	 LAMWCommon.setLParamHeight(_h)
    }
 
    fun GetLParamWidth(): Int {
       return LAMWCommon.getLParamWidth()
    }
 
    fun GetLParamHeight(): Int {
	 return  LAMWCommon.getLParamHeight()
    }
 
    fun SetLGravity(_g: Int) {
   	 LAMWCommon.setLGravity(_g)
    }
 
    fun SetLWeight(_w: Float) {
   	 LAMWCommon.setLWeight(_w)
    }
 
    fun SetLeftTopRightBottomWidthHeight(_left: Int, _top: Int, _right: Int, _bottom: Int, _w: Int, _h: Int) {
       LAMWCommon.setLeftTopRightBottomWidthHeight(_left, _top, _right, _bottom, _w, _h)
    }
 
    fun AddLParamsAnchorRule(_rule: Int) {
	 LAMWCommon.addLParamsAnchorRule(_rule)
    }
 
    fun AddLParamsParentRule(_rule: Int) {
	 LAMWCommon.addLParamsParentRule(_rule)
    }
 
    fun SetLayoutAll(_idAnchor: Int) {
   	 LAMWCommon.setLayoutAll(_idAnchor)
    }
 
    fun ClearLayoutAll() {
	 LAMWCommon.clearLayoutAll()
    }
 
    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
    fun SetId(_id: Int) {
       this.setId(_id)
    }

    override fun onSizeChanged(w: Int, h: Int, oldWidth: Int, oldHeight: Int) {
        super.onSizeChanged(w, h, oldWidth, oldHeight)
        btnW = w
        btnH = h
        //btnRadius = btnW / 2
        btnRadius = btnH / 2
    }

    override fun onDraw(canvas: Canvas) {
        super.onDraw(canvas)
        if (paint == null) {
            return
        }
        savedColor = paint.color
        if (shapeType == 1) {
            canvas.drawCircle((btnW / 8).toFloat(), (btnH / 2).toFloat(), btnRadius.toFloat(), paint)
            paint.color = Color.BLUE
            //canvas.drawText(this.text as String, 50.0F,80.0F, paint)
            paint.color = savedColor
        } else {
            rectF.set(0f, 0f, btnW.toFloat(), btnH.toFloat())
            canvas.drawRoundRect(rectF, roundRadius.toFloat(), roundRadius.toFloat(), paint)
            paint.color = Color.BLUE
            //canvas.drawText(this.text as String, 50.0F,80.0F, paint)
            paint.color = savedColor
        }
    }

    override fun onTouchEvent(event: MotionEvent): Boolean {
        when (event.action) {
            MotionEvent.ACTION_DOWN -> {
                paint.color = pressedColor
                //Log.i("KToyButton", "Dow")
                invalidate()
            }
            MotionEvent.ACTION_UP -> {
                paint.color = unPressedColor
                //Log.i("KToyButton", "Up")
                invalidate()
            }
        }
        return super.onTouchEvent(event)
    }

    fun SetPressedColor(_color: Int) {
        pressedColor = _color
    }

    fun SetUnPressedColor(_color: Int) {
        unPressedColor = _color
    }

    fun SetRoundRadiusCorner(_roundRadiusCorner: Int) {
        roundRadius = _roundRadiusCorner
    }

    fun SetShapeType(_shapeType: Int) {
        shapeType = _shapeType
    }

    fun SetText(_text: String) {
        this.text = _text
    }

    fun GetText(): String {
        return this.text as String
    }

    fun SetEnable(_value: Boolean) {
        clicktouchEnable = _value;
        this.setEnabled(_value)
    }

}
