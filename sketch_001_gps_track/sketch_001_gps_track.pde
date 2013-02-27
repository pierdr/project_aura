
void setup()
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
    ABSOLUTE_NUMBER=int(date+""+NUMBER_OF_SESSIONS);
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
  init();
  loadLocationData();
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
  if (redraw)
  {
    
    drawBackground();
    debugDraw();
    UIDraw();
    redraw=true;
  }
}

void onLocationEvent(double _latitude, double _longitude, double _altitude)
{
  
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

void exit()
{
  if (!simulation)
  {

    saveLocationData(false, false);   
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

