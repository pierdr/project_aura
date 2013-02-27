
/**
SESSION DATA
**/
public int     VERSION_COUNTER         =  0;
public int     NUMBER_OF_SESSIONS      =  0;
public int     ABSOLUTE_NUMBER         =  -1;
public String  GLOBAL_NAME             =  "";
public String  bufferWeb               =  "";
public String  bufferWebGlobal         =  "";

/***
DATA STRUCTURE VAR
***/
ArrayList<PVector> keyPoints;
ArrayList<PVector> pointsInSession;
ArrayList<PVector> backgroundPoints;



/***
MAP
***/
final static double earth_radius = 6371; //km
MercatorMap map;
PImage map_background;
KetaiLocation location;
PVector me=null;
PVector me_pixel=null;
PVector me_last=null;


ArrayList<PVector> places;
ArrayList<PVector> dataStore;



String[] coords=null;

/*****
  OTHER VAR
*****/
KetaiGesture gesture;

boolean redraw=true;

boolean simulation=false;

float dist         = 0;
float dist_total   = 0;
float vel          = 0;
int tick           = 0;
int tack           = 0;
int index          = 0;

/*****
IMPORT
******/
import java.io.FileWriter;
import java.io.BufferedWriter;
import java.util.Date;
import java.io.PrintWriter;
import java.net.URLEncoder;
import ketai.ui.*;
import android.view.MotionEvent;
import ketai.sensors.*;
import android.os.Environment;
import java.io.File;
import android.net.ConnectivityManager;
import android.content.Context;



/******
MAP BOUNDS
 size(1280,800);
 bounds(12.487,55.6623,12.6322,55.7135);
 leftLon, bottomLat, rightLon, topLat
 ******/
final static int   MAP_WIDTH    = 1280;
final static int   MAP_HEIGHT   = 800;

final static float LEFT_LON     = 12.487;
final static float BOTTOM_LAT   = 55.6623;

final static float RIGHT_LON    = 12.6322;
final static float TOP_LAT      = 55.7135;

float dataBoundsTopLat=0;
float dataBoundsRightLon=0;
float dataBoundsLeftLon=0;
float dataBoundsBottomLat=0;
