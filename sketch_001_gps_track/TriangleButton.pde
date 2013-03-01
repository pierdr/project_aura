class TriangleButton
{
  int state;
  Point a;
  Point b;
  Point c;
  private ArrayList<TriangleButton> triangles;

    public TriangleButton(Point a, Point b, Point c)
  {
    this.a=a;
    this.b=b;
    this.c=c;
  }
  public TriangleButton()
  {

    this.a=new Point(int(displayWidth/2-(displayWidth/10)+random(-10, 10)),int( displayHeight/2-(displayHeight/10)+random(-10, 10)));
    this.b=new Point(int(displayWidth/2+(displayWidth/10)+random(-10, 10)), int(displayHeight/2-(displayHeight/10)+random(-10, 10)));
    this.c=new Point(int(displayWidth/2+random(-10, 10)), int(displayHeight/2-(displayHeight/10)+random(-10, 10)));
  }
  public void paint()
  {
    beginShape();
    vertex (a.x, a.y);
    vertex (b.x, b.y);
    vertex (c.x, c.y);
    endShape(CLOSE);
  }
  public boolean mouseEvent(int mX,int mY)
  {
    if (mousePressed)
    {

      boolean ret=false;
      
      if ((x>this.pos.x && x<(this.pos.x+this.dim.x)) && (y>this.pos.y && y<(this.pos.y+ this.dim.y)) && !this.prs)
      {
        //println(name+": tap("+x+", " +y+")  pos("+pos.x+","+pos.y+") dim("+dim.x+","+dim.y+") sum("+(pos.x+dim.x)+","+(pos.y+dim.y)+")");
        this.c=color(red(this.c)+50, green(this.c)+50, blue(this.c)+50);
        this.prs=true;
        ret=true;
        redraw=true;
      }
      return ret;
    }
    else
    {
      if (this.prs)
      {
        this.c=color(red(this.c)-50, green(this.c)-50, blue(this.c)-50);
        this.prs=false;
        redraw=true;
      }
      return false;
    }
  }
}

