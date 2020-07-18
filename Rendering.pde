float hSize = 20;

PVector vecX = new PVector(0    * hSize, -sqrt(3)/2 * hSize);
PVector vecY = new PVector(0.75  * hSize, sqrt(3)/4  * hSize);
PVector vecZ = new PVector(-0.75 * hSize, sqrt(3)/4  * hSize);

color col1 = color(0, 180, 255);//color(255, 255, 150);//color(0,250,255);
color col2 = color(100, 255, 30);//color(255, 255, 255);//color(0,255,0);
color col3 = color(255, 210, 120);//color(255, 150, 150);//color(200,255,0);
color col4 = color(0, 0, 0);//color(255, 255, 255);//color(0,0,0);
color colbg = color(0,0,0);

float color_change_freq = 1;
float color_change_phase = 0;

float smoothness_factor = hexcount*0.3;

void renderAll()
{
  background(colbg);
  translate(512,512);
  renderHexes();
  renderSmoothness();
}

void renderHexes()
{
  Hex h = firstHex;
  int i_col = 0;
  for(int k = 0; k<next.size(); k++)
  {
    drawHex(h, colorFromVal(i_col));
    h = next.get(h);
    i_col++;
  }
}

void renderSmoothness()
{
  Hex h = firstHex;
  int i_col = 0;
  for(int k = 0; k<next.size(); k++)
  {
    Hex h_next = next.get(h);
    drawSmoothness(h, h_next, colorFromVal(i_col));
    h = h_next;
    i_col++;
  }
}

void drawHex(Hex h, color col)
{
  PVector pos = getPos(h);
  fill(col);
  beginShape();
  noStroke();
  for(int i = 0; i < 6; i++)
  {
    vertex(pos.x+(0.5*hSize+0.5)*cos(TWO_PI*i/6), pos.y+(0.5*hSize+0.5)*sin(TWO_PI*i/6));
  }
  endShape(CLOSE);
  //shape(hexShape, h.x * vecX.x + h.y * vecY.x + h.z * vecZ.x, h.x * vecX.y + h.y * vecY.y + h.z * vecZ.y);
}

void drawSmoothness(Hex h1, Hex h2, color col)
{
  PVector p1 = getPos(h1);
  PVector p2 = getPos(h2);
  Hex diff = h2.sub(h1);
  PVector pr = getPos(h1.add(diff.rotated6(1)));
  
  PVector a = new PVector((p1.x + pr.x)/2., (p1.y + pr.y)/2.);
  PVector b = new PVector((p2.x + pr.x)/2., (p2.y + pr.y)/2.);
  PVector c = new PVector((p1.x + p2.x + pr.x)/3., (p1.y + p2.y + pr.y)/3.);
  PVector m = new PVector((p1.x + p2.x)/2., (p1.y + p2.y)/2.);
  
  println("h:" + h1 + "diffr1:" + getPos(diff.rotated6(1)) + "diffr5" + getPos(diff.rotated6(5)) );
  //println(a1, "   ", b1, "   ", a2, "   ", b2);
  fill(col);
  beginShape();
  noStroke();
  vertex(a.x, a.y);
  quadraticVertex(c.x, c.y, b.x, b.y);
  vertex(m.x, m.y);
  endShape(CLOSE);
  //stroke(1);
  //circle(a.x, a.y, 10);
}

  
PVector getPos(Hex h)
{
  return new PVector(h.x * vecX.x + h.y * vecY.x + h.z * vecZ.x, 
                     h.x * vecX.y + h.y * vecY.y + h.z * vecZ.y);
}

color colorFromVal(float val)
{
  val = (color_change_freq*2*PI*val/hexcount)+color_change_phase;
  float right = constrain((1+1.4*cos(val))/2, 0, 1);
  float left = constrain((1-1.4*cos(val))/2, 0, 1);
  float up = constrain((1+1.4*sin(val))/2, 0, 1);
  float down = constrain((1-1.4*sin(val))/2, 0, 1);
  
  return color(up*right*red(col1) + up*left*red(col2) + down*left*red(col3) + down*right*red(col4),
               up*right*green(col1) + up*left*green(col2) + down*left*green(col3) + down*right*green(col4),
               up*right*blue(col1) + up*left*blue(col2) + down*left*blue(col3) + down*right*blue(col4));
}

color runningDotFromVal(float val)
{
  val = (color_change_freq*val/hexcount)+color_change_phase;
  return color(255*pow(1-(val%1),1));
}
