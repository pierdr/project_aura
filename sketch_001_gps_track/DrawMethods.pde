
void drawBackground() {
  stroke(0);
  strokeWeight(1);
  println("background:"+backgroundPoints.size());
  for (int i=0;i<backgroundPoints.size();i++)
  {
    PVector tmpM=backgroundPoints.get(i);
    PVector tmpP=map.getScreenLocation(tmpM);

    point(tmpP.x, tmpP.y);
    if (i<backgroundPoints.size()-1)
    {
      // line(tmpP.x, tmpP.y, backgroundPoints.get(i+1).x, backgroundPoints.get(i+1).y);
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
    +GLOBAL_NAME+"\nAbsolute_number:"+ABSOLUTE_NUMBER, 100, 100);
}

void UIDraw()
{
  
}
