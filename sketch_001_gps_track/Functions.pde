double earth_radius = 6371; //km
import java.io.FileWriter;
import java.io.BufferedWriter;
import java.util.Date;
import java.io.PrintWriter;


public int VERSION_COUNTER =  0;
public int NUMBER_OF_SESSIONS  =  0;
public int ABSOLUTE_NUMBER =  -1;
public String GLOBAL_NAME  =  "";
public String bufferWeb    =  "";



/*******************************************
 SAVE LOCATION DATA
 ********************************************/
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
    VERSION_COUNTER++;

    saveStringToFile(SDCARD + File.separator + "gps_track_"+ABSOLUTE_NUMBER+".txt", s1);
    String url= "http://www.pierdr.com/ciid/06_GD/AURA.php";
    url+="?save_user="+GLOBAL_NAME;
    url+="&session="+ABSOLUTE_NUMBER;
    url+="&version="+VERSION_COUNTER;
    url+="&data="+bufferWeb+"\n"+s1;
    if(makeHTTPGET(url))
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
          if(NUMBER_OF_SESSIONS<100)
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
void newSession()
{
  Date d = new Date();
  long timestamp = d.getTime() + (86400000 ); 
  String date = new java.text.SimpleDateFormat("yyyyMMdd").format(timestamp); 
  NUMBER_OF_SESSIONS+=1;
  ABSOLUTE_NUMBER=int(date+""+NUMBER_OF_SESSIONS);
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
boolean saveStringOnTheWeb(String URL, String newData)
{
  return false;
}
boolean makeHTTPGET(String URL)
{
  try {
    String []c=loadStrings(URL);
    println("success");
    println(c);
    return true;
  }
  catch(Exception e)
  {

    println("MAKE_HTTP_GET:"+e);
    return false;
  }
}
boolean saveStringToFile(String outFileName, String newData)
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

