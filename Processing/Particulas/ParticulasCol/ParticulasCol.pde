class Particula {
  
  PVector posicion;
  PVector velocidad;
  ArrayList<PVector> traza;
  
  float R = 100;
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

  // Checa colision con otra partícula
  void checar_colision(Particula otra) {
    
    PVector diff = PVector.sub(posicion, otra.posicion);
    float dist = diff.mag();
    float min_dist = R + otra.R;

    if (dist < min_dist && dist > 0) {
      PVector collisionNormal = diff.copy().normalize();

      // Ajustamos las partículas para que apenas se estén tocando
      float overlap = (min_dist - dist) / 2;
      posicion.add(collisionNormal.copy().mult(overlap));
      otra.posicion.sub(collisionNormal.copy().mult(overlap));

      PVector relativeVelocity = PVector.sub(velocidad, otra.velocidad);
      float velAlongNormal = relativeVelocity.dot(collisionNormal);

      if (velAlongNormal > 0) return;

      float impulse = (2 * velAlongNormal) / 2;
      PVector impulseVector = collisionNormal.mult(impulse);

      velocidad.sub(impulseVector);
      otra.velocidad.add(impulseVector);

    }

  }

  void display() {
    //for (int i = 0; i < traza.size(); i++) {
    //  float alpha = map(i, 0, traza.size(), 0, 255);
    //  fill(red(c), green(c), blue(c), alpha * 0.5); // Transparent trail
    //  float size = map(i, 0, traza.size(), R * 0.4, R * 1.2);
    //  PVector p = traza.get(i);
    //  circle(p.x, p.y, size);
    //}    
    fill(0, 0, 255);
    noStroke();
    circle(posicion.x, posicion.y, 2*R);
  }

}

// Variables globales
ArrayList<Particula> particulas;
int num_particulas = 2;
float dt = 1.0;
float g = 0.0;

void setup() {
  
  size(800, 800);
  
  float vel = 10;
  particulas = new ArrayList<Particula>();
  for (int i = 0; i < num_particulas; i++) {
    float x = random(0, width);
    float y = random(0, height);
    float dir = random(0, 2*PI);
    float vx = vel * cos(dir);
    float vy = vel * sin(dir);
    particulas.add(new Particula(x, y, vx, vy));
  }

}

void draw() {
  background(255);
  
  for (Particula p : particulas) {
    p.update();
  }
  
  // Handle collisions
  for (int i = 0; i < num_particulas; i++) {
    Particula a = particulas.get(i);
    for (int j = i + 1; j < num_particulas; j++) {
      Particula b = particulas.get(j);
      a.checar_colision(b);
    }
  }
   
  for (Particula p : particulas) {
    p.display();
  }
  
  
}
