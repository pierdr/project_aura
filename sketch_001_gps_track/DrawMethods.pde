
void drawBackground() {
  try {
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
        line(tmpP.x, tmpP.y, tmpPP.x, tmpPP.y);
      }
    }
  }
  catch(Exception e)
  {
    println("DRAW_BACKGROUND:"+e);
  }
}
void drawShape()
{
  try {
    fill(0, 255, 0);
    beginShape();

    for (int i=0;i<keyPoints.size();i++)
    {
      PVector tmpPP=keyPoints.get(i);
      tmpPP=map.getScreenLocation(tmpPP);
      vertex(tmpPP.x, tmpPP.y);
    }  
    endShape(CLOSE);
  }
  catch(Exception e)
  {
    println("DRAW_SHAPE:"+e);
  }
}

void debugDraw()
{
  try{
  fill(0);
  textSize(30);
  text("Distance:"+dist +"\n"+
    "Velocity:"+ vel+
    "\nTotal Distance:"+dist_total+"\n Size:"+places.size()+
    "\nGlobal_counter:"+VERSION_COUNTER+"\nName: "
    +GLOBAL_NAME+"\nAbsolute_number:"+ABSOLUTE_ID+"\nNumber_sessions:"+NUMBER_OF_SESSIONS+"\nbackground:"+userBackgroundPoints.size()+"\nsession:"+pointsInSession.size()+"\npins:"+keyPoints.size(), 100, 100);
  }
  catch(Exception e)
  {
    println("DRAW_DEBUG:"+e);
  }
}

void UIDraw()
{
  theButton.paint();
 /* 
  buttonTakePhoto.paint();
  buttonPin.paint();
  buttonRedraw.paint();*/
  
}





