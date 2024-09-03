void initLines() {
  // Inicializar las líneas
  coords = new int[][] {
    {width/2, height/2, width/2, height/2}, // Línea 1
    {width/2, height/2, width/2, height/2}, // Línea 2
    {width/2, height/2, width/2, height/2}  // Línea 3
  };
}

void drawLine(int[] coord, int index, float weight, float[] range) {
  buffer.beginDraw(); // estaba fuera de la funcion pero es mas limpio  asi porque queda encapsulado todo
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
  buffer.endDraw();
  // Actualizar las coordenadas para la siguiente iteración
  coord[2] += int(random(range[0], range[1]));
  coord[3] += int(random(range[0], range[1]));

  coord[2] = constrain(coord[2], 0, width);
  coord[3] = constrain(coord[3], 0, height);

  coord[0] = coord[2];
  coord[1] = coord[3];
}
