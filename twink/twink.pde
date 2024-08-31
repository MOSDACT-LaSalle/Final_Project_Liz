ArrayList<Linea> lineas; // Lista para gestionar múltiples líneas
ArrayList<Ellipse> elipses; // Lista para gestionar las elipses
int maxLineas = 20; // Limitar el número máximo de líneas activas

void setup() {
  size(900, 900);
  background(0); // Fondo negro inicial
  strokeWeight(1);
  
  int numPuntos = int(random(30, 60)); // Número de puntos aleatorio

  elipses = new ArrayList<Ellipse>();
  for (int i = 0; i < numPuntos; i++) {
    float x = random(width);  // Coordenada x aleatoria
    float y = random(height); // Coordenada y aleatoria
    float size = random(30, 50); // Tamaño aleatorio para las elipses
    color col = color(random(255), random(255), random(255)); // Color aleatorio para la elipse
    elipses.add(new Ellipse(x, y, size, col)); // Añade la elipse a la lista
  }
  
  lineas = new ArrayList<Linea>();
  lineas.add(new Linea(random(width), random(height), random(TWO_PI), color(255))); // Línea inicial blanca
}

void draw() {
  // No borrar el fondo, para que las líneas permanezcan en la pantalla
  
  // Dibuja las elipses
  for (Ellipse e : elipses) {
    e.display();
  }
  
  ArrayList<Linea> nuevasLineas = new ArrayList<Linea>(); // Lista temporal para nuevas líneas

  for (int i = lineas.size() - 1; i >= 0; i--) {
    Linea l = lineas.get(i);
    l.update();
    l.display();
    
    // Verifica si la línea se ha salido de la pantalla
    if (l.isOffScreen()) {
      lineas.remove(i); // Elimina la línea si sale de la pantalla

      // Solo agrega una nueva línea si hay espacio en maxLineas
      if (lineas.size() + nuevasLineas.size() < maxLineas) {
        nuevasLineas.add(new Linea(random(width), random(height), random(TWO_PI), color(255)));
      }
      
      continue; // Salta al siguiente ciclo
    }
    
    boolean colisiono = false; // Marca si se produce una colisión

    // Verificar colisiones con las elipses
    for (Ellipse e : elipses) {
      if (e.contains(l.x, l.y)) {
        // Si ocurre una colisión, generar nuevas líneas y eliminar la línea original
        color newColor = e.col; // Cambia el color de la línea al del círculo

        // Crea dos nuevas líneas en ángulos ligeramente distintos
        if (lineas.size() + nuevasLineas.size() + 2 <= maxLineas) {
          nuevasLineas.add(new Linea(l.x, l.y, l.angle + HALF_PI + random(-QUARTER_PI, QUARTER_PI), newColor));
          nuevasLineas.add(new Linea(l.x, l.y, l.angle - HALF_PI + random(-QUARTER_PI, QUARTER_PI), newColor));
        } else if (lineas.size() + nuevasLineas.size() + 1 <= maxLineas) {
          nuevasLineas.add(new Linea(l.x, l.y, l.angle + HALF_PI + random(-QUARTER_PI, QUARTER_PI), newColor));
        }

        lineas.remove(i); // Elimina la línea original después de la colisión
        colisiono = true; // Marca que ocurrió una colisión
        break; // Salir del bucle de colisiones para que no se procesen múltiples colisiones en un solo frame
      }
    }

    if (colisiono) {
      break; // Salir del bucle principal de la línea si ocurrió una colisión
    }
  }

  // Añadir las nuevas líneas generadas por colisiones o cuando una línea sale de la pantalla
  lineas.addAll(nuevasLineas);

  fondo(); // Esta función sigue vacía, pero puedes llenarla si es necesario
}

class Linea {
  float x, y;
  float prevX, prevY; // Posiciones anteriores
  float angle;
  float step = 5;
  color col; // Color de la línea
  
  Linea(float x, float y, float angle, color col) {
    this.x = x;
    this.y = y;
    this.angle = angle;
    this.col = col;
    this.prevX = x;
    this.prevY = y;
  }
  
  void update() {
    prevX = x; // Guarda la posición anterior
    prevY = y;
    x += cos(angle) * step;
    y += sin(angle) * step;
  }
  
  void display() {
    stroke(col); // Color de la línea
    line(prevX, prevY, x, y); // Dibuja la línea desde la posición anterior hasta la actual
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

void fondo(){
  // Vacía, podrías eliminarla o llenarla si necesitas un fondo dinámico
}
