void refreshSeq() {
  int pos [] = new int [sequenceSize];
  int last = 0;
  for (int i = 0; i < sequenceSize; i++) {
    for (int j = last; j < note.size(); j++) {
      if (note.get(j).getFreq() > 0.01) {
        pos[i] = j;
        last = j + 1;
        break;
      }
    }
  }
  for (int i = 0; i < sequenceSize; i++) {
    noteSeq[i] = note.get(pos[i]).getMax();
  }

  if (sequenceSize > 0) {
    for (int i = 0; i < sequenceSize; i++) {
      note2msg.add(noteSeq[i]);
    }
  }
  sequencemsg.add(sequenceSize);

  if (abs(metScan - metFinal) > 20) {
    oscP5.send(sequencemsg, Remote);
    oscP5.send(note2msg, Remote); 
    oscP5.send(metmsg, Remote);
    metFinal = metScan;
  }

  if (metFinal < 62) { 
    oscP5.send(metmsg, Remote); 
    oscP5.send(metmsg, Remote);
  }
}
