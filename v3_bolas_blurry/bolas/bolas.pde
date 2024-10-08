/*---------------------------------
 Name: Elisabet Romo Heredia
 Date: Sept 2024
 Tittle:  Esporas en Danza
 Description:
 
 Este proyecto explora el crecimiento orgánico 
 de formas abstractas. Elipses se mueven lentamente por el lienzo, 
 y las líneas, interactúan con estas formas adoptando su color, 
 creando un diálogo visual entre movimiento y transformación. 
 La obra refleja la expansión silenciosa y constante de lo orgánico 
 en un entorno digital.
 
 Links:
 https://www.lipsum.com/feed/html
 https://www.lipsum.com/feed/html
 -----------------------------------*/


int numElipses = 30; // Número de elipses que genera+

float[][] elipseCoords = new float[numElipses][2]; // Coordenadas x, y de cada elipse
float[]   elipseSizes = new float[numElipses]; // Tamaño de cada elipse
int[]     elipseColors = new int[numElipses]; // Color de cada elipse
float[][] elipseVelocities = new float[numElipses][2]; // Vector de movimiento de cada elipse

// Paleta de colores específica

float  op = random(100,150); //opacidad de las elipses
float op1 = random(50, 100);
float op2 = random(100,110);
float op3 = random(10,50);
float op4 = random(10,50);

color[] paletaColores = {
  color(27, 67, 50,  op),
  color(45, 106, 79, op1),
  color(116, 198, 157, op2),
  color(149, 213, 178, op3),
  color(183, 228, 199, op4)
};

// Arrays para las líneas
int[][]   coords;
int[]     colors;  
float[]   weights;
float[][] ranges;

// Buffer gráfico fuera de pantalla
PGraphics buffer;

void setup() {
  size(900, 900);
  
  // Inicializar el buffer fuera de pantalla
  buffer = createGraphics(width, height);
  buffer.beginDraw();
  buffer.background(8, 28, 21);
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
 
  colors = new int[] {color(64, 145, 108), color(64, 145, 108), color(64, 145, 108)};
  weights = new float[] {random(5, 10), random(10, 20), random(6, 9)};
  ranges = new float[][] {{-5, 5}, {-10, 10}, {-7, 7}};
}

void draw() {
  // Limpiar el lienzo principal
  background(8, 28, 21);
  
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

// Función para dibujar elipses borrosas
void drawBlurryEllipse(float x, float y, float size, color c) {
  noStroke();
  for (int i = 0; i < 10; i++) {
    float alpha = map(i, 0, 9, 20, 5); //ultimos dos num maxima opacidad y minima opacidad
    float s = size + i * 10; // Aumentar ligeramente el tamaño en cada paso
    fill(c, alpha);
    ellipse(x, y, s, s);
  }
}
