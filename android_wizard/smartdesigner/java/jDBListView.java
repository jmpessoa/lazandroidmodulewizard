package ml.smartware.appdbgridviewdemo1;

import android.content.Context;
import android.graphics.Color;
import android.graphics.Typeface;
import android.graphics.drawable.ColorDrawable;
import android.util.Log;
import android.util.TypedValue;
import android.view.View;
import android.view.Gravity;
import android.view.ViewGroup;
import android.view.ViewGroup.LayoutParams;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.AdapterView;
import android.widget.CursorAdapter;
import android.database.Cursor;

class jDBCursorAdapter extends CursorAdapter {
	
	private jDBRecordView mClient;

    public jDBCursorAdapter(Context context, jDBRecordView rv) {
        super(context, null, 0);
        mClient = rv;   
    }
	
     @Override
    public View newView(Context context, Cursor cursor, ViewGroup parent) {
		// Log.i("jDBCursorAdapter", "newView called");
		return mClient.newView(parent, cursor);
	}

    @Override
    public void bindView(View view, Context context, Cursor cursor) {
		// Log.i("jDBCursorAdapter", "bindView called");
		mClient.bindView(view, cursor);
	}
}

class jDBViewHolder {
	TextView[] tv;
	
	public jDBViewHolder(int length) {
		tv = new TextView[length];
	}
	
	public void Add(TextView item, int position) {
		tv[position] = item;
	}
	
	public TextView Get(int position) {
		return tv[position];
	}
}
	
/*Draft java code by "Lazarus Android Module Wizard" [1/9/2015 18:20:04]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jVisualControl template*/

class jDBRecordView extends ListView {

    private Context    mContext = null;
    private Controls   controls  = null; // Control Class for events
    private long       pascalObj = 0;    // Pascal Object
    private jCommons   LAMWCommon;
     
    private Boolean enabled = true;      // click-touch enabled!

	private int mTextSizeTypedValue = 0;
    private int mItemTextColor = 0;
    private int mItemTextSize = 0;
    // private long mLastSelectedItem = -1;

	private String[] mColumnNames = null;
	private float[] mColumnWeight = null;
	private boolean mUseWeights = false;
	
    private jDBCursorAdapter mCustomAdapter;
	
	public jDBRecordView(Controls _ctrls, long _Self) { //Add more others news "_xxx" params if needed!
        super(_ctrls.activity);
		
        controls  = _ctrls;
        mContext  = _ctrls.activity;
        pascalObj = _Self;
        LAMWCommon = new jCommons(this, mContext, pascalObj);
        LAMWCommon.setMarginLeftTopRightBottom(0, 0, 0, 0);
		
		//ColorDrawable dvdr = new ColorDrawable(this.getResources().getColor(R.drawable.black));
		ColorDrawable dvdr = new ColorDrawable(0xFF000000);
		setDivider(dvdr);
		setDividerHeight(1);
		setId(controls.getJavaNewId());
		
		mColumnWeight = new float[]{1f};

		setChoiceMode(ListView.CHOICE_MODE_SINGLE);
		
        //Create the Custom Adapter Object
        mCustomAdapter = new jDBCursorAdapter(mContext, this);

        // Set the Adapter to ListView
        this.setAdapter(mCustomAdapter);

    } //end constructor
	
    public void jFree() {
        //free local objects...
        this.setAdapter(null);
        mCustomAdapter = null;
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

    public void SetLParamWidth(int _w) {
    	LAMWCommon.setLParamWidth(_w);   
    }

    public void SetLParamHeight(int _h) {
    	LAMWCommon.setLParamHeight(_h);
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

    public void ClearLayoutAll() {   //TODO Pascal
		LAMWCommon.clearLayoutAll();
    }

    public void SetFontSize(int _size) {
        mItemTextSize = _size;
    }

    public void SetFontColor(int _color) {
        mItemTextColor = _color;
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

	public void SetCursor(Cursor c) {
		// Log.i("jDBRecordView", "SetCursor called "+c);
		mCustomAdapter.changeCursor(c);
	}
	
	public void SetColumnWeights(float[] _weights) {
		mColumnWeight = new float[_weights.length];
		float sum = 0;
		for (int i = 0; i < _weights.length; i++) {
			sum += _weights[i];
		}
		for (int i = 0; i < _weights.length; i++) {
			mColumnWeight[i] = _weights[i] / sum;
		}
		mUseWeights = true;
	}

	public View newView(ViewGroup parent, Cursor cursor) {
		
        LinearLayout listLayout = new LinearLayout(mContext);
        listLayout.setLayoutParams(new ListView.LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.WRAP_CONTENT));
		listLayout.setOrientation(LinearLayout.HORIZONTAL);
		listLayout.setGravity(Gravity.START | Gravity.CENTER_VERTICAL);
		listLayout.setShowDividers(LinearLayout.SHOW_DIVIDER_MIDDLE);

		int nCols = cursor.getColumnCount();
		int txtWidth = 0;
		if (!mUseWeights)
			txtWidth = this.getWidth() / nCols;
		
		jDBViewHolder vh = new jDBViewHolder(nCols);
		for (int colndx = 1; colndx < nCols; colndx++) {                        // We never use the _id column 
			TextView textViewItem = new TextView(mContext);
            textViewItem.setTextSize(mTextSizeTypedValue, mItemTextSize == 0 ? 12 : mItemTextSize);
			if (mItemTextColor != 0)
				textViewItem.setTextColor(mItemTextColor);

			LinearLayout.LayoutParams txtParam = new LinearLayout.LayoutParams(txtWidth, LayoutParams.WRAP_CONTENT, 0); //w,h,weight
			txtParam.setMargins(10, 5, 0, 5);
			if (mUseWeights)
				txtParam.weight = mColumnWeight[colndx-1];
			
			textViewItem.setLayoutParams(txtParam);
			vh.Add(textViewItem, colndx);
            listLayout.addView(textViewItem);
        }
		
		listLayout.setTag(vh);
        return listLayout;
	}

	private boolean StackDumped = true;

	private void DumpStackTrace() {
		Log.i("jDBRecordView", "Printing stack trace:");
		StackTraceElement[] elements = Thread.currentThread().getStackTrace();
		for (int i = 1; i < elements.length; i++) {
			StackTraceElement s = elements[i];
			Log.i("jDBRecordView", "\tat " + s.getClassName() + "." + s.getMethodName() + "(" + s.getFileName() + ":" + s.getLineNumber() + ")");
		}
	}
	
	public void bindView(View view, Cursor cursor) {
		
		if (!StackDumped) {
			DumpStackTrace();
			StackDumped = true;
		}

		int position = cursor.getPosition();
		// Log.i("jDBRecordView", "bindView called for row "+position);
		boolean odd = (position % 2) == 1;
		if (odd) {
			view.setBackgroundColor(Color.LTGRAY);
		}
		else {
			view.setBackgroundColor(Color.WHITE);
		}
		
		jDBViewHolder vh = (jDBViewHolder) view.getTag();
		
		int nCols = cursor.getColumnCount();
		for (int colndx = 1; colndx < nCols; colndx++) {                        // We never use the _id column 
			TextView textViewItem = vh.Get(colndx);
			String text = "";
			int FldType = cursor.getType(colndx);
			switch (FldType) {
				case Cursor.FIELD_TYPE_NULL:
					text = " ";
					break;
				case Cursor.FIELD_TYPE_INTEGER:
					text = Integer.toString(cursor.getInt(colndx));
					break;
				case Cursor.FIELD_TYPE_FLOAT:
					text = String.format("%9.4f", cursor.getFloat(colndx));
					break;
				case Cursor.FIELD_TYPE_STRING:
					text = cursor.getString(colndx);
					break;
				case Cursor.FIELD_TYPE_BLOB:
					text = "(BLOB)";
			}
			textViewItem.setText(text);
		}
	}
	
	public View newHeader() {
		// Log.i("jDBRecordView", "newHeader ...");
		final int len = mColumnNames.length;
		LinearLayout header = new LinearLayout(mContext);
		header.setId(controls.getJavaNewId());
		header.setOrientation(LinearLayout.HORIZONTAL);
		header.setGravity(Gravity.CENTER);
		header.setShowDividers(LinearLayout.SHOW_DIVIDER_MIDDLE);
		header.setBackgroundColor(R.color.primary_light);
			
		LinearLayout.LayoutParams lllp = new LinearLayout.LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.WRAP_CONTENT);
		lllp.setMargins(0, 0, 0, 0);
		header.setLayoutParams(lllp);

		if (len > 0) {
			int txtWidth = 0;
			if (!mUseWeights)
				txtWidth = this.getWidth() / len;
			
			jDBViewHolder vh = new jDBViewHolder(len);
			for (int i = 0; i < len; i++) {
				TextView tv = new TextView(mContext);
				tv.setTextSize(mTextSizeTypedValue, mItemTextSize == 0 ? 12 : mItemTextSize);
				tv.setTypeface(null, Typeface.BOLD);
				tv.setGravity(Gravity.CENTER);
				LinearLayout.LayoutParams txtParam = new LinearLayout.LayoutParams(txtWidth, LayoutParams.WRAP_CONTENT, 0); //w,h,weight
				txtParam.setMargins(0, 5, 0, 5);
				if (mUseWeights)
					txtParam.weight = mColumnWeight[i];
			
				tv.setLayoutParams(txtParam);
				tv.setText(mColumnNames[i]);
				vh.Add(tv, i);
				header.addView(tv);
			}
			header.setTag(vh);
		}
		return header;
	}

	public View CreateHeader(String[] names) {
		// Log.i("jDBRecordView", "CreateHeader ...");
		mColumnNames = names;
		View header = newHeader();

		jDBViewHolder vh = (jDBViewHolder) header.getTag();
		int len = mColumnNames.length;
		for (int i = 0; i < len; i++) {               
			TextView tv = vh.Get(i);
			tv.setText(mColumnNames[i]);
		}
		return header;
	}
}

public class jDBListView extends LinearLayout {

	private Context    context = null;
	private Controls   controls  = null; // Control Class for events
	private long       pascalObj = 0;    // Pascal Object
	private jCommons   LAMWCommon;
	 
	private Boolean enabled = true;      // click-touch enabled!

	private int mTextSizeTypedValue = 0;
	private int mItemTextColor = 0;
	private int mItemTextSize = 0;
	private long mLastSelectedItem = -1;

	private AdapterView.OnItemClickListener onItemClickListener;           // click event handler
	private AdapterView.OnItemLongClickListener onItemLongClickListener;   // long click event handler
	
	private View mHeader = null;
	private jDBRecordView mItemList = null;
	
	private void dumpVH(ViewGroup top, String inset, View selected) {
		// Log.i("jDBListView","dumpVH");
		View child = null;

		int count = top.getChildCount();
		for (int i = 0; i < count; i++) {
			child = top.getChildAt(i);
			String txt = "";
			if (child instanceof TextView) {
				txt = " contains "+((TextView)child).getText();
			}
			Log.i("jDBListView", inset+i+((child==selected)?":*":": ")+"["+child+"]"+txt);
			if (child instanceof ViewGroup) {
				int cCount = ((ViewGroup)child).getChildCount();
				if (cCount > 0) {
					dumpVH((ViewGroup)child, inset+"  ", selected);
				}
			}
		}
	}

	//GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
	public jDBListView(Controls _ctrls, long _Self) { //Add more others news "_xxx" params if needed!
        super(_ctrls.activity);
		
        controls  = _ctrls;
        context   = _ctrls.activity;
        pascalObj = _Self;
        LAMWCommon = new jCommons(this, context, pascalObj);
        
		setOrientation(LinearLayout.VERTICAL);
		mItemList = new jDBRecordView(controls, pascalObj);
		mItemList.setId(controls.getJavaNewId());
		mItemList.SetViewParent(this);
		mItemList.SetLParamWidth(android.view.ViewGroup.LayoutParams.MATCH_PARENT);
		
        onItemClickListener = new AdapterView.OnItemClickListener(){
            /*.*/public void onItemClick(AdapterView<?> parent, View v, int position, long id){  //please, do not remove /*.*/ mask for parse invisibility!
				// Log.i("jDBListView","onItemClickListener.onItemClick("+position+", "+id+")");
                if (enabled) {
                    mLastSelectedItem = id;
					jDBViewHolder vh = (jDBViewHolder)v.getTag();
					String caption = String.valueOf(((TextView)vh.Get(1)).getText());            // position 0 will be null, see jDBRecordView.newView
                    controls.pOnClickDBListItem(pascalObj, (int)mLastSelectedItem, caption);
                }
				// dumpVH((ViewGroup)parent.getParent(), "", v);
            };
        };
        mItemList.setOnItemClickListener(onItemClickListener);

		onItemLongClickListener = new AdapterView.OnItemLongClickListener() {
            @Override
            /*.*/public boolean onItemLongClick(AdapterView<?> parent, View v, int position, long id) {
                if (enabled) {
                    mLastSelectedItem = id;
                    controls.pOnLongClickDBListItem(pascalObj, (int)mLastSelectedItem, "");
                }
                return false;
            }
        };
		mItemList.setOnItemLongClickListener(onItemLongClickListener);
		
    } //end constructor

    public void jFree() {
        //free local objects...
		if (mHeader != null) mHeader = null;
		mItemList.jFree();
		mItemList = null;
        onItemClickListener=null;
        onItemLongClickListener=null; // renabor
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

    public View GetView() {
        return this;
    }

    public int  GetItemIndex() {
        return (int)mLastSelectedItem;
    }

    // public String GetItemCaption() {
        // return lastSelectedItemCaption;
    // }

    //write others [public] methods code here......
    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...

    public void SetFontSize(int _size) {
        mItemList.SetFontSize(_size);
    }

    public void SetFontColor(int _color) {
        mItemList.SetFontColor(_color);
    }

    public void SetFontSizeUnit(int _unit) {
        mItemList.SetFontSizeUnit(_unit);
	}

	public void SetCursor(Cursor c) {
		// Log.i("jDBListView", "SetCursor called "+c);
		mItemList.SetCursor(c);
	}

	public void SetColumnWeights(float[] _weights) {
		mItemList.SetColumnWeights(_weights);
	}
	
	public void SetColumnNames(String[] names) {
		// Log.i("jDBListView", "SetColumnNames ... "+names[0]);
		if (names.length>0) {
			mHeader = mItemList.CreateHeader(names);
			mHeader.setVisibility(View.VISIBLE);
			this.addView(mHeader, 0);   // index (2nd parameter) must be 0 so that the header 'heads' the list
		}
		else {
			if (mHeader != null) {
				mHeader.setVisibility(View.GONE);
				this.removeViewAt(0);
				mHeader = null;
			}
		}
		// dumpVH((ViewGroup)mHeader, "", null);
	}
	
} //end class
