package com.example.appactionbartabdemo1;

//relational: jActionBarTab.java

import android.app.Fragment;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.RelativeLayout;
import android.widget.RelativeLayout.LayoutParams;

public class TabContentFragment extends Fragment {
    private View mView;
    private String mText;

    /*.*/public TabContentFragment() {

    }

    /*
    public TabContentFragment(View v, String tag) {
        mView = v;
        mText = tag;
    }
    */

    public void setTabContentFragment(View v, String tag) {
        mView = v;
        mText = tag;
    }

    /*.*/public String getText() {
        return mText;
    }

    /*.*/public View getView() {
        return mView;
    }

    @Override
    /*.*/public void onActivityCreated(Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);
    }

    @Override
    /*.*/public View onCreateView(LayoutInflater inflater, ViewGroup container,
                                  Bundle savedInstanceState) {
    	    /*
    	     * You can access the container's id by calling
               ((ViewGroup)getView().getParent()).getId();
    	     */
        LayoutParams lparams = new LayoutParams(RelativeLayout.LayoutParams.MATCH_PARENT, RelativeLayout.LayoutParams.MATCH_PARENT);
        lparams.addRule(RelativeLayout.CENTER_IN_PARENT);
        mView.setLayoutParams(lparams);
        return mView;
    }
}
