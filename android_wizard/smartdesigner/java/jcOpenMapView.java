package org.lamw.applamwprojecttt1;

import android.content.Context;
import android.graphics.Color;
import android.graphics.DashPathEffect;
import android.graphics.Paint;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.Drawable;
import android.os.AsyncTask;
import android.os.Build;
import android.os.StrictMode;
import android.util.Log;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;

import org.osmdroid.api.IMapController;
import org.osmdroid.bonuspack.BuildConfig;
import org.osmdroid.bonuspack.overlays.GroundOverlay;
import org.osmdroid.bonuspack.routing.OSRMRoadManager;
import org.osmdroid.bonuspack.routing.Road;
import org.osmdroid.bonuspack.routing.RoadManager;
import org.osmdroid.bonuspack.routing.RoadNode;
import org.osmdroid.config.Configuration;
import org.osmdroid.events.MapEventsReceiver;
import org.osmdroid.tileprovider.tilesource.TileSourceFactory;
import org.osmdroid.util.BoundingBox;
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

    private ArrayList<GeoPoint> mBufferGeoPointsList;
    private MapView mThis;
    private RoadManager mRoadManager;
    MapEventsOverlay mapEventsOverlay;
    List<Marker> mMarkerList;
    List<Polygon> mPolygonList;
    List<Polyline> mPolylineList;
    List<Polyline> mLineList;

    private boolean IsMarkerDraggable;

    private int mStrokeColor = Color.RED;
    private float mStrokeWidth = 2;
    private int mFillColor = 0x12121212;

    float mX = Marker.ANCHOR_CENTER;
    float mY = Marker.ANCHOR_BOTTOM;

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
                    controls.pOnClickGeneric(pascalObj); //JNI event onClick!
                }
            };
        };
        setOnClickListener(onClickListener);
        */

        /*
        this.setOnTouchListener(new View.OnTouchListener() {
            @Override
            public boolean onTouch(View v, MotionEvent event) {
                return true;
            }
        });
        */

        //images sources
        switch(_tileSource) {
            case 0: this.setTileSource(TileSourceFactory.MAPNIK); break;//MAPNIK-HIKEBIKEMAP-OpenTopo ok
            case 1: this.setTileSource(TileSourceFactory.HIKEBIKEMAP); break; //MAPNIK-HIKEBIKEMAP-OpenTopo ok
            case 2: this.setTileSource(TileSourceFactory.OpenTopo); break; //MAPNIK-HIKEBIKEMAP-OpenTopo ok
        }

        mapController = this.getController();
        mapController.setZoom((double)_zoom);

        mMarkerList = new ArrayList<Marker>();
        mPolygonList = new ArrayList<Polygon>();
        mPolylineList = new ArrayList<Polyline>();
        mLineList = new ArrayList<Polyline>();

        mBufferGeoPointsList = new ArrayList<GeoPoint>();

        //Configuration.getInstance().setUserAgentValue(BuildConfig.APPLICATION_ID);
        mRoadManager = new OSRMRoadManager(controls.activity, BuildConfig.LIBRARY_PACKAGE_NAME);
        mThis = this;
        mapEventsOverlay = new MapEventsOverlay(this);

        this.getOverlays().add(0, mapEventsOverlay);

        //show scale
        if (_showScale) {
            ScaleBarOverlay scale = new ScaleBarOverlay(this);
            this.getOverlays().add(scale);
        }

        IsMarkerDraggable = true;
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
        mMarkerList.clear();
        mPolygonList.clear();
        mPolylineList.clear();
        mLineList.clear();
        mBufferGeoPointsList.clear();

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

    public void DrawCircle(double _latitude, double _longitude, double _radiusInMetters, String _title, int _strokeColor, float _strokeWidth) {
        GeoPoint geoPoint = new GeoPoint(_latitude, _longitude);
        Polygon circle = new Polygon(this); //radiusInMetter
        circle.setPoints(Polygon.pointsAsCircle(geoPoint, _radiusInMetters)); //2000.0
        //And we adjust some design aspects:
        Paint paint = circle.getFillPaint();
        paint.setColor(mFillColor);
        paint.setStrokeWidth(_strokeWidth); //2
        //And as Polygon supports bubbles, let's add one:
        circle.setInfoWindow(new BasicInfoWindow(org.osmdroid.bonuspack.R.layout.bonuspack_bubble, this)); //int layoutResId, MapView mapView
        //circle.setTitle("Centered on "+geoPoint.getLatitude()+","+geoPoint.getLongitude());
        circle.setTitle(_title);
        this.getOverlays().add(circle);
        //this.invalidate();
    }

    public void SetGroundImageOverlay(double _latitude, double _longitude, String _imageIdentifier, float _dimMetters) {
        int resId = controls.GetDrawableResourceId(_imageIdentifier);
        Drawable d = controls.GetDrawableResourceById(resId);
        GeoPoint geoPointTopLeft = new GeoPoint(_latitude, _longitude);
        GeoPoint geoPointBottomRight = new GeoPoint(_latitude+_dimMetters, _longitude+_dimMetters);
        GroundOverlay myGroundOverlay = new GroundOverlay();
        myGroundOverlay.setPositionFromBounds(geoPointTopLeft, geoPointBottomRight);
        myGroundOverlay.setImage(((BitmapDrawable)d).getBitmap()); //d.mutate()
        //myGroundOverlay.setDimensions(_dimMetters) or 2000.0f
        this.getOverlays().add(myGroundOverlay);
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

    public void DrawRoad(int _roadCode) {
        if (mBufferGeoPointsList.size() < 2) return;
        new MyAsyncTask(_roadCode).execute(mBufferGeoPointsList);
    }

    public void DrawRoad() {
        if (mBufferGeoPointsList.size() < 2) return;
        new MyAsyncTask(0).execute(mBufferGeoPointsList);
    }

    public void DrawRoad(int _roadCode, int _geoPointStartIndex, int _count) {
        ArrayList<GeoPoint> pointsList = new ArrayList<GeoPoint>();

        int size = mBufferGeoPointsList.size();

        int startIndex = _geoPointStartIndex;
        if (startIndex < 0) startIndex = 0;

        int cnt = _count;
        if (cnt < 2) cnt = 2;

        for (int i = 0; i < cnt; i++) {
            if ((startIndex + i) < size)
                pointsList.add(mBufferGeoPointsList.get(startIndex + i));
        }
        if (pointsList.size() < 2) return;

        new MyAsyncTask(0).execute(pointsList);
    }

    public void DrawRoad(int _roadCode, double[] _latitudeLongitude) {
        int count = _latitudeLongitude.length;
        ArrayList<GeoPoint> pointsList = new ArrayList<GeoPoint>();
        int i = 0;
        while ( (2*i+1) < count) { //0-> 0,1   1->2,3  2->4,5
            pointsList.add(new GeoPoint(_latitudeLongitude[2*i], _latitudeLongitude[2*i+1]));
            i = i +1;
        }
        if (pointsList.size() < 2) return;
        new MyAsyncTask(0).execute(pointsList);
    }


    public int AddMarker(double _latitude, double _longitude, String _iconIdentifier, int _rotationAngleDeg) {
        Marker marker = new Marker(this);
        GeoPoint geoPoint = new GeoPoint(_latitude, _longitude);
        marker.setPosition(geoPoint);
        marker.setTitle(_iconIdentifier);
        marker.setAnchor(mX, mY);
        marker.setIcon(controls.GetDrawableResourceById(controls.GetDrawableResourceId(_iconIdentifier)));
        marker.setRotation(_rotationAngleDeg);
        //marker.setInfoWindow(null);
        marker.setDraggable(IsMarkerDraggable);
        marker.setOnMarkerClickListener(new Marker.OnMarkerClickListener() {
            @Override
            public boolean onMarkerClick(Marker marker, MapView mapView) {
                marker.showInfoWindow();
                mapView.getController().animateTo(marker.getPosition());
                controls.pOnOpenMapViewMarkerClick(pascalObj, marker.getTitle(),  marker.getPosition().getLatitude(), marker.getPosition().getLongitude());
                return false;
            }
        });

        this.getOverlays().add(marker);
        this.invalidate();
        mMarkerList.add(marker);
        return mMarkerList.size();
    }

    public int AddMarker(double _latitude, double _longitude, String _iconIdentifier) {
        Marker marker = new Marker(this);
        GeoPoint geoPoint = new GeoPoint(_latitude, _longitude);
        marker.setPosition(geoPoint);
        marker.setTitle(_iconIdentifier);
        marker.setAnchor(mX, mY);
        marker.setIcon(controls.GetDrawableResourceById(controls.GetDrawableResourceId(_iconIdentifier)));
        //marker.setInfoWindow(null);
        marker.setDraggable(IsMarkerDraggable);
        marker.setOnMarkerClickListener(new Marker.OnMarkerClickListener() {
            @Override
            public boolean onMarkerClick(Marker marker, MapView mapView) {
                marker.showInfoWindow();
                mapView.getController().animateTo(marker.getPosition());
                controls.pOnOpenMapViewMarkerClick(pascalObj, marker.getTitle(),  marker.getPosition().getLatitude(), marker.getPosition().getLongitude());
                return false;
            }
        });

        this.getOverlays().add(marker);
        this.invalidate();
        mMarkerList.add(marker);
        return mMarkerList.size();
    }

    public int AddMarker(double _latitude, double _longitude, String _title, String _iconIdentifier,  int _rotationAngleDeg) {
        Marker marker = new Marker(this);
        GeoPoint geoPoint = new GeoPoint(_latitude, _longitude);
        marker.setPosition(geoPoint);
        marker.setTitle(_title);
        //marker.setSnippet("Département INFO, IUT de Lannion");
        //marker.setAlpha(0.75f);
        //nodeMarker.setSubDescription(Road.getLengthDurationText(controls.activity, _node.mLength, _node.mDuration));
        //nodeMarker.setImage(controls.GetDrawableResourceById(controls.GetDrawableResourceId(_imageIdentifier)));
        marker.setAnchor(mX, mY);
        marker.setIcon(controls.GetDrawableResourceById(controls.GetDrawableResourceId(_iconIdentifier)));
        marker.setRotation(_rotationAngleDeg);
        marker.setDraggable(IsMarkerDraggable);
        marker.setOnMarkerClickListener(new Marker.OnMarkerClickListener() {
            @Override
            public boolean onMarkerClick(Marker marker, MapView mapView) {
                marker.showInfoWindow();
                mapView.getController().animateTo(marker.getPosition());
                controls.pOnOpenMapViewMarkerClick(pascalObj, marker.getTitle(), marker.getPosition().getLatitude(), marker.getPosition().getLongitude());
                return false;
            }
        });

        this.getOverlays().add(marker);
        this.invalidate();
        mMarkerList.add(marker);
        return mMarkerList.size();
    }

    public int AddMarker(double _latitude, double _longitude, String _title, String _iconIdentifier) {
        Marker marker = new Marker(this);
        GeoPoint geoPoint = new GeoPoint(_latitude, _longitude);
        marker.setPosition(geoPoint);
        marker.setTitle(_title);
        //marker.setSnippet("Département INFO, IUT de Lannion");
        //marker.setAlpha(0.75f);
        //nodeMarker.setSubDescription(Road.getLengthDurationText(controls.activity, _node.mLength, _node.mDuration));
        //nodeMarker.setImage(controls.GetDrawableResourceById(controls.GetDrawableResourceId(_imageIdentifier)));
        marker.setAnchor(mX, mY);
        marker.setIcon(controls.GetDrawableResourceById(controls.GetDrawableResourceId(_iconIdentifier)));
        marker.setDraggable(IsMarkerDraggable);
        marker.setOnMarkerClickListener(new Marker.OnMarkerClickListener() {
            @Override
            public boolean onMarkerClick(Marker marker, MapView mapView) {
                marker.showInfoWindow();
                mapView.getController().animateTo(marker.getPosition());
                controls.pOnOpenMapViewMarkerClick(pascalObj, marker.getTitle(), marker.getPosition().getLatitude(), marker.getPosition().getLongitude());
                return false;
            }
        });

        this.getOverlays().add(marker);
        this.invalidate();
        mMarkerList.add(marker);
        return mMarkerList.size();
    }

    public int AddMarker(double _latitude, double _longitude, String _title, String _snippetInfo, String _iconIdentifier) {
        Marker marker = new Marker(this);
        GeoPoint geoPoint = new GeoPoint(_latitude, _longitude);
        marker.setPosition(geoPoint);
        marker.setTitle(_title);
        marker.setSnippet(_snippetInfo);
        //marker.setAlpha(0.75f);
        marker.setAnchor(mX, mY);
        marker.setIcon(controls.GetDrawableResourceById(controls.GetDrawableResourceId(_iconIdentifier)));
        marker.setDraggable(IsMarkerDraggable);
        marker.setOnMarkerClickListener(new Marker.OnMarkerClickListener() {
            @Override
            public boolean onMarkerClick(Marker marker, MapView mapView) {
                marker.showInfoWindow();
                mapView.getController().animateTo(marker.getPosition());
                controls.pOnOpenMapViewMarkerClick(pascalObj, marker.getTitle(), marker.getPosition().getLatitude(), marker.getPosition().getLongitude());
                return false;
            }
        });

        this.getOverlays().add(marker);
        this.invalidate();
        mMarkerList.add(marker);
        return mMarkerList.size();
    }

    public int AddMarkers(double[] _latitudeLongitude, String _title, String _snippetInfo, String _iconIdentifier) {
        int count = _latitudeLongitude.length;
        Marker marker;
        int i = 0;
        while ( (2*i+1) < count) { //0-> 0,1   1->2,3  2->4,5
            marker = new Marker(this);
            marker.setPosition(new GeoPoint(_latitudeLongitude[2*i], _latitudeLongitude[2*i+1]));
            i = i +1;
            marker.setTitle(_title);
            marker.setSnippet(_snippetInfo);
            //marker.setAlpha(0.75f);
            marker.setAnchor(mX, mY);
            marker.setIcon(controls.GetDrawableResourceById(controls.GetDrawableResourceId(_iconIdentifier)));
            marker.setDraggable(IsMarkerDraggable);
            marker.setOnMarkerClickListener(new Marker.OnMarkerClickListener() {
                @Override
                public boolean onMarkerClick(Marker marker, MapView mapView) {
                    marker.showInfoWindow();
                    mapView.getController().animateTo(marker.getPosition());
                    controls.pOnOpenMapViewMarkerClick(pascalObj, marker.getTitle(), marker.getPosition().getLatitude(), marker.getPosition().getLongitude());
                    return false;
                }
            });
            this.getOverlays().add(marker);
            this.invalidate();
            mMarkerList.add(marker);
        }
        return mMarkerList.size();
    }

    public int AddMarkers(double[] _latitudeLongitude, String _iconIdentifier) {
        int count = _latitudeLongitude.length;
        Marker marker;
        int i = 0;
        while ( (2*i+1) < count) { //0-> 0,1   1->2,3  2->4,5
            marker = new Marker(this);
            marker.setPosition(new GeoPoint(_latitudeLongitude[2*i], _latitudeLongitude[2*i+1]));
            i = i +1;
            //marker.setTitle(_title);
            //marker.setSnippet(_snippetInfo);
            //marker.setAlpha(0.75f);
            marker.setAnchor(mX, mY);
            marker.setIcon(controls.GetDrawableResourceById(controls.GetDrawableResourceId(_iconIdentifier)));
            marker.setDraggable(IsMarkerDraggable);
            marker.setOnMarkerClickListener(new Marker.OnMarkerClickListener() {
                @Override
                public boolean onMarkerClick(Marker marker, MapView mapView) {
                    marker.showInfoWindow();
                    mapView.getController().animateTo(marker.getPosition());
                    controls.pOnOpenMapViewMarkerClick(pascalObj, marker.getTitle(), marker.getPosition().getLatitude(), marker.getPosition().getLongitude());
                    return false;
                }
            });
            this.getOverlays().add(marker);
            this.invalidate();
            mMarkerList.add(marker);
        }
        return mMarkerList.size();
    }

    public int AddMarker(double _latitude, double _longitude, String _title, String _snippetInfo, String _markerIconIdentifier, String _snippetImageIdentifier) {
        Marker marker = new Marker(this);
        GeoPoint geoPoint = new GeoPoint(_latitude, _longitude);
        marker.setPosition(geoPoint);

        marker.setTitle(_title);
        marker.setSnippet(_snippetInfo);
        //marker.setAlpha(0.75f);
        marker.setImage(controls.GetDrawableResourceById(controls.GetDrawableResourceId(_snippetImageIdentifier)));
        marker.setAnchor(mX, mY);
        marker.setIcon(controls.GetDrawableResourceById(controls.GetDrawableResourceId(_markerIconIdentifier)));
        marker.setDraggable(IsMarkerDraggable);
        marker.setOnMarkerClickListener(new Marker.OnMarkerClickListener() {
            @Override
            public boolean onMarkerClick(Marker marker, MapView mapView) {
                marker.showInfoWindow();
                mapView.getController().animateTo(marker.getPosition());
                controls.pOnOpenMapViewMarkerClick(pascalObj, marker.getTitle(), marker.getPosition().getLatitude(), marker.getPosition().getLongitude());
                return false;
            }
        });

        this.getOverlays().add(marker);
        this.invalidate();
        mMarkerList.add(marker);
        return mMarkerList.size();
    }

    public Marker DrawMarker(double _latitude, double _longitude,  String _title, String _iconIdentifier) {
        GeoPoint geoPoint = new GeoPoint(_latitude,_longitude);
        Marker marker = new Marker(this);
        marker.setPosition(geoPoint);
        marker.setAnchor(mX, mY);
        marker.setIcon(controls.GetDrawableResourceById(controls.GetDrawableResourceId(_iconIdentifier)));
        marker.setTitle(_title);
        marker.setDraggable(IsMarkerDraggable);
        marker.setOnMarkerClickListener(new Marker.OnMarkerClickListener() {
            @Override
            public boolean onMarkerClick(Marker marker, MapView mapView) {
                marker.showInfoWindow();
                mapView.getController().animateTo(marker.getPosition());
                controls.pOnOpenMapViewMarkerClick(pascalObj, marker.getTitle(), marker.getPosition().getLatitude(), marker.getPosition().getLongitude());
                return false;
            }
        });
        this.getOverlays().add(marker);
        this.invalidate();
        return marker;
    }

    public Marker DrawMarker(double _latitude, double _longitude, String _title, String _snippetInfo, String _iconIdentifier) {
        GeoPoint geoPoint = new GeoPoint(_latitude,_longitude);
        Marker marker = new Marker(this);
        marker.setPosition(geoPoint);
        marker.setAnchor(mX, mY);
        marker.setIcon(controls.GetDrawableResourceById(controls.GetDrawableResourceId(_iconIdentifier)));
        marker.setTitle(_title);
        marker.setSnippet(_snippetInfo);
        marker.setDraggable(IsMarkerDraggable);
        marker.setOnMarkerClickListener(new Marker.OnMarkerClickListener() {
            @Override
            public boolean onMarkerClick(Marker marker, MapView mapView) {
                marker.showInfoWindow();
                mapView.getController().animateTo(marker.getPosition());
                controls.pOnOpenMapViewMarkerClick(pascalObj, marker.getTitle(), marker.getPosition().getLatitude(), marker.getPosition().getLongitude());
                return false;
            }
        });
        this.getOverlays().add(marker);
        this.invalidate();
        return marker;
    }

    public void ClearMarker(Marker _marker) {
        this.getOverlays().remove(_marker);
        this.invalidate();
    }

    public void MoveMarker(Marker _marker, double _latitude, double _longitude) {
        _marker.getPosition().setLatitude(_latitude);
        _marker.getPosition().setLongitude(_longitude);
        this.invalidate();
    }

    public void ClearMarker(int _index) {
        Marker m = mMarkerList.get(_index);
        this.getOverlays().remove(m);
        this.invalidate();
        mMarkerList.remove(_index);
    }

    public void ClearMarkers() {
        int count = mMarkerList.size();
        for (int i = 0; i < count; i++) {
            this.getOverlays().remove((Marker)mMarkerList.get(i));
        }
        mMarkerList.clear();
        this.invalidate();
    }

    public void ClearMarkers(boolean _invalidate) {  //TODO Pascal
        int count = mMarkerList.size();
        if (_invalidate) {
            for (int i = 0; i < count; i++) {
                this.getOverlays().remove((Marker) mMarkerList.get(i));
            }
            this.invalidate();
        }
        mMarkerList.clear();
    }

    public double[] GetMarkersPositions() {
        int count = mMarkerList.size();
        double[] array = new double[2*count];
        int j = 0;
        for (int i=0; i < count; i++) {
            Marker marker = mMarkerList.get(i);
            array[j] = marker.getPosition().getLatitude(); // 0 2 4 6
            array[j+1] = marker.getPosition().getLongitude(); //1 3 5 7
            j = j+2; //2 4 6
        }
        return array;
    }

    public int GetMarkersCount() {
        return mMarkerList.size();
    }

    public double[] GetMarkerPosition(int _index) {
        double r[] = new double[2];
        Marker m = mMarkerList.get(_index);
        r[0] = m.getPosition().getLatitude();
        r[1] = m.getPosition().getLongitude();
        return r;
    }

    public Marker GetMarker(int _index) {
        return  (Marker)mMarkerList.get(_index);
    }

    public void SetMarkerRotation(Marker _marker, int _angleDeg) {
        _marker.setRotation(_angleDeg);
    }

    public double[] GetMarkerPosition(Marker _marker) {
        double r[] = new double[2];
        r[0] = _marker.getPosition().getLatitude();
        r[1] = _marker.getPosition().getLongitude();
        return r;
    }

    public void SetIsMarkerDraggable(boolean _value) {
        IsMarkerDraggable = _value;
    }

    public void SetMarkerDraggable(Marker _marker, boolean _draggable) {
        _marker.setDraggable(_draggable);
    }

    public Polyline DrawPolyline(double[] _latitude, double[] _longitude) {
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
        return line;
    }

    public Polyline DrawPolyline(int _geoPointStartIndex, int _count) {
        List<GeoPoint> geoPoints = new ArrayList<>();
        Polyline line = new Polyline();   //see note below!
        //add points
        for (int i = 0; i < _count; i++) {
            geoPoints.add(mBufferGeoPointsList.get(_geoPointStartIndex+ i));
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
        return line;
    }

    public void ClearPolyline(Polyline _polyline) {
        this.getOverlays().remove(_polyline);
        this.invalidate();
    }

    public Polyline DrawLine(double _latitude1, double _longitude1, double _latitude2, double _longitude2, int _strokeColor, int _strokeWidth) {
        List<GeoPoint> geoPoints = new ArrayList<>();
        Polyline line = new Polyline();   //see note below!
        //add points
        geoPoints.add(new GeoPoint(_latitude1, _longitude1));
        geoPoints.add(new GeoPoint(_latitude2, _longitude2));
        line.setPoints(geoPoints);

        //line.setStrokeColor(_strokeColor);  //Color.RED
        //line.setStrokeWidth(_strokeWidth); //2
        line.setColor(_strokeColor);//0xAA0000FF
        line.setWidth(_strokeWidth); //2.0f
        //line.setStyle(1);
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
        return line;
    }

    public int AddLine(double _latitude1, double _longitude1, double _latitude2, double _longitude2) {
        List<GeoPoint> geoPoints = new ArrayList<>();
        Polyline line = new Polyline();   //see note below!
        //add points
        geoPoints.add(new GeoPoint(_latitude1, _longitude1));
        geoPoints.add(new GeoPoint(_latitude2, _longitude2));
        line.setPoints(geoPoints);
        line.setColor(mStrokeColor);//0xAA0000FF
        line.setWidth(mStrokeWidth); //2.0f
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
        mLineList.add(line);
        return mLineList.size();
    }

    public int AddLine(double _latitude1, double _longitude1, double _latitude2, double _longitude2, int _strokeColor, int _strokeWidth) {
        List<GeoPoint> geoPoints = new ArrayList<>();

        Polyline line = new Polyline();   //see note below!

        /*
        Paint paint = line.getPaint();
        float[] intervals = new float[]{50.0f, 20.0f};
        float phase = 0;
        DashPathEffect dashPathEffect = new DashPathEffect(intervals, phase);
        paint.setPathEffect(dashPathEffect);
        */

        //add points
        geoPoints.add(new GeoPoint(_latitude1, _longitude1));
        geoPoints.add(new GeoPoint(_latitude2, _longitude2));
        line.setPoints(geoPoints);
        // line.setStrokeColor(mStrokeColor);  //Color.RED
        //line.setStrokeWidth(mStrokeWidth); //2
        line.setColor(_strokeColor);//0xAA0000FF
        line.setWidth(_strokeWidth); //2.0f
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
        mLineList.add(line);
        return mLineList.size();
    }

    public void ClearLine(Polyline _line) {
        this.getOverlays().remove(_line);
        this.invalidate();
    }

    public void ClearLine(int _index) {
        Polyline p = mLineList.get(_index);
        this.getOverlayManager().remove(p);
        this.invalidate();
        mLineList.remove(_index);
    }

    public void ClearLines() {
        int count = mLineList.size();
        for (int i = 0; i < count; i++) {
            this.getOverlayManager().remove(mLineList.get(i));
        }
        mLineList.clear();
        this.invalidate();
    }

    public int GetLinesCount() {
        return mLineList.size();
    }

    //https://github.com/osmdroid/osmdroid/wiki/Markers,-Lines-and-Polygons
    public int AddPolygon(double[] _latitude, double[] _longitude, String _title, int _color, int _alphaTransparency) {
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
        mPolygonList.add(polygon);
        return mPolygonList.size();
    }

    public int AddPolygon(double[] _latitudeLongitude, String _title, int _color, int _alphaTransparency) {
        List<GeoPoint> geoPoints = new ArrayList<>();
        int count = _latitudeLongitude.length;
        //add points
        int i = 0;
        while ( (2*i+1) < count) { //0-> 0,1   1->2,3  2->4,5
            geoPoints.add(new GeoPoint(_latitudeLongitude[2*i], _latitudeLongitude[2*i+1]));
            i = i +1;
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
        mPolygonList.add(polygon);
        return mPolygonList.size();
    }

    public int AddPolygon(int _geoPointStartIndex, int _count, String _title, int _color, int _alphaTransparency) {
        if (mBufferGeoPointsList.size() < 3) return -1;
        ArrayList<GeoPoint> pointsList = new ArrayList<GeoPoint>();

        int size = mBufferGeoPointsList.size();

        int startIndex = _geoPointStartIndex;
        if (startIndex < 0) startIndex = 0;

        int cnt = _count;
        if (cnt < 3) cnt = 3;

        for (int i = 0; i < cnt; i++) {
            if ((startIndex + i) < size)
                pointsList.add(mBufferGeoPointsList.get(startIndex + i));
        }

        if (pointsList.size() < 3) return -1;

        Polygon polygon = new Polygon();
        polygon.setFillColor(Color.argb(_alphaTransparency, 255,0,0)); //5     0=total transparency
        polygon.setStrokeColor(_color);
        polygon.setStrokeWidth(3);
        polygon.setPoints(pointsList);
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
        mPolygonList.add(polygon);
        return mPolygonList.size();
    }

    public void ClearPolygon(int _index) {
        Polygon p = mPolygonList.get(_index);
        this.getOverlayManager().remove(p);
        this.invalidate();
        mPolygonList.remove(_index);
    }

    public void ClearPolygons() {
        int count = mPolygonList.size();
        for (int i = 0; i < count; i++) {
            this.getOverlayManager().remove(mPolygonList.get(i));
        }
        mPolygonList.clear();
        this.invalidate();
    }

    public int GetPolygonsCount() {
        return mPolygonList.size();
    }

    public double[] GetGeoPoints() {
        int count = mBufferGeoPointsList.size();
        double[] array = new double[2*count];
        int j = 0;
        for (int i=0; i < count; i++) {
            GeoPoint gp = mBufferGeoPointsList.get(i);
            array[j] = gp.getLatitude(); // 0 2 4 6
            array[j+1] = gp.getLongitude(); //1 3 5 7
            j = j+2; //2 4 6
        }
        return array;
    }

    public int AddGeoPoint(double _latitude, double _longitude) {
        mBufferGeoPointsList.add(new GeoPoint(_latitude, _longitude));
        return mBufferGeoPointsList.size();
    }

    public int AddGeoPoint(int _index, double _latitude, double _longitude) {
        mBufferGeoPointsList.add(_index, new GeoPoint(_latitude, _longitude));
        return mBufferGeoPointsList.size();
    }

    public void ClearGeoPoints() {
        mBufferGeoPointsList.clear();
    }

    public void ClearGeoPoint(int _index) {
        mBufferGeoPointsList.remove(_index);
    }

    public double[] GetGeoPoint(int _index) {
        GeoPoint g = (GeoPoint)mBufferGeoPointsList.get(_index);
        double[] r = new double[2];
        r[0] = g.getLatitude();
        r[1] = g.getLongitude();
        return r;
    }

    public int GetGeoPointsCount() {
        return mBufferGeoPointsList.size();
    }

    public void StopPanning() {
        mapController.stopPanning();
    }

    public void SetStrokeColor(int _strokeColor) {
        mStrokeColor = _strokeColor;
    }

    public void SetStrokeWidth(float _strokeWidth) {
        mStrokeWidth = _strokeWidth;
    }

    public void SetFillColor(int _fillColor) {
        mFillColor = _fillColor;
    }

    //https://stackoverflow.com/questions/13721008/how-to-draw-dashed-polyline-with-android-google-map-sdk-v2
    private double deg2rad(double deg) {
        return (deg * Math.PI / 180.0);
    }

    private double rad2deg(double rad) {
        return (rad * 180.0 / Math.PI);
    }

    public double GetDistance(double lat1, double lon1, double lat2,
                                  double lon2, char unit) {
        double theta = lon1 - lon2;
        double dist = Math.sin(deg2rad(lat1)) * Math.sin(deg2rad(lat2))
                + Math.cos(deg2rad(lat1)) * Math.cos(deg2rad(lat2))
                * Math.cos(deg2rad(theta));
        dist = Math.acos(dist);
        dist = rad2deg(dist);
        dist = dist * 60 * 1.1515;
        if (unit == 'K') {
            dist = dist * 1.609344;
        } else if (unit == 'N') {
            dist = dist * 0.8684;
        }
        return (dist);
    }

    public void SetMarkerXY(float _x, float _y){
        mX = _x;
        mY = _y;

        if (mY < 0) mY = 0;
        if (mX < 0) mX = 0;

        if (mY > 1) mY = 1;
        if (mX > 1) mX = 1;
    }

}
