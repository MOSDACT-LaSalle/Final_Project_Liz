void setup() {
  size(900, 900);
  background(255);
  
  // Ahora que width y height están definidos, inicio los arrays para que me pille los valores (si no aparece donde quiere)
  coords = new int[][] {
    {width/2, height/2, width/2, height/2}, // Línea 1
    {width/2, height/2, width/2, height/2}, // Línea 2
    {width/2, height/2, width/2, height/2}  // Línea 3
  };
  
  colors = new int[] {color(random(255)), color(200, 80, 100), color(50, 150, 250)};
  weights = new float[] {random(5,10), random(10,20), random(6,9)};
  ranges = new float[][] {{-5, 5}, {-10, 10}, {-7, 7}};
}

void draw() {
  for (int i = 0; i < coords.length; i++) {
    drawLine(coords[i], colors[i], weights[i], ranges[i]);
  }
}
