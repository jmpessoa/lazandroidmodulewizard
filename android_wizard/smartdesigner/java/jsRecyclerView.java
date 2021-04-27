package org.lamw.appcompatrecyclerviewdemo1;

import android.content.Context;
import android.content.res.AssetManager;
import android.graphics.PorterDuff.Mode;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.Rect;
import android.graphics.Typeface;
import android.graphics.drawable.ColorDrawable;
import android.graphics.drawable.Drawable;
import android.graphics.drawable.PaintDrawable;
import android.os.AsyncTask;
import android.os.Build;
import android.os.Environment;
import android.os.Handler;
import android.view.View;
import android.view.ViewGroup;
import com.google.android.material.appbar.AppBarLayout;
import androidx.coordinatorlayout.widget.CoordinatorLayout;
import androidx.cardview.widget.CardView;
import androidx.recyclerview.widget.DefaultItemAnimator;
import androidx.recyclerview.widget.DividerItemDecoration;
import androidx.recyclerview.widget.GridLayoutManager;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView; 
import androidx.recyclerview.widget.StaggeredGridLayoutManager;
import android.util.Log;
import android.util.TypedValue;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Pattern;

import android.widget.CheckBox;
import android.widget.CompoundButton;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.Switch;
import android.widget.TextView;
import android.widget.RatingBar;
import android.widget.ProgressBar;
import android.widget.RelativeLayout.LayoutParams;
import android.view.MotionEvent;


//-------------------------------------------------------------------------
// jsRecyclerView
// Review by ADiV for LAMW on 2021-03-09
//-------------------------------------------------------------------------

class IdObjects{
	
	static final String VIEW_TEXT     = "Text";
	static final String VIEW_IMAGE    = "Image";
	static final String VIEW_CHECK    = "Check";
	static final String VIEW_RATING   = "Rating";
	static final String VIEW_SWITCH   = "Switch";
	static final String VIEW_PROGRESS = "Progress";
	static final String VIEW_PANEL    = "Panel";
	
	public int[] idLabel;
	public int[] idImage;
	public int[] idCheck;
	public int[] idRating;
	public int[] idSwitch;
	public int[] idProgress;
	public int[] idPanel;
	
	public int countLabel = 0;
	public int countImage = 0;
	public int countCheck = 0;
	public int countRating = 0;
	public int countSwitch = 0;
	public int countProgress = 0;
	public int countPanel = 0;
	
	public IdObjects(String holderItemFormat) {		
		   countLabel = countSubString(holderItemFormat, VIEW_TEXT);  //mContentFormat = "jTextView:300|jTextView:301|IMAGE:200";
		   idLabel = new int[countLabel];	
			
	       countImage= countSubString(holderItemFormat, VIEW_IMAGE);  //mContentFormat = "TEXT:300|TEXT:301|IMAGE:200";
		   idImage = new int[countImage];

		   countCheck = countSubString(holderItemFormat, VIEW_CHECK);  //mContentFormat = "TEXT:300|TEXT:301|IMAGE:200";
		   idCheck = new int[countCheck];

		   countRating= countSubString(holderItemFormat, VIEW_RATING);  //mContentFormat = "TEXT:300|TEXT:301|IMAGE:200";
		   idRating = new int[countRating];

		   countSwitch = countSubString(holderItemFormat, VIEW_SWITCH);  //mContentFormat = "TEXT:300|TEXT:301|IMAGE:200";
		   idSwitch = new int[countSwitch];
		   
		   countProgress = countSubString(holderItemFormat, VIEW_PROGRESS);  //mContentFormat = "TEXT:300|TEXT:301|IMAGE:200";
		   idProgress = new int[countProgress];
		   
		   countPanel= countSubString(holderItemFormat, VIEW_PANEL);  //mContentFormat = "TEXT:300|TEXT:301|IMAGE:200";
		   idPanel = new int[countPanel];

		   int indexLabel = 0;
		   int indexImage = 0;
		   int indexCheck = 0;
		   int indexRating = 0;
		   int indexSwitch = 0;
		   int indexProgress  = 0;
		   int indexPanel = 0;

		   String delimiter = "|";
		   String[] words = holderItemFormat.split(Pattern.quote(delimiter));
		   int countAll =  words.length;
		   delimiter = ":";		   		   
		   		 
		   for (int i=0; i < countAll; i++) {	   
		    if ( words[i].contains(VIEW_TEXT) )	{		    	    												 
				String[] nameValueText = words[i].split(Pattern.quote(delimiter));
				idLabel[indexLabel] = Integer.valueOf(nameValueText[1]);				
				indexLabel++;
		    }
		    
		    if ( words[i].contains(VIEW_IMAGE) )	{		    	    												 
				String[] nameValueText = words[i].split(Pattern.quote(delimiter));
				idImage[indexImage] = Integer.valueOf(nameValueText[1]);				
				indexImage++;
		    }
		    
		    if ( words[i].contains(VIEW_CHECK) )	{		    	    												 
				String[] nameValueText = words[i].split(Pattern.quote(delimiter));
				idCheck[indexCheck] = Integer.valueOf(nameValueText[1]);				
				indexCheck++;
		    }
		    
		    if ( words[i].contains(VIEW_RATING) )	{		    	    												 
				String[] nameValueText = words[i].split(Pattern.quote(delimiter));
				idRating[indexRating] = Integer.valueOf(nameValueText[1]);				
				indexRating++;
		    }
		    
		    if ( words[i].contains(VIEW_SWITCH) )	{		    	    												 
				String[] nameValueText = words[i].split(Pattern.quote(delimiter));
				idSwitch[indexSwitch] = Integer.valueOf(nameValueText[1]);				
				indexSwitch++;
		    }
		    
		    if ( words[i].contains(VIEW_PROGRESS) )	{		    	    												 
				String[] nameValueText = words[i].split(Pattern.quote(delimiter));
				idProgress[indexProgress] = Integer.valueOf(nameValueText[1]);				
				indexProgress++;
		    }
		    
		    if ( words[i].contains(VIEW_PANEL) )	{		    	    												 
				String[] nameValueText = words[i].split(Pattern.quote(delimiter));
				idPanel[indexPanel] = Integer.valueOf(nameValueText[1]);				
				indexPanel++;
		    }
		   }					
	}
	
	//http://www.java2s.com/Code/Java/Data-Type/Countthenumberofinstancesofsubstringwithinastring.htm
    public int countSubString(final String string, final String substring) {
       int count = 0;
       int idx = 0;
       while ((idx = string.indexOf(substring, idx)) != -1) {
          idx++;
          count++;
       }
       return count;
    }
}

class ItemObject {

    public String[] label;
    public int[] labelTextColor;    
    public int[] idLabel;
    public int countlabel = 0;

    public String[] image;
    public int[] idImage;
    public int countimage = 0;

	public String[] check;
	public int[] idCheck;
	public int[] checkTextColor;
	public int countcheck = 0;

	public String[] rating;
	public int[] idRating;
	public int countrating = 0;

	public String[] switchbtn;
	public int[] switchTextColor;
	public int[] idSwitch;
	public int countswitchbtn = 0;
	
	public String[] progress;
	public int[] idProgress;
	public int countprogress = 0;
	
	public String[] panel;
	public int[] idPanel;
	public int countpanel = 0;
	
	public int itemSelect = 0;
	public String  itemTag = "";

	//public int position;

    public ItemObject(String content, String format,  String delimiter, int pos, IdObjects idObjects) {
		//position = pos;
    	String upperFormat = format.toUpperCase();

		countlabel = countSubString(upperFormat, "TEXT");
		label = new String[countlabel];
		labelTextColor = new int[countlabel];
		idLabel = new int[countlabel];

		countimage= countSubString(upperFormat, "IMAGE");
		image = new String[countimage];
		idImage = new int[countimage];

		countcheck = countSubString(upperFormat, "CHECK");
		check = new String[countcheck];
		checkTextColor = new int[countcheck];
		idCheck = new int[countcheck];

		countrating = countSubString(upperFormat, "RATING");
		rating = new String[countrating];
		idRating = new int[countrating];

		countswitchbtn = countSubString(upperFormat, "SWITCH");
		switchbtn = new String[countswitchbtn];
		switchTextColor = new int[countswitchbtn];
		idSwitch  = new int[countswitchbtn];
		
		countprogress = countSubString(upperFormat, "PROGRESS");
		progress = new String[countprogress];
		idProgress  = new int[countprogress];
		
		countpanel = countSubString(upperFormat, "PANEL");
		panel = new String[countpanel];		
		idPanel  = new int[countpanel];

		int indexText = 0;
		int indexImage = 0;
		int indexCheck = 0;
		int indexRating = 0;
		int indexSwitchbtn = 0;
		int indexProgress = 0;
		int indexPanel = 0;

		String[] formats  = upperFormat.split(Pattern.quote(delimiter));  //  "\\s+"   [space]						
		String[] contents = content.split(Pattern.quote(delimiter));
		
		int countAll =  formats.length;
		for (int i=0; i < countAll; i++) {

			if ( formats[i].startsWith("TEXT") )	{
				label[indexText] =  contents[i];
				labelTextColor[indexText] = 0;
				idLabel[indexText] = -1;
				
				if(idObjects != null)
					if( indexText < idObjects.countLabel )
						idLabel[indexText] = idObjects.idLabel[indexText];
								
				indexText++;
			}
							
			if ( formats[i].startsWith("IMAGE") )	{								
				image[indexImage] = contents[i];  //data@location
				idImage[indexImage] = -1;
				
				if(idObjects != null)
					if( indexImage < idObjects.countImage )
						idImage[indexImage] = idObjects.idImage[indexImage];
				
				indexImage++;
			}

			if ( formats[i].startsWith("CHECK") )	{  //visited@0   or visited@1
				check[indexCheck] =  contents[i]; //caption@value
				checkTextColor[indexCheck] = 0;
				idCheck[indexCheck] = -1;
				
				if(idObjects != null)
					if( indexCheck < idObjects.countCheck )
						idCheck[indexCheck] = idObjects.idCheck[indexCheck];
				
				indexCheck++;
			}

			if ( formats[i].startsWith("RATING") )	{  //value  ex: 2 or 3.5
				rating[indexRating] =  contents[i];
				idRating[indexRating] = -1;
				
				if(idObjects != null)
					if( indexRating < idObjects.countRating )
						idRating[indexRating] = idObjects.idRating[indexRating];
				
				indexRating++;
			}


			if ( formats[i].startsWith("SWITCH") )	{  //value  ex: OFF:ON@0  OFF:ON@1   //1=checked
				switchbtn[indexSwitchbtn] =  contents[i];
				switchTextColor[indexSwitchbtn] = 0;
				idSwitch[indexSwitchbtn] = -1;
				
				if(idObjects != null)
					if( indexSwitchbtn < idObjects.countSwitch )
						idSwitch[indexSwitchbtn] = idObjects.idSwitch[indexSwitchbtn];
				
				indexSwitchbtn++;
			}
			
			if ( formats[i].startsWith("PROGRESS") )	{  //value  ex: OFF:ON@0  OFF:ON@1   //1=checked
				progress[indexProgress] =  contents[i];
				idProgress[indexProgress] = -1;
				
				if(idObjects != null)
					if( indexProgress < idObjects.countProgress )
						idProgress[indexProgress] = idObjects.idProgress[indexProgress];
				
				indexProgress++;
			}
			
			if ( formats[i].startsWith("PANEL") )	{  //value  ex: color@cornerRadiusRound
				panel[indexPanel] =  contents[i];				
				idPanel[indexPanel] = -1;
				
				if(idObjects != null)
					if( indexPanel < idObjects.countPanel )
						idPanel[indexPanel] = idObjects.idPanel[indexPanel];
				
				indexPanel++;
			}
		}              
    }
    
    //http://www.java2s.com/Code/Java/Data-Type/Countthenumberofinstancesofsubstringwithinastring.htm
    public int countSubString(final String string, final String substring) {
       int count = 0;
       int idx = 0;
       while ((idx = string.indexOf(substring, idx)) != -1) {
          idx++;
          count++;
       }
       return count;
    }

}

//https://www.androidhive.info/2012/07/android-loading-image-from-url-http/
//http://www.viralandroid.com/2015/11/load-image-from-url-internet-in-android.html
class LoadImageTask extends AsyncTask <String, Void, Bitmap> {
	
	//public Listener mListener;
	public ImageView mImageView;
	
    public LoadImageTask(/*Listener listener*/ImageView imageView) {
        //mListener = listener;
    	mImageView = imageView;
    }

    @Override
    protected Bitmap doInBackground(String... args) {
        try {
            return BitmapFactory.decodeStream((InputStream)new URL(args[0]).getContent());
        } catch (IOException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    protected void onPostExecute(Bitmap bitmap) {
        if (bitmap != null) {        	
        	//mListener.onImageLoaded("sucesss loading imagem !!! ");
        	mImageView.setImageBitmap(bitmap);
        	Log.i("onImageLoaded", "sucesss loading imagem !!! ");
            
        } else {
            //mListener.onError();
        	Log.i("onImageLoaded", "Error loading imagem ....");
        	//mListener.onImageLoaded("Error loading imagem ....");
        }
    }    
    
    /*
    public interface Listener{    	
        void onImageLoaded(String status);
        //void onError();
    } 
    */       
}

class RecyclerViewAdapter extends RecyclerView.Adapter<RecyclerViewAdapter.RecyclerViewHolders>  {

	public IdObjects idObjects = null;
    public List<ItemObject> itemList;
    public String mItemContentDictionary; // = "TEXT|TEXT|DRAWABLE";    
    public String mItemContentDelimiter; // = "|";
    private Context context;
    //public OnItemSelecteListener mListener;
    public View mDraftLayoutView;
    public boolean mCardStyle;
    public int     mCardRound = 0;
    public int     mCardColor = Color.WHITE;
    String mFormat="dummy";
    public Controls  controls;
    public long pasObject;
    public int  backId=-1;

	public RecyclerViewAdapter(Controls _controls,  long PasObj, List<ItemObject> _itemList) {
        this.itemList = _itemList;
		controls = _controls;
		pasObject = PasObj;
        this.context = controls.activity; 
    }

    @Override
    public RecyclerViewHolders onCreateViewHolder(ViewGroup parent, int viewType) {
		View v  = getlayoutView(context, mFormat);
    	return new RecyclerViewHolders(context, pasObject, v, mFormat);  //holderView
    }    

    @Override
    public void onBindViewHolder(RecyclerViewHolders holderView, final int position) {
    	if( (position < 0) || (position >= itemList.size()) ) return;
    	    	    	    	
		int countlabel = itemList.get(position).countlabel;
    	int countimage = itemList.get(position).countimage;
		int countcheck = itemList.get(position).countcheck;
		int countrating = itemList.get(position).countrating;
		int countswitchbtn = itemList.get(position).countswitchbtn;
		int countprogress  = itemList.get(position).countprogress;
		int countpanel     = itemList.get(position).countpanel;

    	for (int i=0; i < countlabel; i++) {
    		if( itemList.get(position).idLabel[i] == -1 )
    		 itemList.get(position).idLabel[i] = holderView.label[i].getId();
    		
    		holderView.label[i].setText( itemList.get(position).label[i]);
    		
    		//--- TextColor
    		int textColor    = itemList.get(position).labelTextColor[i];
    		
    		if( textColor != 0 )    		  
    		  holderView.label[i].setTextColor( textColor );    		     		   		     		    		    		    	
    	}

		for (int i=0; i < countcheck; i++) {
			if( itemList.get(position).idCheck[i] == -1 )
	    		itemList.get(position).idCheck[i] = holderView.check[i].getId();
			
            String delimiter = "@";
            String checkData = itemList.get(position).check[i];  //image@drawable
            String[] namevalue = checkData.split(Pattern.quote(delimiter));
            holderView.check[i].setText( namevalue[0]);
                        
            if ( namevalue[1].equals("1"))
               holderView.check[i].setChecked(true);
            
            //--- TextColor
    		int textColor    = itemList.get(position).checkTextColor[i];
    		
    		if( textColor != 0 )
    			 holderView.check[i].setTextColor( textColor );
		}

		for (int i=0; i < countswitchbtn; i++) {
			if( itemList.get(position).idSwitch[i] == -1 )
	    		itemList.get(position).idSwitch[i] = holderView.switchbtn[i].getId();
			
			String delimiter = "@";
			String data = itemList.get(position).switchbtn[i];  //OFF:ON@0  OFF:ON@1   1=checked
			String[] nameval = data.split(Pattern.quote(delimiter));


			if (nameval[0].contains(":")) {
				//[ifdef_api21up]
				if (Build.VERSION.SDK_INT >= 21) {
					holderView.switchbtn[i].setShowText(true);
				}//[endif_api21up]
				delimiter = ":";
				String[] OffOn = nameval[0].split(Pattern.quote(delimiter));  //OFF:ON
				holderView.switchbtn[i].setTextOff(OffOn[0]);
				holderView.switchbtn[i].setTextOn(OffOn[1]);
			}
			else {
				holderView.switchbtn[i].setText( nameval[0]);
			}
						           
			if ( nameval[1].equals("1"))
				holderView.switchbtn[i].setChecked(true);
			
			//--- TextColor
    		int textColor    = itemList.get(position).switchTextColor[i];
    		
    		if( textColor != 0 )
    			 holderView.switchbtn[i].setTextColor( textColor );    		
		}

		for (int i=0; i < countrating; i++) {
			if( itemList.get(position).idRating[i] == -1 )
	    		itemList.get(position).idRating[i] = holderView.rating[i].getId();
			
			float r = Float.parseFloat(itemList.get(position).rating[i]);
			holderView.rating[i].setRating(r);
		}
		
		for (int i=0; i < countprogress; i++) {
			if( itemList.get(position).idProgress[i] == -1 )
	    		itemList.get(position).idProgress[i] = holderView.progress[i].getId();
			
			int r = Integer.parseInt(itemList.get(position).progress[i]);
			holderView.progress[i].setProgress(r);
		}
		
		for (int i=0; i < countpanel; i++) {
			if( itemList.get(position).idPanel[i] == -1 )
	    		itemList.get(position).idPanel[i] = holderView.panel[i].getId();
			
			int index = countpanel - i - 1;
			
			String delimiter = "@";
            String panelData = itemList.get(position).panel[index];  //??@??
            String[] namevalue = panelData.split(Pattern.quote(delimiter));
            
            holderView.panel[index].setBackgroundColor( Integer.parseInt(namevalue[0]) );                                    
			
			int panelRound = Integer.parseInt(namevalue[1]);
					
		    if( panelRound > 0){
			 PaintDrawable  shape =  new PaintDrawable();
	         shape.setCornerRadius(panelRound);                
	         int color = Color.TRANSPARENT;
	         Drawable background = holderView.panel[index].getBackground();        
	         if (background instanceof ColorDrawable) {
	            color = ((ColorDrawable)holderView.panel[index].getBackground()).getColor();
		        shape.setColorFilter(color, Mode.SRC_ATOP);        		           		        		        
		        //[ifdef_api16up]
		  	    if(Build.VERSION.SDK_INT >= 16) 
		  	    	holderView.panel[index].setBackground((Drawable)shape);
		        //[endif_api16up]		          
	         }
		    }
		}

		for (int i=0; i < countimage; i++) {
			if( itemList.get(position).idImage[i] == -1 )
	    		itemList.get(position).idImage[i] = holderView.image[i].getId();
			
		    String imageData = itemList.get(position).image[i];  //image@drawable
    		String delimiter = "@";    		
    		String[] namevalue = imageData.split(Pattern.quote(delimiter));
    		
    		if 	( namevalue[1].equals("drawable") ) {  	
    		  int id = context.getResources().getIdentifier(namevalue[0], "drawable", context.getPackageName() );    		
    		  holderView.image[i].setImageResource(id);
    		}
    		else if 	( namevalue[1].equals("assets") ) {    			
    			holderView.image[i].setImageBitmap( LoadFromAssets(namevalue[0]) ); 
    		}    		
    		//https://www.learn2crack.com/2014/06/android-load-image-from-internet.html
    		//https://inducesmile.com/android-tutorials-for-nigerian-developer/android-load-image-from-url/
    		else if 	(namevalue[1].startsWith("http") ) {    			
    			new LoadImageTask(holderView.image[i]).execute(namevalue[0]);
    		}    		    		
    		else if 	(namevalue[1].startsWith("download") ) {    			    			
    			holderView.image[i].setImageBitmap( LoadFromFile(namevalue[0]) );
    		}    		    		
    		else if 	(namevalue[1].startsWith("sdcard") ) {
    			holderView.image[i].setImageBitmap( LoadFromSdcard(namevalue[0]) );    			
    		}    		
    	}       	
    }

    public Bitmap LoadFromFile(String _filename) { //EnvironmentDirectoryPath  !!	
       File filePath = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS);	 	 	      	      
 	   return BitmapFactory.decodeFile(filePath.getPath() +"/"+_filename);
    }
    
    public Bitmap LoadFromSdcard(String _filename) {    	
	    if (Environment.getExternalStorageState().equals(Environment.MEDIA_MOUNTED) == true) {
	    	File filePath = Environment.getExternalStorageDirectory();  //sdcard!
	    	return BitmapFactory.decodeFile(filePath.getPath() +"/"+_filename);	   	    
	    }
	    else return null;
    }

    public Bitmap LoadFromAssets(String strName)  {
       AssetManager assetManager = context.getAssets();
       InputStream istr = null;
       try {
          istr = assetManager.open(strName);
       } catch (IOException e) {
          e.printStackTrace();
       }
       return BitmapFactory.decodeStream(istr);      
    }

        
    @Override
    public int getItemCount() {
        return this.itemList.size();
    }
    
    public void setItemContentDictionary(String contentDictionary, String delimiter) {
    	mItemContentDictionary = contentDictionary;
    	mItemContentDelimiter = delimiter; 
    }
    
    public void add(String content) {    	    	
    	int position = this.itemList.size();
    	itemList.add(position, new ItemObject(content, mItemContentDictionary, mItemContentDelimiter, position, idObjects) );
        notifyItemInserted(position);
    }

    public void remove(int position) {
    	if( (position < 0) || (position >= itemList.size()) ) return;
    	    			
    	itemList.remove(position);        
        notifyItemRangeChanged(position, itemList.size());
    }
    
    public void RemoveAll() {    	    	    	
    	itemList.clear();            	
        notifyDataSetChanged();
    }
    
    public int GetItemsSelect(){
    	int countSelect = 0;
    	
    	for( int i = 0; i < this.itemList.size(); i++ )
    		if( itemList.get(i).itemSelect > 0 )
    			countSelect++;
    			
    	return countSelect;
    }
    
    public void ClearItemsSelect(){
    	
    	for( int i = 0; i < this.itemList.size(); i++ )
    		if( itemList.get(i).itemSelect > 0 )
    			itemList.get(i).itemSelect = 0;
    	
    }
    
    public int GetItemSelectFirst(){
    	
    	for( int i = 0; i < this.itemList.size(); i++ )
    		if( itemList.get(i).itemSelect > 0 )
    			return i;
    	
    	return -1;
    }
    
    public int GetItemSelectFirst( int _int ){
    	
    	for( int i = 0; i < this.itemList.size(); i++ )
    		if( itemList.get(i).itemSelect == _int )
    			return i;
    	
    	return -1;
    }
    
    public void SetItemSelect( int position, int select ){
    	if( (position < 0) || (position >= itemList.size()) ) return;
    	
    	itemList.get(position).itemSelect = select;
    }
    
    public void SetItemTag( int position, String tagString ){
    	if( (position < 0) || (position >= itemList.size()) ) return;
    	
    	itemList.get(position).itemTag = tagString;
    }
    
    public int GetItemSelect( int position ){
    	if( (position < 0) || (position >= itemList.size()) ) return 0;
    	
    	return itemList.get(position).itemSelect;
    }
    
    public String GetItemTag( int position ){
    	if( (position < 0) || (position >= itemList.size()) ) return "";
    	
    	return itemList.get(position).itemTag;
    }
    
    public void SetWidgetText(int position, int widget, int widgetId, String strText){
    	
    	if( (position < 0) || (position >= itemList.size()) ) return;
    	
    	//Pascal: TItemContentFormat = (cfText=0, cfImage=1, cfCheck=2, cfRating=3, cfSwitch=4, cfPanel=5, cfProgress=6);
    	
    	switch(widget){
    	 case 0:{
    		int countLabel = itemList.get(position).countlabel;
 			
 			for( int i = 0; i < countLabel; i++)
 				if( itemList.get(position).idLabel[i] == widgetId ){
 					itemList.get(position).label[i] = strText;
 					break;
 				}
    	 }break;
    	 case 1:{
    		    int countImage = itemList.get(position).countimage;
    			
    			for( int i = 0; i < countImage; i++)
    				if( itemList.get(position).idImage[i] == widgetId ){
    					itemList.get(position).image[i] = strText;
    					break;
    				}
    	 }break;
    	 case 2:{
    		int countCheck = itemList.get(position).countcheck;
  			
  			for( int i = 0; i < countCheck; i++)
  				if( itemList.get(position).idCheck[i] == widgetId ){
  					itemList.get(position).check[i] = strText;
  					break;
  				} 
    	 }break;
    	 case 3:{
    		int countSwitch = itemList.get(position).countswitchbtn;
   			
   			for( int i = 0; i < countSwitch; i++)
   				if( itemList.get(position).idSwitch[i] == widgetId ){
   					itemList.get(position).switchbtn[i] = strText;
   					break;
   				} 
    	 }break;
    	 case 4:{
    		 int countRating = itemList.get(position).countrating;
    			
    		 for( int i = 0; i < countRating; i++)
    			if( itemList.get(position).idRating[i] == widgetId ){
    				itemList.get(position).rating[i] = strText;
    				break;
    		 } 
    	 }break;
    	 case 5:{
    		 int countPanel = itemList.get(position).countpanel;
 			
    		 for( int i = 0; i < countPanel; i++)
    			if( itemList.get(position).idPanel[i] == widgetId ){
    				itemList.get(position).panel[i] = strText;
    				break;
    		 }  
    	 }break;
    	 case 6:{
    		 int countProgress = itemList.get(position).countprogress;
  			
    		 for( int i = 0; i < countProgress; i++)
    			if( itemList.get(position).idProgress[i] == widgetId ){
    				itemList.get(position).progress[i] = strText;
    				break;
    		 }
    	 }break;    	     	
    	}
    	   		
    }
    
    public String GetWidgetText(int position, int widget, int widgetId){
    	
    	if( (position < 0) || (position >= itemList.size()) ) return "";
    	
    	//Pascal: TItemContentFormat = (cfText=0, cfImage=1, cfCheck=2, cfRating=3, cfSwitch=4, cfPanel=5, cfProgress=6);
    	
    	switch(widget){
    	 case 0:{
    		int countLabel = itemList.get(position).countlabel;
 			
 			for( int i = 0; i < countLabel; i++)
 				if( itemList.get(position).idLabel[i] == widgetId )
 					return itemList.get(position).label[i]; 					 				
    	 }break;
    	 case 1:{
    		    int countImage = itemList.get(position).countimage;
    			
    			for( int i = 0; i < countImage; i++)
    				if( itemList.get(position).idImage[i] == widgetId )
    					return itemList.get(position).image[i];    				    			
    	 }break;
    	 case 2:{
    		int countCheck = itemList.get(position).countcheck;
  			
  			for( int i = 0; i < countCheck; i++)
  				if( itemList.get(position).idCheck[i] == widgetId )
  					return itemList.get(position).check[i];
    	 }break;
    	 case 3:{
    		int countSwitch = itemList.get(position).countswitchbtn;
   			
   			for( int i = 0; i < countSwitch; i++)
   				if( itemList.get(position).idSwitch[i] == widgetId )
   					return itemList.get(position).switchbtn[i];   					
    	 }break;
    	 case 4:{
    		 int countRating = itemList.get(position).countrating;
    			
    		 for( int i = 0; i < countRating; i++)
    			if( itemList.get(position).idRating[i] == widgetId )
    				return itemList.get(position).rating[i];
    	 }break;
    	 case 5:{
    		 int countPanel = itemList.get(position).countpanel;
 			
    		 for( int i = 0; i < countPanel; i++)
    			if( itemList.get(position).idPanel[i] == widgetId )
    				return itemList.get(position).panel[i];    				
    	 }break;
    	 case 6:{
    		 int countProgress = itemList.get(position).countprogress;
  			
    		 for( int i = 0; i < countProgress; i++)
    			if( itemList.get(position).idProgress[i] == widgetId )
    				return itemList.get(position).progress[i];
    	 }break;    	     	   	
       }
    	
       return "";
    }
    
    public void SetCardBackgroundColor( int _color ){
    	mCardColor = _color;
    }
    
    public void SetItemsRound(int _round){
    	if(_round > 0)
    	    mCardRound = _round;
    	else
    		mCardRound = 0;
    }
    
    public void SetItemBackgroundColor( int position, int color, int round ){
    	if( (position < 0) || (position >= itemList.size()) ) return;
    	
    	int countpanel = itemList.get(position).countpanel;
    	
    	if( countpanel > 0 )
    		itemList.get(position).panel[0] = Integer.toString(color)+"@"+Integer.toString(round); //color@cornerRadiusRound
    }
    
    public void SetWidgetTextColor( int position, int widget, int widgetid, int color ){
    	
    	if( (position < 0) || (position >= itemList.size()) ) return;
    	
    	//Pascal: TItemContentFormat = (cfText=0, cfImage=1, cfCheck=2, cfRating=3, cfSwitch=4, cfPanel=5, cfProgress=6);
    	
    	switch(widget){
    	 case 0:{
    		int countLabel = itemList.get(position).countlabel;
    		
    		for( int i = 0; i < countLabel; i++)
    			if( itemList.get(position).idLabel[i] == widgetid ){
    				itemList.get(position).labelTextColor[i] = color;
    				break;
    			}
    	 }break;
    	 case 2:{
    		int countCheck = itemList.get(position).countcheck;
     		
     		for( int i = 0; i < countCheck; i++)
     			if( itemList.get(position).idCheck[i] == widgetid ){
     				itemList.get(position).checkTextColor[i] = color;
     				break;
     			}
    	 }break;
    	 case 4:{
    		int countSwitch = itemList.get(position).countswitchbtn;
     		
     		for( int i = 0; i < countSwitch; i++)
     			if( itemList.get(position).idSwitch[i] == widgetid ){
     				itemList.get(position).switchTextColor[i] = color;
     				break;
     			}
    	 }break;
    	 
    	}
    }
    
    public void Refresh(){    	
    	notifyItemRangeChanged(0, this.itemList.size());    	
    }
    
    public void Refresh(int position){
    	if( (position < 0) || (position >= itemList.size()) ) return;
    	
    	notifyItemChanged(position);
    }
    
    public void Moved(int fromPosition, int toPosition){
    	
    	if( itemList.size() < 2 ) return;
    	
    	int posFrom = fromPosition;
    	int posTo   = toPosition;
    	
    	if( posFrom >= itemList.size() )
    		posFrom = itemList.size() - 1;
    	else if(posFrom < 0)
    		posFrom = 0;
    	
    	if( posTo >= itemList.size() )
    		posTo = itemList.size() - 1;
    	else if(posTo < 0)
    		posTo = 0;
    	
    	ItemObject itemFrom = itemList.get(posFrom);
    	ItemObject itemTo   = itemList.get(posTo);
    	
    	itemList.remove(posTo);
    	itemList.add(posTo, itemFrom);
    	
    	itemList.remove(posFrom);
    	itemList.add(posFrom, itemTo);
    			
    	notifyItemMoved(posFrom, posTo);
    }
    
    //https://faqdroid.com/android-material-design-recyclerview-android-cardview-example-tutorial
    //https://www.androidtutorialpoint.com/material-design/android-cardview-tutorial/
    //https://inducesmile.com/android/android-recyclerview-and-cardview-in-material-design-tutorial/
    
    public void setlayoutView(View draftlayoutView, boolean cardStyle) {    	
    	mCardStyle = cardStyle;
	    mDraftLayoutView = draftlayoutView;
	    // "jTextView:5|jTextView:6|jImageView:7";    
		mFormat = getAllChildrenBFS(draftlayoutView);
		
		idObjects = new IdObjects(mFormat);
    }
        
    public int countSubString(final String string, final String substring) {
	       int count = 0;
	       int idx = 0;
	       while ((idx = string.indexOf(substring, idx)) != -1) {
	          idx++;
	          count++;
	       }
	       return count;
	}
    
	public float pixelsToSP(Float px) {  //Scaled Pixels
	    float scaledDensity = context.getResources().getDisplayMetrics().scaledDensity;
	    return px/scaledDensity;
	}

    public View getlayoutView(Context ctx, String holderItemFormat) {
    	
       RelativeLayout layout = new RelativeLayout(ctx);       
       layout.setId(controls.getJavaNewId());             
              
       int countlabel = countSubString(holderItemFormat, "Text");  //mContentFormat = "TEXT:300|TEXT:301|IMAGE:200";
	   TextView[] label = new TextView[countlabel];	
		
       int countimage= countSubString(holderItemFormat, "Image");  //mContentFormat = "TEXT:300|TEXT:301|IMAGE:200";
	   ImageView[] image = new ImageView[countimage];

	   int countcheck = countSubString(holderItemFormat, "Check");  //mContentFormat = "TEXT:300|TEXT:301|IMAGE:200";
	   CheckBox[] check = new CheckBox[countcheck];

	   int countrating= countSubString(holderItemFormat, "Rating");  //mContentFormat = "TEXT:300|TEXT:301|IMAGE:200";
	   RatingBar[] rating = new RatingBar[countrating];

	   int countswitchbtn = countSubString(holderItemFormat, "Switch");  //mContentFormat = "TEXT:300|TEXT:301|IMAGE:200";
	   Switch[] switchbtn = new Switch[countswitchbtn];
	   
	   int countprogress = countSubString(holderItemFormat, "Progress");  //mContentFormat = "TEXT:300|TEXT:301|IMAGE:200";
	   ProgressBar[] progress = new ProgressBar[countprogress];
	   
	   int countpanel= countSubString(holderItemFormat, "Panel");  //mContentFormat = "TEXT:300|TEXT:301|IMAGE:200";
	   RelativeLayout[] panel = new RelativeLayout[countpanel];

	   int indexText = 0;
	   int indexImage = 0;
	   int indexCheck = 0;
	   int indexRating = 0;
	   int indexSwitchbtn = 0;
	   int indexProgress  = 0;
	   int indexPanel = 0;

	   String delimiter = "|";
	   String[] words = holderItemFormat.split(Pattern.quote(delimiter));
	   int countAll =  words.length;
	   delimiter = ":";
	   
	   boolean panelBegin = true;
	   
	   for (int i=(countAll-1); i >= 0; i--) {
	    if ( words[i].contains("Panel") )	{
	    	    												  
			String[] nameValueText = words[i].split(Pattern.quote(delimiter));
			int idPanel = Integer.valueOf(nameValueText[1]);				
			RelativeLayout draftPanel = (RelativeLayout)mDraftLayoutView.findViewById(idPanel);
			
			Drawable d = null;
			
			if( panelBegin ){
			 backId = idPanel;			 			 
			 
			 d = draftPanel.getBackground();
			 if (d!=null)  {
			   int color = ((ColorDrawable) d).getColor();
			   layout.setBackgroundColor(color);			   			  
			 }
			 
			 layout.setId(idPanel);
			 layout.setLayoutParams(draftPanel.getLayoutParams());
			 panelBegin = false;
			 			 
			 panel[indexPanel] = layout;
			 indexPanel++;
			 
			 continue;
			}
			
			panel[indexPanel] = new RelativeLayout(context);
			panel[indexPanel].setId(idPanel);
			
			d = draftPanel.getBackground();
			if (d!=null)  {
			   int color = ((ColorDrawable) d).getColor();
			   panel[indexPanel].setBackgroundColor(color);
			}						
			   
			panel[indexPanel].setLayoutParams(draftPanel.getLayoutParams());

			   String pad = (String) draftPanel.getTag(); //seted in "jSwitchButton.java"
			   String paddelimiter = "|";

			   String[] paddingValues = pad.split(Pattern.quote(paddelimiter));
			   panel[indexPanel].setPadding(Integer.valueOf(paddingValues[0]), Integer.valueOf(paddingValues[1]),
					   Integer.valueOf(paddingValues[2]), Integer.valueOf(paddingValues[3]));
			   
			   boolean findParent = false;
				
		        if( indexPanel > 1 ){
					int idParent = ((RelativeLayout)((ViewGroup) draftPanel.getParent())).getId();
										
					for( int j = 1; j < indexPanel; j++ )						
						if( panel[j].getId() == idParent ){
							findParent = true;
							panel[j].addView(panel[indexPanel]);
							break;
						}					
			    }
				
			    if( !findParent)				
			     layout.addView(panel[indexPanel]);

			   indexPanel++;			   			   
	    }
       }	   
		
	   for (int i=0; i < (countAll); i++) {		   
		   
		   if ( words[i].contains("Text") ) {
			   
			    if( label[indexText] != null ) continue;
			   			    
				String[] nameValueText = words[i].split(Pattern.quote(delimiter));
				int idText = Integer.valueOf(nameValueText[1]);				
				TextView drafTextView = (TextView)mDraftLayoutView.findViewById(idText);
								
				label[indexText] = new TextView(context);				
				label[indexText].setId(idText);						
				
				ViewGroup.LayoutParams lp = (ViewGroup.LayoutParams) drafTextView.getLayoutParams();
				
				label[indexText].setGravity(drafTextView.getGravity());
				
				label[indexText].setLayoutParams(drafTextView.getLayoutParams());
				
				String pad = (String) drafTextView.getTag(); //seted in "jTextView.java"
				String paddelimiter = "|";
				String[] paddingValues = pad.split(Pattern.quote(paddelimiter));								
				label[indexText].setPadding(Integer.valueOf(paddingValues[0]), Integer.valueOf(paddingValues[1]), 
						                    Integer.valueOf(paddingValues[2]), Integer.valueOf(paddingValues[3]));
				
				label[indexText].setTextColor(drafTextView.getCurrentTextColor());								
				
				float defaultInPixel = drafTextView.getTextSize();  //default in pixel!!!
				if (defaultInPixel != 42) { //Pascal font = 0!				      				       				     
				   float  auxf =  pixelsToSP(defaultInPixel);   //default in TypedValue.COMPLEX_UNIT_SP!									
				   label[indexText].setTextSize(TypedValue.COMPLEX_UNIT_SP, auxf);
				}
								
				Drawable d = drafTextView.getBackground();
				if (d!=null)  {
				   int color = ((ColorDrawable) d).getColor();
				   label[indexText].setBackgroundColor(color);
				}
				
				label[indexText].setTypeface(drafTextView.getTypeface());
				
				//--- Shadow layer
				
				int shColor    = drafTextView.getShadowColor();  //need min API 16!
				float shDx     = drafTextView.getShadowDx();
				float shDy     = drafTextView.getShadowDy();
				float shRadius = drafTextView.getShadowRadius();
				
				if( shRadius > 0 )
					label[indexText].setShadowLayer(shRadius, shDx, shDy, shColor);
				
				//--- In panel
				
                boolean findParent = false;
				
                if( indexPanel > 1 ){
					int idParent = ((RelativeLayout)((ViewGroup) drafTextView.getParent())).getId();
										
					for( int j = 1; j < indexPanel; j++ )						
						if( panel[j].getId() == idParent ){
							findParent = true;
							panel[j].addView(label[indexText]);
							break;
						}					
			   }
				
			   if( !findParent)
				layout.addView(label[indexText]);
				
				indexText++;
	       }			
		
		   if ( words[i].contains("Image") )	{
			   
				String[] nameValueImage = words[i].split(Pattern.quote(delimiter));
				int idImage = Integer.valueOf(nameValueImage[1]);								
				ImageView drafImageView = (ImageView)mDraftLayoutView.findViewById(idImage);
				
				image[indexImage] = new ImageView(context);				
				image[indexImage].setId(idImage);
								
				image[indexImage].setLayoutParams(drafImageView.getLayoutParams());
			
				String pad = (String) drafImageView.getTag(); //seted in "jImageView.java"
				String paddelimiter = "|";
				String[] paddingValues = pad.split(Pattern.quote(paddelimiter));								
				image[indexImage].setPadding(Integer.valueOf(paddingValues[0]), Integer.valueOf(paddingValues[1]), 
						                    Integer.valueOf(paddingValues[2]), Integer.valueOf(paddingValues[3]));
				
				boolean findParent = false;
				
				if( indexPanel > 1 ){
					int idParent = ((RelativeLayout)((ViewGroup) drafImageView.getParent())).getId();
										
					for( int j = 1; j < indexPanel; j++ )						
						if( panel[j].getId() == idParent ){
							findParent = true;
							panel[j].addView(image[indexImage]);
							break;
						}					
			   }
				
			   if( !findParent)
				 layout.addView(image[indexImage]);

				indexImage++;
		   }

		   if ( words[i].contains("Check") )	{

			   String[] nameValueCheck = words[i].split(Pattern.quote(delimiter));
			   int idCheck = Integer.valueOf(nameValueCheck[1]);
			   CheckBox draftCheckBox = (CheckBox)mDraftLayoutView.findViewById(idCheck);

			   check[indexCheck] = new CheckBox(context);
			   check[indexCheck].setId(idCheck);
			   
			   check[indexCheck].setLayoutParams(draftCheckBox.getLayoutParams());

			   String pad = (String) draftCheckBox.getTag(); //seted in "jCheckBox.java"
			   String paddelimiter = "|";

			   String[] paddingValues = pad.split(Pattern.quote(paddelimiter));
			   check[indexCheck].setPadding(Integer.valueOf(paddingValues[0]), Integer.valueOf(paddingValues[1]),
					   Integer.valueOf(paddingValues[2]), Integer.valueOf(paddingValues[3]));

			   boolean findParent = false;
				
			   if( indexPanel > 0 ){
					int idParent = ((RelativeLayout)((ViewGroup) draftCheckBox.getParent())).getId();
										
					for( int j = 0; j < indexPanel; j++ )						
						if( panel[j].getId() == idParent ){
							findParent = true;
							panel[j].addView(check[indexCheck]);
							break;
						}					
			   }
				
			   if( !findParent)
			     layout.addView(check[indexCheck]);

			   indexCheck++;
		   }

		   if ( words[i].contains("Rating") )	{

			   String[] nameVal = words[i].split(Pattern.quote(delimiter));
			   int idRat = Integer.valueOf(nameVal[1]);
			   RatingBar draftRatingBar = (RatingBar)mDraftLayoutView.findViewById(idRat);

			   String tagData = (String) draftRatingBar.getTag(); //seted in "jRatingBar.java"
			   //String tag = ""+_left+"|"+_top+"|"+_right+"|"+_bottom + "|" + smallStyle

			   String paddelimiter = "|";
			   String[] paddingValues = tagData.split(Pattern.quote(paddelimiter));

			   if (Integer.valueOf(paddingValues[4]) == 1)    //smallStyle
			       rating[indexRating] = new RatingBar(context, null, android.R.attr.ratingBarStyleSmall);
			   else
				   rating[indexRating] = new RatingBar(context, null, android.R.attr.ratingBarStyle);

			   rating[indexRating].setId(idRat);
			   
			   rating[indexRating].setStepSize(draftRatingBar.getStepSize());
     	       rating[indexRating].setIsIndicator(draftRatingBar.isIndicator());

			   rating[indexRating].setLayoutParams(draftRatingBar.getLayoutParams());

			   /*need this.setPadding(_left,_top,_right, _bottom);//nedd by jRatingBar.java
			   rating[indexRating].setPadding( draftRatingBar.getPaddingLeft(),
					                           draftRatingBar.getPaddingTop(),
			                                   draftRatingBar.getPaddingRight(),
			                                   draftRatingBar.getPaddingBottom());
			   */

			   //setPadding(int left, int top, int right, int bottom)  by force!!!
			   rating[indexRating].setPadding(Integer.valueOf(paddingValues[0]), Integer.valueOf(paddingValues[1]),
					   Integer.valueOf(paddingValues[2]), Integer.valueOf(paddingValues[3]));

			   boolean findParent = false;
				
			   if( indexPanel > 0 ){
					int idParent = ((RelativeLayout)((ViewGroup) draftRatingBar.getParent())).getId();
										
					for( int j = 0; j < indexPanel; j++ )						
						if( panel[j].getId() == idParent ){
							findParent = true;
							panel[j].addView(rating[indexRating]);
							break;
						}					
			   }
				
			   if( !findParent)
			    layout.addView(rating[indexRating]);

			   indexRating++;
		   }

		   if ( words[i].contains("Switch") )	{

			   String[] nameVal = words[i].split(Pattern.quote(delimiter));
			   int idSwitch = Integer.valueOf(nameVal[1]);
			   Switch draftSwitch = (Switch)mDraftLayoutView.findViewById(idSwitch);

			   switchbtn[indexSwitchbtn] = new Switch(context);
			   switchbtn[indexSwitchbtn].setId(idSwitch);
			   
			   switchbtn[indexSwitchbtn].setLayoutParams(draftSwitch.getLayoutParams());

			   String pad = (String) draftSwitch.getTag(); //seted in "jSwitchButton.java"
			   String paddelimiter = "|";

			   String[] paddingValues = pad.split(Pattern.quote(paddelimiter));
			   switchbtn[indexSwitchbtn].setPadding(Integer.valueOf(paddingValues[0]), Integer.valueOf(paddingValues[1]),
					   Integer.valueOf(paddingValues[2]), Integer.valueOf(paddingValues[3]));

			   boolean findParent = false;			  
				
			   if( indexPanel > 1 ){
					int idParent = ((RelativeLayout)((ViewGroup) draftSwitch.getParent())).getId();
										
					for( int j = 1; j < indexPanel; j++ )						
						if( panel[j].getId() == idParent ){
							findParent = true;
							panel[j].addView(switchbtn[indexSwitchbtn]);
							break;
						}					
			   }
				
			   if( !findParent)
			    layout.addView(switchbtn[indexSwitchbtn]);

			   indexSwitchbtn++;
		   }
		   
		   if ( words[i].contains("Progress") )	{

			   String[] nameVal = words[i].split(Pattern.quote(delimiter));
			   int idProgress = Integer.valueOf(nameVal[1]);
			   ProgressBar draftProgress = (ProgressBar)mDraftLayoutView.findViewById(idProgress);

			   progress[indexProgress] = new ProgressBar(context, null, 0x01010078);
			   progress[indexProgress].setId(idProgress);			   
			   
			   progress[indexProgress].setLayoutParams(draftProgress.getLayoutParams());			   

			   boolean findParent = false;			  
				
			   if( indexPanel > 1 ){
					int idParent = ((RelativeLayout)((ViewGroup) draftProgress.getParent())).getId();
										
					for( int j = 1; j < indexPanel; j++ )						
						if( panel[j].getId() == idParent ){
							findParent = true;
							panel[j].addView(progress[indexProgress]);
							break;
						}					
			   }
				
			   if( !findParent)
			    layout.addView(progress[indexProgress]);

			   indexProgress++;
		   }		   
	   }
	   
	   if (mCardStyle) {		   	      	
	       CardView  cardView = new CardView(ctx);
	       ViewGroup.LayoutParams paramCardView = new ViewGroup.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT);
	       cardView.setLayoutParams(paramCardView);	       
	       cardView.setUseCompatPadding(true);
	       //cardView.setCardElevation(20);
	       //cardView.setContentPadding(10, 10,10, 10);
	       //cardView.setPadding(30, 40, 30, 40);
	       cardView.setCardElevation(20);
	       cardView.setContentPadding(0, 0,0, 0);
	       cardView.setPadding(0, 0, 0, 0);
	       
	       /*TypedValue outValue = new TypedValue();
	       ctx.getTheme().resolveAttribute(android.R.attr.selectableItemBackground, outValue, true);
	       cardView.setBackgroundResource(outValue.resourceId);
	       
	       cardView.setClickable(true);
	       cardView.setFocusable(true);*/
	       
	       /*cardView.setShapeAppearanceModel(
	    		   cardView.getShapeAppearanceModel()
	    		       .toBuilder()
	    		       .setTopLeftCorner(CornerFamily.ROUNDED,20)
	    		       .setTopRightCorner(CornerFamily.ROUNDED,20)
	    		       .setBottomRightCorner(CornerFamily.ROUNDED,20)
	    		       .setBottomLeftCorner(CornerFamily.ROUNDED,20)
	    		       .build());*/	       
	       
	       cardView.setCardBackgroundColor(mCardColor);
	       cardView.setRadius(mCardRound);
	       
	       cardView.setId(controls.getJavaNewId()); 
	       cardView.addView(layout);    	      	       
	       
	       return cardView; 
	   }	   
	   else return layout;
	   
    }
    
  //https://stackoverflow.com/questions/18668897/android-get-all-children-elements-of-a-viewgroup
    private String getAllChildrenBFS(View v) {
    	
    	    List<View> visited = new ArrayList<View>();
    	    List<View> unvisited = new ArrayList<View>();
    	    
    	    unvisited.add(v);
            String format= "";
            
    	    while (!unvisited.isEmpty()) {
    	        View child = unvisited.remove(0);    	            	        
    	        format = child.getClass().getSimpleName()+":"+child.getId() + "|" + format;    	        
    	        visited.add(child);    	        
    	        if (!(child instanceof ViewGroup)) continue;
    	        ViewGroup group = (ViewGroup) child;
    	        final int childCount = group.getChildCount();
    	        for (int i=0; i < childCount; i++) {		        		        	
    	           unvisited.add(group.getChildAt(i));	           	           	           
    	        }
    	    }    	    
    	    return format;
    }    
    
    /*public void setOnItemClickLister(OnItemSelecteListener mListener) {  
        this.mListener = mListener;  
    }*/
 
 
    class RecyclerViewHolders extends RecyclerView.ViewHolder   /*implements View.OnClickListener*/ {

	    //public CardView cardView;
    	
		public TextView[] label;	
		public int countlabel = 0;
		
	    public ImageView[] image;
	    public int countimage = 0;

		public CheckBox[] check;
		public int countcheck = 0;

		public RatingBar[] rating;
		public int countrating = 0;
		
		public ProgressBar[] progress;
		public int countprogress = 0;

		public Switch[] switchbtn;
		public int countswitchbtn = 0;
		
		public RelativeLayout[] panel;
		public int countpanel = 0;


		public final long pascalObject;

	    public RecyclerViewHolders(Context ctx, long pasObj,  View itemLayoutView, String holderItemFormat) {
	        super(itemLayoutView);

			pascalObject =  pasObj;
	        countlabel = countSubString(holderItemFormat, "Text");  //mContentFormat = "TEXT:300|TEXT:301|IMAGE:200|CHECK:100";
			label = new TextView[countlabel];	
			
	        countimage= countSubString(holderItemFormat, "Image");  //mContentFormat = "TEXT:300|TEXT:301|IMAGE:200|CHECK:100";
			image = new ImageView[countimage];

			countcheck= countSubString(holderItemFormat, "Check");  //mContentFormat = "TEXT:300|TEXT:301|IMAGE:200|CHECK:100";
			check = new CheckBox[countcheck];

			countrating= countSubString(holderItemFormat, "Rating");  //mContentFormat = "TEXT:300|TEXT:301|IMAGE:200|RATING:50";
			rating = new RatingBar[countrating];

			countswitchbtn= countSubString(holderItemFormat, "Switch");  //mContentFormat = "TEXT:300|TEXT:301|IMAGE:200|RATING:50";
			switchbtn = new Switch[countswitchbtn];
			
			countprogress= countSubString(holderItemFormat, "Progress");  //mContentFormat = "TEXT:300|TEXT:301|IMAGE:200|RATING:50";
			progress = new ProgressBar[countprogress];
			
			countpanel= countSubString(holderItemFormat, "Panel");  //mContentFormat = "TEXT:300|TEXT:301|IMAGE:200|RATING:50";
			panel = new RelativeLayout[countpanel];

			int indexText = 0;
			int indexImage = 0;
			int indexCheck = 0;
			int indexRating = 0;
			int indexSwitchbtn = 0;
			int indexProgress  = 0;
			int indexPanel     = 0;

			String delimiter = "|";
			
			String[] words = holderItemFormat.split(Pattern.quote(delimiter));
			
			int countAll =  words.length;
								
			delimiter = ":";
			for (int i=0; i < countAll; i++) {
				
				if ( words[i].contains("Text") )	{
					String[] nameValueText = words[i].split(Pattern.quote(delimiter));
					int idText = Integer.valueOf(nameValueText[1]);					
					//Log.i("indexText="+ indexText , "idText="+idText);					
					label[indexText] = (TextView)itemLayoutView.findViewById(idText);					
					indexText++;
				}
								
				if ( words[i].contains("Image") )	{					
					String[] nameValueImage = words[i].split(Pattern.quote(delimiter));
					final int idImage = Integer.valueOf(nameValueImage[1]);
					image[indexImage] = (ImageView)itemLayoutView.findViewById(idImage);

					/*image[indexImage].setOnClickListener(new View.OnClickListener() {
						@Override
						public void onClick(View v) {
							String caption =  "ImageId=" + Integer.toString(idImage);
							//Pascal: TItemWidgetStatus = (wsNone=0, wsChecked=1);
							//Pascal: TItemContentFormat = (cfText=0, cfImage=1, cfCheck=2, cfRating=3, cfSwitch=4);
							controls.pOnRecyclerViewItemWidgetClick(pascalObject, getAdapterPosition(),1, caption, 0 );
						}
					});*/
					
					image[indexImage].setOnTouchListener(new View.OnTouchListener() {
						
						boolean mRunning;
			        	
			        	final Handler handler = new Handler();
			        	
			            final Runnable runClick = new Runnable(){
			                @Override
			                public void run()
			                {
			                	controls.pOnRecyclerViewItemWidgetLongClick(pascalObject, getAdapterPosition(), 1, idImage );
			                    mRunning = false;
			                }
			            };
			            
		                @Override
		                public boolean onTouch(View v, MotionEvent event) {
		                    switch (event.getActionMasked()) {
		                     case MotionEvent.ACTION_DOWN:{
		                    	//Pascal: TItemContentFormat = (cfText=0, cfImage=1, cfCheck=2, cfRating=3, cfSwitch=4);  
	                        	handler.postDelayed(runClick, 1000);
	                            mRunning = true;
	                            controls.pOnRecyclerViewItemWidgetTouchDown(pascalObject, getAdapterPosition(), 1, idImage );
	                            break;
	                         }
	                         case MotionEvent.ACTION_UP:{
	                        	 controls.pOnRecyclerViewItemWidgetTouchUp(pascalObject, getAdapterPosition(), 1, idImage );
	                        	
	                        	if (mRunning)
	                        		controls.pOnRecyclerViewItemWidgetClick(pascalObject, getAdapterPosition(), 1, idImage, 0);
	                        	
	                            handler.removeCallbacks(runClick);
	                            mRunning = false;
	                            break;
	                         }                       
	                         case MotionEvent.ACTION_CANCEL:{
	                            handler.removeCallbacks(runClick);
	                            mRunning = false;
	                            break;
	                         }
	                        }		                  
		                    return true;
		                }
		            });

					indexImage++;
				}

				if ( words[i].contains("Check") )	{
					final String[] nameValueCheck = words[i].split(Pattern.quote(delimiter)); //jCheckBox:4
					final int idCheck = Integer.valueOf(nameValueCheck[1]);
					//Log.i("indexText="+ indexText , "idText="+idText);
					check[indexCheck] = (CheckBox)itemLayoutView.findViewById(idCheck);
	                check[indexCheck].setOnClickListener(new View.OnClickListener() {
	                    @Override
	                    public void onClick(View v) {
	                    	int status = 0;	                    	
							//Pascal: TItemWidgetStatus = (wsNone=0, wsChecked=1);
	            	        //Pascal: TItemContentFormat = (cfText=0, cfImage=1, cfCheck=2, cfRating=3, cfSwitch=4, cfPanel = 5, cfProgressBar=6);
							if  ( ((CheckBox)v).isChecked() ) status = 1;
							controls.pOnRecyclerViewItemWidgetClick(pascalObject, getAdapterPosition(),2, idCheck, status );
	                    }
	                });

					indexCheck++;
				}

				if ( words[i].contains("Rating") )	{
					final String[] nameValueRating = words[i].split(Pattern.quote(delimiter)); //jRatingBar:6
					final int idRating = Integer.valueOf(nameValueRating[1]);
					rating[indexRating] = (RatingBar)itemLayoutView.findViewById(idRating);
					rating[indexRating].setOnRatingBarChangeListener(new RatingBar.OnRatingBarChangeListener() { //OnRatingBarChangeListener
						@Override
						public void onRatingChanged(RatingBar ratingBar, float rating,  boolean fromUser) {
							if (fromUser) {								
								//Pascal: TItemWidgetStatus = (wsNone=0, wsChecked=1);
								//Pascal: TItemContentFormat = (cfText=0, cfImage=1, cfCheck=2, cfRating=3, cfSwitch=4);
								controls.pOnRecyclerViewItemWidgetClick(pascalObject, getAdapterPosition(), 3, idRating, 0);
							}
						}
					});

					indexRating++;
				}

				if ( words[i].contains("Switch") )	{
					final String[] nameVal = words[i].split(Pattern.quote(delimiter)); //jSwitchButton:9
					final int idSwitch = Integer.valueOf(nameVal[1]);
					switchbtn[indexSwitchbtn] = (Switch)itemLayoutView.findViewById(idSwitch);
					switchbtn[indexSwitchbtn].setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
						@Override
						public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
							int status = 0;							
							//Pascal: TItemWidgetStatus = (wsNone=0, wsChecked=1);
							//Pascal: TItemContentFormat = (cfText=0, cfImage=1, cfCheck=2, cfRating=3, cfSwitch=4);
							if  ( ((Switch)buttonView).isChecked() ) status = 1;
							controls.pOnRecyclerViewItemWidgetClick(pascalObject, getAdapterPosition(),4, idSwitch, status );
						}
					});

					indexSwitchbtn++;
				}
				
				if ( words[i].contains("Progress") )	{
					String[] nameValueText = words[i].split(Pattern.quote(delimiter));
					int idProgress = Integer.valueOf(nameValueText[1]);					
										
					progress[indexProgress] = (ProgressBar)itemLayoutView.findViewById(idProgress);					
					indexProgress++;
				}
				
				if ( words[i].contains("Panel") )	{
					String[] nameValueText = words[i].split(Pattern.quote(delimiter));
					final int idPanel = Integer.valueOf(nameValueText[1]);
					
					int iPanel = countpanel - indexPanel - 1;
										
					panel[iPanel] = (RelativeLayout)itemLayoutView.findViewById(idPanel);
					
					if( iPanel != 0 ) // itemlayout
					 panel[iPanel].setOnTouchListener(new View.OnTouchListener() {
						
						boolean mRunning;
			        	
			        	final Handler handler = new Handler();
			        	
			            final Runnable runClick = new Runnable(){
			                @Override
			                public void run()
			                {
			                	controls.pOnRecyclerViewItemWidgetLongClick(pascalObject, getAdapterPosition(), 5, idPanel );
			                    mRunning = false;
			                }
			            };
			            
		                @Override
		                public boolean onTouch(View v, MotionEvent event) {
		                    switch (event.getAction()) {
		                     case MotionEvent.ACTION_DOWN:{
		                    	//Pascal: TItemContentFormat = (cfText=0, cfImage=1, cfCheck=2, cfRating=3, cfSwitch=4, cfPanel=5, cfProgress=6);  
	                        	handler.postDelayed(runClick, 1000);
	                            mRunning = true;
	                            controls.pOnRecyclerViewItemWidgetTouchDown(pascalObject, getAdapterPosition(), 5, idPanel );
	                            break;
	                         }
	                         case MotionEvent.ACTION_UP:{
	                        	 controls.pOnRecyclerViewItemWidgetTouchUp(pascalObject, getAdapterPosition(), 5, idPanel );
	                        	
	                        	if (mRunning)
	                        		controls.pOnRecyclerViewItemWidgetClick(pascalObject, getAdapterPosition(), 5, idPanel, 0);
	                        	
	                            handler.removeCallbacks(runClick);
	                            mRunning = false;
	                            break;
	                         }                       
	                         case MotionEvent.ACTION_CANCEL:{
	                            handler.removeCallbacks(runClick);
	                            mRunning = false;
	                            break;
	                         }
	                        }		                  
		                    return true;
		                }
		             });
					
					if( panel[iPanel] != null )
					 indexPanel++;
				}
			}

	        /*
	        labelView.setOnClickListener(new View.OnClickListener() {
	            @Override
	            public void onClick(View v) {   
	            	Log.i("onClick", "Clicked Country Position = " + getAdapterPosition());
	            }
	        });	      
	        */	
	        
	        /*itemLayoutView.setOnClickListener(new View.OnClickListener() {  
	            @Override  
	            public void onClick(View view) {
	              String[] content = itemList.get( getAdapterPosition() ).label;	
	              mListener.onItemSelected(view, getAdapterPosition(), content);  
	            }  
	          });
	        	        
	        itemLayoutView.setOnLongClickListener(new View.OnLongClickListener() {
	            @Override
	            public boolean onLongClick(View v) {
	            	controls.pOnRecyclerViewItemLongClick(pascalObject, getAdapterPosition());
	                return true;
	            }
	        });*/
	        
	        itemLayoutView.setOnTouchListener(new View.OnTouchListener() {
	        	
	        	boolean mRunning;
	        	
	        	final Handler handler = new Handler();
	        	
	            final Runnable runClick = new Runnable(){
	                @Override
	                public void run()
	                {
	                	controls.pOnRecyclerViewItemLongClick(pascalObject, getAdapterPosition());
	                    mRunning = false;
	                }
	            };	            
	        	
                @Override
                public boolean onTouch(View v, MotionEvent event) {
                    switch (event.getAction()) {
                        case MotionEvent.ACTION_DOWN:{
                        	handler.postDelayed(runClick, 1000);
                            mRunning = true;
							controls.pOnRecyclerViewItemTouchDown(pascalObject, getAdapterPosition());
                            break;
                        }
                        case MotionEvent.ACTION_UP:{
                        	controls.pOnRecyclerViewItemTouchUp(pascalObject, getAdapterPosition());
                        	
                        	if (mRunning)
                        		controls.pOnRecyclerViewItemClick(pascalObject, getAdapterPosition());                        		                        	
                        	
                            handler.removeCallbacks(runClick);
                            mRunning = false;
                            break;
                        }                       
                        case MotionEvent.ACTION_CANCEL:{
                            handler.removeCallbacks(runClick);
                            mRunning = false;
                            break;
                        }
                    }
                    return true;
                }
            });
		}
	    	    
	    //http://www.java2s.com/Code/Java/Data-Type/Countthenumberofinstancesofsubstringwithinastring.htm
	    public int countSubString(final String string, final String substring) {
	       int count = 0;
	       int idx = 0;
	       while ((idx = string.indexOf(substring, idx)) != -1) {
	          idx++;
	          count++;
	       }
	       return count;
	    }
	    
	}    
}
//-----
/**https://gist.github.com/AKiniyalocts/5a00d66f03f1c3393c1302bea73749b2
 * Created by anthonykiniyalocts on 12/8/16.
 *
 * Quick way to add padding to first and last item in recyclerview via decorators
 */

class EdgeDecorator extends RecyclerView.ItemDecoration {

    private final int edgePadding;

    /**
     * EdgeDecorator
     * @param edgePadding padding set on the left side of the first item and the right side of the last item
     */
    public EdgeDecorator(int edgePadding) {
        this.edgePadding = edgePadding;
    }

    @Override
    public void getItemOffsets(Rect outRect, View view, RecyclerView parent, RecyclerView.State state) {
        super.getItemOffsets(outRect, view, parent, state);

        int itemCount = state.getItemCount();

        final int itemPosition = parent.getChildAdapterPosition(view);

        // no position, leave it alone
        if (itemPosition == RecyclerView.NO_POSITION) {
            return;
        }

        // first item
        if (itemPosition == 0) {
            outRect.set(edgePadding, view.getPaddingTop(), view.getPaddingRight(), view.getPaddingBottom());
        }
        // last item
        else if (itemCount > 0 && itemPosition == itemCount - 1) {
            outRect.set(view.getPaddingLeft(), view.getPaddingTop(), edgePadding, view.getPaddingBottom());
        }
        // every other item
        else {
            outRect.set(view.getPaddingLeft(), view.getPaddingTop(), view.getPaddingRight(), view.getPaddingBottom());
        }
    }
}

class TopBottomDecorator extends RecyclerView.ItemDecoration {

    private final int edgePadding;

    /**
     * EdgeDecorator
     * @param edgePadding padding set on the left side of the first item and the right side of the last item
     */
    public TopBottomDecorator(int edgePadding) {
        this.edgePadding = edgePadding;
    }

    @Override
    public void getItemOffsets(Rect outRect, View view, RecyclerView parent, RecyclerView.State state) {
        super.getItemOffsets(outRect, view, parent, state);

        int itemCount = state.getItemCount();

        final int itemPosition = parent.getChildAdapterPosition(view);

        // no position, leave it alone
        if (itemPosition == RecyclerView.NO_POSITION) {
            return;
        }

        // first item
        if (itemPosition == 0) {
            //outRect.set(view.getPaddingLeft(), edgePadding, view.getPaddingRight(), view.getPaddingBottom());
            outRect.set(view.getPaddingLeft(), edgePadding, view.getPaddingRight(), 0);
        }
        // last item
        else if (itemCount > 0 && itemPosition == itemCount - 1) {
            //outRect.set(view.getPaddingLeft(), view.getPaddingTop(), view.getPaddingRight(), edgePadding);
            outRect.set(view.getPaddingLeft(), edgePadding, view.getPaddingRight(), edgePadding);
        }
        // every other item
        else {
            //outRect.set(view.getPaddingLeft(), view.getPaddingTop(), view.getPaddingRight(), view.getPaddingBottom());
            outRect.set(view.getPaddingLeft(), edgePadding, view.getPaddingRight(), 0);
        }
    }
}
//-----
//https://blog.davidmedenjak.com/android/2015/11/10/recyclerview-with-decorations-basic-guide.html
class SeparatorDecoration extends RecyclerView.ItemDecoration {

    private final Paint mPaint;

    /**
     * Create a decoration that draws a line in the given color and width between the items in the view.
     *
     * @param context  a context to access the resources.
     * @param color    the color of the separator to draw.
     * @param heightDp the height of the separator in dp.
     */
    public SeparatorDecoration(Context context, int color, float heightDp) {
        mPaint = new Paint();
        mPaint.setColor(color);
        final float thickness = TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP,
                heightDp, context.getResources().getDisplayMetrics());
        mPaint.setStrokeWidth(thickness);
    }

    @Override
    public void getItemOffsets(Rect outRect, View view, RecyclerView parent, RecyclerView.State state) {
        final RecyclerView.LayoutParams params = (RecyclerView.LayoutParams) view.getLayoutParams();

        // we want to retrieve the position in the list
        final int position = params.getViewAdapterPosition();

        // and add a separator to any view but the last one
        if (position < state.getItemCount()) {
            outRect.set(0, 0, 0, (int) mPaint.getStrokeWidth()); // left, top, right, bottom
        } else {
            outRect.setEmpty(); // 0, 0, 0, 0
        }
    }

    @Override
    public void onDraw(Canvas c, RecyclerView parent, RecyclerView.State state) {
        // we set the stroke width before, so as to correctly draw the line we have to offset by width / 2
        final int offset = (int) (mPaint.getStrokeWidth() / 2);

        // this will iterate over every visible view
        for (int i = 0; i < parent.getChildCount(); i++) {
            // get the view
            final View view = parent.getChildAt(i);
            final RecyclerView.LayoutParams params = (RecyclerView.LayoutParams) view.getLayoutParams();

            // get the position
            final int position = params.getViewAdapterPosition();

            // and finally draw the separator
            if (position < state.getItemCount()) {
                c.drawLine(view.getLeft(), view.getBottom() + offset, view.getRight(), view.getBottom() + offset, mPaint);
            }
        }
    }
}
//---------------

/*Draft java code by "Lazarus Android Module Wizard" [12/21/2017 0:15:18]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jVisualControl LAMW template*/
 
//https://www.androidhive.info/2016/05/android-working-with-card-view-and-recycler-view/
//http://www.vogella.com/tutorials/AndroidRecyclerView/article.html
public class jsRecyclerView extends RecyclerView /*dummy*/ { //please, fix what GUI object will be extended!

   final private long pascalObj;        // Pascal Object
   private Controls controls  = null; //Java/Pascal [events] Interface ...
   private jCommons LAMWCommon;
   private Context context;

   private Boolean enabled  = true;           // click-touch enabled!
         
   private LinearLayoutManager linearLayoutManager;   
   
   private StaggeredGridLayoutManager staggeredLayoutManager;
   
   private RecyclerViewAdapter rcAdapter;
   
   List<ItemObject> rowListItem;
   
   private int   mSeparatorColor = Color.TRANSPARENT;
   private float mSeparatorHeight = 1.5f;
   
   //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
   public jsRecyclerView(Controls _ctrls, long _Self, int _mode, int _direction, int _cols) { //Add more others news "_xxx" params if needed!

      super(_ctrls.activity);
      context   = _ctrls.activity;
      pascalObj = _Self;      
      controls  = _ctrls;
      
      LAMWCommon = new jCommons(this,context,pascalObj);      
      rowListItem = new ArrayList<ItemObject>();
                  
      //mLayoutManager = new GridLayoutManager(this, 2, GridLayoutManager.Horizontal, false);
      //mLayoutManager = new GridLayoutManager(this, 2);
      /*
       * ((LinearLayoutManager) mLayoutManager).setOrientation(LinearLayoutManager.HORIZONTAL);
    // OR
    ((GridLayoutManager) mLayoutManager).setOrientation(GridLayoutManager.HORIZONTAL);    
       //StaggeredGridLayoutManager 
       */            
      
      switch(_mode) {
      
      case 0: {    	   
           linearLayoutManager = new LinearLayoutManager(context);                
           if (_direction == 0) {
                	linearLayoutManager.setOrientation(LinearLayoutManager.VERTICAL);
           } else {
                	linearLayoutManager.setOrientation(LinearLayoutManager.HORIZONTAL);
           }                
           this.setLayoutManager(linearLayoutManager); break;   
      }
      
      case 1: {    	                            
          if (_direction == 0) {
        	  linearLayoutManager = new GridLayoutManager(context, _cols, GridLayoutManager.VERTICAL, false);
               	
          } else {
        	  linearLayoutManager = new GridLayoutManager(context, _cols, GridLayoutManager.HORIZONTAL, false);        	  
          }                
          this.setLayoutManager(linearLayoutManager); break;   
       }

      case 2: {    	                            
          if (_direction == 0) {
        	  staggeredLayoutManager = new StaggeredGridLayoutManager(_cols,StaggeredGridLayoutManager.VERTICAL);        	 
               	
          } else {
        	  staggeredLayoutManager = new StaggeredGridLayoutManager(_cols,StaggeredGridLayoutManager.HORIZONTAL);
        	  
          }   
          //staggeredLayoutManager.setGapStrategy(StaggeredGridLayoutManager.GAP_HANDLING_NONE);
          //StaggeredGridLayoutManager.GAP_HANDLING_MOVE_ITEMS_BETWEEN_SPANS
          this.setLayoutManager(staggeredLayoutManager); break;   
       }
          	                    
      }

      //linearLayoutManager = new LinearLayoutManager(context);      
      //linearLayoutManager.setOrientation(LinearLayoutManager.VERTICAL);      
      //this.setLayoutManager(linearLayoutManager);   
      
   // add the decoration to the recyclerView
      //SeparatorDecoration decoration = new SeparatorDecoration(context, Color.GRAY, 1.5f);
      //this.addItemDecoration(decoration);
      /*
       * Sets whether the LayoutManager should be 
       * queried for views outside of its viewport while the UI thread is idle between frames.
       */     
      //linearLayoutManager.setItemPrefetchEnabled(false);
      
      //linearLayoutManager.setAutoMeasureEnabled(true);
      
      rcAdapter = new RecyclerViewAdapter(controls, pascalObj, rowListItem);
      
      
      //this.setHorizontalScrollBarEnabled(true);      
      this.setVerticalScrollBarEnabled(true);
      // this.scrollToPosition(0);
      this.setHasFixedSize(true);         
      
      this.setAdapter(rcAdapter);
      
     // this.addItemDecoration(new DividerItemDecoration(context,  linearLayoutManager.getOrientation()) ); 
      
      /*
      this.SetItemContentDictionary("text|text|image", "|");      
      this.Add("0.Material Design|0.Hello Word!|ic_launcher@drawable");
      this.Add("1.Android|1.Hello|ic_launcher@drawable");
      this.Add("2.RecyclerView|2.Hello|undo_048.png@assets");  //http://www.iconarchive.com/search?q=list&res=48&page=1
      this.Add("3.RecyclerView|3.Hello|url@http://icons.iconarchive.com/icons/alecive/flatwoken/128/Apps-Google-Chrome-App-List-icon.png");
      this.Add("4.RecyclerView|4.Hello|ic_launcher@drawable");      
      this.Add("5.RecyclerView|5.Hello|ic_launcher@drawable");
      this.Add("6.RecyclerView|6.Hello|ic_launcher@drawable");
      this.Add("7.RecyclerView|7.Hello|ic_launcher@drawable");
      this.Add("8.RecyclerView|8.Hello|ic_launcher@drawable");
      this.Add("9.RecyclerView|9.Hello|ic_launcher@drawable");
      this.Add("10.RecyclerView|10.Hello|ic_launcher@drawable");
      this.Add("11.RecyclerView|11.Hello|ic_launcher@drawable");
      this.Add("12.RecyclerView|12.Hello|ic_launcher@drawable");      
      this.Add("13.RecyclerView|13.Hello|ic_launcher@drawable");
      this.Add("14.RecyclerView|14.Hello|ic_launcher@drawable");
      this.Add("15.RecyclerView|15.Hello|ic_launcher@drawable");
      this.Add("16.RecyclerView|16.Hello|ic_launcher@drawable");
      */
        
   //http://blog.technoguff.com/2015/07/navigation-drawer-using-recyclerview.html
   /*rcAdapter.setOnItemClickLister(new OnItemSelecteListener() {	 
      @Override  
      public void onItemSelected(View v, int position,  String[] content) {
    	  lastSelectedContent = content;
    	  //Log.i("setOnItemClickLister", "pos="+position);
    	  controls.pOnRecyclerViewItemClick(pascalObj, position, content.length);
      }  
    });*/
  
        
   } //end constructor
            
   public void jFree() {
      //free local objects...
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
   
   public void SetItemContentDictionary(String _delimitedContentDictionary, String _delimiter) {
	   rcAdapter.setItemContentDictionary(_delimitedContentDictionary, _delimiter);
   }
   
   public void ScrollToPosition( int position ){
	   if( (position < 0) || (position >= rcAdapter.getItemCount()) ) return;
	   
	   this.scrollToPosition(position);
   }
   
   public void SmoothScrollToPosition(int position){	   
	   if( (position < 0) || (position >= rcAdapter.getItemCount()) ) return;	   
	   
	   this.smoothScrollToPosition(position);
   }
   
   public void Add(String _delimitedContent) {	   
	   rcAdapter.add(_delimitedContent); 	   
   }
   
   /*public String GetWidget(int position, int widgetId){
	    View v = getLayoutManager().findViewByPosition(position);
	    
	    if( v == null ) return "";
	    
	    TextView lb = (TextView)v.findViewById(widgetId);
	    
	    if( lb != null )
	     return ""+lb.getText();
	    else
	     return "";
		  
	   }*/
   
   public void SetCardBackgroundColor( int _color ){
	   rcAdapter.SetCardBackgroundColor(_color);
   }
   
   public void SetItemsRound(int round){
	   rcAdapter.SetItemsRound(round);
   }
   
   public void SetItemBackgroundColor( int position, int backColor, int cornerRadiusRound ){
	   rcAdapter.SetItemBackgroundColor( position, backColor, cornerRadiusRound );
	   //if cornerRadiusRound == 0 then not Rounded!
   }
   
   public void SetItemSeparatorColorHeight( int _color, float _height ){
	   mSeparatorColor  = _color;
	   
	   if( _height > 0 )
		   mSeparatorHeight = _height;
	   else
		   mSeparatorHeight = 0;  
   }
   
   public void SetItemViewLayout(View _itemViewLayout, boolean _forceCardStyle) {
	   
	   ViewGroup parent = (ViewGroup) _itemViewLayout.getParent();
	   
	   if ( parent != null)
		   parent.removeView(_itemViewLayout);
	       //add the decoration to the recyclerView
	   if (!_forceCardStyle) {
	       SeparatorDecoration decoration = new SeparatorDecoration(context, mSeparatorColor, mSeparatorHeight);
	       this.addItemDecoration(decoration);
	   }
	   else {		   
		   TopBottomDecorator  decoration = new TopBottomDecorator(Math.round(mSeparatorHeight));  //EdgeDecorator 
	       this.addItemDecoration(decoration);		   
	   }
	      	   	   	   
	   rcAdapter.setlayoutView(_itemViewLayout, _forceCardStyle);  //true = cardStyle	   
   }
   
   public void SetItemViewLayout(View _itemViewLayout) {	   
	   SetItemViewLayout(_itemViewLayout, false);
   }
   
   public void SetAppBarLayoutScrollingViewBehavior() { //This attribute will trigger event in the Toolbar.
     CoordinatorLayout.LayoutParams params = (CoordinatorLayout.LayoutParams)this.getLayoutParams();
     params.setBehavior(new AppBarLayout.ScrollingViewBehavior(context, null));
     this.requestLayout();
   }
   
   public void RemoveAll() {
       rcAdapter.RemoveAll();      
   }

   public void Remove(int _position) {
          rcAdapter.remove(_position);
   }
   
   public int GetItemsSelect(){
   	   return rcAdapter.GetItemsSelect();
   }
   
   public int GetItemSelectFirst(){
	   return rcAdapter.GetItemSelectFirst();  
   }
   
   public int GetItemSelectFirst( int _int ){
	   return rcAdapter.GetItemSelectFirst(_int);
   }
   
   public void ClearItemsSelect(){
	   rcAdapter.ClearItemsSelect();
   }
   
   public void SetItemSelect( int position, int select ){	   
	   rcAdapter.SetItemSelect( position, select );   	
   }
   
   public void SetItemTag( int position, String tagString ){
	   rcAdapter.SetItemTag( position, tagString );
   }
   
   public int GetItemSelect( int position ){   	
   	return rcAdapter.GetItemSelect( position );
   }
   
   public String GetItemTag( int position ){   	
   	return rcAdapter.GetItemTag( position );
   }
   
   public void SetWidgetText(int position, int widget, int widgetId, String strText) {
       rcAdapter.SetWidgetText(position, widget, widgetId, strText);
   }
   
   public String GetWidgetText(int position, int widget, int widgetId){
	   return rcAdapter.GetWidgetText(position, widget, widgetId);
   }
   
   public void SetWidgetTextColor( int position, int widget, int widgetid, int color ){
	   rcAdapter.SetWidgetTextColor(position, widget, widgetid, color); 
   }
   
   public void Refresh() {
       rcAdapter.Refresh();
       setAdapter(rcAdapter);
   }
   
   public void Refresh( int _position ) {
       rcAdapter.Refresh( _position );
   }
   
   public void Moved(int fromPosition, int toPosition){
	   rcAdapter.Moved(fromPosition, toPosition);
   }

   public int GetItemCount() {
      return rcAdapter.getItemCount();
   }  

   public void SetFitsSystemWindows(boolean _value) {
	LAMWCommon.setFitsSystemWindows(_value);
   }
 
   public void SetClipToPadding(boolean _value)  {
     //android:clipToPadding="false"
      this.setClipToPadding(_value);
   }

}

