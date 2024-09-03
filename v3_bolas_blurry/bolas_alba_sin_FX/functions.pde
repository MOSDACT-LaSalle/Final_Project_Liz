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
