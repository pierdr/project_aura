
void drawBackground() {
  stroke(0);
  strokeWeight(1);
  println("background:"+backgroundPoints.size());
  for (int i=0;i<backgroundPoints.size();i++)
  {
    PVector tmpM=backgroundPoints.get(i);
    PVector tmpP=map.getScreenLocation(tmpM);
    println(tmpP);
    point(tmpP.x, tmpP.y);
    if (i<backgroundPoints.size()-1)
    {
     // line(tmpP.x, tmpP.y, backgroundPoints.get(i+1).x, backgroundPoints.get(i+1).y);
    }
  }
}

