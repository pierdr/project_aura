
void drawBackground() {
  stroke(0);
  strokeWeight(1);
  for (int i=0;i<userBackgroundPoints.size();i++)
  {
    PVector tmpM=userBackgroundPoints.get(i);
    PVector tmpP=map.getScreenLocation(tmpM);
    
    point(tmpP.x, tmpP.y);
    if (i<userBackgroundPoints.size()-1)
    {
      strokeWeight(0.5);
      PVector tmpPP=userBackgroundPoints.get(i+1);
      tmpPP=map.getScreenLocation(tmpPP);
      line(tmpP.x, tmpP.y, tmpPP.x,tmpPP.y);
    }
  }
}

void debugDraw()
{
  fill(0);
  textSize(30);
  text("Distance:"+dist +"\n"+
    "Velocity:"+ vel+
    "\nTotal Distance:"+dist_total+"\n Size:"+places.size()+"\nGlobal_counter:"+VERSION_COUNTER+"\nName: "
    +GLOBAL_NAME+"\nAbsolute_number:"+ABSOLUTE_ID+"\nNumber_sessions:"+NUMBER_OF_SESSIONS, 100, 100);
}

void UIDraw()
{
  buttonNewSession.paint();
  buttonTakePhoto.paint();
  buttonPin.paint();
  buttonRedraw.paint();
}



