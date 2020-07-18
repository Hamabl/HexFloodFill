void setup()
{
  size(1080,1080);
  frameRate(40);
  smooth(8);

  seed = int(random(10000));
  randomSeed(seed);
  
  hexes = new HashMap<Hex, Float>();
  next = new HashMap<Hex, Hex>(hexcount);
  prev = new HashMap<Hex, Hex>(hexcount);
  open = new ArrayList<Hex>();

  generate();
  
  println("next : ", next.size(), " hexes", hexes.size());


  background(0);
  renderAll();
  
  /*
  translate(512,512);
  Hex h = new Hex(0,0,0);
  Hex h1 = new Hex(0,1,1);
  Hex n1 = h.plus( h1.sub(h).rotated6(1) );
  Hex n5 = h.plus( h1.sub(h).rotated6(5) );

  drawHex(new Hex(0,0,0), color(255,0,0));
  drawHex(h, color(200,0,50));
  drawHex(h1, color(200,0,200));
  drawHex(n1, color(0,0,150));
  drawHex(n5, color(0,0,200));//*/
}

void draw()
{
  color_change_phase += 0.02;
  renderAll();
}

void keyPressed()
{
  if(key == 'g')
  {
    generate();
    renderAll();
  }
  
  if(key == 'c')
  {
    col1 = color(int(random(256)), int(random(256)), int(random(256)));
    col2 = color(int(random(256)), int(random(256)), int(random(256)));
    col3 = color(int(random(256)), int(random(256)), int(random(256)));
    col4 = color(int(random(256)), int(random(256)), int(random(256)));
    renderAll();
  }
  
  if(key == 'b')
  {
    colbg = color(int(random(256)), int(random(256)), int(random(256)));
    renderAll();
  }
  
  if(key == '+')
  {
    color_change_freq += 1;
    renderAll();
  }
  if(key == '-')
  {
    color_change_freq = color_change_freq > 1 ? color_change_freq-1 : 1;
    renderAll();
  }
}
