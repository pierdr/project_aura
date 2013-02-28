class Triangle2
{
  PVector p1,p2,p3;
  color c1,c2,c3;
  
  Triangle2() {
  }
  
  Triangle2(PVector _p1, PVector _p2, PVector _p3, color _c1, color _c2, color _c3)
  {
    p1 = _p1;
    p2 = _p2;
    p3 = _p3;
    
    c1 = _c1;
    c2 = _c2;
    c3 = _c3;
    
    
    reArrange();
  }
  
  //look for leftMost(o0) point and can brighten it, also darken the rests
  //or do slightly color adjustments
  void reArrange()
  {
    PVector o0,o1,o2;
    color m0,m1,m2;
    
    if(p1.x <= p2.x && p1.x <=p3.x)
    {
      o0 = p1;
      o1 = p2;
      o2 = p3;
      
      m0 = c1;
      m1 = c2;
      m2 = c3;
    }
    else if(p2.x < p3.x)
    {
      o0 = p2;
      o1 = p1;
      o2 = p3;
      
      m0 = c2;
      m1 = c1;
      m2 = c3;
    }
    else
    {
      o0 = p3;
      o1 = p1;
      o2 = p2;
      
      m0 = c3;
      m1 = c1;
      m2 = c2;
    }
    
    
    p1 = o0;
    p2 = o1;
    p3 = o2;
    
    c1 = m0;
    c2 = m1;
    c3 = m2;
    
    colorMode(HSB);
    float amplify = 1;
    float d2 = p2.x-p1.x;
    float d3 = p3.x-p1.x;
    c1 = color(hue(c1),saturation(c1)*1,constrain(brightness(c1),20,255));//+(d2+d3)*amplify);
    c2 = color(hue(c2),saturation(c2)*1,constrain(brightness(c2),20,255));//-d2*amplify);
    c3 = color(hue(c3),saturation(c3)*1,constrain(brightness(c3),20,255));//-d3*amplify);
    
    
    colorMode(RGB);
  }
  
  void draw()
  {
    if(mode>1)
      noStroke();
    else stroke(0);
    
    beginShape();
    fill(c1);
    vertex(p1.x,p1.y);
    if(mode %2==1)fill(c2);
    vertex(p2.x,p2.y);
    if(mode %2== 1)fill(c3);
    vertex(p3.x,p3.y);
    
    endShape(CLOSE);
  }
  
}