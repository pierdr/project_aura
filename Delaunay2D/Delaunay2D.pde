//import ketai.sensors.*;
//import android.os.Environment;
//import java.io.File;


///////////////////////////////////////////////////////////////////////////

int vn =5;                       // number of points (sites)
int cap=100;                    // max number of points
pt[] P = new pt [cap];          // Array containing the points
int bi=-1;                      // index of selected mouse-vertex, -1 if none selected
pt Mouse = new pt(0, 0);         // current mouse position
color black = color(0, 10, 10); 
color blue = color(10, 10, 200); 
color grey = color(0, 5, 0);
boolean redraw;
boolean dots = false;           // toggles display circle centers
boolean numbers = false;         // toggles display of vertex numbers 

void setup() {   
  size(700, 700);  
  strokeJoin(ROUND); 
  strokeCap(ROUND);
  setuppixelImage();
  
  for (int i=0; i<cap; i++) {
    P[i]=new pt(0, 0);
  };      // creates all points
  
  for (int i=0; i<vn; i++) {
    P[i]=new pt(random(width), random(height));
  };  // makes the first vn poits random
  
  noFill();
} 


///////////////////////////////////////////////////////////////////////////


void draw() { 
  if (redraw) {   
  background(255); 
  if (bi!= -1) {
    P[bi].setFromMouse();
  };                    // snap selected vertex to mouse position during dragging
  drawTriangles();
//  drawPoints();
  redraw = false;
  }
};

//void drawPoints() {              // draws the vn sites and numbers them 
//  if (numbers) {
//    fill(10, 10, 100); 
//    for (int i=0; i<vn; i++) 
//    {
//      vec V = new vec(5, 5); 
//      P[i].label(str(i), V );
//    }; 
//
//    noFill();
//  };
//  for (int i=0; i<vn; i++) {
//    P[i].show(5);
//  };
//}; 

///////////////////////////////////////////////////////////////////////////

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
          //         strokeWeight(0.2); stroke(grey); 
          //         ellipse(X.x,X.y,r,r); 

          //         if (dots) {
          //         stroke(blue); X.show(2); 
          //         };
//          strokeWeight(0.5); 
//          stroke(black); 
          noStroke();
          //color c = (int) random(50,100);
          //color c = findColor((int) random(0,myImage.width),(int) random(0,myImage.height),myImage.width/imageScale,myImage.height/imageScale);
          
//          color c = pixel_color(myImage);
  
          color a = lerpColor(P[i].c, P[j].c, 0.5);
          color f = lerpColor(a, P[k].c, 0.5);        
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


///////////////////////////////////////////////////////////////////////////


void mousePressed() {  // to do when mouse is pressed  
  redraw = true;
  float bd=sq(width/5);                                                       // init square of smallest distance to selected point
  Mouse.setFromMouse();                                                 // save current mouse location
  for (int i=0; i<vn; i++) { 
    if (d2(i)<bd) {
      bd=d2(i); 
      bi=i;
    };
  };      // select closeest vertex
  if (bd>10) { 
    bi=vn++;  
    P[bi].setFromMouse();                          // if closest vertex is too far
    P[bi].setColor(pixel_color(myImage));
  };
  
 int scaledMouseX = mouseX / imageScale;
  int scaledMouseY = mouseY / imageScale;
 
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

///////////////////////////////////////////////////////////////////////////


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
    saveFrame("pix-####.tif");
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

/* not used
 float radiusCC (pt A, pt B, pt C) {
 float a=B.disTo(C);     float b=C.disTo(A);     float c=A.disTo(B);
 float s=(a+b+c)/2;     float d=sqrt(s*(s-a)*(s-b)*(s-c));   float r=a*b*c/4/d;
 return (r);
 };
 */





