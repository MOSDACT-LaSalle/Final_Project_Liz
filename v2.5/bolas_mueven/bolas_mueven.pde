int numElipses = 30; // Número de elipses que deseas generar

float[][] elipseCoords = new float[numElipses][2]; // Coordenadas x, y de cada elipse
float[] elipseSizes = new float[numElipses]; // Tamaño de cada elipse
int[] elipseColors = new int[numElipses]; // Color de cada elipse
float[][] elipseVelocities = new float[numElipses][2]; // Vector de movimiento de cada elipse

PGraphics pg; // Canvas separado para las líneas

// Paleta de colores específica
color[] paletaColores = {
  color(220, 99, 140, 70),
  color(164, 131, 159, 70),
  color(206, 169, 161, 70),
  color(225, 200, 193, 70),
  color(243, 232, 226, 70)
};

// Arrays para las líneas
int[][] coords;
int[] colors;
float[] weights;
float[][] ranges;

void setup() {
  size(900, 900);
  background(30, 30, 62); // Fondo inicial
  
  // Inicializar PGraphics
  pg = createGraphics(width, height);
  pg.beginDraw();
  pg.background(30, 30, 62); // Mismo fondo para las líneas
  pg.endDraw();
  
  // Inicializar propiedades de las elipses
  for (int i = 0; i < numElipses; i++) {
    elipseCoords[i][0] = random(width);  // Posición x
    elipseCoords[i][1] = random(height); // Posición y
    elipseSizes[i] = random(50, 90);     // Tamaño
    
    // Asignar un color aleatorio de la paleta
    elipseColors[i] = paletaColores[int(random(paletaColores.length))];
    
    // Asignar una dirección de movimiento aleatoria (velocidad pequeña para movimiento lento)
    elipseVelocities[i][0] = random(-1, 1); // Velocidad en x
    elipseVelocities[i][1] = random(-1, 1); // Velocidad en y
  }
  
  // Inicializar las líneas
  coords = new int[][] {
    {width/2, height/2, width/2, height/2}, // Línea 1
    {width/2, height/2, width/2, height/2}, // Línea 2
    {width/2, height/2, width/2, height/2}  // Línea 3
  };
  
  colors = new int[] {color(67, 73, 112, 70), color(67, 73, 112, 70), color(67, 73, 112, 70)};
  weights = new float[] {random(5, 10), random(10, 20), random(6, 9)};
  ranges = new float[][] {{-5, 5}, {-10, 10}, {-7, 7}};
}

void draw() {
  background(30, 30, 62); // Redibujar el fondo para borrar el rastro de las elipses
  
  // Dibujar las líneas almacenadas en PGraphics
  image(pg, 0, 0);
  
  // Actualizar y dibujar las elipses
  noStroke();
  for (int i = 0; i < numElipses; i++) {
    // Actualizar la posición de la elipse
    elipseCoords[i][0] += elipseVelocities[i][0];
    elipseCoords[i][1] += elipseVelocities[i][1];
    
    // Rebotar si llega al borde del canvas
    if (elipseCoords[i][0] <= 0 || elipseCoords[i][0] >= width) {
      elipseVelocities[i][0] *= -1;
    }
    if (elipseCoords[i][1] <= 0 || elipseCoords[i][1] >= height) {
      elipseVelocities[i][1] *= -1;
    }
    
    // Dibujar la elipse
    fill(elipseColors[i]);
    ellipse(elipseCoords[i][0], elipseCoords[i][1], elipseSizes[i], elipseSizes[i]);
  }
  
  // Dibujar las líneas nuevas en PGraphics
  pg.beginDraw();
  for (int i = 0; i < coords.length; i++) {
    drawLine(coords[i], i, weights[i], ranges[i], pg);
  }
  pg.endDraw();
}

void drawLine(int[] coord, int index, float weight, float[] range, PGraphics pg) {
  // Verificar si la línea toca alguna elipse
  for (int i = 0; i < numElipses; i++) {
    if (isPointInsideEllipse(coord[2], coord[3], elipseCoords[i][0], elipseCoords[i][1], elipseSizes[i])) {
      colors[index] = elipseColors[i]; // Cambiar color de la línea al color de la elipse tocada
      break; // Termina la búsqueda al encontrar la primera colisión
    }
  }
  
  pg.stroke(colors[index]); // Usar el color actualizado de la línea
  pg.strokeWeight(weight);
  pg.line(coord[0], coord[1], coord[2], coord[3]);
  
  // Actualizar las coordenadas para la siguiente iteración
  coord[2] += int(random(range[0], range[1]));
  coord[3] += int(random(range[0], range[1]));
  
  coord[2] = constrain(coord[2], 0, width);
  coord[3] = constrain(coord[3], 0, height);
  
  coord[0] = coord[2];
  coord[1] = coord[3];
}

// Función para comprobar si un punto está dentro de una elipse
boolean isPointInsideEllipse(float px, float py, float ex, float ey, float esize) {
  float dx = px - ex;
  float dy = py - ey;
  return (dx*dx)/(esize*esize/4) + (dy*dy)/(esize*esize/4) <= 1;
}
