int x1, y1, x2, y2;
int a1, b1, a2, b2;

void setup() {
 size(900,900);
 background(255);
 
  x1 = width / 2;
  y1 = height / 2;
  x2 = width / 2;
  y2 = height / 2;

  a1 = width / 2;
  b1 = height / 2;
  a2 = width / 2;
  b2 = height / 2;
  
}

void draw() {

linea1();
linea2();
  

}

void linea1(){
  stroke(random(0,255)); //color de la linea
  strokeWeight(random(1,16));
  line(x1, y1, x2, y2);
  
   // Actualiza el segundo punto de la línea de manera aleatoria
  x2 += int(random(-5, 5));
  y2 += int(random(-5, 5));
  
  // Constrain los valores para que la línea no salga de la pantalla
  x2 = constrain(x2, 0, width);
  y2 = constrain(y2, 0, height);
  
  // Mueve el primer punto al segundo punto para la siguiente iteración
  x1 = x2;
  y1 = y2;
}

void linea2(){
  stroke(200,80,100); //color de la linea
  strokeWeight(random(1,16));
  line(a1, b1, a2, b2);
  
   // Actualiza el segundo punto de la línea de manera aleatoria
  a2 += int(random(-10, 10));
  b2 += int(random(-10, 10));
  
  // Constrain los valores para que la línea no salga de la pantalla
  a2 = constrain(a2, 0, width);
  b2 = constrain(b2, 0, height);
  
  // Mueve el primer punto al segundo punto para la siguiente iteración
  a1 = a2;
  b1 = b2;
}
