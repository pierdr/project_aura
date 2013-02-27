
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
    
     /***********
     save data for background
     *****************/
     
    String sG=me.x+","+me.y;
    saveStringToFile(SDCARD + File.separator + "global_point_"+GLOBAL_NAME+".txt", sG);
    
    
    String url= "http://www.pierdr.com/ciid/06_GD/AURA.php";
    url+="?user="+GLOBAL_NAME;
    url+="&save_point=";
    
    String tmpAsd = bufferWebGlobal+"\n"+s1;

    try
    {
      bufferWebGlobal=URLEncoder.encode(tmpAsd, "utf-8");
    }
    catch(Exception e)
    {
      println("SAVE_LOCATION_GLOBAL_URL_ENCODER:"+e);
    }
    url+=bufferWebGlobal;
    if (makeHTTPGET(url))
    {
      bufferWeb="";
    }
    else
    {
      bufferWebGlobal+="\n"+sG;
    }
    //end save data for background
    
    /************************
    SAVE DATA 
    *************************/
    
    url= "http://www.pierdr.com/ciid/06_GD/AURA.php";
    url+="?save_user="+GLOBAL_NAME;
    url+="&session="+ABSOLUTE_NUMBER;
    url+="&version="+VERSION_COUNTER;
    tmpAsd = bufferWeb+"\n"+s1;

    try
    {
      bufferWeb=URLEncoder.encode(tmpAsd, "utf-8");
    }
    catch(Exception e)
    {
      println("SAVE_LOCATION_SESSION_SAVE_URL_ENCODER:"+e);
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
 SERVICE METHODS
 ********************************************/
void logMessage(String s)
{
  String dateTmp=year()+"-"+month()+"-"+day()+" "+hour()+":"+minute()+":"+second();
  s=dateTmp+" :: "+s;
  String SDCARD = Environment.getExternalStorageDirectory().getAbsolutePath();

  saveStringToFile(SDCARD + File.separator +ABSOLUTE_NUMBER +"_log.txt", s);
}
void logMessage(String[] s)
{
  String dateTmp=year()+"-"+month()+"-"+day()+" "+hour()+":"+minute()+":"+second();
  String s1=s.toString();
  s1=dateTmp+" :: "+s1;
  String SDCARD = Environment.getExternalStorageDirectory().getAbsolutePath();
  saveStringToFile(SDCARD + File.separator +ABSOLUTE_NUMBER +"_log.txt", s1);
}
boolean checkInternetConnection()
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
    //println("success");
    //println(c);
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
    println("SAVE_STRING_TO_FILE:"+e);
    return false;
  }
  finally
  {

  }
}


