package com.example.appgooglemapsdemo1;

import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.List;
import android.content.Context;
import android.graphics.Bitmap;
import android.util.Log;
import android.util.TypedValue;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewGroup.LayoutParams;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.GridView;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.RelativeLayout;
import android.widget.LinearLayout;

class jGridItem{

    Context ctx;
    String label;
    int itemTextColor;
    int itemTextSize;
    int id;
    String drawableIdentifier;

    public  jGridItem(Context context) {
        ctx = context;
        itemTextColor = 0; //default
    }
}

class jGridViewCustomAdapter extends ArrayAdapter {
	
    Context context;
    Controls contrls;
    long pascalObj;
        
    boolean mDispatchOnDrawItemTextColor;
    boolean mDispatchOnDrawItemBitmap;

    int mTextSizeTypedValue;

    private int itemsLayout;
    private List <jGridItem> items ;

    public jGridViewCustomAdapter(Context context, Controls ctrls,long pasobj, int ResourceId, int itemslayout, List<jGridItem> list) {
        super(context, ResourceId, list);  //ResourceId/0 or android.R.layout.simple_list_item_1;
        this.context=context;

        contrls = ctrls;
        pascalObj = pasobj;
                
        items = list;
        itemsLayout = itemslayout;
        mDispatchOnDrawItemTextColor = true;
        mDispatchOnDrawItemBitmap = true;

        mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_SP;
    }

    public void SetFontSizeUnit(int _unit) {
        switch (_unit) {
            case 0: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_SP; break; //default
            case 1: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_PX; break;
            case 2: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_DIP; break;
            case 3: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_MM; break;
            case 4: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_PT; break;
            case 5: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_SP; break;
        }
    }

    public void SetDispatchOnDrawItemTextColor(boolean _value) {
        mDispatchOnDrawItemTextColor= _value;
    }

    public void SetDispatchOnDrawItemBitmap(boolean _value) {
        mDispatchOnDrawItemBitmap= _value;
    }

    @Override
    public int getCount() {        
        return items.size();
    }

    @Override
    public Object getItem(int position) {
        return null;
    }

    @Override
    public long getItemId(int position) {
        return 0;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {

        LinearLayout listLayout = new LinearLayout(context);
        listLayout.setLayoutParams(new GridView.LayoutParams(LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT));

        android.widget.RelativeLayout itemLayout = new android.widget.RelativeLayout(context);
        itemLayout.setLayoutParams(new android.widget.RelativeLayout.LayoutParams(LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT));

        TextView textViewTitle = new TextView(context);

        textViewTitle.setPadding(10, 10, 10, 10); //try improve here ... 17-jan-2015

        ImageView imageViewItem = new ImageView(context);
        android.widget.RelativeLayout.LayoutParams imgParam = new android.widget.RelativeLayout.LayoutParams(LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT); //w,h

        android.widget.RelativeLayout.LayoutParams txtParam = new android.widget.RelativeLayout.LayoutParams(LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT); //w,h        
        txtParam.addRule(RelativeLayout.CENTER_HORIZONTAL);
        if ( this.itemsLayout == 0 ) {
            imageViewItem.setPadding(25,20,25,40);
            txtParam.addRule(RelativeLayout.ALIGN_PARENT_BOTTOM);
        }
        else {
            imageViewItem.setPadding(25,45,25,20);
            txtParam.addRule(RelativeLayout.ALIGN_PARENT_TOP);
        }

        if (mDispatchOnDrawItemBitmap)  {
            Bitmap  imageBmp = (Bitmap)contrls.pOnGridDrawItemBitmap(pascalObj, (int)position , items.get(position).label);
            if (imageBmp != null) {
                imageViewItem.setImageBitmap(imageBmp);
                itemLayout.addView(imageViewItem, imgParam);
            }
            else {
                if (! items.get(position).drawableIdentifier.equals("")) {
                    imageViewItem.setImageResource(GetDrawableResourceId( items.get(position).drawableIdentifier ));
                    itemLayout.addView(imageViewItem, imgParam);
                }
            }
        }
        else {
            if (! items.get(position).drawableIdentifier.equals("")) {
                imageViewItem.setImageResource(GetDrawableResourceId( items.get(position).drawableIdentifier ));
                itemLayout.addView(imageViewItem, imgParam);
            }
        }

        if (!items.get(position).label.equals("")) {
            textViewTitle.setText( items.get(position).label ); //+""+ items.get(position).id

            if (items.get(position).itemTextSize != 0) {
                if ((mTextSizeTypedValue != TypedValue.COMPLEX_UNIT_SP) )
                    textViewTitle.setTextSize(mTextSizeTypedValue, items.get(position).itemTextSize);
                else
                    textViewTitle.setTextSize(items.get(position).itemTextSize);
            }

            if (mDispatchOnDrawItemTextColor)  {
                int drawItemCaptionColor = contrls.pOnGridDrawItemCaptionColor(pascalObj, (int)position , items.get(position).label);
                if (drawItemCaptionColor != 0) {
                    textViewTitle.setTextColor(drawItemCaptionColor);
                }
                else {
                    if (items.get(position).itemTextColor != 0) {
                        textViewTitle.setTextColor(items.get(position).itemTextColor);
                    }
                }
            }
            else {
                if (items.get(position).itemTextColor != 0) {
                    textViewTitle.setTextColor(items.get(position).itemTextColor);
                }
            }

            itemLayout.addView(textViewTitle, txtParam);
        }

        listLayout.addView(itemLayout);

        return listLayout;
    }

    private int GetDrawableResourceId(String _resName) {   //    ../res/drawable
        try {
            Class<?> res = R.drawable.class;
            Field field = res.getField(_resName);  //"drawableName"
            int drawableId = field.getInt(null);
            return drawableId;
        }
        catch (Exception e) {
            Log.e("gridViewItem", "Failure to get drawable id.", e);
            return 0;
        }
    }

    public void SetItemsLayout(int value) {
        itemsLayout = value;
    }
}

/*Draft java code by "Lazarus Android Module Wizard" [1/9/2015 18:20:04]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jVisualControl template*/

public class jGridView extends GridView /*dummy*/ { //please, fix what GUI object will be extended!

    private long       pascalObj = 0;    // Pascal Object
    private Controls   controls  = null; // Control Class for events
    private jCommons LAMWCommon;
    
    private Context context = null;
 
    private  OnItemClickListener onItemClickListener;   // click event
    private Boolean enabled  = true;           // click-touch enabled!
 
    private int lastSelectedItem = -1;
    String lastSelectedItemCaption = "";

    int mItemTextColor = 0;
    int mItemTextSize = 0;

    private jGridViewCustomAdapter gridViewCustomeAdapter;
    private ArrayList<jGridItem>  alist;

    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
    public jGridView(Controls _ctrls, long _Self) { //Add more others news "_xxx"p arams if needed!
        super(_ctrls.activity);
        context   = _ctrls.activity;
        pascalObj = _Self;
        controls  = _ctrls;
        LAMWCommon = new jCommons(this,context,pascalObj);
        
        alist = new ArrayList<jGridItem>();

        //Create the Custom Adapter Object
        gridViewCustomeAdapter = new jGridViewCustomAdapter(this.controls.activity, controls, pascalObj, android.R.layout.simple_list_item_1, 0, alist);

        // Set the Adapter to GridView
        this.setAdapter(gridViewCustomeAdapter);

        onItemClickListener = new  OnItemClickListener(){
            /*.*/public void onItemClick(AdapterView<?> parent, View v, int position, long id){  //please, do not remove /*.*/ mask for parse invisibility!
                if (enabled) {
                    lastSelectedItem = (int)position;
                    lastSelectedItemCaption = alist.get((int)position).label;
                    controls.pOnClickGridItem(pascalObj, (int)position , alist.get((int)position).label);
                }
            };
        };

        this.setOnItemClickListener(onItemClickListener);

        this.setOnItemLongClickListener(new AdapterView.OnItemLongClickListener() {
            @Override
            public boolean onItemLongClick(AdapterView<?> parent, View view, int position, long id) {
                if (enabled) {
                    //Log.i("OnItemLongClickListener", "position = "+position);
                    lastSelectedItem = (int) position;
                    lastSelectedItemCaption = alist.get((int) position).label;
                    controls.pOnLongClickGridItem(pascalObj, (int) position, lastSelectedItemCaption);
                }
                return false;
            }
        });

        this.setNumColumns(android.widget.GridView.AUTO_FIT);  //android.widget.GridView.AUTO_FIT --> -1

    } //end constructor

    public void jFree() {
        //free local objects...
        alist.clear();
        alist    = null;
        setAdapter(null);
        gridViewCustomeAdapter = null;
        setOnItemClickListener(null);
        setOnItemLongClickListener(null); // renabor
        LAMWCommon.free();
    }

    public void SetViewParent(ViewGroup _viewgroup) {
    	LAMWCommon.setParent(_viewgroup);
    }

    public void RemoveFromViewParent() {
    	LAMWCommon.removeFromViewParent();
    }
    
	public ViewGroup GetParent() {
		return LAMWCommon.getParent();
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

    public void setLGravity(int _g) {
		LAMWCommon.setLGravity(_g);
    }

    public void setLWeight(float _w) {
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

    public void ClearLayoutAll() {   //TODO Pascal
		LAMWCommon.clearLayoutAll();
    }

    public void SetId(int _id) { //wrapper method pattern ...
        this.setId(_id);
    }

    //write others [public] methods code here......
    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...

    //by jmpessoa
    public  void Add(String _item, String _imgIdentifier) {
        jGridItem info = new jGridItem(controls.activity);
        info.label = _item;
        info.drawableIdentifier = _imgIdentifier;
        info.id = alist.size();
        info.itemTextColor = mItemTextColor;
        info.itemTextSize = mItemTextSize;
        alist.add(info);
        gridViewCustomeAdapter.notifyDataSetChanged();
    }

    public void SetNumColumns(int _value) {
        if (_value <= 0)
            this.setNumColumns(android.widget.GridView.AUTO_FIT);
        else
            this.setNumColumns(_value);
    }

    public void SetColumnWidth(int _value) {
        if (_value > 0)
            this.setColumnWidth(_value);
        else
            this.setNumColumns(40);
    }

    public  void Clear() {
        alist.clear();
        gridViewCustomeAdapter.notifyDataSetChanged();
    }

    public  void Delete(int _index) {
        alist.remove(_index);
        gridViewCustomeAdapter.notifyDataSetChanged();
    }

    public void SetItemsLayout(int _value){
        //0: image-text  ; 1: text-image
        gridViewCustomeAdapter.SetItemsLayout(_value);
    }

    public int  GetItemIndex() {
        return lastSelectedItem;
    }

    public String GetItemCaption() {
        return lastSelectedItemCaption;
    }

    public void DispatchOnDrawItemTextColor(boolean _value) {
        gridViewCustomeAdapter.SetDispatchOnDrawItemTextColor(_value);
    }


    public void DispatchOnDrawItemBitmap(boolean _value) {
        gridViewCustomeAdapter.SetDispatchOnDrawItemBitmap(_value);
    }

    public void SetFontSize(int _size) {
        mItemTextSize = _size;
    }

    public void SetFontColor(int _color) {
        mItemTextColor = _color;
    }


    public void UpdateItemTitle(int _index, String _title) {
        jGridItem info = alist.get(_index);
        info.label = _title;
        gridViewCustomeAdapter.notifyDataSetChanged();
    }

    //Set the amount of horizontal (x) spacing to place between each item in the grid.
    public void SetHorizontalSpacing(int _horizontalSpacingPixels) {
        this.setHorizontalSpacing(_horizontalSpacingPixels);
    }

    //Set the amount of vertical (y) spacing to place between each item in the grid.
    public void SetVerticalSpacing(int _verticalSpacingPixels){  // in pixels.
        this.setVerticalSpacing(_verticalSpacingPixels);
    }

    //Sets the currently selected item
    public void SetSelection(int _index){
        this.setSelection(_index);
    }

    //Control how items are stretched to fill their space.
    public void SetStretchMode(int _stretchMode) {
        this.setStretchMode(_stretchMode);
    }
   
   /*NO_STRETCH, STRETCH_SPACING, STRETCH_COLUMN_WIDTH, STRETCH_SPACING_UNIFORM,
    * smNone, smSpacingWidth, smColumnWidth, smSpacingWidthUniform 
    * none	0	Stretching is disabled.
      spacingWidth	1	The spacing between each column is stretched.
      columnWidth	2	Each column is stretched equally.
      spacingWidthUniform	3	The spacing between each column is uniformly stretched..
    */

} //end class


