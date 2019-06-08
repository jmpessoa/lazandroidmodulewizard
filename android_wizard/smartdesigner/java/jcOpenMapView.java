package org.lamw.appjcenteropenstreetmapdemo1;

import android.content.Context;
import android.graphics.Color;
import android.graphics.drawable.Drawable;
import android.os.AsyncTask;
import android.os.Build;
import android.os.StrictMode;
import android.util.Log;
import android.view.View;
import android.view.ViewGroup;

import org.osmdroid.api.IMapController;
import org.osmdroid.bonuspack.overlays.GroundOverlay;
import org.osmdroid.bonuspack.routing.OSRMRoadManager;
import org.osmdroid.bonuspack.routing.Road;
import org.osmdroid.bonuspack.routing.RoadManager;
import org.osmdroid.bonuspack.routing.RoadNode;
import org.osmdroid.config.Configuration;
import org.osmdroid.events.MapEventsReceiver;
import org.osmdroid.tileprovider.tilesource.TileSourceFactory;
import org.osmdroid.util.GeoPoint;
import org.osmdroid.views.MapView;
import org.osmdroid.views.overlay.MapEventsOverlay;
import org.osmdroid.views.overlay.Marker;
import org.osmdroid.views.overlay.Overlay;
import org.osmdroid.views.overlay.Polygon;
import org.osmdroid.views.overlay.Polyline;
import org.osmdroid.views.overlay.ScaleBarOverlay;
import org.osmdroid.views.overlay.infowindow.BasicInfoWindow;

import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.List;

/*Draft java code by "Lazarus Android Module Wizard" [5/25/2019 22:51:05]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jVisualControl LAMW template*/

// https://github.com/MKergall/osmbonuspack/releases
//https://github.com/osmdroid/osmdroid/wiki/Important-notes-on-using-osmdroid-in-your-app
public class jcOpenMapView extends MapView implements MapEventsReceiver { //please, fix what GUI object will be extended!

    private long pascalObj = 0;        // Pascal Object
    private Controls controls = null; //Java/Pascal [events] Interface ...
    private jCommons LAMWCommon;
    private Context context = null;

    //private OnClickListener onClickListener;   // click event
    private Boolean enabled = true;           // click-touch enabled!

    private IMapController mapController;

    private ArrayList<GeoPoint> mPath;
    private MapView mThis;
    private RoadManager mRoadManager;

    MapEventsOverlay mapEventsOverlay;

    List<GeoPoint> mGeoPointsList;

    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
    public jcOpenMapView(Controls _ctrls, long _Self, boolean _showScale, int _tileSource, int _zoom) { //Add more others news "_xxx" params if needed!
        super(_ctrls.activity);
        context = _ctrls.activity;
        pascalObj = _Self;
        controls = _ctrls;
        LAMWCommon = new jCommons(this, context, pascalObj);

        /*
        onClickListener = new OnClickListener() {
            public void onClick(View view) {     // *.* is a mask to future parse...;
                if (enabled) {
                    controls.pOnClickGeneric(pascalObj, Const.Click_Default); //JNI event onClick!
                }
            };
        };
        setOnClickListener(onClickListener);
        */

        //Fonte de imagens
        switch(_tileSource) {
            case 0: this.setTileSource(TileSourceFactory.MAPNIK); break;//MAPNIK-HIKEBIKEMAP-OpenTopo ok
            case 1: this.setTileSource(TileSourceFactory.HIKEBIKEMAP); break; //MAPNIK-HIKEBIKEMAP-OpenTopo ok
            case 2: this.setTileSource(TileSourceFactory.OpenTopo); break; //MAPNIK-HIKEBIKEMAP-OpenTopo ok
        }

        mapController = this.getController();
        mapController.setZoom((double)_zoom);

        mGeoPointsList = new ArrayList<GeoPoint>(); //polygon
        mPath = new ArrayList<GeoPoint>();   //road

        Configuration.getInstance().setUserAgentValue(BuildConfig.APPLICATION_ID);

        mRoadManager = new OSRMRoadManager(controls.activity);
        mThis = this;
        mapEventsOverlay = new MapEventsOverlay(this);
        this.getOverlays().add(0, mapEventsOverlay);

        //show scale
        if (_showScale) {
            ScaleBarOverlay scale = new ScaleBarOverlay(this);
            this.getOverlays().add(scale);
        }
    } //end constructor

    //https://code.google.com/archive/p/osmbonuspack/wikis/Tutorial_5.wiki
    @Override
    public boolean singleTapConfirmedHelper(GeoPoint p) {
        //Toast.makeText(this, "Tapped", Toast.LENGTH_SHORT).show();
        //Log.i("singleTap", "Latitude" + p.getLatitude());
        controls.pOnOpenMapViewClick(pascalObj, p.getLatitude(),p.getLongitude());
        return false;
    }

    @Override
    public boolean longPressHelper(GeoPoint p) {
        //DO NOTHING FOR NOW: return false
        //Log.i("longPress", "Latitude" + p.getLatitude());
        controls.pOnOpenMapViewLongClick(pascalObj, p.getLatitude(),p.getLongitude());
        return false;
    }

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
    public void SetId(int _id) { //wrapper method pattern ...
        this.setId(_id);
    }

    //Faz zoom no mapa
    public void SetZoom(int _zoom) {
        mapController.setZoom((double)_zoom);
    }

    //Centraliza o mapa no ponto de referência
    public void SetCenter(double _latitude, double _longitude) {
        //Cria um ponto de referência com base na latitude e longitude
        GeoPoint geoPoint = new GeoPoint(_latitude, _longitude);
        mapController.setCenter(geoPoint);
        //mapController.animateTo(geoPoint);
    }

    public void ClearOverlays() {
        this.getOverlays().clear();
    }

    public void Invalidate() {
        this.invalidate();
    }

    public int GetDrawableResourceId(String _resName) {
        try {
            Class<?> res = R.drawable.class;
            Field field = res.getField(_resName);  //"drawableName"
            int drawableId = field.getInt(null);
            return drawableId;
        } catch (Exception e) {
            Log.e("jcOpenMapView", "Failure to get drawable id.", e);
            return 0;
        }
    }

    public Drawable GetDrawableResourceById(int _resID) {
        if (_resID == 0) return null; // by tr3e
        Drawable res = null;
        if (Build.VERSION.SDK_INT < 21) {    //for old device < 21
            res = this.controls.activity.getResources().getDrawable(_resID);
        }
        //[ifdef_api21up]
        if (Build.VERSION.SDK_INT >= 21) {
            res = this.controls.activity.getResources().getDrawable(_resID, null);
        }//[endif_api21up]
        return res;
    }

    /**
     * AsyncTask <TypeOfVarArgParams, ProgressValue, ResultValue>
     */
    class MyAsyncTask extends AsyncTask<Object, Void, Road> {

        int roadtag;

        public  MyAsyncTask(int tag) {
            roadtag = tag;
        }
        @Override
        protected void onPreExecute() {
            //
        }
        @Override
        protected Road doInBackground(Object... params) {
            @SuppressWarnings("unchecked")
            ArrayList<GeoPoint> waypoints = (ArrayList<GeoPoint>)params[0];
            Road road = null;
            try {
                //roadManager.addRequestOption("vehicle=foot");
                //roadManager.addRequestOption("optimize=true"); //min path
                road = mRoadManager.getRoad(waypoints);
            } catch(Exception e) {
                e.printStackTrace();
            }
            return road;
        }
        @Override
        protected void onProgressUpdate(Void... values) {
            //
        }
        @Override
        protected void onPostExecute(Road road) {
            super.onPostExecute(road);

           if (road != null) {
               if (road.mStatus == Road.STATUS_INVALID) { //1
                   Log.i("onPostExecute", "Technical issue when getting the route");
                   int[] r0 = controls.pOnOpenMapViewRoadDraw(pascalObj,roadtag,1, 0,0);
               } else if (road.mStatus == Road.STATUS_TECHNICAL_ISSUE) { //2
                   Log.i("onPostExecute", "Technical issue when getting the route");
                   int[] r0 = controls.pOnOpenMapViewRoadDraw(pascalObj,roadtag,2, 0, 0);
               } else if (road.mStatus > Road.STATUS_TECHNICAL_ISSUE) { //functional issues
                   Log.i("onPostExecute", "No possible route here");
                   int[] r0 = controls.pOnOpenMapViewRoadDraw(pascalObj,roadtag,3, 0, 0);
               } else if (road.mStatus == Road.STATUS_OK){
                   int color = Color.BLUE;
                   int width = 3;
                   int[] r = controls.pOnOpenMapViewRoadDraw(pascalObj,roadtag,0,road.mDuration, road.mLength);
                   if (r[0] != 0) color = r[0];
                   if (r[1] > 0) width = r[1];
                   Polyline roadOverlay = RoadManager.buildRoadOverlay(road, color, width);
                   mThis.getOverlays().add(roadOverlay);
                   mThis.invalidate();
               }
           }
           else
               Log.i("onPostExecute", "road NULL!!!");
        }
    }

    public void RoadDraw(int _roadCode) {
        if (mPath.size() == 0) return;
        new MyAsyncTask(_roadCode).execute(mPath);
    }

    public void RoadDraw() {
        if (mPath.size() == 0) return;
        new MyAsyncTask(0).execute(mPath);
    }

    public void RoadClear() {
        mPath.clear();
    }

    public void RoadAdd(double _latitude, double _longitude) {
        mPath.add(new GeoPoint(_latitude, _longitude));
    }

    public void SetMarker(double _latitude, double _longitude, String _iconIdentifier) {
        Marker marker = new Marker(this);
        GeoPoint geoPoint = new GeoPoint(_latitude, _longitude);
        marker.setPosition(geoPoint);
        marker.setAnchor(Marker.ANCHOR_CENTER, Marker.ANCHOR_BOTTOM);
        marker.setIcon(GetDrawableResourceById(GetDrawableResourceId(_iconIdentifier)));
        this.getOverlays().add(marker);
    }

    public void SetMarker(double _latitude, double _longitude, String _title, String _iconIdentifier) {
        Marker marker = new Marker(this);
        GeoPoint geoPoint = new GeoPoint(_latitude, _longitude);
        marker.setPosition(geoPoint);
        marker.setTitle(_title);
        marker.setSnippet("Département INFO, IUT de Lannion");
        //marker.setAlpha(0.75f);
        //nodeMarker.setSubDescription(Road.getLengthDurationText(controls.activity, _node.mLength, _node.mDuration));
        //nodeMarker.setImage(GetDrawableResourceById(GetDrawableResourceId(_imageIdentifier)));
        marker.setAnchor(Marker.ANCHOR_CENTER, Marker.ANCHOR_BOTTOM);
        marker.setIcon(GetDrawableResourceById(GetDrawableResourceId(_iconIdentifier)));
        this.getOverlays().add(marker);
    }

    public void SetMarker(double _latitude, double _longitude, String _title, String _snippetInfo, String _iconIdentifier) {
        Marker marker = new Marker(this);
        GeoPoint geoPoint = new GeoPoint(_latitude, _longitude);
        marker.setPosition(geoPoint);
        marker.setTitle(_title);
        marker.setSnippet(_snippetInfo);
        //marker.setAlpha(0.75f);
        marker.setAnchor(Marker.ANCHOR_CENTER, Marker.ANCHOR_BOTTOM);
        marker.setIcon(GetDrawableResourceById(GetDrawableResourceId(_iconIdentifier)));
        this.getOverlays().add(marker);
    }

    public void SetMarker(double _latitude, double _longitude, String _title, String _snippetInfo, String _markerIconIdentifier, String _snippetImageIdentifier) {
        Marker marker = new Marker(this);
        GeoPoint geoPoint = new GeoPoint(_latitude, _longitude);
        marker.setPosition(geoPoint);
        marker.setTitle(_title);
        marker.setSnippet(_snippetInfo);
        //marker.setAlpha(0.75f);
        marker.setImage(GetDrawableResourceById(GetDrawableResourceId(_snippetImageIdentifier)));
        marker.setAnchor(Marker.ANCHOR_CENTER, Marker.ANCHOR_BOTTOM);
        marker.setIcon(GetDrawableResourceById(GetDrawableResourceId(_markerIconIdentifier)));
        this.getOverlays().add(marker);
    }

    public void SetShowScale(boolean _show) {//show scale
        if (_show) {
            ScaleBarOverlay scale = new ScaleBarOverlay(this);
            this.getOverlays().add(scale);
        }
    }

    public void SetTileSource(int _tileSource) {
        //Fonte de imagens
        switch(_tileSource) {
            case 0: this.setTileSource(TileSourceFactory.MAPNIK); break;//MAPNIK-HIKEBIKEMAP-OpenTopo ok
            case 1: this.setTileSource(TileSourceFactory.HIKEBIKEMAP); break; //MAPNIK-HIKEBIKEMAP-OpenTopo ok
            case 2: this.setTileSource(TileSourceFactory.OpenTopo); break; //MAPNIK-HIKEBIKEMAP-OpenTopo ok
        }
    }

    public void SetCircle(double _latitude, double _longitude, double _radiusInMetters, String _title, int _strokeColor, float _strokeWidth) {
        GeoPoint geoPoint = new GeoPoint(_latitude, _longitude);
        Polygon circle = new Polygon(this); //radiusInMetter
        circle.setPoints(Polygon.pointsAsCircle(geoPoint, _radiusInMetters)); //2000.0
        //And we adjust some design aspects:
        circle.setFillColor(0x12121212);
        circle.setStrokeColor(_strokeColor);  //Color.RED
        circle.setStrokeWidth(_strokeWidth); //2
       //And as Polygon supports bubbles, let's add one:
        circle.setInfoWindow(new BasicInfoWindow(R.layout.bonuspack_bubble, this));
        //circle.setTitle("Centered on "+geoPoint.getLatitude()+","+geoPoint.getLongitude());
        circle.setTitle(_title);
        this.getOverlays().add(circle);
        //this.invalidate();
    }

    public void SetGroundImageOverlay(double _latitude, double _longitude, String _imageIdentifier, float _dimMetters) {
        int resId = GetDrawableResourceId(_imageIdentifier);
        Drawable d = GetDrawableResourceById(resId);
        GeoPoint geoPoint = new GeoPoint(_latitude, _longitude);
        GroundOverlay myGroundOverlay = new GroundOverlay();
        myGroundOverlay.setPosition(geoPoint);
        myGroundOverlay.setImage(d.mutate()); //
        myGroundOverlay.setDimensions(_dimMetters); //2000.0f
        this.getOverlays().add(myGroundOverlay);
    }

    //https://github.com/osmdroid/osmdroid/wiki/Markers,-Lines-and-Polygons
    public void DrawPolygon(double[] _latitude, double[] _longitude, String _title, int _color, int _alphaTransparency) {
        List<GeoPoint> geoPoints = new ArrayList<>();
        int count = _latitude.length;
        //add points
        for (int i = 0; i < count; i++) {
            geoPoints.add(new GeoPoint(_latitude[i], _longitude[i]));
        }
        geoPoints.add(geoPoints.get(0));    //forces the loop to close

        Polygon polygon = new Polygon();

        polygon.setFillColor(Color.argb(_alphaTransparency, 255,0,0)); //5     0=total transparency

        polygon.setStrokeColor(_color);
        polygon.setStrokeWidth(3);

        polygon.setPoints(geoPoints);
        polygon.setTitle(_title); //"A sample polygon"
        //polygons supports holes too, points should be in a counter-clockwise order
        /*
        if (_holes) {
            List<List<GeoPoint>> holes = new ArrayList<>();
            holes.add(geoPointsHoles);
            polygon.setHoles(holes);
        }
        */
        this.getOverlayManager().add(polygon);
        this.invalidate();
    }

    public void DrawPolyline(double[] _latitude, double[] _longitude) {
        List<GeoPoint> geoPoints = new ArrayList<>();
        Polyline line = new Polyline();   //see note below!
        int count = _latitude.length;
        //add points
        for (int i = 0; i < count; i++) {
            geoPoints.add(new GeoPoint(_latitude[i], _longitude[i]));
        }
        line.setPoints(geoPoints);
        /*
        line.setOnClickListener(new Polyline.OnClickListener() {
            @Override
            public boolean onClick(Polyline polyline, MapView mapView, GeoPoint eventPos) {
               //Toast.makeText(mapView.getContext(), "polyline with " + polyline.getPoints().size() + "pts was tapped", Toast.LENGTH_LONG).show();
                return false;
            }
        });
        */
        this.getOverlayManager().add(line);
        this.invalidate();
    }

    private void setMarkerListeners(Marker locationMarker) {
        locationMarker.setOnMarkerClickListener(new Marker.OnMarkerClickListener() {
            @Override
            public boolean onMarkerClick(Marker marker, MapView map) {
                if (marker.isInfoWindowShown() != true) {
                    //hideInfoWindows();
                    marker.showInfoWindow();
                } else {
                    //hideInfoWindows();
                }
                return false;
            }
        });
    }

    public int PolygonAdd(double _latitude, double _longitude) {
        mGeoPointsList.add(new GeoPoint(_latitude, _longitude));
        return mGeoPointsList.size();
    }

    public void PolygonClear() {
        mGeoPointsList.clear();
    }

    public void PolygonDraw(String _title, int _color, int _alphaTransparency) {

        if (mGeoPointsList.size() < 3) return;

        Polygon polygon = new Polygon();

        polygon.setFillColor(Color.argb(_alphaTransparency, 255,0,0)); //5     0=total transparency

        polygon.setStrokeColor(_color);
        polygon.setStrokeWidth(3);
        polygon.setPoints(mGeoPointsList);
        polygon.setTitle(_title); //"A sample polygon"

        /*
        //polygons supports holes too, points should be in a counter-clockwise order
        if (_holes) {
            List<List<GeoPoint>> holes = new ArrayList<>();
            holes.add(mGeoPointsHolesList);
            polygon.setHoles(holes);
        }
        */

        this.getOverlayManager().add(polygon);
        this.invalidate();
    }

    public double[] GetPolygon() {
        int count = mGeoPointsList.size();
        double[] array = new double[2*count];
        int j = 0;
        for (int i=0; i < count; i++) {
            GeoPoint gp =mGeoPointsList.get(i);
            array[j] = gp.getLatitude(); // 0 2 4 6
            array[j+1] = gp.getLongitude(); //1 3 5 7
            j = j+2; //2 4 6
        }
        return array;
    }

}
