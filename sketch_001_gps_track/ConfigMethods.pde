
/*******************************************
 CONFIG FILE
 ********************************************/
void loadConfigFile()
{
  //read name from read only config file in the internal storage
  XML xml=loadXML( "config.xml");
  XML[] infos = xml.getChildren("info");

  for ( int i = 0; i < infos.length; i++)
  {
    String field = infos[i].getString("field");

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
    println(xml);
    for ( int i = 0; i < infos.length; i++)
    {
      String field = infos[i].getString("field");

      if (field.equals("counter"))
      {
        VERSION_COUNTER=infos[i].getInt("value");
      }
      else if (field.equals("absolute_number"))
      {

        if (infos[i].getInt("value")!=-1)
        {
          ABSOLUTE_ID=infos[i].getString("value");
          //println("session id (alias ABSOLUTE_NUMBER):"+ABSOLUTE_NUMBER);
        }
      }
      else if (field.equals("number_of_sessions"))
      {
        // println("NOS:"+infos[i].getInt("value"));
        if (infos[i].getInt("value")!=-1)
        {

          NUMBER_OF_SESSIONS=infos[i].getInt("value");
          if (NUMBER_OF_SESSIONS<100)
          {
            NUMBER_OF_SESSIONS=100;
          }
          //println(NUMBER_OF_SESSIONS);
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
        infos[i].setString("value", ABSOLUTE_ID);
      }
      else if (field.equals("number_of_sessions"))
      {

        infos[i].setInt("value", NUMBER_OF_SESSIONS);
      }
    }

    //saveXML(xml,"config.xml");
    String tmpF="<?xml version=\"1.0\"?>\n"+xml.toString();
    String []tmp=split(tmpF, "\n");


    String SDCARD = Environment.getExternalStorageDirectory().getAbsolutePath();
    saveStrings(SDCARD + File.separator + GLOBAL_NAME+"_config.xml", tmp);
  }
  catch(Exception e)
  {
    println("UPDATE_CONFIG_FILE:"+e);
  }
}
//end config methods

