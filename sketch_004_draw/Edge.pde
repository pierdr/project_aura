import java.awt.Point;

class Edge {

  Point start;
  Point end;

  public Edge (int startX, int startY, int endX, int endY) {
    start = new Point (startX, startY);
    end = new Point (endX, endY);
  }
  public Edge (float startX, float startY, float endX, float endY) {
    start = new Point (int(startX), int(startY));
    end = new Point (int(endX), int(endY));
  }
  public boolean hasOnePointInCommon(Edge tmp)
  {

    if ((tmp.start.x==start.x && tmp.start.y==start.y) || (tmp.end.x==end.x && tmp.end.y==end.y))
    {
      return true;
    }
    return false;
  }
}

class Triangle {
  color pixelColor;
  Edge a;
  Edge b;
  Edge c;
   float area;
  private boolean complete=false;

  public Triangle (Edge mainEdge) {
    a = mainEdge;
  }

  public boolean isComplete() {
    return complete;
  }
  public int setEdges(Edge v2, Edge v3)
  {
    this.b=v2;
    c=v3;
    complete=true;
    area=abs((a.start.x*(b.start.y-c.start.y)+b.start.x*(c.start.y-a.start.y)+c.start.x*(a.start.y-b.start.y))/2);
    return int(area);
  }
  public boolean hasVoid()
  {
    if (a.start.x+a.start.y<20 || a.end.x+a.end.y<20)
    {
      return true;
    }
    if (b.start.x+b.start.y<20 || b.end.x+b.end.y<20)
    {
      return true;
    }

    if (c.start.x+c.start.y<20 || c.end.x+c.end.y<20)
    {
      return true;
    }
    return false;
  }
  void paintColor() {

    beginShape();
    vertex (a.start.x, a.start.y);
    vertex (a.end.x, a.end.y);
    vertex (b.end.x, b.end.y); 
    vertex (c.end.x, c.end.y);
    endShape(CLOSE);
  }
    void paintColor(color c1) {
    //fill(c1,int(map(area,0,maxArea,0,250)));
    //println(area+"::"+maxArea+"::"+map(area,0,maxArea,0,250));
    beginShape();
    vertex (a.start.x, a.start.y);
    vertex (a.end.x, a.end.y);
    vertex (b.end.x, b.end.y); 
    vertex (c.end.x, c.end.y);
    endShape(CLOSE);
  }
  void paintColor(PImage img) {
    textureMode(IMAGE);
    beginShape();
    texture(img);
    vertex (a.start.x, a.start.y);
    vertex (a.end.x, a.end.y);
    vertex (b.end.x, b.end.y); 
    vertex (c.end.x, c.end.y);
    endShape(CLOSE);
  }
}

