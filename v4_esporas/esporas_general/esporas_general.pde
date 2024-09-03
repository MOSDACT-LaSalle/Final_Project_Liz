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

/*----------------- LIBRERIAS---------------*/

/* postFX*/
//https://github.com/cansik/processing-postfx
import ch.bildspur.postfx.builder.*;
import ch.bildspur.postfx.pass.*;
import ch.bildspur.postfx.*;

PostFX fx; // a simple way
PostFXSupervisor supervisor; // a complex way (see library examples)
BrightPass brightPass;
SobelPass sobelPass;

float tam_min=2;
float tam_max = 10; //tamamños de las lines

float tam_min_ellipses=1;
float tam_max_ellipses = 15; //tamamños de las ellipses( si están separados tienes mas control de cada tamaño, antes estaban con el mismo parametro)

int numElipses = 50; // Número de elipses que genera+

float[][] elipseCoords = new float[numElipses][2]; // Coordenadas x, y de cada elipse
float[]   elipseSizes = new float[numElipses]; // Tamaño de cada elipse
float[]   elipseSizes_ellipses = new float[numElipses]; // Tamaño de cada elipse
int[]     elipseColors = new int[numElipses]; // Color de cada elipse
float[][] elipseVelocities = new float[numElipses][2]; // Vector de movimiento de cada elipse

// Paleta de colores específica

float  op = random(100, 150); //opacidad de las elipses
float op1 = random(50, 100);
float op2 = random(100, 110);
float op3 = random(10, 50);
float op4 = random(10, 50);

color[] paletaColores = {
  color(27, 67, 50, op),
  color(45, 106, 79, op1),
  color(116, 198, 157, op2),
  color(202, 229, 168, op3),
  color(183, 228, 199, op4)
};

// Arrays para las líneas
int[][]   coords;
int[]     colors;
float[]   weights;
float[][] ranges;

// Buffer gráfico fuera de pantalla
PGraphics buffer;

// Buffer gráfico fuera de pantalla para ellipses
PGraphics buffer_ellipses;
void setup() {
  size(900, 900, P3D); //createGraphics() with P2D requires size() to use P2D or P3D
  fx = new PostFX(this);
  // create supervisor and load shaders
  supervisor = new PostFXSupervisor(this);
  brightPass = new BrightPass(this, 0.1f);
  sobelPass = new SobelPass(this);
  // Inicializar el buffer fuera de pantalla
  buffer = createGraphics(width, height);
  buffer_ellipses = createGraphics(width, height);
  buffer.beginDraw();
  buffer.background(8, 28, 21);
  buffer.endDraw();

  initEllipses();

  initLines();

  colors = new int[] {color(64, 145, 108), color(64, 145, 108), color(64, 145, 108)};
  weights = new float[] {random(5, 10), random(10, 20), random(6, 9)};
  ranges = new float[][] {{-5, 5}, {-10, 10}, {-7, 7}};
}

void draw() {
  // Limpiar el lienzo principal
  buffer_ellipses.beginDraw();
  buffer_ellipses.clear(); //clear de background buffers
  buffer_ellipses.endDraw();
  // Dibujar los trazos (líneas) en el buffer
  
  /* drawLines */
  
  for (int i = 0; i < coords.length; i++) {
    drawLine(coords[i], i, weights[i], ranges[i]);
  }
  renderEllipses();
  
  
  /* POSTfx AND draw in screen processing sketch  */
  blendMode(BLEND); // blending for the postFX
  // Mostrar el buffer (con trazos) en el lienzo principal
  image(buffer, 0, 0);
 blendMode(SCREEN);
  /*fx.render(buffer)
   .brightPass(4)
   .blur(20, 10)
   .compose();*/
  // add white ring around sphere
  blendMode(SCREEN);
  supervisor.render(buffer);
  supervisor.pass(brightPass);
  supervisor.pass(sobelPass);
  supervisor.compose();
  


  blendMode(BLEND); // blending for the postFX
  image(buffer_ellipses, 0, 0);
  blendMode(SCREEN);
  fx.render(buffer_ellipses)
    .brightPass(0.001)
    .blur(1, 2)
    .compose();
}
