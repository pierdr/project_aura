import ketai.sensors.*;
import android.os.Environment;
import java.io.File;

import ketai.ui.*;
import android.view.MotionEvent;
KetaiGesture gesture;




/*
 size(1280,800);
 bounds(12.487,55.6623,12.6322,55.7135);
 leftLon, bottomLat, rightLon, topLat
 */

final static int   MAP_WIDTH    = 1280;
final static int   MAP_HEIGHT   = 800;

final static float LEFT_LON     = 12.487;
final static float BOTTOM_LAT   = 55.6623;

final static float RIGHT_LON    = 12.6322;
final static float TOP_LAT      = 55.7135;


MercatorMap map;
PImage map_background;
KetaiLocation location;
PVector me=null;
PVector me_pixel=null;
PVector me_last=null;
ArrayList<PVector> places;
ArrayList<PVector> dataStore;
String[] coords=null;

boolean simulation=false;

float dist         = 0;
float dist_total   = 0;
float vel          = 0;
int tick           = 0;
int tack           = 0;
int index          = 0;

void setup()
{
  orientation(LANDSCAPE);
  size(displayWidth, displayHeight);
  frameRate(1);
  
  loadConfigFile();
  GLOBAL_COUNTER++;
  //set absolute number
  if (ABSOLUTE_NUMBER==-1)
  {
    Date d = new Date();
    long timestamp = d.getTime() + (86400000 ); 
    String date = new java.text.SimpleDateFormat("yyyyMMdd").format(timestamp); 
    ABSOLUTE_NUMBER=0;
    ABSOLUTE_NUMBER=int(date+""+(int)random(10,99));
  }
  try {
    //float mapScreenWidth, float mapScreenHeight, float topLatitude, float bottomLatitude, float leftLongitude, float rightLongitude) {
    map =new MercatorMap(MAP_WIDTH, MAP_HEIGHT, TOP_LAT, BOTTOM_LAT, LEFT_LON, RIGHT_LON );
    map_background=loadImage("project_aura.png");
    me_pixel=new PVector(0, 0);
    me=new PVector(0, 0); 
    gesture = new KetaiGesture(this);

    if (simulation)
    {
      loadPointsFromFile();
    }
    else
    {
      location=new KetaiLocation(this);
    }
  }
  catch(Exception e)
  {
    println("SETUP:" +e);
  }
  updateConfigFile();
}

void loadPointsFromFile()
{
  try {
    String SDCARD = Environment.getExternalStorageDirectory().getAbsolutePath();  
    File file = new File(SDCARD + File.separator + "gps_log.txt"); 
    coords = loadStrings(file.getPath());
    tack=millis();
  }
  catch(Exception e)
  {
  }
}
void simulator() {
  if (millis()-tack>1000 && index< coords.length && simulation)
  {
    String[] latlon=split(coords[index], "|");
    float lat=float(latlon[0]);
    float lon=float(latlon[1]);
    index++;
    onLocationEvent((double)parseFloat(latlon[0]), (double)parseFloat(latlon[1]), 0);
    tack=millis();
  }
}
void draw()
{
  image(map_background, 0, 0, MAP_WIDTH, MAP_HEIGHT);
  stroke(0, 255, 230, 100);
  fill(0, 255, 200, 100);
  // draw something 
  //ellipse(me_pixel.x, me_pixel.y, 8, 8);
  //simulator();
  try {
    for (int i=0;i<places.size();i++)
    {
      PVector tmpP=places.get(i);
      int sz=(int)(map(i, 0, places.size(), 0, 8));
      ellipse(tmpP.x, tmpP.y, sz, sz);
      if (i<places.size()-1)
      {
        line(tmpP.x, tmpP.y, places.get(i+1).x, places.get(i+1).y);
      }
    } 
    fill(0);
    textSize(30);
    text("Distance:"+dist +"\n"+
      "Velocity:"+ vel+
      "\nTotal Distance:"+dist_total+"\n Size:"+places.size()+"\nGlobal_counter:"+GLOBAL_COUNTER+"\nName: "
      +GLOBAL_NAME+"\nAbsolute_number:"+ABSOLUTE_NUMBER, 100, 100);
  }
  catch(Exception e)
  {
    println("DRAW:"+e);
  }
}

void onLocationEvent(double _latitude, double _longitude, double _altitude)
{
  println(_latitude+" "+_longitude+" "+me+" "+me_pixel);
  try {
    me.x=(float)_latitude;
    me.y=(float)_longitude;


    me_pixel = map.getScreenLocation(me);
    if (places==null)
    {
      places=new ArrayList<PVector>();
      dataStore=new ArrayList<PVector>();
    }

    dataStore.add(me.get());
    places.add(me_pixel);

    if (me_last!=null)
    {
      dist        = distance_world_mercator(me_last, me);
      dist_total  +=dist;

      float dt=(float)(millis()-tick);
      vel=dist/dt;
    }

    me_last=new PVector(me.x, me.y);
    saveLocationData(false,false);   
  }
  catch(Exception e)
  {
    println("ON_LOCATION:"+e);
  }
}
void exit()
{
  if (!simulation)
  {
   
   saveLocationData(false,false);   
   updateConfigFile();
 
  }
  super.exit();
}

void onDoubleTap(float x, float y) {
  if (simulation)
  {
    places=new ArrayList<PVector>();
    dataStore=new ArrayList<PVector>();
    index=0;
  }
}


