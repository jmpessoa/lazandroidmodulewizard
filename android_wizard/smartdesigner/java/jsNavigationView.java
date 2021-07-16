package org.lamw.appcompatnavigationdrawerdemo1;

import java.lang.reflect.Field;
import java.util.regex.Pattern;
import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Path;
import android.graphics.Rect;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.Drawable;
import android.os.Build;
import android.os.Handler;
import android.util.DisplayMetrics;
import android.util.TypedValue;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;
import com.google.android.material.navigation.NavigationView;
import android.text.SpannableString;
import android.text.style.ForegroundColorSpan;
import android.util.Log;

/*Draft java code by "Lazarus Android Module Wizard" [12/16/2017 0:54:36]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jVisualControl LAMW template*/
 
public class jsNavigationView extends NavigationView /*dummy*/ { //please, fix what GUI object will be extended!

   private long pascalObj = 0;        // Pascal Object
   private Controls controls  = null; //Java/Pascal [events] Interface ...
   private jCommons LAMWCommon;
   private Context context = null;

   //private OnClickListener onClickListener;   // click event
   
   private Boolean enabled  = true;           // click-touch enabled!
   private MenuItem mLastMenuItem = null;
   
   private int menuItemColor = android.R.color.black;
   private int selectedMenuItemColor = R.color.primary;
      
   RelativeLayout  headerLayout;     
   ImageView headerImageView;
   TextView headerTextView;
   TextView headerSubTextView;
   
   int headerImageIdentifier = R.drawable.ic_launcher;

   String mHeaderBackgroundImageIdentifier = "";
   String mHeaderLogoImageIdentifier = "";
   String mHeaderTitle ="Hello World!|LAMW 0.8";
   int mHeaderHeight = 240;

   int mHeaderLogoPosition = RelativeLayout.CENTER_IN_PARENT;

   //int imagePosRelativeToParente = RelativeLayout.CENTER_IN_PARENT;
   //int headerColor = 0xC5CAE9; // R.color.primary_light; ;

	String headerText;
    String headerSubText;

   int mHeaderColor = 0xC5CAE9; // R.color.primary_light; ;

   int itemId;
   String itemCaption;

   int textColor = Color.WHITE;
   int subTextColor = Color.WHITE;

   int headerTextSize = 0; //default
   int textSizeDecorated = 0; //1 = Decreasing  //2 Increasing  //0 none

   float textSizeDecoratedGap = 3;

   int mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_SP;

   //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
   public jsNavigationView(Controls _ctrls, long _Self) { //Add more others news "_xxx" params if needed!

      super(_ctrls.activity);
      context   = _ctrls.activity;
      pascalObj = _Self;
      controls  = _ctrls;

      LAMWCommon = new jCommons(this,context,pascalObj);
      
      if (Build.VERSION.SDK_INT >= 21) {
          this.setFitsSystemWindows(true);
       }
         
      this.setNavigationItemSelectedListener(new NavigationView.OnNavigationItemSelectedListener() {
    	  @Override
    	  /*.*/public boolean onNavigationItemSelected(MenuItem menuItem) {
    		  
    		    itemId = menuItem.getItemId();
    		    itemCaption = menuItem.getTitle().toString();
    		    
    		    if (mLastMenuItem !=  null) {    	
    		       // mLastMenuItem.setChecked(false);    		    	
        		   if (menuItemColor == android.R.color.black)
    		           mLastMenuItem.setChecked(false);  //highlighted item
        		   else
        		      SetItemTextColor(mLastMenuItem, menuItemColor);    		    	    		    	
    		    }
    		    
    		    if (selectedMenuItemColor == R.color.primary)
    		        menuItem.setChecked(true);  //highlighted item
    		    else
    		    	SetItemTextColor(menuItem, selectedMenuItemColor);

    		    mLastMenuItem = menuItem;
    		    
    		    Handler handler = new Handler();
	                handler.postDelayed(new Runnable(){
	                     @Override
	                     public void run(){
	                    	 controls.pOnClickNavigationViewItem(pascalObj, itemId, itemCaption);      
	                     }
	                 }, 300);
    		         		        		        		        			    			
    	        return true;    		        		    
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
      
   public Menu GetMenu() {
      return this.getMenu();
   }

   //https://ptyagicodecamp.github.io/adding-menu-items-in-navigation-drawer-dynamically.html      
   public Menu AddMenu(String _headerTitle) {	    
	    Menu menu = this.getMenu();	    
	    Menu submenu = menu.addSubMenu(_headerTitle);	    
	    //submenu.setHeaderIcon(controls.GetDrawableResourceId(_headerIconIdentifier));
	    this.invalidate();
	    return submenu;
   }	   
           
   public MenuItem AddItem(Menu _menu, int _itemId,  String _itemCaption) {	   	   	   
	   MenuItem item = _menu.add(0,_itemId,0 ,(CharSequence)_itemCaption);	   
	   this.invalidate();	   
	   return  item;
   }
   
   public void AddItem(Menu _menu,  int _itemId, String _itemCaption, String _drawableIdentifier) {	   	   	   	   
	  // MenuItem item = _menu.add(_itemCaption);	  
	   MenuItem item = _menu.add(0,_itemId,0 ,(CharSequence)_itemCaption);
	   int id = context.getResources().getIdentifier(_drawableIdentifier, "drawable", context.getPackageName() );		   
	   item.setIcon(id); // add icon with drawable resource	   
	   this.invalidate();
   }
     
   public void AddItemIcon(MenuItem _menuItem, String _drawableIdentifier) {	   	   	   	   
		   int id = context.getResources().getIdentifier(_drawableIdentifier, "drawable", context.getPackageName() );		   
		   _menuItem.setIcon(id); // add icon with drawable resource	   
		   this.invalidate();
   }
   
   //http://blog.xebia.com/android-design-support-navigationview/
   public void ClearMenu() {
	   this.getMenu().clear(); //clear old inflated items.   
   }
   
   public void AddHeaderView(View _headerView) {	
	   android.view.ViewGroup parent = (ViewGroup) _headerView.getParent();	 
	   
	   if (parent!=null)
	      parent.removeView(_headerView);
	   
	   this.addHeaderView(_headerView);
	   this.invalidate();
   }
    
   //ref. https://hanihashemi.com/2017/05/06/change-text-color-of-menuitem-in-navigation-drawer/
   public void SetItemTextColor(MenuItem _menuItem, int _color) {
	   SpannableString spanString = new SpannableString(_menuItem.getTitle().toString());
	   spanString.setSpan(new ForegroundColorSpan(_color ), 0, spanString.length(), 0);
	   _menuItem.setTitle(spanString);
   }
   
   public void SetAllItemsTextColor(int _color) {	   	   	   
	   for (int i = 0; i < this.getMenu().size(); i++) {
		   SetItemTextColor(this.getMenu().getItem(i), _color);
	   }  	   
	   menuItemColor = _color;
   }

   public void ResetAllItemsTextColor() {	   	   	   
	   for (int i = 0; i < this.getMenu().size(); i++) {
		   SetItemTextColor(this.getMenu().getItem(i),  menuItemColor);
	   }  	   
   }
   
   public void SetItemTextColor(int _color) {
	   menuItemColor = _color;
   }
   
   public void SetSelectedItemTextColor(int _color) {
	   selectedMenuItemColor = _color;
   }
      
   /*
    * Making image in circular shape
    * http://www.androiddevelopersolutions.com/2012/09/crop-image-in-circular-shape-in-android.html
    */
   public Bitmap GetRoundedShape(Bitmap _bitmapImage, int _diameter) {
    // TODO Auto-generated method stub	
    Bitmap sourceBitmap = _bitmapImage;
    Path path = new Path();
    
    int dim;
    if(_diameter == 0 ) { 
       dim = sourceBitmap.getHeight();
       if (dim > sourceBitmap.getWidth()) dim = sourceBitmap.getWidth();
    }
    else {
   	 dim = _diameter;
   	 int min;
   	 
   	 if (sourceBitmap.getWidth() <  sourceBitmap.getHeight())  
   		 min = sourceBitmap.getWidth();
   	 else
   		 min = sourceBitmap.getHeight();
   	  
   	 if (dim > min) dim = min; 
    }
    
    int targetWidth = dim;
    int targetHeight = dim;

    Bitmap targetBitmap = Bitmap.createBitmap(targetWidth, 
            targetHeight,Bitmap.Config.ARGB_8888);

    Canvas canvas = new Canvas(targetBitmap);

    path.addCircle(((float) targetWidth - 1) / 2,
    ((float) targetHeight - 1) / 2,
    (Math.min(((float) targetWidth), 
                  ((float) targetHeight)) / 2),
    Path.Direction.CCW);
    
    canvas.clipPath(path);
    
    canvas.drawBitmap(sourceBitmap, 
                                  new Rect(0, 0, sourceBitmap.getWidth(),
                                  sourceBitmap.getHeight()), 
                                  new Rect(0, 0, targetWidth,
                                  targetHeight), null);
    return targetBitmap;
   }


   public Bitmap GetRoundedShape(Bitmap _bitmapImage) {
   	return GetRoundedShape(_bitmapImage, 0);
   }
      
   private Bitmap GetBitmapFromById(int _resID) {
	    if( _resID == 0 ) return null; // by tr3e
	   
 		Drawable res = null;		
 		
 		if (Build.VERSION.SDK_INT < 21 ) {
 			Log.i("jsNavigationView","Build.VERSION.SDK_INT < 21");
 			res = this.controls.activity.getResources().getDrawable(_resID);
 		}
 		
 		
 		if(Build.VERSION.SDK_INT >= 21) {
 			Log.i("jsNavigationView","Build.VERSION.SDK_INT >= 21");
 			//[ifdef_api21up]
 			res = this.controls.activity.getResources().getDrawable(_resID, null);
 			//[endif_api21up]	
 		}	
        
 		
 		if (res != null)
 		  return  ((BitmapDrawable)res).getBitmap();
 		else
 		  return  null;
 	}

	public void AddHeaderView(int _color, Bitmap _bitmapLogo, String _text, int _height) {
		String delimiter = "|";
		String[] words = _text.split(Pattern.quote(delimiter));
		int countText = words.length;

		if (countText >= 2) {
			headerText = words[0];
			headerSubText = words[1];
		}
		else {
			headerText = _text;
		}

		Bitmap bmp =  _bitmapLogo;
		if (bmp != null) bmp = GetRoundedShape(bmp);

		headerLayout = new RelativeLayout(context);

		int h =  (int) (_height * getResources().getDisplayMetrics().density);  //_height = 192
		RelativeLayout.LayoutParams paramLayout = new RelativeLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, h);

		headerLayout.setLayoutParams(paramLayout);
		headerLayout.setBackgroundColor(_color);
		headerImageView = new ImageView(context);

		if (bmp != null) {
			headerImageView.setImageBitmap(bmp);
			headerImageView.setPadding(10, 10, 10, 10);
			headerImageView.setId(controls.getJavaNewId());
		}

		headerTextView = new TextView(context);
		headerTextView.setId(controls.getJavaNewId());
		headerTextView.setText(headerText);
		headerTextView.setPadding(10, 30, 10, 5);
		headerTextView.setTextColor(textColor);

		int i = 0;
		float auxf = setTextSizeAndGetAuxf(headerTextSize, headerTextView);
		if ( textSizeDecorated == 1)
			headerTextView.setTextSize(mTextSizeTypedValue, auxf - textSizeDecoratedGap*i);  // sdDeCecreasing
		else if (textSizeDecorated == 2)
			headerTextView.setTextSize(mTextSizeTypedValue, auxf + textSizeDecoratedGap*i);  // sdInCecreasing

		if (bmp != null) {
			RelativeLayout.LayoutParams paramImg = new RelativeLayout.LayoutParams(ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT);
			paramImg.addRule(mHeaderLogoPosition); //RelativeLayout.CENTER_IN_PARENT
			headerLayout.addView(headerImageView, paramImg);
		}

		RelativeLayout.LayoutParams paramText = new RelativeLayout.LayoutParams(ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT);
		paramText.addRule(RelativeLayout.CENTER_HORIZONTAL);
		paramText.addRule(RelativeLayout.BELOW, headerImageView.getId());
		headerLayout.addView(headerTextView, paramText);

		if (countText >= 2) {
			headerSubTextView = new TextView(context);
			headerSubTextView.setText(headerSubText);
			headerSubTextView.setPadding(10, 5, 10, 20);
			headerSubTextView.setTextColor(subTextColor);

			int factor = 1;
			float aux = setTextSizeAndGetAuxf(headerTextSize, headerSubTextView);
			if ( textSizeDecorated == 1)
				headerSubTextView.setTextSize(mTextSizeTypedValue, aux - textSizeDecoratedGap*factor);  // sdDeCecreasing
			else if (textSizeDecorated == 2)
				headerSubTextView.setTextSize(mTextSizeTypedValue, aux + textSizeDecoratedGap*factor);  // sdInCecreasing

			RelativeLayout.LayoutParams paramText2 = new RelativeLayout.LayoutParams(ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT);
			paramText2.addRule(RelativeLayout.CENTER_HORIZONTAL);
			paramText2.addRule(RelativeLayout.BELOW, headerTextView.getId());
			headerLayout.addView(headerSubTextView, paramText2);
		}
		this.addHeaderView(headerLayout);
	}

	public void AddHeaderView(int _color, String _drawableLogoIdentifier, String _text, int _height) {
	   	   
	      String delimiter = "|";
	      String[] words = _text.split(Pattern.quote(delimiter));
	      int countText = words.length;
	      
	      if (countText >= 2) {	    	  
	    	  headerText = words[0];
	    	  headerSubText = words[1];
	      }
	      else {	    	  
	    	  headerText = _text;
	      }

	      headerImageIdentifier = context.getResources().getIdentifier(_drawableLogoIdentifier, "drawable", context.getPackageName() );

	      Bitmap bmp =  GetBitmapFromById(headerImageIdentifier);	      
	      if (bmp != null) bmp = GetRoundedShape(bmp);
	      	      	      
	      headerLayout = new RelativeLayout(context); 
	      
	      int h =  (int) (_height * getResources().getDisplayMetrics().density);  //_height = 192
	      RelativeLayout.LayoutParams paramLayout = new RelativeLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, h);

	      headerLayout.setLayoutParams(paramLayout);
	      headerLayout.setBackgroundColor(_color);
	      headerImageView = new ImageView(context);

	      if (bmp != null) { 	    	  
	    	  headerImageView.setImageBitmap(bmp);	      
	          headerImageView.setPadding(10, 10, 10, 10);
	          headerImageView.setId(controls.getJavaNewId());
          }
	      
		  headerTextView = new TextView(context);
		  headerTextView.setId(controls.getJavaNewId());
		  headerTextView.setText(headerText);      
		  headerTextView.setPadding(10, 30, 10, 5);
		  headerTextView.setTextColor(textColor);

		int i = 0;
		float auxf = setTextSizeAndGetAuxf(headerTextSize, headerTextView);
		if ( textSizeDecorated == 1)
			headerTextView.setTextSize(mTextSizeTypedValue, auxf - textSizeDecoratedGap*i);  // sdDeCecreasing
		else if (textSizeDecorated == 2)
			headerTextView.setTextSize(mTextSizeTypedValue, auxf + textSizeDecoratedGap*i);  // sdInCecreasing

		if (bmp != null) {
	          RelativeLayout.LayoutParams paramImg = new RelativeLayout.LayoutParams(ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT);
	          paramImg.addRule(mHeaderLogoPosition);//RelativeLayout.CENTER_IN_PARENT
			  headerLayout.addView(headerImageView, paramImg);
		  }	      

		  RelativeLayout.LayoutParams paramText = new RelativeLayout.LayoutParams(ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT);
		  paramText.addRule(RelativeLayout.CENTER_HORIZONTAL);
		  paramText.addRule(RelativeLayout.BELOW, headerImageView.getId());
		  headerLayout.addView(headerTextView, paramText);

		  if (countText >= 2) {
  	          headerSubTextView = new TextView(context);
  	          headerSubTextView.setText(headerSubText);      
  	          headerSubTextView.setPadding(10, 5, 10, 20);
     	      headerSubTextView.setTextColor(subTextColor);

			  int factor = 1;
			  float aux = setTextSizeAndGetAuxf(headerTextSize, headerSubTextView);
			  if ( textSizeDecorated == 1)
				  headerSubTextView.setTextSize(mTextSizeTypedValue, aux - textSizeDecoratedGap*factor);  // sdDeCecreasing
			  else if (textSizeDecorated == 2)
				  headerSubTextView.setTextSize(mTextSizeTypedValue, aux + textSizeDecoratedGap*factor);  // sdInCecreasing

    		  RelativeLayout.LayoutParams paramText2 = new RelativeLayout.LayoutParams(ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT);
    		  paramText2.addRule(RelativeLayout.CENTER_HORIZONTAL);
    		  paramText2.addRule(RelativeLayout.BELOW, headerTextView.getId());
    	      headerLayout.addView(headerSubTextView, paramText2);	    	  
	      }

	      this.addHeaderView(headerLayout);
   }

	private void AddHeaderView(int _headerColor,  String _drawableBackgroundIdentifier, String _drawableLogoIdentifier, String _text, int _height) {
		Bitmap bmp = null;
   	    String delimiter = "|";
		String[] words = _text.split(Pattern.quote(delimiter));
		int countText = words.length;

		if (countText >= 2) {
			headerText = words[0];
			headerSubText = words[1];
		}
		else {
			headerText = _text;
		}
		if (! _drawableLogoIdentifier.equals("")) {
			headerImageIdentifier = context.getResources().getIdentifier(_drawableLogoIdentifier, "drawable", context.getPackageName());
			bmp = GetBitmapFromById(headerImageIdentifier);
			if (bmp != null) bmp = GetRoundedShape(bmp);
		}

		headerLayout = new RelativeLayout(context);
		int h =  (int) (_height * getResources().getDisplayMetrics().density);  //_height = 192
		RelativeLayout.LayoutParams paramLayout = new RelativeLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, h);
		headerLayout.setLayoutParams(paramLayout);
		headerLayout.setBackgroundColor(_headerColor);

		if (bmp != null) {
			headerImageView = new ImageView(context);
			headerImageView.setImageBitmap(bmp);
			headerImageView.setPadding(10, 10, 10, 10);
			headerImageView.setId(controls.getJavaNewId());
		}

		headerTextView = new TextView(context);
		headerTextView.setId(controls.getJavaNewId());
		headerTextView.setText(headerText);
		headerTextView.setPadding(10, 30, 10, 5);
		headerTextView.setTextColor(textColor);

		int factor1 = 0;
		float aux1 = setTextSizeAndGetAuxf(headerTextSize, headerTextView);
		if ( textSizeDecorated == 1)
			headerTextView.setTextSize(mTextSizeTypedValue, aux1 - textSizeDecoratedGap*factor1);  // sdDeCecreasing
		else if (textSizeDecorated == 2)
			headerTextView.setTextSize(mTextSizeTypedValue, aux1 + textSizeDecoratedGap*factor1);  // sdInCecreasing

		if (bmp != null) {
			RelativeLayout.LayoutParams paramImg = new RelativeLayout.LayoutParams(ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT);
			paramImg.addRule(mHeaderLogoPosition); //RelativeLayout.CENTER_IN_PARENT
			headerLayout.addView(headerImageView, paramImg);
		}

		RelativeLayout.LayoutParams paramText = new RelativeLayout.LayoutParams(ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT);
		paramText.addRule(RelativeLayout.CENTER_HORIZONTAL);
		paramText.addRule(RelativeLayout.BELOW, headerImageView.getId());
		headerLayout.addView(headerTextView, paramText);

		if (countText >= 2) {
			headerSubTextView = new TextView(context);
			headerSubTextView.setText(headerSubText);
			headerSubTextView.setPadding(10, 5, 10, 20);
			headerSubTextView.setTextColor(subTextColor);

			int factor2 = 1;
			float aux2 = setTextSizeAndGetAuxf(headerTextSize, headerSubTextView);
			if ( textSizeDecorated == 1)
				headerSubTextView.setTextSize(mTextSizeTypedValue, aux2 - textSizeDecoratedGap*factor2);  // sdDeCecreasing
			else if (textSizeDecorated == 2)
				headerSubTextView.setTextSize(mTextSizeTypedValue, aux2 + textSizeDecoratedGap*factor2);  // sdInCecreasing

			RelativeLayout.LayoutParams paramText2 = new RelativeLayout.LayoutParams(ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT);
			paramText2.addRule(RelativeLayout.CENTER_HORIZONTAL);
			paramText2.addRule(RelativeLayout.BELOW, headerTextView.getId());
			headerLayout.addView(headerSubTextView, paramText2);
		}

		if (! _drawableBackgroundIdentifier.equals("")) {
			headerLayout.setBackgroundResource(context.getResources().getIdentifier(_drawableBackgroundIdentifier, "drawable", context.getPackageName()));
		}

		this.addHeaderView(headerLayout);

	}

	public void AddHeaderView(String _drawableBackgroundIdentifier, String _drawableLogoIdentifier, String _text, int _height) {
		AddHeaderView(android.R.color.transparent,  _drawableBackgroundIdentifier, _drawableLogoIdentifier, _text, _height);
	}

	public void SetHeaderBackgroundImageIdentifier(String _backgroundIdentifier) {
		mHeaderBackgroundImageIdentifier = _backgroundIdentifier;
	}

	public void SetHeaderLogoImageIdentifier(String _logoIdentifier) {
		mHeaderLogoImageIdentifier = _logoIdentifier;
	}

	public void SetHeaderLogoPosition(int _logoPosition) {//RelativeLayout.CENTER_IN_PARENT;
		mHeaderLogoPosition = _logoPosition;
	}

	public void SetHeaderColor(int _color) {
		mHeaderColor = _color;
	}

	public void SetHeaderTitle(String _headerTitle) {
		mHeaderTitle = _headerTitle;
	}

	public void SetHeaderHeight(int _value) {
		mHeaderHeight = _value;
	}

	public void SetHeader(String _backgroundIdentifier,String _logoIdentifier,
			               int _logoPosition, int _color, String _headerTitle, int _height) {
		mHeaderBackgroundImageIdentifier = _backgroundIdentifier;
		mHeaderLogoImageIdentifier = _logoIdentifier;
		mHeaderLogoPosition = _logoPosition;
		mHeaderColor = _color;
		mHeaderTitle = _headerTitle;
		mHeaderHeight = _height;
		UpdateHeader();
	}

	public void UpdateHeader() {
		AddHeaderView(mHeaderColor, mHeaderBackgroundImageIdentifier,
				                    mHeaderLogoImageIdentifier,
				                    mHeaderTitle,
				                    mHeaderHeight);
	}

	public void AddHeaderView(String _drawableBackgroundIdentifier, Bitmap _bitmapLogo, String _text, int _height) {

		String delimiter = "|";
		String[] words = _text.split(Pattern.quote(delimiter));
		int countText = words.length;

		if (countText >= 2) {
			headerText = words[0];
			headerSubText = words[1];
		}
		else {
			headerText = _text;
		}

		Bitmap bmp =  _bitmapLogo;
		if (bmp != null) bmp = GetRoundedShape(bmp);

		headerLayout = new RelativeLayout(context);
		int h =  (int) (_height * getResources().getDisplayMetrics().density);  //_height = 192
		RelativeLayout.LayoutParams paramLayout = new RelativeLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, h);
		headerLayout.setLayoutParams(paramLayout);
		headerImageView = new ImageView(context);

		if (bmp != null) {
			headerImageView.setImageBitmap(bmp);
			headerImageView.setPadding(10, 10, 10, 10);
			headerImageView.setId(controls.getJavaNewId());
		}

		headerTextView = new TextView(context);
		headerTextView.setId(controls.getJavaNewId());
		headerTextView.setText(headerText);
		headerTextView.setPadding(10, 30, 10, 5);
		headerTextView.setTextColor(textColor);

		int factor1 = 0;
		float aux1 = setTextSizeAndGetAuxf(headerTextSize, headerTextView);
		if ( textSizeDecorated == 1)
			headerTextView.setTextSize(mTextSizeTypedValue, aux1 - textSizeDecoratedGap*factor1);  // sdDeCecreasing
		else if (textSizeDecorated == 2)
			headerTextView.setTextSize(mTextSizeTypedValue, aux1 + textSizeDecoratedGap*factor1);  // sdInCecreasing

		if (bmp != null) {
			RelativeLayout.LayoutParams paramImg = new RelativeLayout.LayoutParams(ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT);
			paramImg.addRule(mHeaderLogoPosition); //RelativeLayout.CENTER_IN_PARENT
			headerLayout.addView(headerImageView, paramImg);
		}

		RelativeLayout.LayoutParams paramText = new RelativeLayout.LayoutParams(ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT);
		paramText.addRule(RelativeLayout.CENTER_HORIZONTAL);
		paramText.addRule(RelativeLayout.BELOW, headerImageView.getId());
		headerLayout.addView(headerTextView, paramText);

		if (countText >= 2) {
			headerSubTextView = new TextView(context);
			headerSubTextView.setText(headerSubText);
			headerSubTextView.setPadding(10, 5, 10, 20);
			headerSubTextView.setTextColor(subTextColor);

			int factor2 = 1;
			float aux2 = setTextSizeAndGetAuxf(headerTextSize, headerSubTextView);
			if ( textSizeDecorated == 1)
				headerSubTextView.setTextSize(mTextSizeTypedValue, aux2 - textSizeDecoratedGap*factor2);  // sdDeCecreasing
			else if (textSizeDecorated == 2)
				headerSubTextView.setTextSize(mTextSizeTypedValue, aux2 + textSizeDecoratedGap*factor2);  // sdInCecreasing

			RelativeLayout.LayoutParams paramText2 = new RelativeLayout.LayoutParams(ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT);
			paramText2.addRule(RelativeLayout.CENTER_HORIZONTAL);
			paramText2.addRule(RelativeLayout.BELOW, headerTextView.getId());
			headerLayout.addView(headerSubTextView, paramText2);
		}

		headerLayout.setBackgroundResource(context.getResources().getIdentifier(_drawableBackgroundIdentifier, "drawable", context.getPackageName() ));
		this.addHeaderView(headerLayout);
	}

    public void SetSubtitleTextColor(int _color) {
	   subTextColor =  _color;
   }

    public void SetTitleTextColor(int _color) {
	   textColor = _color; 
   }

	public void SetTitleTextSize(int _textSize) {
		headerTextSize = _textSize;
	}

	public void SetTitleSizeDecorated(int _sizeDecorated) {
		//int textSizeDecorated = 1; //1 = Decreasing  //2 Increasing  //0 none
		textSizeDecorated = _sizeDecorated;
	}

	public void SetTitleSizeDecoratedGap(float _textSizeGap) {
		//int textSizeDecorated = 1; //1 = Decreasing  //2 Increasing  //0 none
		textSizeDecoratedGap = _textSizeGap;
	}

   /* TODO
	public void SetFontSizeUnit(int _unit) {
		switch (_unit) {
			case 0: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_SP; break; //default
			case 1: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_PX; break;  //raw pixel :: good experience!
			case 2: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_DIP; break; //device
			case 3: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_MM; break;
			case 4: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_PT; break;  //points
			case 5: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_SP; break;  //scaled pixel -- default
		}
	}
   */

	private float pixelsToSP(Float px) {  //Scaled Pixels
		float scaledDensity = controls.activity.getResources().getDisplayMetrics().scaledDensity;
		return px/scaledDensity;
	}

	private float setTextSizeAndGetAuxf(int _textSize, TextView _textView){
		float auxCustomPixel;
		float defaultInPixel = _textView.getTextSize();  //default in pixel!!!
		float result =  pixelsToSP(defaultInPixel);  //just initialize ... pixel to TypedValue.COMPLEX_UNIT_SP
		if (mTextSizeTypedValue == TypedValue.COMPLEX_UNIT_SP) {
			result =  pixelsToSP(defaultInPixel);   //default in TypedValue.COMPLEX_UNIT_SP!
			if (_textSize != 0) {
				_textView.setTextSize(_textSize);
				auxCustomPixel = _textView.getTextSize();
				result = pixelsToSP(auxCustomPixel);  //custom in default in TypedValue.COMPLEX_UNIT_SP!
			}
		}
		return result;
	}


	public void SetFitsSystemWindows(boolean _value) {
	   LAMWCommon.setFitsSystemWindows(_value);
	}

}


