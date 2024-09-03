/*---------------------------------
 Name: Donec dignissim elementum
 Date: Sept 2024
 Tittle:  Sed laoreet dolor eu ur
 Description:
 
 It was popularised in the 1960s with the release of
 Letraset sheets containing Lorem Ipsum passages,
 and more recently with desktop publishing
 software like Aldus PageMaker including versions
 of Lorem Ipsum
 Links:
 https://www.lipsum.com/feed/html
 https://www.lipsum.com/feed/html
 -----------------------------------*/

/*----------------- LIBRERIAS---------------*/

/* postFX*/
//https://github.com/cansik/processing-postfx
/*import ch.bildspur.postfx.builder.*;
import ch.bildspur.postfx.pass.*;
import ch.bildspur.postfx.*;*/

/*PostFX fx; // a simple way
PostFXSupervisor supervisor; // a complex way (see library examples)
BrightPass brightPass;
SobelPass sobelPass;*/

float tam_min=2;
float tam_max = 6; //tamamños de las lines

float tam_min_ellipses=1;
float tam_max_ellipses = 3; //tamamños de las ellipses( si están separados tienes mas control de cada tamaño, antes estaban con el mismo parametro)

int numElipses = 30; // Número de elipses que genera+

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
  color(220, 99, 140, op),
  color(164, 131, 159, op1),
  color(206, 169, 161, op2),
  color(225, 200, 193, op3),
  color(243, 232, 226, op4)
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
  /*fx = new PostFX(this);
  // create supervisor and load shaders
  supervisor = new PostFXSupervisor(this);
  brightPass = new BrightPass(this, 0.1f);
  sobelPass = new SobelPass(this);*/
  // Inicializar el buffer fuera de pantalla
  buffer = createGraphics(width, height);
  buffer_ellipses = createGraphics(width, height);
  buffer.beginDraw();
  buffer.background(30, 30, 62);
  buffer.endDraw();

  initEllipses();

  initLines();

  colors = new int[] {color(67, 73, 112), color(67, 73, 112), color(67, 73, 112)};
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
  /*blendMode(SCREEN);
  supervisor.render(buffer);
  supervisor.pass(brightPass);
  supervisor.pass(sobelPass);
  supervisor.compose();*///
  


  //blendMode(BLEND); // blending for the postFX
  image(buffer_ellipses, 0, 0);
  /*blendMode(SCREEN);
  fx.render(buffer_ellipses)
    .brightPass(0.001)
    .blur(1, 2)
    .compose();*/
}
