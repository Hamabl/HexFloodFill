float hSize = 10;

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

float smoothness_factor = hexcount*0.01;

void renderAll()
{
  background(colbg);
  translate(540,540);
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
  for(Hex h : hexes.keySet())
  {
    float i_col = hexes.get(h);
    Hex[] neighbours = h.neighbours();
    boolean previous_is_similar = hexes.containsKey(neighbours[5]) && abs(hexes.get(neighbours[5]) - i_col)%hexes.size() < smoothness_factor;
    
    for(int i=0; i<6; i++)
    {
      boolean is_similar = hexes.containsKey(neighbours[i]) && abs(hexes.get(neighbours[i]) - i_col)%hexes.size() < smoothness_factor;
      if(previous_is_similar && !is_similar)
      {
        drawSmoothness(h, neighbours[(i+5)%6], neighbours[i], colorFromVal(i_col));
      }
      else if(!previous_is_similar && is_similar)
      {
        drawSmoothness(h, neighbours[i], neighbours[(i+5)%6], colorFromVal(i_col));
      }
      previous_is_similar = is_similar;
    }
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
}

void drawSmoothness(Hex h1, Hex h2, Hex hr, color col)
{
  PVector p1 = getPos(h1);
  PVector p2 = getPos(h2);
  //Hex diff = h2.sub(h1);
  //PVector pr = getPos(h1.add(diff.rotated6(1)));
  PVector pr = getPos(hr);
  
  PVector a = new PVector((p1.x + pr.x)/2., (p1.y + pr.y)/2.);
  PVector b = new PVector((p2.x + pr.x)/2., (p2.y + pr.y)/2.);
  PVector c = new PVector((p1.x + p2.x + pr.x)/3., (p1.y + p2.y + pr.y)/3.);
  PVector m = new PVector((p1.x + p2.x)/2., (p1.y + p2.y)/2.);
  
  //println(a, "   ", b, "   ", c, "   ", m);
  fill(col);
  beginShape();
  noStroke();
  vertex(a.x, a.y);
  quadraticVertex(c.x, c.y, b.x, b.y);
  vertex(m.x, m.y);
  endShape(CLOSE);
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
