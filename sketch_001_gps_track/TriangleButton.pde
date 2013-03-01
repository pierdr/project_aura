class TriangleButton
{
  int state;
  Point a;
  Point b;
  Point c;
  
  private ArrayList<TriangleButton> triangles;
  boolean prs=false;

  public TriangleButton(Point a, Point b, Point c)
  {
    this.a=a;
    this.b=b;
    this.c=c;
  }
  public TriangleButton()
  {
    state=0;
    this.a=new Point(int(displayWidth/2-(displayWidth/10)+random(-10, 10)), int( displayHeight/2-(displayHeight/10)+random(-10, 10)));
    this.b=new Point(int(displayWidth/2+(displayWidth/10)+random(-10, 10)), int(displayHeight/2-(displayHeight/10)+random(-10, 10)));
    this.c=new Point(int(displayWidth/2+random(-10, 10)), int(displayHeight/2-(displayHeight/10)+random(-10, 10)));
  }
  public void paint()
  {
    if(state==0)
    {
      strokeWeight(1);
    }
    else
    {
      strokeWeight(3);
    }
    beginShape();
    vertex (a.x, a.y);
    vertex (b.x, b.y);
    vertex (c.x, c.y);
    endShape(CLOSE);
  }

  float sign(Point p1, Point p2, Point p3)
  {
    return (p1.x - p3.x) * (p2.y - p3.y) - (p2.x - p3.x) * (p1.y - p3.y);
  }

  boolean pointInTriangle(Point pt)
  {
    boolean b1, b2, b3;

    b1 = sign(pt, a, b) < 0.0f;
    b2 = sign(pt, b, c) < 0.0f;
    b3 = sign(pt, c, a) < 0.0f;

    return ((b1 == b2) && (b2 == b3));
  }


  public void mouseEvent(int mX, int mY)
  {
    if (mousePressed)
    {

      

      if (pointInTriangle(new Point(mX,mY)) && !this.prs)
      {
        state=1;
        //println(name+": tap("+x+", " +y+")  pos("+pos.x+","+pos.y+") dim("+dim.x+","+dim.y+") sum("+(pos.x+dim.x)+","+(pos.y+dim.y)+")");
        this.prs=true;
        redraw=true;
      }
    
    }
    else
    {
      if (this.prs)
      {
        state=2;
        this.prs=false;
        redraw=true;
      }
      
    }
  }
}

