
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
