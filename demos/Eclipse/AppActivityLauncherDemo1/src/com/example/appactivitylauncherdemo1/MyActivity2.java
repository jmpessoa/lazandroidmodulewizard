package com.example.appactivitylauncherdemo1;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.ListView;

//REF: http://www.androidinterview.com/android-custom-listview-with-image-and-text-using-arrayadapter/
public class MyActivity2 extends Activity{
	
	ListView list;
	String[] itemname ={
			"Safari",
			"Camera",
			"Global",
			"FireFox",
			"UC Browser",
			"Android Folder",
			"VLC Player",
			"Cold War"
		};
	
	Integer[] imgid={
			R.drawable.pic1,
			R.drawable.pic2,
			R.drawable.pic3,
			R.drawable.pic4,
			R.drawable.pic5,
			R.drawable.pic6,
			R.drawable.pic7,
			R.drawable.pic8,
	};
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_main);
		
		//this.get
		CustomListAdapter adapter=new CustomListAdapter(this, itemname, imgid);
		list=(ListView)findViewById(R.id.list);
		list.setAdapter(adapter);
		
		list.setOnItemClickListener(new OnItemClickListener() {

			@Override
			public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
				// TODO Auto-generated method stub
				String selectedItem= itemname[+position];								
		        Intent intent= new Intent();                
		        // put the message to return as result in Intent
		        intent.putExtra("CAPTION", selectedItem);
		        intent.putExtra("INDEX", +position);
		        // Set The Result in Intent
		        setResult(Activity.RESULT_OK, intent);
		        // finish The activity 
		        finish();		        							
				
			}
		});
	}
}
