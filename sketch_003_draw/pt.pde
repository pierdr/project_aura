//************************************************************************
//**** 2D POINTS AND VECTOR CLASSES, Jarek Rossignac, Oct 2005
//************************************************************************
class pt { 

  float x, y; 
  color c;

  // CREATE, COPY
  pt (float px, float py) {
    x = px; 
    y = py;
  };
  pt makeCopy() {
    return(new pt(x, y));
  };
  void setFromValues(float px, float py) {
    x = px; 
    y = py;
  }; 
  void setFromPt(pt P) { 
    x = P.x; 
    y = P.y;
  }; 
  void setFromMouse() { 
    x = mouseX; 
    y = mouseY;
  }; 
  void setFromDataSet()
  {
    x  =  points.get(index).x ;
    y  =  points.get(index).y ;
  }

  void setColor(color newcolor) {
    c = newcolor;
  }

  // DISPLAY, PRINT 
  void vert() {
    vertex(x, y);
  };
  void show(int r) { 
    ellipse(x, y, r, r);
  }; 
  void label(String s, vec D) {
    text(s, x+D.x, y+D.y);
  };
  void showLineTo (pt P) {
    line(x, y, P.x, P.y);
  }; 
  void write() {
    println("("+x+","+y+")");
  };

  // DISPLACE
  void addVec(vec V) {
    x += V.x; 
    y += V.y;
  };
  void subVec(vec V) {
    x -= V.x; 
    y -= V.y;
  };
  void addScaledVec(float s, vec V) {
    x += s*V.x; 
    y += s*V.y;
  };
  void moveTowards(pt P, float s) {
    x=x+s*(P.x-x);  
    y=y+s*(P.y-y);
  };

  // ADD, SUBTRACT, MULTIPLY
  void addPt(pt P) {
    x+=P.x; 
    y+=P.y;
  };
  void subPt(pt P) {
    x-=P.x; 
    y-=P.y;
  };
  void mul(float f) {
    x*=f; 
    y*=f;
  };

  // TEST, MEASURE
  boolean isOut() {
    return(((x<0)||(x>width)||(y<0)||(y>height)));
  };
  float disTo(pt P) {
    return(sqrt(sq(P.x-x)+sq(P.y-y)));
  };

  // MAKE VECTOR
  vec vecTo(pt P) {
    return(new vec(P.x-x, P.y-y));
  };
  vec vecToMid (pt P, pt Q) {
    return(new vec((P.x+Q.x)/2.0-x, (P.y+Q.y)/2.0-y));
  };
  vec vecToBisect (pt P, pt Q) {
    float a=sqrt(sq(P.x-x)+sq(P.y-y));   
    float b=sqrt(sq(x-Q.x)+sq(y-Q.y));
    return(new vec((b*P.x+a*Q.x)/(a+b)-x, (a*P.y+b*Q.y)/(a+b)-y));
  };
} 

pt average(pt A, pt B) {
  return(new pt((A.x+B.x)/2, (A.y+B.y)/2));
};
pt center(pt A, pt B, pt C) {
  return(new pt((A.x+B.x+C.x)/3.0, (A.y+B.y+C.y)/3.0));
};


class vec { 
  float x, y; 

  // CREATE, COPY
  vec (float px, float py) {
    x = px; 
    y = py;
  };
  vec makeCopy() {
    return(new vec(x, y));
  }; 
  void setFromValues(float px, float py) {
    x = px; 
    y = py;
  }; 
  void setFromVec(vec V) { 
    x = V.x; 
    y = V.y;
  }; 

  // DISPLAY, PRINT 
  void show (pt P) { 
    ellipse(P.x, P.y, 3, 3); 
    line(P.x, P.y, P.x+x, P.y+y);
  }; 
  void write() {
    println("("+x+","+y+")");
  };

  // ADD, SUBTRACT, MULTIPLY, DIVIDE, NORMALIZE

  void mul(float m) {
    x *= m; 
    y *= m;
  };
  void div(float m) {
    x /= m; 
    y /= m;
  };
  void add(vec V) {
    x += V.x; 
    y += V.y;
  };
  void addScaled(float m, vec V) {
    x += m*V.x; 
    y += m*V.y;
  };
  void sub(vec V) {
    x -= V.x; 
    y -= V.y;
  };

  // TEST, MEASURE
  float norm() {
    return(sqrt(sq(x)+sq(y)));
  }; 
  boolean isZero() {
    return((abs(x)+abs(y)<0.000001));
  }; 

  // MAKE VECTOR 
  void unit() {
    float n=sqrt(sq(x)+sq(y)); 
    if (n>0.000001) {
      x/=n; 
      y/=n;
    };
  };
  void left() {
    float w=x; 
    x=-y; 
    y=w;
  };
  void back() {
    x= -this.x; 
    y= -this.y;
  };
} 

vec average(vec U, vec V) {
  return(new vec((U.x+V.x)/2, (U.y+V.y)/2));
};
float dot(vec U, vec V) {
  return(U.x*V.x+U.y*V.y);
};

