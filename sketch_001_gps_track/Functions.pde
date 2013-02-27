double earth_radius = 6371; //km
import java.io.FileWriter;
import java.io.BufferedWriter;
import java.util.Date;

public int GLOBAL_COUNTER=0;
public int ABSOLUTE_NUMBER=-1;
public String GLOBAL_NAME="";


// based on haversine formula - http://en.wikipedia.org/wiki/Haversine_formula
float distance(PVector lat_lon_0, PVector lat_lon_1) {

  float lat0 = to_radians(lat_lon_0.x);
  float lon0 = to_radians(lat_lon_0.y);
  float lat1 = to_radians(lat_lon_1.x);
  float lon1 = to_radians(lat_lon_1.y);

  float dlat = lat1 - lat0;
  float dlon = lon1 - lon0;

  double h = sin(dlat / 2) * sin(dlat / 2) + cos(lon0) * cos(lon1) * sin(dlon / 2) * sin(dlon / 2);
  double a = 2 * Math.atan2(Math.sqrt(h), Math.sqrt(1 - h));
  double d = h * earth_radius * 1000.0;

  return  (float)d;
}

float angle(PVector a, PVector b) {
  // a . b = |a||b|cos(ø)
  float angle = acos(a.dot(b) / (a.mag() * b.mag()));
  if (b.y > a.y)
    angle = TWO_PI - angle;
  return angle;
}

float ellipsoid_a = 6378137.0;
float ellipsoid_b = 6356752.314;

float distance_world_mercator(PVector lat_lon_0, PVector lat_lon_1) {

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

float to_radians(float deg) {
  return deg * PI / 180;
}
void saveLocationData(boolean whole, boolean user)
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
    saveStringToFile(SDCARD + File.separator + "gps_track_"+ABSOLUTE_NUMBER+".txt", s1);
  }
}
void saveStringOnTheWeb(String URL, String newData)
{
}
void saveStringToFile(String outFileName, String newData)
{
  PrintWriter pw = null;
  try 
  {
    pw = createWriter(outFileName); 
    pw.println(newData);
  } 
  catch (Exception e) 
  {
    // Report problem or handle it
    println("SAVE_STRING_TO_FILE:"+e);
  }
  finally
  {
    if (pw != null)
    {
      pw.flush(); 
      pw.close();
    }
  }
}

void loadConfigFile()
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
        GLOBAL_COUNTER=infos[i].getInt("value");
      }
      else if (field.equals("absolute_number"))
      {
        println("ABS:"+infos[i].getInt("value"));
        if (infos[i].getInt("value")!=-1)
        {
          ABSOLUTE_NUMBER=infos[i].getInt("value");
          println(ABSOLUTE_NUMBER);
        }
      }
    }
  }
  catch(Exception e)
  {
    println("LOAD_CONFIG_FILE"+e);
  }
}

void updateConfigFile()
{
  try {
    XML xml=loadXML("config.xml");
    XML[] infos = xml.getChildren("info");
    for ( int i = 0; i < infos.length; i++)
    {
      String field = infos[i].getString("field");
      if (field.equals("counter"))
      {
        infos[i].setInt("value", GLOBAL_COUNTER);
      }
      else if (field.equals("absolute_number"))
      {
        infos[i].setInt("value", ABSOLUTE_NUMBER);
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

void newSession()
{
  Date d = new Date();
  long timestamp = d.getTime() + (86400000 ); 
  String date = new java.text.SimpleDateFormat("yyyyMMdd").format(timestamp); 
  ABSOLUTE_NUMBER=int(date+""+(int)random(10, 99));
}


public boolean surfaceTouchEvent(MotionEvent event) {

  //call to keep mouseX, mouseY, etc updated
  super.surfaceTouchEvent(event);

  //forward event to class for processing
  return gesture.surfaceTouchEvent(event);
}

