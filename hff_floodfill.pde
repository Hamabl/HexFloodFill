/*int radius = 80;
float size = 7;
int hexcount = 1 + 6*radius*(radius+1)/2;
float propagation_probas[] = {0.3, 0.3, 2, 0.3, 0.3, 2};
boolean turning = true;
float base_color_change_freq = 0.005;
float color_change_freq = base_color_change_freq;
float color_change_offset = 0;
float color_change_randomness = 3;
color col1 = color(0, 180, 255);//color(255, 255, 150);//color(0,250,255);
color col2 = color(100, 255, 30);//color(255, 255, 255);//color(0,255,0);
color col3 = color(255, 210, 120);//color(255, 150, 150);//color(200,255,0);
color col4 = color(0, 0, 0);//color(255, 255, 255);//color(0,0,0);
color colbg = color(0,0,0);

PVector vecX = new PVector(0    * size, -sqrt(3)/2 * size);
PVector vecY = new PVector(0.75  * size, sqrt(3)/4  * size);
PVector vecZ = new PVector(-0.75 * size, sqrt(3)/4  * size);
PShape hexShape;

HashMap<Hex, Float> hexes;
ArrayList<Hex> open;

int current_step = 0;
boolean progressive_mode = false;
int frame = 0;

int seed;

void setup()
{
  size(1024,1024);
  hexShape = createShape();
  hexShape.beginShape();
  hexShape.noStroke();
  for(int i = 0; i < 6; i++)
  {
    hexShape.vertex((0.5*size+0.5)*cos(TWO_PI*i/6), (0.5*size+0.5)*sin(TWO_PI*i/6));
  }
  hexShape.endShape(CLOSE);
  
  seed = int(random(1000));
  randomSeed(seed);
  
  hexes = new HashMap<Hex, Float>(hexcount);
  open = new ArrayList<Hex>();
  
  Generate();
  
  //Init();
  //progressive_mode = true;
  
}

void keyPressed()
{
  if(key == 'g')
  {
    Generate();
  }
  
  if(key == 'f')
  {
    Init();
    progressive_mode = false;
  }
  
  if(key == 's')
  {
    saveFrame("hex-"+str(seed)+".png");
  }
  
  if(key == 'c')
  {
    col1 = color(int(random(256)), int(random(256)), int(random(256)));
    col2 = color(int(random(256)), int(random(256)), int(random(256)));
    col3 = color(int(random(256)), int(random(256)), int(random(256)));
    col4 = color(int(random(256)), int(random(256)), int(random(256)));
  }
  
  if(key == 'b')
  {
    colbg = color(int(random(256)), int(random(256)), int(random(256)));
  }
  
  if(key == '+')
  {
    base_color_change_freq *= 1.5;
  }
  if(key == '-')
  {
    base_color_change_freq /= 1.5;
  }
}

void draw()
{
  translate(512,512);
  background(colbg);
  
  //color_change_freq = base_color_change_freq * (1 - cos(0.0001*millis()));
  //color_change_offset = hexcount * sin(0.000056232187654348*millis());
  color_change_freq = base_color_change_freq * (1 - cos(0.005 * frame));
  color_change_offset = hexcount * sin(0.056232187654348 * frame);
  
  if(progressive_mode && current_step < hexcount)
  {
    for(int s = 0; s<500;)
    {
      if(open.size() == 0)
      {
        break;
      }

      if(Step(current_step))
      {
        s++;
        current_step ++;
        if((current_step%int(0.05*hexcount) == 1))
          println(int(current_step*100/hexcount) + "%");
      }
    }
  }
  
  for(Hex h : hexes.keySet())
  {
    drawHex(h, colorFromVal(hexes.get(h)));
  }
  
  saveFrame("anim/frame"+str(frame)+".png");
  frame ++;
}

void Generate()
{
  progressive_mode = false;
  Init();
  for(; current_step<hexcount;)
  {
    if(open.size() == 0)
    {
      println("bigbreakfail");
      return;
    }
    
    if(Step(current_step))
    {
      current_step ++;
      if((current_step%int(0.05*hexcount) == 1))
        println(int(current_step*100/hexcount) + "%");
    }
  }
  
  println("Generated ", hexcount, " tiles");
}

void Init()
{
  hexes.clear();
  open.clear();
  Hex h0 = new Hex(int(random(0,radius)),int(random(0,radius)),int(random(0,radius)));
  hexes.put(h0, 0f);
  open.add(h0);
  
  current_step = 1;
}

boolean Step(int i) //true if successfully added hex
{
  Hex h = open.get(open.size()-1);
  Hex[] neighbours;
  if(turning)
    neighbours = h.neighboursRotated();
  else
    neighbours = h.neighbours();
  
  //getting available neighbours
  IntList free_neighbours = new IntList();

  for(int k = 0; k<neighbours.length; k++)
  {
    neighbours[k].normalize();

    if (max(neighbours[k].x, neighbours[k].y, neighbours[k].z) <= radius && !hexes.containsKey(neighbours[k]))
    {
      free_neighbours.append(k);
    }
  }
  
  if(free_neighbours.size() >0)
  {
    int i_neighbour = pickRandom(free_neighbours, propagation_probas);
    Hex neighbour = neighbours[i_neighbour];//neighbours[free_neighbours.get(int(random(free_neighbours.size())))];
    //color propagation
    hexes.put(neighbour, (hexes.get(open.get(open.size()-1)) + random(1/color_change_randomness, 1*color_change_randomness)));
    open.add(neighbour);
    return true; //i++;
  }
  else
  {
    open.remove(open.size()-1);
    return false;
  }
  
}

int pickRandom(IntList list, float probas[])
{
  float cumulated = 0;
  for(int i=0; i<list.size(); i++)
  {
    cumulated += probas[list.get(i)];
  }
  float rand_val = random(0, cumulated);
  
  cumulated = 0;
  for(int i=0; i<list.size(); i++)
  {
    cumulated += probas[list.get(i)];
    if(rand_val < cumulated)
      return list.get(i);
  }
  return list.get(list.size()-1);
}

void drawHex(Hex h, color col)
{
    hexShape.setFill(col);
    shape(hexShape, h.x * vecX.x + h.y * vecY.x + h.z * vecZ.x, h.x * vecX.y + h.y * vecY.y + h.z * vecZ.y);
}

color colorFromVal(float val)
{
  val = color_change_freq*(val+color_change_offset);// % TWO_PI;
  float right = constrain((1+1.4*cos(val))/2, 0, 1);
  float left = constrain((1-1.4*cos(val))/2, 0, 1);
  float up = constrain((1+1.4*sin(val))/2, 0, 1);
  float down = constrain((1-1.4*sin(val))/2, 0, 1);
  
  return color(up*right*red(col1) + up*left*red(col2) + down*left*red(col3) + down*right*red(col4),
               up*right*green(col1) + up*left*green(col2) + down*left*green(col3) + down*right*green(col4),
               up*right*blue(col1) + up*left*blue(col2) + down*left*blue(col3) + down*right*blue(col4));
}*/
