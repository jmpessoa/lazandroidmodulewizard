package org.lamw.appcompatdemo1;

import android.content.Context;
import android.content.res.AssetManager;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.AsyncTask;
import android.os.Environment;
import android.view.View;
import android.view.ViewGroup;
import android.support.v7.widget.CardView;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.util.Log;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Pattern;

import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.RelativeLayout.LayoutParams;


interface OnItemSelecteListener {  
    public void onItemSelected(View v, int position, String[] content);  
} 

class ItemObject {
	
    public String[] label;
    public int countlabel = 0;
    
    public String[] image;
    public int countimage = 0;
        
    public ItemObject(String content, String format,  String delimiter) {
    	String upperFormat = format.toUpperCase();
        countlabel = countSubString(upperFormat, "TEXT");  
		label = new String[countlabel];				    	
		countimage= countSubString(upperFormat, "IMAGE");  
		image = new String[countimage];				    			
		int indexText = 0;
		int indexImage = 0;		
		String[] formats = upperFormat.split(Pattern.quote(delimiter));  //  "\\s+"   [space]						
		String[] contents = content.split(Pattern.quote(delimiter));		
		int countAll =  formats.length;		
		for (int i=0; i < countAll; i++) {
			
			if ( formats[i].startsWith("TEXT") )	{
				label[indexText] =  contents[i];
				indexText++;
			}
							
			if ( formats[i].startsWith("IMAGE") )	{								
				image[indexImage] = contents[i];  //data@location					
				indexImage++;
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
class LoadImageTask extends AsyncTask < String, Void, Bitmap> {
	
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

    public List<ItemObject> itemList;
    
    public String mItemContentDictionary; // = "TEXT|TEXT|DRAWABLE";    
    public String mItemContentDelimiter; // = "|";
    
    private Context context;
    
    OnItemSelecteListener mListener;
    
    public RecyclerViewAdapter(Context context, List<ItemObject> itemList) {
        this.itemList = itemList;
        this.context = context; 
    }

    @Override
    public RecyclerViewHolders onCreateViewHolder(ViewGroup parent, int viewType) {
    	View v  = getlayoutView(context); 
    	String format = getholderContentFormat(v); 
    	
    	RecyclerViewHolders holder = new RecyclerViewHolders(context, v, format);
        return holder;
    }

    @Override
    public void onBindViewHolder(RecyclerViewHolders holderView, final int position) {
    	
    	int countlabel = itemList.get(position).countlabel;
    	int countimage = itemList.get(position).countimage;
    	
    	for (int i=0; i < countlabel; i++) {
    		holderView.label[i].setText( itemList.get(position).label[i]);
    	}
    	    	
    	for (int i=0; i < countimage; i++) {
    		    		
    		String imageData = itemList.get(position).image[i];  //image@drawable    		
    		//Log.i("onBindViewHolder", imageData);    		
    		String delimiter = "@";    		
    		String[] namevalue = imageData.split(Pattern.quote(delimiter)); 
    		
    		if 	( namevalue[1].equals("drawable") ) {  	
    		  int id = context.getResources().getIdentifier(namevalue[0], "drawable", context.getPackageName() );    		
    		  holderView.image[i].setImageResource(id);
    		}    		
    		else if 	( namevalue[1].equals("assets") ) {    			
    			//holderView.image[i].setImageResource(android.R.color.transparent);
    			holderView.image[i].setImageBitmap( LoadFromAssets(namevalue[0]) ); //GetImageFromAssetsFile(namevalue[0])
    			//holderView.image[i].invalidate();
    		}    		
    		//https://www.learn2crack.com/2014/06/android-load-image-from-internet.html
    		//https://inducesmile.com/android-tutorials-for-nigerian-developer/android-load-image-from-url/
    		else if 	(namevalue[1].startsWith("http") ) {    			
    			new LoadImageTask(holderView.image[i]).execute(namevalue[1]);
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
    	itemList.add(position, new ItemObject(content, mItemContentDictionary, mItemContentDelimiter) );    	
        notifyItemInserted(position);
    }

    public void remove(int position) {
    	itemList.remove(position);
        notifyItemRemoved(position);
    }
    
    //https://faqdroid.com/android-material-design-recyclerview-android-cardview-example-tutorial
    //https://www.androidtutorialpoint.com/material-design/android-cardview-tutorial/
    //https://inducesmile.com/android/android-recyclerview-and-cardview-in-material-design-tutorial/
    
    public View getlayoutView(Context ctx) {
    	
       CardView cardView = new CardView(ctx);
       ViewGroup.LayoutParams paramCardView = new ViewGroup.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT);
       cardView.setLayoutParams(paramCardView);
       cardView.setCardElevation(20);
       cardView.setUseCompatPadding(true);
       
       cardView.setContentPadding(10, 20, 10, 20);       
       cardView.setPadding(30, 30, 30, 30);
       cardView.setId(100);                    
                          
       RelativeLayout layout = new RelativeLayout(ctx);       
       ViewGroup.LayoutParams params = new ViewGroup.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT); 
       layout.setLayoutParams(params);

       ImageView imageView = new  ImageView(ctx);
       imageView.setId(200);       
       imageView.setTag(1);;       
       imageView.setPadding(10, 20, 10, 20);              
	   LayoutParams imgParam = new LayoutParams(LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT); //w,h  //layText					
       imgParam.addRule(RelativeLayout.ALIGN_PARENT_LEFT);				         
       layout.addView(imageView, imgParam); 
       
       TextView label0View = new TextView(ctx);
       label0View.setId(300);
              
       label0View.setPadding(10, 20, 10, 20);       
	   LayoutParams txt0Param = new LayoutParams(LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT); //w,h  //layText					
       //txtParam.addRule(RelativeLayout.CENTER_IN_PARENT);				  
	   txt0Param.addRule(RelativeLayout.CENTER_HORIZONTAL);       
       layout.addView(label0View, txt0Param);
       
       TextView label1View = new TextView(ctx);
       label1View.setId(301);
       
       label1View.setPadding(10, 20, 10, 20);       
	   LayoutParams txt1Param = new LayoutParams(LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT); //w,h  //layText					
       //txtParam.addRule(RelativeLayout.CENTER_IN_PARENT);				  
	   txt1Param.addRule(RelativeLayout.ALIGN_PARENT_RIGHT);       
       layout.addView(label1View, txt1Param);       
       
       cardView.addView(layout);
                    
       return cardView;
    }
    
    
    public String getholderContentFormat(View v) {    	
        // "TEXT:300|TEXT:301|IMAGE:200";    	
    	return 	getAllChildrenBFS(v);    		  
    }
    
  //https://stackoverflow.com/questions/18668897/android-get-all-children-elements-of-a-viewgroup
    private String getAllChildrenBFS(View v) {
    	
    	    List<View> visited = new ArrayList<View>();
    	    List<View> unvisited = new ArrayList<View>();
    	    
    	    unvisited.add(v);
            String format= "";
            
    	    while (!unvisited.isEmpty()) {
    	        View child = unvisited.remove(0);
    	            	        
    	        format = format + child.getClass().getSimpleName()+":"+child.getId() + "|";
    	        
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
    
    public void setOnItemClickLister(OnItemSelecteListener mListener) {  
        this.mListener = mListener;  
    }
 
 
    class RecyclerViewHolders extends RecyclerView.ViewHolder   /*implements View.OnClickListener*/ {

	    //public CardView cardView;
    	
		public TextView[] label;	
		public int countlabel = 0;
		
	    public ImageView[] image;
	    public int countimage = 0;

	    public RecyclerViewHolders(Context ctx,  View itemLayoutView, String holderItemFormat) {    	
	        super(itemLayoutView);
	        	        
	        countlabel = countSubString(holderItemFormat, "Text");  //mContentFormat = "TEXT:300|TEXT:301|IMAGE:200";
			label = new TextView[countlabel];				    	

	        countimage= countSubString(holderItemFormat, "Image");  //mContentFormat = "TEXT:300|TEXT:301|IMAGE:200";
			image = new ImageView[countimage];				    	
			
			int indexText = 0;
			int indexImage = 0;
			
			String delimiter = "|";
			
			String[] words = holderItemFormat.split(Pattern.quote(delimiter));
			
			int countAll =  words.length;
			
			delimiter = ":";
			for (int i=0; i < countAll; i++) {
				
				if ( words[i].startsWith("Text") )	{
					String[] nameValueText = words[i].split(Pattern.quote(delimiter));
					int idText = Integer.valueOf(nameValueText[1]);
					label[indexText] = (TextView)itemLayoutView.findViewById(idText);
					indexText++;
				}
								
				if ( words[i].startsWith("Image") )	{					
					String[] nameValueImage = words[i].split(Pattern.quote(delimiter));
					int idImage = Integer.valueOf(nameValueImage[1]);
					image[indexImage] = (ImageView)itemLayoutView.findViewById(idImage);
					indexImage++;
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
	        
	        itemLayoutView.setOnClickListener(new View.OnClickListener() {  
	            @Override  
	            public void onClick(View view) {
	              String[] content =	itemList.get( getAdapterPosition() ).label;	
	              mListener.onItemSelected(view, getAdapterPosition(), content);  
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

/*Draft java code by "Lazarus Android Module Wizard" [12/21/2017 0:15:18]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jVisualControl LAMW template*/
 
//https://www.androidhive.info/2016/05/android-working-with-card-view-and-recycler-view/
//http://www.vogella.com/tutorials/AndroidRecyclerView/article.html
public class jsRecyclerView extends RecyclerView /*dummy*/ { //please, fix what GUI object will be extended!

   private long pascalObj = 0;        // Pascal Object
   private Controls controls  = null; //Java/Pascal [events] Interface ...
   private jCommons LAMWCommon;
   private Context context = null;

   private Boolean enabled  = true;           // click-touch enabled!
         
   private LinearLayoutManager linearLayoutManager;   
   private RecyclerViewAdapter rcAdapter;
   
   List<ItemObject> rowListItem;
   String[] lastSelectedContent;
   
   //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
   public jsRecyclerView(Controls _ctrls, long _Self) { //Add more others news "_xxx" params if needed!

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
      
      linearLayoutManager = new LinearLayoutManager(context);
      this.setLayoutManager(linearLayoutManager);    

      rcAdapter = new RecyclerViewAdapter(context, rowListItem);      
      this.setAdapter(rcAdapter);
      
      //this.setHorizontalScrollBarEnabled(true);      
      this.setVerticalScrollBarEnabled(true);
      // this.scrollToPosition(0);
      this.setHasFixedSize(true);
            
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
      
        
  //http://blog.technoguff.com/2015/07/navigation-drawer-using-recyclerview.html
  rcAdapter.setOnItemClickLister(new OnItemSelecteListener() {	 
      @Override  
      public void onItemSelected(View v, int position,  String[] content) {
    	  lastSelectedContent = content;
    	  Log.i("setOnItemClickLister", "pos="+position);
    	  //controls.pOnClickGeneric(pascalObj, position, content.length);
      }  
    }); 
      
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
   public void SetId(int _id) { //wrapper method pattern ...
      this.setId(_id);
   }
   
   public void SetItemContentDictionary(String _contentDictionary, String _delimiter) {
	   rcAdapter.setItemContentDictionary(_contentDictionary, _delimiter);
   }
   
   public void Add(String _content) {
	   rcAdapter.add(_content); 	   
   }
   
   public String GetSelectedContent(int _contentIndex) {
	  return lastSelectedContent[_contentIndex];
   }

}
