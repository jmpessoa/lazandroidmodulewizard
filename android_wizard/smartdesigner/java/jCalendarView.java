package org.lamw.appcalendarviewdemo1;

import android.content.Context;
import android.os.Build;
import android.view.View;
import android.view.ViewGroup;
import android.widget.CalendarView;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

/*Draft java code by "Lazarus Android Module Wizard" [9/17/2018 0:53:58]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jVisualControl LAMW template*/

public class jCalendarView extends CalendarView /*dummy*/ { //please, fix what GUI object will be extended!

    private long pascalObj = 0;        // Pascal Object
    private Controls controls  = null; //Java/Pascal [events] Interface ...
    private jCommons LAMWCommon;
    private Context context = null;

    //private OnClickListener onClickListener;   // click event
    private Boolean enabled  = true;           // click-touch enabled!

    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
    public jCalendarView(Controls _ctrls, long _Self) { //Add more others news "_xxx" params if needed!

        super(_ctrls.activity);
        context   = _ctrls.activity;
        pascalObj = _Self;
        controls  = _ctrls;

        LAMWCommon = new jCommons(this,context,pascalObj);

        this.setOnDateChangeListener(new CalendarView.OnDateChangeListener() {
            @Override
            /*.*/public void onSelectedDayChange(CalendarView view, int year, int monthOfYear, int dayOfMonth) {
                // Note that months are indexed from 0. So, 0 means January, 1 means february, 2 means march etc.
               // String msg = "Selected date is " + dayOfMonth + "/" + (month + 1) + "/" + year;
                controls.pOnCalendarSelectedDayChange(pascalObj, year, monthOfYear+1, dayOfMonth);
            }

        });


    } //end constructor

    public void jFree() {
        //free local objects...
        //setOnClickListener(null);
        LAMWCommon.free();
    }

    public void SetViewParent(ViewGroup _viewgroup) {
        LAMWCommon.setParent(_viewgroup);
    }

    public ViewGroup GetParent() {
        return LAMWCommon.getParent();
    }

    public void RemoveFromViewParent() {
        LAMWCommon.removeFromViewParent();
    }

    public View GetView() {
        return this;
    }

    public void SetLParamWidth(int _w) {
        LAMWCommon.setLParamWidth(_w);
    }

    public void SetLParamHeight(int _h) {
        LAMWCommon.setLParamHeight(_h);
    }

    public int GetLParamWidth() {
        return LAMWCommon.getLParamWidth();
    }

    public int GetLParamHeight() {
        return  LAMWCommon.getLParamHeight();
    }

    public void SetLGravity(int _g) {
        LAMWCommon.setLGravity(_g);
    }

    public void SetLWeight(float _w) {
        LAMWCommon.setLWeight(_w);
    }

    public void SetLeftTopRightBottomWidthHeight(int _left, int _top, int _right, int _bottom, int _w, int _h) {
        LAMWCommon.setLeftTopRightBottomWidthHeight(_left,_top,_right,_bottom,_w,_h);
    }

    public void AddLParamsAnchorRule(int _rule) {
        LAMWCommon.addLParamsAnchorRule(_rule);
    }

    public void AddLParamsParentRule(int _rule) {
        LAMWCommon.addLParamsParentRule(_rule);
    }

    public void SetLayoutAll(int _idAnchor) {
        LAMWCommon.setLayoutAll(_idAnchor);
    }

    public void ClearLayoutAll() {
        LAMWCommon.clearLayoutAll();
    }

    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
    
    private String getDateString(long currentDateTime){
        //creating Date from millisecond
        Date currentDate = new Date(currentDateTime);  //Examples of patterns are dd/MM/yyyy, dd-MM-yyyy, MM/dd/yyyy, yyyy-MM-dd.
        DateFormat df = new SimpleDateFormat("MM/dd/yyyy");  // or dd/MM/yyyy
        //formatted value of current Date
        return df.format(currentDate);
    }

    private long getDateMilliseconds(String MMddyyyy) {
        //String date_ = date;
        SimpleDateFormat sdf = new SimpleDateFormat("MM/dd/yyyy");
        try
        {
            Date mDate = sdf.parse(MMddyyyy);
            long timeInMilliseconds = mDate.getTime();
            return timeInMilliseconds;
        }
        catch (ParseException e)
        {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }

        return 0;
    }

    // https://abhiandroid.com/ui/calendarview

    public void SetFirstDayOfWeek(int _firstDayOfWeek) {  //"2"
        this.setFirstDayOfWeek(_firstDayOfWeek);
    }

    public int GetFirstDayOfWeek() {
        return this.getFirstDayOfWeek();
    }

    public void SetFocusedMonthDateColor(int _color) {
        //[ifdef_api16up]
        if(Build.VERSION.SDK_INT >= 16) this.setFocusedMonthDateColor(_color);
        //[endif_api16up]
    }

    public void SetUnfocusedMonthDateColor(int _color) {
        //[ifdef_api16up]
        if(Build.VERSION.SDK_INT >= 16) this.setUnfocusedMonthDateColor(_color);
        //[endif_api16up]
    }

    public void SetSelectedWeekBackgroundColor(int _color) {
        //[ifdef_api16up]
        if(Build.VERSION.SDK_INT >= 16) this.setSelectedWeekBackgroundColor(_color);
        //[endif_api16up]
    }

    public void SetWeekSeparatorLineColor(int _color) {
        //[ifdef_api16up]
        if(Build.VERSION.SDK_INT >= 16) this.setWeekSeparatorLineColor(_color);
        //[endif_api16up]
    }

    public void SetWeekNumberColor(int _color) {
        //[ifdef_api16up]
        if(Build.VERSION.SDK_INT >= 16) this.setWeekNumberColor(_color);
        //[endif_api16up]
    }

    public long GetLongDate(){  //get selected date in milliseconds
        return this.getDate();
    }

    public void SetLongDate(long _date) {
        this.setDate(_date);
    }
    public String GetDate(){  //get selected date in milliseconds
        return getDateString(this.getDate());
    }

    public String GetMaxDate() {
        return getDateString(this.getMaxDate());
    }

    public String GetMinDate() {
        return getDateString(this.getMinDate());
    }
                   //dayOfMonth + "/" + (month + 1) + "/" + year

    //This method is used to set the selected date in milliseconds since January 1, 1970 00:00:00 in user’s preferred  time zone.
    public void SetDate(int _year, int _month, int  _day) { //set selected date 22 May 2016 in milliseconds yyyyMMdd
        String _MM_dd_yyyy =  _month + "/" + _day + "/" + _year;
        this.setDate(getDateMilliseconds(_MM_dd_yyyy));
    }

    public void SetMaxDate(int _year, int _month, int  _day) {
        String _MM_dd_yyyy =  _month + "/" + _day + "/" + _year;
        this.setMaxDate(getDateMilliseconds(_MM_dd_yyyy)); //Defines maximal date shown in calendar view in mm/dd/yyyy format
    }

    public void SetMinDate(int _year, int _month, int  _day) {
         String _MM_dd_yyyy =  _month + "/" + _day + "/" + _year;
         this.setMinDate(getDateMilliseconds(_MM_dd_yyyy)); //Defines minimal date shown in calendar view in mm/dd/yyyy format
    }

    public void SetShowWeekNumber(boolean _value) {  //set true value for showing the week numbers.
        this.setShowWeekNumber(_value);
    }

}
