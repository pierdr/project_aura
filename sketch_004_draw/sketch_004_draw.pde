import processing.pdf.*;
import megamu.mesh.*;

ArrayList <Triangle> triangles;
ArrayList<pt> points;

int vn =5;                       // number of points (sites)
int cap;                     // max number of points
pt[] P;                          // Array containing the points
int bi=-1;                       // index of selected mouse-vertex, -1 if none selected
pt Mouse = new pt(0, 0);         // current mouse position
boolean redraw;
boolean dots = false;            // toggles display circle centers
boolean numbers = false;         // toggles display of vertex numbers
int index=0;
Delaunay myDelaunay;
Delaunay my_delaunay_prime;
float [][] points_matrix;
float [][] points_matrix_prime;
MPolygon[] myRegions;
color [] fillColors;

void setup()
{
  size (800, 800);
  points=new ArrayList<pt>();
  String [] s=loadStrings("points_cph.csv");
  float boundsTopLat=0, boundsRightLon=0, boundsBottomLat=0, boundsLeftLon=0;
  for (int i=0;i<s.length;i++) {

    String[] sTmp=split(s[i], ",");
    if (sTmp.length>1)
    {

      if (boundsBottomLat==0 && boundsLeftLon==0)
      {
        boundsBottomLat=float(sTmp)[0];
        boundsLeftLon=float(sTmp)[1];
      }

      if (float(sTmp[0])>boundsTopLat)
      {
        boundsTopLat=float(sTmp)[0];
      }
      if (float(sTmp[0])<boundsBottomLat)
      {
        boundsBottomLat=float(sTmp)[0];
      }
      if (float(sTmp[1])>boundsRightLon)
      {
        boundsRightLon=float(sTmp)[1];
      }
      if (float(sTmp[1])<boundsLeftLon)
      {
        boundsLeftLon=float(sTmp)[1];
      }
    }
  }

  println(boundsTopLat+" "+boundsRightLon+" "+boundsBottomLat+" "+boundsLeftLon);
  map =new MercatorMap(displayWidth-200, displayHeight-200, boundsTopLat, boundsBottomLat, boundsLeftLon, boundsRightLon );
  float[][] points_matrix = new float[s.length][2];

  println("size");
  int sizePrime = (int)random(25, 50);
  int previous=0;
  int[] primeIndexes = new int[sizePrime];
  for (int i=0; i < sizePrime; i++) {
    int tmpI=0;
    if (!(i==0 || i==(sizePrime-1)))
    {
      tmpI = (int) (floor((s.length/sizePrime)*i) + (random (-s.length/sizePrime/2, +s.length/sizePrime/2)));
    }
    println(tmpI);
    previous=tmpI;
    primeIndexes[i] = tmpI;
  }
  println("indexes");
  int f=0;
  points_matrix_prime=new float[sizePrime][2];
  for (int i=0;i<s.length;i++) {

    String[] sTmp=split(s[i], ",");
    if (sTmp.length>1)
    {

      PVector pTmp=map.getScreenLocation(new PVector(float(sTmp[0]), float(sTmp[1])));
      points.add(new pt(pTmp.x, pTmp.y));
      //      voronoi.addPoint(new Vec2D(pTmp.x, pTmp.y));

      points_matrix[i][0] = pTmp.x+100;
      points_matrix[i][1] = pTmp.y+100;

      for (int k=0; k < sizePrime; k++) {
        if (i == primeIndexes[k]) {
          if (pTmp.x<10 || pTmp.y<10)
          {
          }
          else
          {
            points_matrix_prime[f][0] = pTmp.x+100;
            points_matrix_prime[f][1] = pTmp.y+100;
            println(points_matrix_prime[f]);
            f++;
          }
          break;
        }
      }

      //println(points_matrix[i]);
    }
  }

  myDelaunay = new Delaunay( points_matrix );

  println(points.size());
  size(displayWidth, displayHeight);  
  strokeJoin(ROUND); 
  strokeCap(ROUND);
  setuppixelImage();
  P=new pt[points.size()];
  cap=points.size();
  for (int i=0; i<cap; i++) {
    P[i]=new pt(0, 0);
  };      // creates all points

  for (int i=0; i<vn; i++) {
    P[i]=new pt(random(width), random(height));
  };  // makes the first vn poits random

  //noFill();
  redraw=true;

  my_delaunay_prime=new Delaunay(points_matrix_prime);

  println(points.size());
  size(displayWidth, displayHeight);  
  strokeJoin(ROUND); 
  strokeCap(ROUND);
  setuppixelImage();
  P=new pt[points.size()];
  cap=points.size();
  for (int i=0; i<cap; i++) {
    P[i]=new pt(0, 0);
  };      // creates all points

  for (int i=0; i<vn; i++) {
    P[i]=new pt(random(width), random(height));
  };  // makes the first vn poits random*/



  triangles = new ArrayList <Triangle>();

  ArrayList <Edge> edgesMain = new ArrayList<Edge>();
  ArrayList <Edge> edgesSub  = new ArrayList<Edge>();
  float[][] my_edges_prime = my_delaunay_prime.getEdges();

  for (int i=0; i < my_edges_prime.length; i++) {
    edgesMain.add(new Edge(my_edges_prime[i][0], my_edges_prime[i][1], my_edges_prime[i][2], my_edges_prime[i][3]));
    //edgesSub.add(new Edge(my_edges_prime[i][0], my_edges_prime[i][1], my_edges_prime[i][2], my_edges_prime[i][3]));
  }


  Edge secondEdge=new Edge(0, 0, 0, 0);
  int secondEdgeIndex=-1;
  int firstEdgeIndex=edgesMain.size()-1;
  int thirdEdgeIndex=-1;
  Triangle tmpTr=new Triangle(edgesMain.get(edgesMain.size()-1));
  fillColors=new color[my_edges_prime.length];
  int colorIndex=0;

  while (edgesMain.size ()> 0) {

    if (tmpTr==null || tmpTr.isComplete()) {
      // remove edges from edgesMain
      if (tmpTr!=null)
      {
        if (!tmpTr.hasVoid())
        {
          triangles.add(tmpTr);
        }
          edgesMain.remove(tmpTr.a);
          edgesMain.remove(tmpTr.b);
          edgesMain.remove(tmpTr.c);
        
      }


      int lastElemIndex=edgesMain.size()-1;

      if (lastElemIndex<=0)
      {  
        break;
      }
      println(triangles.size());
      fillColors[colorIndex]=color(random(1, 240), random(1, 240), random(1, 240));
      colorIndex++;
      tmpTr = new Triangle(edgesMain.get(lastElemIndex));
      firstEdgeIndex=edgesMain.size()-1;
    }
    for (int i=0;i<my_edges_prime.length;i++) {
      Edge tmp1=new Edge(my_edges_prime[i][0], my_edges_prime[i][1], my_edges_prime[i][2], my_edges_prime[i][3]);
      if (tmpTr.a.hasOnePointInCommon(tmp1))
      {
        if (secondEdgeIndex!=i)
        {
          secondEdgeIndex=i;
          secondEdge=tmp1;
          continue;
        }
      }
    }
    for (int i=0;i<my_edges_prime.length;i++) {
      Edge tmp2=new Edge(my_edges_prime[i][0], my_edges_prime[i][1], my_edges_prime[i][2], my_edges_prime[i][3]);
      if (secondEdge.hasOnePointInCommon(tmp2) && secondEdgeIndex!=i)
      {
        if (tmpTr.a.hasOnePointInCommon(tmp2))
        {
          thirdEdgeIndex=i;
          tmpTr.setEdges(secondEdge, tmp2);
          break;
        }
      }
    }
  }
  println("tris size:"+triangles.size());
}


///////////////////////////////////////////////////////////////////////////////////////////


void draw()
{
  if (redraw) {   
    // translate(0,-500);
    //scale(1,2);
    background(255); 
    if (bi!= -1) {
      P[bi].setFromDataSet();
    };                    // snap selected vertex to mouse position during dragging

    //    drawTriangles();
    beginShape();
    for (int i=0;i<points.size();i++)
    {
      pt tmp=points.get(i);
      if (false)
      {
        point(tmp.x, tmp.y);
      }
      if (false)
      {
        vertex(tmp.x, tmp.y);
      }
      if (i<points.size()-1 && false)
      {
        pt tmp1=points.get(i+1);
        line(tmp.x, tmp.y, tmp1.x, tmp1.y);
      }
    }
    endShape(CLOSE);

    float[][] myEdges = myDelaunay.getEdges();

    for (int i=0; i<myEdges.length; i++)
    {
      fill(100, 50);
      stroke(100, 50);
      strokeWeight(1);

      float startX = myEdges[i][0];
      float startY = myEdges[i][1];
      float endX = myEdges[i][2];
      float endY = myEdges[i][3];
      line( startX, startY, endX, endY );
    }
    /*
    float[][] my_edges_prime = my_delaunay_prime.getEdges();
     
     for (int i=0; i<my_edges_prime.length; i++)
     {
     noFill();
     stroke(0);
     strokeWeight(1);
     float startX = my_edges_prime[i][0];
     float startY = my_edges_prime[i][1];
     float endX = my_edges_prime[i][2];
     float endY = my_edges_prime[i][3];
     if ((startX+startY<10) || (endX+endY)<10 )
     {
     continue;
     }
     line( startX, startY, endX, endY );
     }*/

    for (int i=0;i<triangles.size();i++)
    {
      fill(fillColors[i]);
      println(red(fillColors[i])+" "+green(fillColors[i])+" "+blue(fillColors[i]));
      triangles.get(i).paintColor();
    }
    /* for (int i=0; i<myRegions.length; i++)
     {
     // an array of points
     float[][] regionCoordinates = myRegions[i].getCoords();
     boolean draw = true;
     
     for (int j=0; j < myRegions[i].count(); j++) {
     if (regionCoordinates[j][0]<0 || regionCoordinates[j][0] > width || regionCoordinates[j][1] < 0 || regionCoordinates[j][1] > height) {
     draw = false;
     }
     }      
     fill(255, 0, 0);
     if (draw) {
     myRegions[i].draw(this); // draw this shape
     }
     }*/
    //  drawPoints();
    redraw = false;

    //    fill(0);
    //    for (Triangle2D t : voronoi.getTriangles()) {
    //    triangle(t.a.x, t.a.y, t.b.x, t.b.y, t.c.x, t.c.y);
    //  }
  }
}


void drawTriangles() { 
  pt X = new pt(0, 0);
  float r=1;

  for (int i=0; i<vn-2; i++) {
    for (int j=i+1; j<vn-1; j++) {
      for (int k=j+1; k<vn; k++) {
        boolean found=false; 
        for (int m=0; m<vn; m++) {
          X=centerCC (P[i], P[j], P[k]);  
          r = X.disTo(P[i]);
          if ((m!=i)&&(m!=j)&&(m!=k)&&(X.disTo(P[m])<=r)) {
            found=true;
          }
        };
        if (!found) {

          noStroke();
          color a = lerpColor(P[i].c, P[j].c, 0.2);
          color f = lerpColor(a, P[k].c, 0.2);        
          fill(f);

          beginShape(POLYGON);  
          P[i].vert(); 
          P[j].vert(); 
          P[k].vert(); 
          endShape();
        };
      };
    };
  }; // end triple loop
};    

///////////////////////////////////////////////////////////////////////////


pt centerCC (pt A, pt B, pt C) {    // computes the center of a circumscirbing circle to triangle (A,B,C)
  vec AB =  A.vecTo(B);  
  float ab2 = dot(AB, AB);
  vec AC =  A.vecTo(C); 
  AC.left();  
  float ac2 = dot(AC, AC);
  float d = 2*dot(AB, AC);
  AB.left();
  AB.back(); 
  AB.mul(ac2);
  AC.mul(ab2);
  AB.add(AC);
  AB.div(d);
  pt X =  A.makeCopy();
  X.addVec(AB);
  return(X);
};


////////////////////////////////////////////////////////////////////////////////////////


void mousePressed() {  // to do when mouse is pressed  
  redraw = true;
  float bd=sq(width/5);                                                       // init square of smallest distance to selected point
  Mouse.setFromDataSet();                                                 // save current mouse location
  for (int i=0; i<vn; i++) { 
    if (d2(i)<bd) {
      bd=d2(i); 
      bi=i;
    };
  };      // select closeest vertex
  if (bd>10) { 
    bi=vn++;  
    P[bi].setFromDataSet();                          // if closest vertex is too far
    P[bi].setColor(pixel_color(myImage));
  };
  index++;
}


float d2(int j) {
  return (Mouse.disTo(P[j]));
};               //  squared distance from mouse to vertex P[j]

void mouseReleased() {                                      // do this when mouse released
  if ( (bi!=-1) &&  P[bi].isOut() ) {                       // if outside of port
    for (int i=bi; i<vn; i++) {
      P[i].setFromPt(P[i+1]);
    };  // shift up to delete selected vertex
    vn--; 
    println("deleted vertex "+bi);
  };                                           
  bi= -1;
};

void keyPressed() {  
  if (key=='d') {
    dots=!dots;
  };
  if (key=='n') {
    numbers=!numbers;
  };
  if (key=='w') {
    writePts();
  };
  if (key=='s') {
    savePts();
  };
  if (key=='l') {
    loadPts();
  };
  if (key=='i') { 
    saveFrame("pix-####.pdf");
  };   
  if (key=='f') { 
    float sx=width; 
    float sy=height; 
    float bx=0.0; 
    float by=0.0; 
    for (int i=0; i<vn; i++) {
      if (P[i].x>bx) {
        bx=P[i].x;
      }; 
      if (P[i].x<sx) {
        sx=P[i].x;
      }; 
      if (P[i].y>by) {
        by=P[i].y;
      }; 
      if (P[i].y<sy) {
        sy=P[i].y;
      };
    };
    float m=max(bx-sx, by-sy);  
    float dx=(m-(bx-sx))/2; 
    float dy=(m-(by-sy))/2;
    for (int i=0; i<vn; i++) {
      P[i].x=(P[i].x-sx+dx)*4*width/5/m+width/10;  
      P[i].y=(P[i].y-sy+dy)*4*height/5/m+height/10;
    };
  };
};                                                                 

//**********************************
//***     PRINT, ARCHIVE POINTS
//**********************************
void writePts() { 
  for (int i=0; i<vn; i++) {
    P[i].write();
  };
};

void savePts() {
  String [] inppts = new String [vn+1];
  int s=0;
  inppts[s++]=str(vn);
  for (int i=0; i<vn; i++) {
    inppts[s++]=str(P[i].x)+","+str(P[i].y);
  };
  saveStrings("points.pts", inppts);
};

void loadPts() {
  String [] ss = loadStrings("points.pts");
  String subpts;
  int s=0;
  int comma;
  vn = int(ss[s]);
  for (int i=0;i<vn; i++) {
    comma=ss[++s].indexOf(',');
    P[i]=new pt (float(ss[s].substring(0, comma)), float(ss[s].substring(comma+1, ss[s].length())));
  };
};

