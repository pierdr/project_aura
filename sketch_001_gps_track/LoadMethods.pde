
/*****************
 
 LOAD LOCATION DATA!
 LOAD BACKGROUND AND KEYPOINTS
 
 ******************/


boolean loadLocationData()
{
  
  try {
    if (loadBackground() && loadKeyPointsInCurrentSession())
    {
      return true;
    }
  }
  catch(Exception e)
  {
    println("LOAD_LOCATION_DATA:"+e);
  }


  return false;
}

boolean loadBackground() 
{
  String []s=new String[0];
  //load database from web if not try from local storage
  try {
    String url= "http://www.pierdr.com/ciid/06_GD/AURA.php";
    url+="?get_user="+GLOBAL_NAME;
    
    s=loadStrings(url);
  }
  catch(Exception e) {
    println("LOAD_BACKGROUND_FROM_WEB"+e);
  }
  finally {
    if (s.length==0)
    {
      try {
        
        String SDCARD = Environment.getExternalStorageDirectory().getAbsolutePath();  
        File file = new File(SDCARD + File.separator + "global_point_"+GLOBAL_NAME+".txt"); 
        s = loadStrings(file.getPath());
      }
      catch(Exception e)
      {
        println("LOAD_BACKGROUND_FROM_FILE:"+e);
        return false;
      }
    }
    for (int i = 0; i < s.length; i++) {
      String []tmp=split(s[i], ",");
      if(tmp.length>1)
      {
        PVector tmpV=new PVector(float(tmp[0]), float(tmp[1]));
        if(tmpV.x>dataBoundsTopLat)
        {
          dataBoundsTopLat=tmpV.x;
        }
        if(tmpV.x<dataBoundsBottomLat)
        {
          dataBoundsBottomLat=tmpV.x;
        }
        if(tmpV.y>dataBoundsRightLon)
        {
          dataBoundsRightLon=tmpV.y;
        }
        if(tmpV.y<dataBoundsLeftLon)
        {
          dataBoundsLeftLon=tmpV.x;
        }
        backgroundPoints.add(tmpV);
      }
    }
    println("("+dataBoundsTopLat+","+dataBoundsRightLon+","+dataBoundsBottomLat+","+dataBoundsLeftLon+")");
    return true;
  }
}

boolean loadKeyPointsInCurrentSession()
{
  String []s=new String[0];
  //load database from web if not try from local storage
  try {
    String url= "http://www.pierdr.com/ciid/06_GD/AURA.php";
    url+="?get_user="+GLOBAL_NAME;
    url+="&session="+ABSOLUTE_NUMBER;
    s=loadStrings(url);
  }
  catch(Exception e) {
    println("LOAD_SESSION_FROM_WEB"+e);
  }
  finally {
    if (s.length==0)
    {
      try {
        String SDCARD = Environment.getExternalStorageDirectory().getAbsolutePath();  
        File file = new File(SDCARD + File.separator +ABSOLUTE_NUMBER +"_log.txt"); 
        s = loadStrings(file.getPath());
      }
      catch(Exception e)
      {
        println("LOAD_SESSION_FROM_FILE:"+e);
        return false;
      }
      try {
        for (int i = 0; i < s.length; i++) {
          String []tmp=split(s[i], ",");
          if (tmp.length==4)
          {
            if (tmp[3]!=null)
            {
              if (tmp[3].equals("user"))
              {
                PVector tmpV=new PVector(float(tmp[0]), float(tmp[1]));
                keyPoints.add(tmpV);
              }
              else if (tmp[3].equals("auto"))
              {
                PVector tmpV=new PVector(float(tmp[0]), float(tmp[1]));
                pointsInSession.add(tmpV);
              }
            }
          }
        }
      }
      catch(Exception e)
      {
        println(e);
      }

      return true;
    }

    return false;
  }
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

