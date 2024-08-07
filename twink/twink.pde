ArrayList<Linea> lineas; // Lista para gestionar múltiples líneas
ArrayList<Ellipse> elipses; // Lista para gestionar las elipses
int maxLineas = 100; // Limitar el número máximo de líneas activas

void setup() {
  size(900, 900);  
  background(0);   // Fondo negro inicial
  
  int numPuntos = int(random(30, 60)); // Reduce el número de puntos para mejorar el rendimiento

  elipses = new ArrayList<Ellipse>();
  for (int i = 0; i < numPuntos; i++) {
    float x = random(width);  // Genera una coordenada x aleatoria
    float y = random(height); // Genera una coordenada y aleatoria
    float size = random(10, 20); // Tamaño aleatorio para las elipses entre 10 y 20 píxeles
    color col = color(random(255), random(255), random(255), 50); // Color aleatorio para la elipse
    elipses.add(new Ellipse(x, y, size, col)); // Añade la elipse a la lista
  }
  
  lineas = new ArrayList<Linea>();
  lineas.add(new Linea(random(width), random(height), random(TWO_PI), color(255))); // Inicializa la primera línea con color blanco
}

void draw() {
  for (Ellipse e : elipses) {
    e.display();
  }
  
  for (int i = lineas.size() - 1; i >= 0; i--) {
    Linea l = lineas.get(i);
    l.update();
    l.display();
    
    if (l.isOffScreen()) {
      lineas.remove(i);
      if (lineas.size() < maxLineas) { // Limita el número de líneas activas para mejorar el rendimiento
        lineas.add(new Linea(random(width), random(height), random(TWO_PI), color(255))); // Genera una nueva línea si toca el borde
      }
    } else {
      for (Ellipse e : elipses) {
        if (e.contains(l.x, l.y)) {
          color newColor = e.col; // Cambia el color de la línea al color del punto
          if (lineas.size() < maxLineas) { // Limita el número de líneas activas para mejorar el rendimiento
            lineas.add(new Linea(l.x, l.y, l.angle + HALF_PI, newColor)); // Nueva línea perpendicular
            lineas.add(new Linea(l.x, l.y, l.angle - HALF_PI, newColor)); // Nueva línea perpendicular en la otra dirección
          }
          lineas.remove(i); // Elimina la línea original
          break;
        }
      }
    }
  }
}

class Linea {
  float x, y;
  float angle;
  float step = 5;
  color col; // Color de la línea
  
  Linea(float x, float y, float angle, color col) {
    this.x = x;
    this.y = y;
    this.angle = angle;
    this.col = col;
  }
  
  void update() {
    float xPrev = x;
    float yPrev = y;
    x += cos(angle) * step;
    y += sin(angle) * step;
  }
  
  void display() {
    stroke(col); // Color de la línea
    line(x, y, x - cos(angle) * step, y - sin(angle) * step);
  }
  
  boolean isOffScreen() {
    return (x < 0 || x > width || y < 0 || y > height);
  }
}

class Ellipse {
  float x, y, size;
  color col; // Color de la elipse
  
  Ellipse(float x, float y, float size, color col) {
    this.x = x;
    this.y = y;
    this.size = size;
    this.col = col;
  }
  
  void display() {
    fill(col); // Color de las elipses
    noStroke(); // Sin borde
    ellipse(x, y, size, size);
  }
  
  boolean contains(float px, float py) {
    float dx = px - x;
    float dy = py - y;
    return sqrt(dx*dx + dy*dy) < size / 2;
  }
}
