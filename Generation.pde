int radius = 60;
int hexcount = 1 + 6*radius*(radius+1)/2;
HashMap<Hex, Float> hexes;
HashMap<Hex, Hex> prev;
HashMap<Hex, Hex> next;
ArrayList<Hex> open;
float color_change_randomness = 3;
int open_list_precedence_index = 3;
Hex firstHex;

int seed;

void generate()
{
  initGeneration();

  for(; hexes.size()<hexcount;)
  {
    if(open.size() == 0)
    {
      println("ERROR: open list is empty.");
      break;
    }
    
    if(step())
    {
      if((hexes.size()%max(int(0.05*hexcount),1) == 1))
        println(int(hexes.size()*100/hexcount) + "%");
    }
  }
  
  //Set the values in hexes hashMap
  Hex h = firstHex;
  int i_col = 0;
  for(int k = 0; k<next.size(); k++)
  {
    hexes.put(h,float(i_col));
    h = next.get(h);
    i_col++;
  }

  println("Generated ", hexes.size(), " tiles (max ", hexcount, ")");
}

void initGeneration()
{
  hexes.clear();
  open.clear();
  prev.clear();
  next.clear();
  Hex h0 = new Hex(int(random(0,radius-1)),int(random(0,radius-1)),int(random(0,radius-1)));
  Hex h1 = h0.neighbours()[0];
  hexes.put(h0, 0f);
  hexes.put(h1, 1f);
  open.add(h0);
  open.add(h1);
  next.put(h0, h1);
  next.put(h1, h0);
  
  firstHex = h0;
}

boolean step()
{
  //Hex h = open.get(open.size()-1);
  //Hex h = open.size()>1 && random(2)<0? open.get(open.size()-2) : open.get(open.size()-1);
  Hex h = open.get(int(random(max(0,open.size()-open_list_precedence_index),open.size()-1)));
  
  Hex[] candidates = {h.add( next.get(h).sub(h).rotated6(1) ),
                      h.add( next.get(h).sub(h).rotated6(5) )};
  IntList free_candidates = new IntList();
  for(int k = 0; k<candidates.length; k++)
  {
    candidates[k].normalize();

    if (max(candidates[k].x, candidates[k].y, candidates[k].z) <= radius && !hexes.containsKey(candidates[k]))
    {
      free_candidates.append(k);
    }
  }
  
  if(free_candidates.size() >0)
  {
    int i_candidate = free_candidates.get(int(random(free_candidates.size())));//pickRandom(free_neighbours, propagation_probas);
    Hex candidate = candidates[i_candidate];
    //color propagation
    hexes.put(candidate, hexes.get(h) + 1);//(hexes.get(h) + random(1/color_change_randomness, 1*color_change_randomness)));
    open.add(candidate);
    next.put(candidate, next.get(h));
    next.put(h, candidate);

    return true; //i++;
  }
  else
  {
    open.remove(h);
    return false;
  }
}
