
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

    url= "http://www.pierdr.com/ciid/06_GD/AURA.php";
    url+="?get_paths_name="+"true";
    String []pathsName=loadStrings(url);

    for (int i=0;i<pathsName.length;i++)
    {
      if (pathsName[i]!="")
      {
         url= "http://www.pierdr.com/ciid/06_GD/AURA.php";
        url+="?get_path="+pathsName[i];
        String []path=loadStrings(url);
        backgroundPaths.add(new Path(path.length));
        for (int j = 0; j < path.length; j++) {
          String []tmp=split(path[j], ",");
          if (tmp.length>1)
          {
            Coord tmpC=new Coord(float(tmp[0]), float(tmp[1]));
            backgroundPaths.get(i).setElem(j, tmpC);
          }
        }
      }
    }
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
      if (tmp.length>1)
      {
        Coord tmpC=new Coord(float(tmp[0]), float(tmp[1]));

        if (dataBoundsBottomLat==0 && dataBoundsLeftLon==0)
        {
          dataBoundsBottomLat=tmpC.lat;
          dataBoundsLeftLon=tmpC.lon;
        }

        if (tmpC.lat>dataBoundsTopLat)
        {
          dataBoundsTopLat=tmpC.lat;
        }
        if (tmpC.lat<dataBoundsBottomLat)
        {
          dataBoundsBottomLat=tmpC.lat;
        }
        if (tmpC.lon>dataBoundsRightLon)
        {
          dataBoundsRightLon=tmpC.lon;
        }
        if (tmpC.lon<dataBoundsLeftLon)
        {
          dataBoundsLeftLon=tmpC.lon;
        }
        userBackgroundPoints.add(new PVector(tmpC.lat, tmpC.lon));
      }
    }
    println("("+dataBoundsTopLat+","+dataBoundsRightLon+","+dataBoundsBottomLat+","+dataBoundsLeftLon+")");
    map =new MercatorMap(MAP_WIDTH, MAP_HEIGHT, dataBoundsTopLat, dataBoundsBottomLat, dataBoundsLeftLon, dataBoundsRightLon );
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
    url+="&session="+ABSOLUTE_ID;
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
        File file = new File(SDCARD + File.separator +ABSOLUTE_ID+"_log.txt"); 
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

