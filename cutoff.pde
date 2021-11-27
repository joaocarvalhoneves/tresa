void cutoff(int x, int y, float h){
if(dist(width/2, height/2, x, y) > 65 && dist(width/2, height/2, x, y) < 142 &&
(((h > 0.5 && h < 20) || (h > 245 && h < 255)) || (h > 140 && h < 163) || (h > 90 && h < 105))) {
      cutoffScan++;
    }
}
