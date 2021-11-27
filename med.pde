void med(int x, int y, float br, float bg, float bb, float h, float s, float b, float redc, float greenc, float bluec) {
  stroke(0,0,255);
  if (dist(width/2, height/2, x, y) > 142 && dist(width/2, height/2, x, y) < 225 && 
      h > 150 && h < 171 && s > 200 && bluec > 50  && redc < 150 && greenc < 150){
    if (br == 252 && bg == 0 && bb == 0){ ellipse(x,y,3,3);    medVol[0]++;} 
    if (br == 250 && bg == 254 && bb == 0){ ellipse(x,y,3,3);  medVol[1]++;}
    if (br == 0 && bg == 160 && bb == 249){ ellipse(x,y,3,3);  medVol[2]++;}
    if (br == 0 && bg == 252 && bb == 71){ ellipse(x,y,3,3);   medVol[3]++;}
    if (br == 252 && bg == 0 && bb == 228){ ellipse(x,y,3,3);  medVol[4]++;}
  }
}
