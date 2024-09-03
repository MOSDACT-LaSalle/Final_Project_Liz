void initEllipses() {
  // Inicializar propiedades de las elipses
  for (int i = 0; i < numElipses; i++) {
    elipseCoords[i][0] = random(width);  // Posición x
    elipseCoords[i][1] = random(height); // Posición y
    elipseSizes[i] = random(tam_min, tam_max);     // Tamaño

    elipseSizes_ellipses[i] = random(tam_min_ellipses, tam_max_ellipses);
    // Asignar un color aleatorio de la paleta
    elipseColors[i] = paletaColores[int(random(paletaColores.length))];

    // Asignar una dirección de movimiento aleatoria (velocidad pequeña para movimiento lento)
    elipseVelocities[i][0] = random(-1, 1); // Velocidad en x
    elipseVelocities[i][1] = random(-1, 1); // Velocidad en y
  }
}

void renderEllipses() {
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
    drawBlurryEllipse(elipseCoords[i][0], elipseCoords[i][1], elipseSizes_ellipses[i], elipseColors[i]);
  }
}

// Función para dibujar elipses borrosas
void drawBlurryEllipse(float x, float y, float size, color c) {
  buffer_ellipses.beginDraw();
  buffer_ellipses.noStroke();
  for (int i = 0; i < numElipses; i++) {

    float alpha = map(i, 0, numElipses, 5, 100); //ultimos dos num maxima opacidad y minima opacidad
    float s = size + i ; // Aumentar ligeramente el tamaño en cada paso
    buffer_ellipses.fill(c, alpha);

    buffer_ellipses.ellipse(x, y, s, s);
  }
  buffer_ellipses.endDraw();
}
