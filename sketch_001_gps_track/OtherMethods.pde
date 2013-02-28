void newSession()
{
  Date d = new Date();
  long timestamp = d.getTime() + (86400000 ); 
  String date = new java.text.SimpleDateFormat("yyyyMMdd").format(timestamp); 
  NUMBER_OF_SESSIONS+=1;
  ABSOLUTE_ID=(date+""+NUMBER_OF_SESSIONS);
  updateConfigFile();
  keyPoints.clear();
  pointsInSession.clear();
  //keyPoints=new ArrayList<PVector>();
  //pointsInSession=new ArrayList<PVector>();
}


public boolean surfaceTouchEvent(MotionEvent event) {

  //call to keep mouseX, mouseY, etc updated
  super.surfaceTouchEvent(event);
  int xTmp=round(event.getX());
  int yTmp=round(event.getY());
  listenToMouseDown(xTmp,yTmp);
  //forward event to class for processing
  return gesture.surfaceTouchEvent(event);
}

void listenToMouseDown(int x, int y)
{
  //UIEventListeners
  /*if (buttonNewSession.mouseDown(x,y))
  {
    newSession();
  }*/
  if(buttonTakePhoto.mouseDown(x,y))
  {
    
  }
  if(buttonPin.mouseDown(x,y))
  {
    saveLocationData(false,true);
  }
  if(buttonRedraw.mouseDown(x,y))
  {
    redraw=true;
  }
}
