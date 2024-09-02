//array de arrays
int[][] coords;
int[] colors;
float[] weights;
float[][] ranges;





void drawLine(int[] coord, int c, float weight, float[] range) {
  stroke(c); // color de la línea
  strokeWeight(weight);
  line(coord[0], coord[1], coord[2], coord[3]);
  
  coord[2] += int(random(range[0], range[1]));
  coord[3] += int(random(range[0], range[1]));
  
  coord[2] = constrain(coord[2], 0, width);
  coord[3] = constrain(coord[3], 0, height);
  
  coord[0] = coord[2];
  coord[1] = coord[3];
}
