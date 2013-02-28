import megamu.mesh.*;
import processing.opengl.*;
import javax.vecmath.*;
import org.processing.wiki.triangulate.*;
import processing.video.*;

Triangle2 ttt;
Capture cam;          //cam image
PImage lastFrame;     //last frame image
PImage diffFrame;     //difference and dark image 

int mode = 0;         //lines and gradients?

PVector ps;            //points (from diffFrame)
ArrayList ts;         //Triangle2 (custom written class)


ArrayList triangles;
ArrayList points = new ArrayList();

void setup() 
{
  size(640, 420,P3D);
  cam = new Capture(this, 320, 240);
  lastFrame = new PImage(cam.width,cam.height);
  diffFrame = new PImage(cam.width,cam.height);
  noCursor();
}


void draw() 
{
  if(frameCount%200==0)
  {
    keyPressed();
  }
  
  if(cam.available() == true) 
  {
    background(255);
    cam.read();
    
    //init with corners
  
    points.add(new PVector(0,0,0));
    points.add(new PVector(cam.width-1,0,0));
    points.add(new PVector(0,cam.height-1,0));
    points.add(new PVector(cam.width-1,cam.height-1,0));
    
    
    //find points (ignore very near points (10))
    for(int i=0;i<diffFrame.pixels.length;i++)
    {
      if(diffFrame.pixels[i] == color(255))
      {
        boolean near = false;
        for(int j=0;j<points.size();j++)
        {
          PVector p = (PVector)points.get(j);
          if(dist(p.x,p.y,i%cam.width,i/cam.width)<5)
          {
            near = true;
            break;
          }
        }
        if(!near)
        {

          points.add(new PVector(i%cam.width,i/cam.width,0));
        }
      }
    }

    ts = new ArrayList();
    if(points.size()>0)  
    { 
      triangles = Triangulate.triangulate(points);  //library helps finding the points (love Delaunay!)
      if(triangles!= null)
      {
        for(int i=0;i<triangles.size();i++)
        {
          Triangle t = (Triangle)triangles.get(i);
          PVector p1 = t.p1;
          PVector p2 = t.p2;
          PVector p3 = t.p3;
          
          ts.add(new Triangle2(p1,p2,p3,
          lastFrame.pixels[floor(p1.x)+floor(p1.y)*lastFrame.width],
          lastFrame.pixels[floor(p2.x)+floor(p2.y)*lastFrame.width],
          lastFrame.pixels[floor(p3.x)+floor(p3.y)*lastFrame.width]));
        }
      }
    }

    int pos=0;
    int count = 0;
    for(int i=0;i<lastFrame.pixels.length;i++)
    {
      //looking for moved pixel and dark pixel
      if(dist(red(cam.pixels[pos]),green(cam.pixels[pos]),blue(cam.pixels[pos]),
      red(lastFrame.pixels[pos]),green(lastFrame.pixels[pos]),blue(lastFrame.pixels[pos]))>130 ||
      (brightness(lastFrame.pixels[pos])<5 &&brightness(lastFrame.pixels[pos])>=0))
      {
        count++;
        diffFrame.pixels[pos] = color(255);
        if(count>300)
          break;
      }
      else diffFrame.pixels[pos] = color(0);
      
      //trying to approach a even space point traversal
      pos+=25603;  
      if(pos>lastFrame.pixels.length) pos-=lastFrame.pixels.length;
    }
    diffFrame.updatePixels();

    //copy current cam to lastFrame, does it seems the fastest (and quite easy) way?
    lastFrame.pixels = cam.pixels.clone();
    lastFrame.updatePixels();

    //draw the triangles
    //draw the triangles
    pushMatrix();
    scale(width/320.0,height/240.0);
    for(int i=0;i<ts.size();i++)
    {
      Triangle2 t = (Triangle2)ts.get(i);
      t.draw();
    }
    popMatrix();



  }
}
