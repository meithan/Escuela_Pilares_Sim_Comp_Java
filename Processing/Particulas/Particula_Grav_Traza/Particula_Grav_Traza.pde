class Particula {
  
  PVector posicion;
  PVector velocidad;
  ArrayList<PVector> traza;
  
  float R = 10;
  int max_traza = 25;
  color c = color(0, 0, 255);

  Particula(float x, float y, float vx, float vy) {
    posicion = new PVector(x, y);
    velocidad = new PVector(vx, vy);
    traza = new ArrayList<PVector>();
  }

  void update() {
    
    // Actualizamos la velocidad vertical
    velocidad.y += g*dt;
    
    // Rebota contras las paredes
    if (posicion.x < R || posicion.x > width - R) {
      velocidad.x *= -1;
      posicion.x = constrain(posicion.x, R, width - R);
    }
    if (posicion.y < R || posicion.y > height - R) {
      velocidad.y *= -1;
      posicion.y = constrain(posicion.y, R, height - R);
    }    
    
    // Movemos la partícula
    posicion.add(velocidad.mult(dt));

    // Guardamos la posición
    traza.add(posicion.copy());
    if (traza.size() > max_traza) {
      traza.remove(0);
    } 
    
  }

  void display() {
    for (int i = 0; i < traza.size(); i++) {
      float alpha = map(i, 0, traza.size(), 0, 255);
      fill(red(c), green(c), blue(c), alpha * 0.5); // Transparent trail
      float size = map(i, 0, traza.size(), R * 0.4, R * 1.2);
      PVector p = traza.get(i);
      circle(p.x, p.y, size);
    }    
    fill(0, 0, 255);
    noStroke();
    circle(posicion.x, posicion.y, 2*R);
  }

}

// Variables globales
Particula part;
float dt = 1.0;
float g = 0.1;

void setup() {
  size(800, 800);
  
  float vel = 10;
  float dir = random(0, 2*PI);
  float vx = vel * cos(dir);
  float vy = vel * sin(dir);
  part = new Particula(width/2, height/2, vx, vy);  

}

void draw() {
  background(255);
  part.update();
  part.display();
}
