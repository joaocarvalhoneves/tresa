void low(int x, int y, float br, float bg, float bb, float h, float s, float b, float redc, float greenc, float bluec) {
  stroke(255,0,0);
  if (dist(width/2, height/2, x, y) > 142 && dist(width/2, height/2, x, y) < 200 &&
    ((h >= 0 && h < 20) || (h > 245 && h < 255)) && s > 100 && redc > 50 && greenc < 80 && bluec < 80) {
    if (br == 252 && bg == 0 && bb == 0) { ellipse(x,y,3,3);   lowVol[0]++; }
    if (br == 250 && bg == 254 && bb == 0) { ellipse(x,y,3,3);  lowVol[1]++;}
    if (br == 0 && bg == 160 && bb == 249) { ellipse(x,y,3,3);  lowVol[2]++;}
    if (br == 0 && bg == 252 && bb == 71) { ellipse(x,y,3,3);   lowVol[3]++;}
    if (br == 252 && bg == 0 && bb == 228) { ellipse(x,y,3,3);  lowVol[4]++;}
  }
}
