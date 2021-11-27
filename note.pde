class Note {
  float freq;
  float vol;
  float max;

  Note(float freq, float vol) {
    this.freq = freq;
    this.vol = vol;
  }

  void setFreq(float a) {
    freq = lerp (freq, a, 0.1);
  }

  void setVol(float a) {
    vol = lerp(vol, a, 0.02);
  }

  void setMax(float a) {
    max = a;
  }

  float getVol() {
    return vol;
  }

  float getFreq() {
    return freq;
  }

  float getMax() {
    return max;
  }
}
