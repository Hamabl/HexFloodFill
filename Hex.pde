
class Hex
{
  public int x;
  public int y;
  public int z;
  
  public Hex(int _x, int _y, int _z)
  {
    x =_x; y=_y; z=_z;
  }

  public Hex add(Hex h)
  {
    return new Hex(x+h.x, y+h.y, z+h.z);
  }
  public Hex sub(Hex h)
  {
    return new Hex(x-h.x, y-h.y, z-h.z);
  }
  public Hex rotated6(int n)
  {
    Hex res = new Hex(int((n+4)%6/3)*x + int((n+0)%6/3)*y + int((n+2)%6/3)*z,
                      int((n+2)%6/3)*x + int((n+4)%6/3)*y + int((n+0)%6/3)*z,
                      int((n+0)%6/3)*x + int((n+2)%6/3)*y + int((n+4)%6/3)*z);
    return res;
    /*
    X = 1,0,0 : 0       1       2       3       4       5
              1,0,0   1,1,0   0,1,0   0,1,1   0,0,1   1,0,1
          x =   1       1       0       0       0       1   = (n+4)%6//3
          y =   0       1       1       1       0       0   = (n+2)%6//3
          z =   0       0       0       1       1       1   = (n+0)%6//3
    */
  }
  
  public Hex[] neighbours()
  {
    Hex[] n = new Hex[6];
    n[0] = new Hex(x+1, y  , z  );
    n[1] = new Hex(x+1, y+1, z  );
    n[2] = new Hex(x  , y+1, z  );
    n[3] = new Hex(x  , y+1, z+1);
    n[4] = new Hex(x  , y  , z+1);
    n[5] = new Hex(x+1, y  , z+1);
    
    return n;
  }
  
  public Hex[] neighboursRotated()
  {
    Hex[] n = new Hex[6];
    int shift = (6-getQuadrant());
    n[(0+shift)%6] = new Hex(x+1, y  , z  );
    n[(1+shift)%6] = new Hex(x+1, y+1, z  );
    n[(2+shift)%6] = new Hex(x  , y+1, z  );
    n[(3+shift)%6] = new Hex(x  , y+1, z+1);
    n[(4+shift)%6] = new Hex(x  , y  , z+1);
    n[(5+shift)%6] = new Hex(x+1, y  , z+1);
    
    return n;
  }
  
  public int getQuadrant()
  {
    if     (x >= y && y >= z)
      return 0;
    else if(y >= x && x >= z)
      return 1;
    else if(y >= z && z >= x)
      return 2;
    else if(z >= y && y >= x)
      return 3;
    else if(z >= x && x >= y)
      return 4;
    else
      return 5;
  }
  
  public void normalize()
  {
    if(x <= y && x <= z)
    {
      y -= x;
      z -= x;
      x = 0;
    }
    else if(y <= x && y <= z)
    {
      x -= y;
      z -= y;
      y = 0;
    }
    else if(z <= x && z <= y)
    {
      x -= z;
      y -= z;
      z = 0;
    }
  }
  
  @Override
  public boolean equals(Object obj)
  {
    if (this == obj)
        return true;
    else if (obj == null)
        return false;
    else if (obj instanceof Hex)
    {
      Hex h = (Hex) obj;
      return (x-y == h.x-h.y) && (y-z == h.y-h.z) && (z-x == h.z-h.x);
    }
    return false;
  }
  
  @Override
  public int hashCode()
  {
    normalize();
    return x + y*256 + z*65536;
  }
  
  @Override
  public String toString() {
    normalize();
    return "(" + x + "," + y + "," + z + ")";
  }
}
