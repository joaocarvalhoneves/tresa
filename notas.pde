void notasini() {
  note.get(0).setMax(130.81);
  note.get(1).setMax(146.83);  
  note.get(2).setMax(164.81);  
  note.get(3).setMax(174.61);  
  note.get(4).setMax(196);  
  note.get(5).setMax(220);  
  note.get(6).setMax(246.94);  
  note.get(7).setMax(261.63);
  note.get(8).setMax(293.66);  
  note.get(9).setMax(329.63);  
  note.get(10).setMax(349.23);  
  note.get(11).setMax(392);
  note.get(12).setMax(440);
  note.get(13).setMax(493.88);
  note.get(14).setMax(523.25);
}

void notas() {
  for (int i = 0; i < 15; i++) {
    if (note.get(i).getVol() > 0.01)
      note.get(i).setFreq(note.get(i).getMax()); 
    else note.get(i).setFreq(0);
  }
}
