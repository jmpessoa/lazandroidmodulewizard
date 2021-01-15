package org.lamw.appselectdirectorydialogdemo1;


import android.content.Context;
//import android.util.Log;
import android.graphics.Color;
import android.os.Build;
import android.view.View;
import android.view.ViewGroup;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.SearchView;

/*Draft java code by "Lazarus Android Module Wizard" [9/21/2018 22:00:44]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jVisualControl LAMW template*/

public class jSearchView extends SearchView /*dummy*/ { //please, fix what GUI object will be extended!

    private long pascalObj = 0;        // Pascal Object
    private Controls controls = null; //Java/Pascal [events] Interface ...
    private jCommons LAMWCommon;
    private Context context = null;

    private OnClickListener onClickListener;   // click event
    private Boolean enabled = true;           // click-touch enabled!
    private SearchView thisView;

    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
    public jSearchView(Controls _ctrls, long _Self, boolean _iconified) { //Add more others news "_xxx" params if needed!

        super(_ctrls.activity);
        context = _ctrls.activity;
        pascalObj = _Self;
        controls = _ctrls;

        thisView = this;

        LAMWCommon = new jCommons(this, context, pascalObj);

        onClickListener = new OnClickListener() {

            /*.*/public void onClick(View view) {     // *.* is a mask to future parse...;
                if (enabled) {
                   // controls.pOnClickGeneric(pascalObj); //JNI event onClick!
                }
            }

            ;
        };
        setOnClickListener(onClickListener);

        // perform set on query text focus change listener event
        this.setOnQueryTextFocusChangeListener(new View.OnFocusChangeListener() {
            @Override
            /*.*/ public void onFocusChange(View v, boolean hasFocus) {
                // do something when the focus of the query text field changes
                controls.pOnSearchViewFocusChange(pascalObj, hasFocus);

                if (hasFocus)
                    controls.pOnClickGeneric(pascalObj); //JNI event onClick!
            }
        });

        // perform set on query text listener event
        this.setOnQueryTextListener(new SearchView.OnQueryTextListener() {
            @Override
            /*.*/ public boolean onQueryTextSubmit(String query) {
                // do something on text submit
                controls.pOnSearchViewQueryTextSubmit(pascalObj, query);
                return false;
            }

            @Override
            /*.*/ public boolean onQueryTextChange(String newText) {
                // do something when text changes
                controls.pOnSearchViewQueryTextChange(pascalObj, newText);
                return false;
            }
        });

        // Catch event on [x] button inside search view
        /*https://stackoverflow.com/questions/24794377/how-do-i-capture-searchviews-clear-button-click/26770767
        It works, just don't forget to add searchView.setIconified(true); or searchView.setIconified(false);
         */
        int searchCloseButtonId = this.getContext().getResources().getIdentifier("android:id/search_close_btn", null, null);
        ImageView closeButton = (ImageView)this.findViewById(searchCloseButtonId);
        // Set on click listener
        closeButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                // Manage this event.
                //Log.i("[x] button", "Clicked!!");
                thisView.setQuery("", false);
                controls.pOnClickX(pascalObj);
            }
        });

        this.setIconified(_iconified);

        this.setFocusable(true);
    } //end constructor

    public void jFree() {
        //free local objects...
        setOnClickListener(null);
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
        return LAMWCommon.getLParamHeight();
    }

    public void SetLGravity(int _g) {
        LAMWCommon.setLGravity(_g);
    }

    public void SetLWeight(float _w) {
        LAMWCommon.setLWeight(_w);
    }

    public void SetLeftTopRightBottomWidthHeight(int _left, int _top, int _right, int _bottom, int _w, int _h) {
        LAMWCommon.setLeftTopRightBottomWidthHeight(_left, _top, _right, _bottom, _w, _h);
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
    public String GetQuery() {
        //CharSequence
        return (String) this.getQuery();
    }

    // getQueryHint():
    public String GetQueryHint() {
        String res = "";
        //CharSequence
        //return (String)this.getQueryHint(); //API 16
        return res;
    }

    public boolean IsIconfiedByDefault() {
        return this.isIconfiedByDefault();
    }

    /*  https://abhiandroid.com/ui/searchviewss
        https://www.javatpoint.com/android-searchview
    Important Note: When a SearchView is used in an Action Bar as an action view for collapsible menu item then
    it needs to be set to iconified by default using setIconfiedByDefault(true) function.
    If you want the search field to always be visible, then call setIconifiedByDefault(false).
    true is the default value for this function.
    You can also set iconfied from xml by using  iconfiedByDefault property to true or false.
    support example:  https://javapapers.com/android/android-searchview-action-bar-tutorial/  */

    public void SetIconifiedByDefault(boolean _value) {  //true = defaiult
        this.setIconifiedByDefault(_value);
    }

    public void SetQueryHint(String _hint) {
        this.setQueryHint((CharSequence) _hint);
    }


    /*
        It works, just don't forget to add searchView.setIconified(true); or searchView.setIconified(false);
        a true value will collapse the SearchView to an icon, while a false will expand it.

        Any query text is cleared when iconified. This is a temporary state and does not override the default
        iconified state set by setIconifiedByDefault(boolean). If the default state is iconified, then a false here
        will only be valid until the user closes the field. And if the default state is expanded,
        then a true here will only clear the text field and not close it.
    */
    public void SetIconified(boolean _value) {   //Iconifies or expands the SearchView.
        this.setIconified(_value);
    }
//https://stackoverflow.com/questions/24794377/how-do-i-capture-searchviews-clear-button-click/26770767
    public void Clear(){
        /*
        //Find EditText view
        int searchEditTextId = this.getContext().getResources().getIdentifier("android:id/search_src_text", null, null);
        EditText edit = (EditText)this.findViewById(searchEditTextId);
        //Clear the text from EditText view
        edit.setText("");
        */
        this.setQuery("", false);
    }

    public void SetText(String _query) {
        //Clear query
        this.setQuery(_query, false);
    }

    public void SetTextAndSubmit(String _query) {
        //Clear query
        this.setQuery(_query, true);
    }

    public void SelectAll() {
        int id = this.getContext().getResources().getIdentifier("android:id/search_src_text", null, null);
        EditText editText = (EditText) this.findViewById(id);
        editText.selectAll();
        editText.setHighlightColor(Color.CYAN);
    }

    public void SelectAll(int _color) {
        int id = this.getContext().getResources().getIdentifier("android:id/search_src_text", null, null);
        EditText editText = (EditText) this.findViewById(id);
        editText.selectAll();
        editText.setHighlightColor( _color);
    }

    public void SetFocus() {
        this.setIconified(false);
        this.requestFocus();
    }

    public void ClearFocus() {
        this.clearFocus();
        //this.setIconified(true);
    }

    public void SetSoftInputShownOnFocus(boolean _show) {
        //[ifdef_api21up]
        if (Build.VERSION.SDK_INT >= 21) {
            int id = this.getContext().getResources().getIdentifier("android:id/search_src_text", null, null);
            EditText editText = (EditText) this.findViewById(id);
            editText.setShowSoftInputOnFocus(_show);
        } //[endif_api21up]
    }

    public EditText GetInnerEditView() {
            int id = this.getContext().getResources().getIdentifier("android:id/search_src_text", null, null);
            EditText editText = (EditText) this.findViewById(id);
            return  editText;
    }
}
