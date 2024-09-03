// Número de elipses a generar
int numElipses = 30;

float[][] elipseCoords = new float[numElipses][2]; // Coordenadas x, y de cada elipse
float[] elipseSizes = new float[numElipses]; // Tamaño de cada elipse
int[] elipseColors = new int[numElipses]; // Color de cada elipse
float[][] elipseVelocities = new float[numElipses][2]; // Vector de movimiento de cada elipse

// Paleta de colores específica
color[] paletaColores = {
  color(220, 99, 140),
  color(164, 131, 159),
  color(206, 169, 161),
  color(225, 200, 193),
  color(243, 232, 226)
};

// Arrays para las líneas
int[][] coords;
int[] colors;
float[] weights;
float[][] ranges;

// Buffer gráfico fuera de pantalla
PGraphics buffer;

void setup() {
  size(900, 900);
  
  // Inicializar el buffer fuera de pantalla
  buffer = createGraphics(width, height);
  buffer.beginDraw();
  buffer.background(30, 30, 62);
  buffer.endDraw();
  
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
 
  colors = new int[] {color(67, 73, 112), color(67, 73, 112), color(67, 73, 112)};
  weights = new float[] {random(5, 10), random(10, 20), random(6, 9)};
  ranges = new float[][] {{-5, 5}, {-10, 10}, {-15, 15}};
}

void draw() {
  // Limpiar el lienzo principal
  background(30, 30, 62);
  
  // Dibujar los trazos (líneas) en el buffer
  buffer.beginDraw();
  for (int i = 0; i < coords.length; i++) {
    drawLine(coords[i], i, weights[i], ranges[i]);
  }
  buffer.endDraw();
  
  // Mostrar el buffer (con trazos) en el lienzo principal
  image(buffer, 0, 0);

  // Dibujar las elipses en el lienzo principal (no dejarán rastro)
  for (int i = 0; i < numElipses; i++) {
    // Actualizar la posición de la elipse
    elipseCoords[i][0] += elipseVelocities[i][0];
    elipseCoords[i][1] += elipseVelocities[i][1];
    
    // Rebotar si llega al borde del lienzo
    if (elipseCoords[i][0] <= 0 || elipseCoords[i][0] >= width) {
      elipseVelocities[i][0] *= -1;
    }
    if (elipseCoords[i][1] <= 0 || elipseCoords[i][1] >= height) {
      elipseVelocities[i][1] *= -1;
    }
    
    // Dibujar la elipse borrosa
    drawBlurryEllipse(elipseCoords[i][0], elipseCoords[i][1], elipseSizes[i], elipseColors[i]);
  }
}

void drawLine(int[] coord, int index, float weight, float[] range) {
  // Verificar si la línea toca alguna elipse
  for (int i = 0; i < numElipses; i++) {
    if (isPointInsideEllipse(coord[2], coord[3], elipseCoords[i][0], elipseCoords[i][1], elipseSizes[i])) {
      colors[index] = elipseColors[i]; // Cambiar el color de la línea al color de la elipse tocada
      break; // Terminar la búsqueda al encontrar la primera colisión
    }
  }
  
  // Dibujar la línea en el buffer
  buffer.stroke(colors[index], 70); // Usar el color actualizado de la línea con algo de transparencia
  buffer.strokeWeight(weight);
  buffer.line(coord[0], coord[1], coord[2], coord[3]);
  
  // Actualizar las coordenadas para la siguiente iteración
  coord[2] += int(random(range[0], range[1]));
  coord[3] += int(random(range[0], range[1]));
  
  coord[2] = constrain(coord[2], 0, width);
  coord[3] = constrain(coord[3], 0, height);
  
  coord[0] = coord[2];
  coord[1] = coord[3];
}

// Función para comprobar si un punto está dentro de una elipse (ajustado para tamaños de elipse variables)
boolean isPointInsideEllipse(float px, float py, float ex, float ey, float esize) {
  float dx = px - ex;
  float dy = py - ey;
  
  // Escalar los radios para las dimensiones variables de las elipses
  float rx = esize / 2;
  float ry = esize / 2;
  
  // Normalizar el punto respecto a los radios de la elipse
  return (dx * dx) / (rx * rx) + (dy * dy) / (ry * ry) <= 1;
}

// Nueva función para dibujar elipses borrosas
void drawBlurryEllipse(float x, float y, float size, color c) {
  noStroke();
  for (int i = 0; i < 5; i++) {
    float alpha = map(i, 0, 4, 30, 25); //ultimos dos num maxima opacidad y minima opacidad
    float s = map(i, 0, 4, size, size * 1.2);
    fill(c, alpha);
    ellipse(x, y, s, s);
  }
}
