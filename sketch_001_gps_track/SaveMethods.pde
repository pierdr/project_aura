
/*******************************************
 SAVE LOCATION DATA
 ********************************************/
/*
@param boolean whole: if true: save all the data in memory if true, overwriting all the old file, else just save the current location
 @param boolean user: if true: set flag user to true, else auto is set.
 */
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
    saveStrings(SDCARD + File.separator + "gps_track_"+ABSOLUTE_ID+".txt", s);
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


    saveStringToFile(SDCARD + File.separator + "gps_track_"+ABSOLUTE_ID+".txt", s1);
    
    if(user)
    {
      keyPoints.add(me);
    }
    /***********
     save data for background
     *****************/
    userBackgroundPoints.add(me);
    pointsInSession.add(me);
    String sG=me.x+","+me.y;
    saveStringToFile(SDCARD + File.separator + "global_point_"+GLOBAL_NAME+".txt", sG);


    String url= "http://www.pierdr.com/ciid/06_GD/AURA.php";
    url+="?user="+GLOBAL_NAME;
    url+="&save_point=";

    String tmpAsd = "\n"+s1;

    try
    {
      tmpAsd=URLEncoder.encode(tmpAsd, "utf-8");
    }
    catch(Exception e)
    {
      println("SAVE_LOCATION_GLOBAL_URL_ENCODER:"+e);
    }
    url+=bufferWebGlobal+tmpAsd;
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
    url+="&session="+ABSOLUTE_ID;
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

  saveStringToFile(SDCARD + File.separator +ABSOLUTE_ID +"_log.txt", s);
}
void logMessage(String[] s)
{
  String dateTmp=year()+"-"+month()+"-"+day()+" "+hour()+":"+minute()+":"+second();
  String s1=s.toString();
  s1=dateTmp+" :: "+s1;
  String SDCARD = Environment.getExternalStorageDirectory().getAbsolutePath();
  saveStringToFile(SDCARD + File.separator +ABSOLUTE_ID +"_log.txt", s1);
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
    //println("success");
    //println(c);
    final String URLTmp=URL;
    new Thread(new Runnable() {
      public void run() {
        try{
        String []c=loadStrings(URLTmp);
          logMessage("success:\n"+c.toString());
        }
        catch(Exception e)
        {
          logMessage("not reacheable:\n"+e);
        }
      }
    }
    ).start();
    return true;
  }
  catch(Exception e)
  {
    println("MAKE_HTTP_GET:"+e+" \n "+URL);
    text(e.toString(), 10, displayHeight-30);
    logMessage(e.toString()+" \n "+URL);
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

