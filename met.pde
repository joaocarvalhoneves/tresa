void met(int x, int y, float h, float b){
  if (dist(width/2, height/2, x, y) < 65 &&
(((h > 0.5 && h < 10) || (h > 245 && h < 255)) || (h > 100 && h < 163) || (h > 90 && h < 105)) && b < 200) {
    metScan++;
    stroke(255,150,0);
    ellipse(x,y,3,3);
  }
}
