int numElipses = 30; // Número de elipses que deseas generar

float[][] elipseCoords = new float[numElipses][2]; // Para almacenar las coordenadas x, y de cada elipse
float[] elipseSizes = new float[numElipses]; // Para almacenar el tamaño de cada elipse
int[] elipseColors = new int[numElipses]; // Para almacenar el color de cada elipse



// Paleta de colores específica
color[] paletaColores = {
  color(27, 67, 50, 70),
  color(45, 106, 79, 70),
  color(116, 198, 157, 70),
  color(149, 213, 178, 70),
  color(183, 228, 199, 70)

};

// Arrays para las líneas
int[][] coords;
int[] colors;
float[] weights;
float[][] ranges;

void setup() {
  size(900, 900);
  background(8, 28, 21);
  
  // Inicializar propiedades de las elipses
  for (int i = 0; i < numElipses; i++) {
    elipseCoords[i][0] = random(width);  // Posición x
    elipseCoords[i][1] = random(height); // Posición y
    elipseSizes[i] = random(50, 90);    // Tamaño
    
    // Asignar un color aleatorio de la paleta
    elipseColors[i] = paletaColores[int(random(paletaColores.length))];
  }
  
  // Inicializar las líneas
  coords = new int[][] {
    {width/2, height/2, width/2, height/2}, // Línea 1
    {width/2, height/2, width/2, height/2}, // Línea 2
    {width/2, height/2, width/2, height/2}  // Línea 3
  };
  
  colors = new int[] {color(64, 145, 108, 70), color(64, 145, 108, 70), color(64, 145, 108, 70)};
  weights = new float[] {random(5, 10), random(10, 20), random(6, 9)};
  ranges = new float[][] {{-5, 5}, {-10, 10}, {-7, 7}};
}

void draw() {
  // Dibujar las elipses sin contorno
  noStroke();
  for (int i = 0; i < numElipses; i++) {
    fill(elipseColors[i]);
    ellipse(elipseCoords[i][0], elipseCoords[i][1], elipseSizes[i], elipseSizes[i]);
  }
  
  // Dibujar las líneas por encima de las elipses
  for (int i = 0; i < coords.length; i++) {
    drawLine(coords[i], i, weights[i], ranges[i]);
  }
}

void drawLine(int[] coord, int index, float weight, float[] range) {
  // Verificar si la línea toca alguna elipse
  for (int i = 0; i < numElipses; i++) {
    if (isPointInsideEllipse(coord[2], coord[3], elipseCoords[i][0], elipseCoords[i][1], elipseSizes[i])) {
      colors[index] = elipseColors[i]; // Cambiar color de la línea al color de la elipse tocada
      break; // Termina la búsqueda al encontrar la primera colisión
    }
  }
  
  stroke(colors[index]); // Usar el color actualizado de la línea
  strokeWeight(weight);
  line(coord[0], coord[1], coord[2], coord[3]);
  
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
