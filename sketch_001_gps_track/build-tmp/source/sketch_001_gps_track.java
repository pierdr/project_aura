import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import ketai.sensors.*; 
import android.os.Environment; 
import java.io.File; 
import ketai.ui.*; 
import android.view.MotionEvent; 
import java.io.FileWriter; 
import java.io.BufferedWriter; 
import java.util.Date; 
import java.io.PrintWriter; 
import java.net.URLEncoder; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class sketch_001_gps_track extends PApplet {







KetaiGesture gesture;

boolean redraw=true;

/*
 size(1280,800);
 bounds(12.487,55.6623,12.6322,55.7135);
 leftLon, bottomLat, rightLon, topLat
 */

final static int   MAP_WIDTH    = 1280;
final static int   MAP_HEIGHT   = 800;

final static float LEFT_LON     = 12.487f;
final static float BOTTOM_LAT   = 55.6623f;

final static float RIGHT_LON    = 12.6322f;
final static float TOP_LAT      = 55.7135f;


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

public void setup()
{
  orientation(LANDSCAPE);
  size(displayWidth, displayHeight);
  frameRate(1);

  loadConfigFile();

  //set number of sessions
  if (NUMBER_OF_SESSIONS<100)
  {
    NUMBER_OF_SESSIONS=100;
  }

  //set absolute number
  if (ABSOLUTE_NUMBER==-1)
  {
    Date d = new Date();
    long timestamp = d.getTime() + (86400000 ); 
    String date = new java.text.SimpleDateFormat("yyyyMMdd").format(timestamp); 
    ABSOLUTE_NUMBER=0;
    ABSOLUTE_NUMBER=PApplet.parseInt(date+""+NUMBER_OF_SESSIONS);
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

public void loadPointsFromFile()
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
public void simulator() {
  if (millis()-tack>1000 && index< coords.length && simulation)
  {
    String[] latlon=split(coords[index], "|");
    float lat=PApplet.parseFloat(latlon[0]);
    float lon=PApplet.parseFloat(latlon[1]);
    index++;
    onLocationEvent((double)parseFloat(latlon[0]), (double)parseFloat(latlon[1]), 0);
    tack=millis();
  }
}
public void draw()
{
  if (redraw)
  {
    image(map_background, 0, 0, MAP_WIDTH, MAP_HEIGHT);
    stroke(0, 255, 230, 100);
    fill(0, 255, 200, 100);
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
        "\nTotal Distance:"+dist_total+"\n Size:"+places.size()+"\nGlobal_counter:"+VERSION_COUNTER+"\nName: "
        +GLOBAL_NAME+"\nAbsolute_number:"+ABSOLUTE_NUMBER, 100, 100);
    }
    catch(Exception e)
    {
      println("DRAW:"+e);
    }
    redraw=false;
  }
}

public void onLocationEvent(double _latitude, double _longitude, double _altitude)
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
    saveLocationData(false, false);
  }
  catch(Exception e)
  {
    println("ON_LOCATION:"+e);
  }
  
  redraw=true;
}
public void exit()
{
  if (!simulation)
  {

    saveLocationData(false, false);   
    updateConfigFile();
  }
  super.exit();
}

public void onDoubleTap(float x, float y) {
  if (simulation)
  {
    places=new ArrayList<PVector>();
    dataStore=new ArrayList<PVector>();
    index=0;
  }
}

double earth_radius = 6371; //km






public int VERSION_COUNTER =  0;
public int NUMBER_OF_SESSIONS  =  0;
public int ABSOLUTE_NUMBER =  -1;
public String GLOBAL_NAME  =  "";
public String bufferWeb    =  "";



/*******************************************
 SAVE LOCATION DATA
 ********************************************/
public void saveLocationData(boolean whole, boolean user)
{
  String[] s;
  String SDCARD = Environment.getExternalStorageDirectory().getAbsolutePath();
  if (whole)
  {
    s = new String[dataStore.size()];
    int i = 0;
    while ( i < dataStore.size () ) {
      s[i] = dataStore.get(i).x+","+dataStore.get(i).y;
      i++;
    }
    saveStrings(SDCARD + File.separator + "gps_track_"+ABSOLUTE_NUMBER+".txt", s);
    return;
  }
  else
  { 
    String s1;
    String dateTmp=year()+"-"+month()+"-"+day()+" "+hour()+":"+minute()+":"+second();
    if (user)
    {
      s1=me.x+","+me.y+","+dateTmp+",user";
    }
    else
    {
      s1=me.x+","+me.y+","+dateTmp+",auto";
    }
    VERSION_COUNTER++;

    
    saveStringToFile(SDCARD + File.separator + "gps_track_"+ABSOLUTE_NUMBER+".txt", s1);
    
     //save data for background
     
    // saveStringToFile(SDCARD + File.separator + "global_point_"+GLOBAL_NAME+".txt", sG);
    //end save data for background
    
    String url= "http://www.pierdr.com/ciid/06_GD/AURA.php";
    url+="?save_user="+GLOBAL_NAME;
    url+="&session="+ABSOLUTE_NUMBER;
    url+="&version="+VERSION_COUNTER;
    String tmpAsd = bufferWeb+"\n"+s1;

    try
    {
      bufferWeb=URLEncoder.encode(tmpAsd, "utf-8");
    }
    catch(Exception e)
    {
      println("SAVE_LOCATION"+e);
    }
    url+="&data="+bufferWeb;
    if (makeHTTPGET(url))
    {
      bufferWeb="";
    }
    else
    {
      bufferWeb+="\n"+s1;
    }
  }
}
//end save location data

/*******************************************
 CONFIG FILE
 ********************************************/
public void loadConfigFile()
{
  //read name from read only config file in the internal storage
  XML xml=loadXML( "config.xml");
  XML[] infos = xml.getChildren("info");
  println(xml.toString());
  for ( int i = 0; i < infos.length; i++)
  {
    String field = infos[i].getString("field");
    println(field);
    if (field.equals("name"))
    {
      GLOBAL_NAME=infos[i].getString("value");
    }
    break;
  }
  //read live data from external storage
  try {
    String SDCARD = Environment.getExternalStorageDirectory().getAbsolutePath();
    xml=loadXML(SDCARD + File.separator + GLOBAL_NAME+"_config.xml");
    infos = xml.getChildren("info");
    for ( int i = 0; i < infos.length; i++)
    {
      String field = infos[i].getString("field");
      println(field);
      if (field.equals("counter"))
      {
        VERSION_COUNTER=infos[i].getInt("value");
      }
      else if (field.equals("absolute_number"))
      {
        println("ABS:"+infos[i].getInt("value"));
        if (infos[i].getInt("value")!=-1)
        {
          ABSOLUTE_NUMBER=infos[i].getInt("value");
          println("session id (alias ABSOLUTE_NUMBER):"+ABSOLUTE_NUMBER);
        }
      }
      else if (field.equals("number_of_sessions"))
      {
        println("NOS:"+infos[i].getInt("value"));
        if (infos[i].getInt("value")!=-1)
        {

          NUMBER_OF_SESSIONS=infos[i].getInt("value");
          if (NUMBER_OF_SESSIONS<100)
          {
            NUMBER_OF_SESSIONS=100;
          }
          println(NUMBER_OF_SESSIONS);
        }
      }
    }
  }
  catch(Exception e)
  {
    println("LOAD_CONFIG_FILE"+e);
  }
}

public void updateConfigFile()
{
  try {
    XML xml=loadXML("config.xml");
    XML[] infos = xml.getChildren("info");
    for ( int i = 0; i < infos.length; i++)
    {
      String field = infos[i].getString("field");
      if (field.equals("counter"))
      {
        infos[i].setInt("value", VERSION_COUNTER);
      }
      else if (field.equals("absolute_number"))
      {
        infos[i].setInt("value", ABSOLUTE_NUMBER);
      }
      else if (field.equals("number_of_sessions"))
      {

        infos[i].setInt("value", NUMBER_OF_SESSIONS);
      }
    }

    //saveXML(xml,"config.xml");
    String tmpF="<?xml version=\"1.0\"?>\n"+xml.toString();
    String []tmp=split(tmpF, "\n");
    println(tmp);

    String SDCARD = Environment.getExternalStorageDirectory().getAbsolutePath();
    saveStrings(SDCARD + File.separator + GLOBAL_NAME+"_config.xml", tmp);
  }
  catch(Exception e)
  {
    println("UPDATE_CONFIG_FILE:"+e);
  }
}
//end config methods


/*******************************************
 SERVICE METHODS
 ********************************************/
public void logMessage(String s)
{
  String dateTmp=year()+"-"+month()+"-"+day()+" "+hour()+":"+minute()+":"+second();
  s=dateTmp+" :: "+s;
  String SDCARD = Environment.getExternalStorageDirectory().getAbsolutePath();

  saveStringToFile(SDCARD + File.separator +ABSOLUTE_NUMBER +"_log.txt", s);
}
public void logMessage(String[] s)
{
  String dateTmp=year()+"-"+month()+"-"+day()+" "+hour()+":"+minute()+":"+second();
  String s1=s.toString();
  s1=dateTmp+" :: "+s1;
  String SDCARD = Environment.getExternalStorageDirectory().getAbsolutePath();
  saveStringToFile(SDCARD + File.separator +ABSOLUTE_NUMBER +"_log.txt", s1);
}
public boolean checkInternetConnection()
{

  ConnectivityManager conMgr = (ConnectivityManager) getSystemService (Context.CONNECTIVITY_SERVICE);

  // ARE WE CONNECTED TO THE NET

  if (conMgr.getActiveNetworkInfo() != null

    && conMgr.getActiveNetworkInfo().isAvailable()

  && conMgr.getActiveNetworkInfo().isConnected()) 
  {

    return true;
  }
  else 
  {
    return false;
  }
}
public void newSession()
{
  Date d = new Date();
  long timestamp = d.getTime() + (86400000 ); 
  String date = new java.text.SimpleDateFormat("yyyyMMdd").format(timestamp); 
  NUMBER_OF_SESSIONS+=1;
  ABSOLUTE_NUMBER=PApplet.parseInt(date+""+NUMBER_OF_SESSIONS);
}


public boolean surfaceTouchEvent(MotionEvent event) {

  //call to keep mouseX, mouseY, etc updated
  super.surfaceTouchEvent(event);

  //forward event to class for processing
  return gesture.surfaceTouchEvent(event);
}



/*******************************************
 GENERIC SAVE STRING ON FILE AND WEB
 ********************************************/
public boolean saveStringOnTheWeb(String URL, String newData)
{
  return false;
}
public boolean makeHTTPGET(String URL)
{
  try {

    String []c=loadStrings(URL);
    println("success");
    println(c);
    logMessage("success:\n"+c.toString());
    text(c.toString(), 10, displayHeight-30);
    return true;
  }
  catch(Exception e)
  {
    println("MAKE_HTTP_GET:"+e);
    text(e.toString(), 10, displayHeight-30);
    logMessage(e.toString());
    return false;
  }
}
public boolean saveStringToFile(String outFileName, String newData)
{
  // PrintWriter pw = null;
  BufferedWriter writer;
  try 
  {
    //pw = createWriter(outFileName); 
    writer = new BufferedWriter(new FileWriter(outFileName, true));
    //pw.println(newData);
    writer.write(newData+"\r\n");
    writer.close();
    return true;
  } 
  catch (Exception e) 
  {
    // Report problem or handle it
    println("SAVE_STRING_TO_FILE:"+e);
    return false;
  }
  finally
  {
    /*if (writer != null)
     {*/
    /*
      pw.flush(); 
     pw.close();*/

    //}
  }
}

/**
 * Utility class to convert between geo-locations and Cartesian screen coordinates.
 * Can be used with a bounding box defining the map section.
 *
 * (c) 2011 Till Nagel, tillnagel.com
 */
public class MercatorMap {
  
  public static final float DEFAULT_TOP_LATITUDE = 80;
  public static final float DEFAULT_BOTTOM_LATITUDE = -80;
  public static final float DEFAULT_LEFT_LONGITUDE = -180;
  public static final float DEFAULT_RIGHT_LONGITUDE = 180;
  
  /** Horizontal dimension of this map, in pixels. */
  protected float mapScreenWidth;
  /** Vertical dimension of this map, in pixels. */
  protected float mapScreenHeight;

  /** Northern border of this map, in degrees. */
  protected float topLatitude;
  /** Southern border of this map, in degrees. */
  protected float bottomLatitude;
  /** Western border of this map, in degrees. */
  protected float leftLongitude;
  /** Eastern border of this map, in degrees. */
  protected float rightLongitude;

  private float topLatitudeRelative;
  private float bottomLatitudeRelative;
  private float leftLongitudeRadians;
  private float rightLongitudeRadians;

  public MercatorMap(float mapScreenWidth, float mapScreenHeight) {
    this(mapScreenWidth, mapScreenHeight, DEFAULT_TOP_LATITUDE, DEFAULT_BOTTOM_LATITUDE, DEFAULT_LEFT_LONGITUDE, DEFAULT_RIGHT_LONGITUDE);
  }
    
  /**
   * Creates a new MercatorMap with dimensions and bounding box to convert between geo-locations and screen coordinates.
   *
   * @param mapScreenWidth Horizontal dimension of this map, in pixels.
   * @param mapScreenHeight Vertical dimension of this map, in pixels.
   * @param topLatitude Northern border of this map, in degrees.
   * @param bottomLatitude Southern border of this map, in degrees.
   * @param leftLongitude Western border of this map, in degrees.
   * @param rightLongitude Eastern border of this map, in degrees.
   */
  public MercatorMap(float mapScreenWidth, float mapScreenHeight, float topLatitude, float bottomLatitude, float leftLongitude, float rightLongitude) {
    this.mapScreenWidth = mapScreenWidth;
    this.mapScreenHeight = mapScreenHeight;
    this.topLatitude = topLatitude;
    this.bottomLatitude = bottomLatitude;
    this.leftLongitude = leftLongitude;
    this.rightLongitude = rightLongitude;

    this.topLatitudeRelative = getScreenYRelative(topLatitude);
    this.bottomLatitudeRelative = getScreenYRelative(bottomLatitude);
    this.leftLongitudeRadians = getRadians(leftLongitude);
    this.rightLongitudeRadians = getRadians(rightLongitude);
  }

  /**
   * Projects the geo location to Cartesian coordinates, using the Mercator projection.
   *
   * @param geoLocation Geo location with (latitude, longitude) in degrees.
   * @returns The screen coordinates with (x, y).
   */
  public PVector getScreenLocation(PVector geoLocation) {
    float latitudeInDegrees = geoLocation.x;
    float longitudeInDegrees = geoLocation.y;

    return new PVector(getScreenX(longitudeInDegrees), getScreenY(latitudeInDegrees));
  }

  private float getScreenYRelative(float latitudeInDegrees) {
    return log(tan(latitudeInDegrees / 360f * PI + PI / 4));
  }

  protected float getScreenY(float latitudeInDegrees) {
    return mapScreenHeight * (getScreenYRelative(latitudeInDegrees) - topLatitudeRelative) / (bottomLatitudeRelative - topLatitudeRelative);
  }
  
  private float getRadians(float deg) {
    return deg * PI / 180;
  }

  protected float getScreenX(float longitudeInDegrees) {
    float longitudeInRadians = getRadians(longitudeInDegrees);
    return mapScreenWidth * (longitudeInRadians - leftLongitudeRadians) / (rightLongitudeRadians - leftLongitudeRadians);
  }
}
// based on haversine formula - http://en.wikipedia.org/wiki/Haversine_formula
public float distance(PVector lat_lon_0, PVector lat_lon_1) {

  float lat0 = to_radians(lat_lon_0.x);
  float lon0 = to_radians(lat_lon_0.y);
  float lat1 = to_radians(lat_lon_1.x);
  float lon1 = to_radians(lat_lon_1.y);

  float dlat = lat1 - lat0;
  float dlon = lon1 - lon0;

  double h = sin(dlat / 2) * sin(dlat / 2) + cos(lon0) * cos(lon1) * sin(dlon / 2) * sin(dlon / 2);
  double a = 2 * Math.atan2(Math.sqrt(h), Math.sqrt(1 - h));
  double d = h * earth_radius * 1000.0f;

  return  (float)d;
}

public float angle(PVector a, PVector b) {
  // a . b = |a||b|cos(\u00f8)
  float angle = acos(a.dot(b) / (a.mag() * b.mag()));
  if (b.y > a.y)
    angle = TWO_PI - angle;
  return angle;
}

float ellipsoid_a = 6378137.0f;
float ellipsoid_b = 6356752.314f;

public float distance_world_mercator(PVector lat_lon_0, PVector lat_lon_1) {

  float lat0 = to_radians(lat_lon_0.x);
  float lon0 = to_radians(lat_lon_0.y);
  float lat1 = to_radians(lat_lon_1.x);
  float lon1 = to_radians(lat_lon_1.y);

  PVector m0 = new PVector();
  m0.y = ellipsoid_a * lon0;
  m0.x = ellipsoid_a * log((sin(lat0) + 1) / cos(lat0));

  PVector m1 = new PVector();
  m1.y = ellipsoid_a * lon1;
  m1.x = ellipsoid_a * log((sin(lat1) + 1) / cos(lat1));

  return PVector.dist(m1, m0);
}

public float to_radians(float deg) {
  return deg * PI / 180;
}

  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "sketch_001_gps_track" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
