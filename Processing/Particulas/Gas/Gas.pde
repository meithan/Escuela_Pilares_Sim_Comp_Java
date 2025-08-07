class Particula {
  
  PVector posicion;
  PVector velocidad;
  float R;
  
  color c = color(0, 0, 255);

  Particula(float x, float y, float vx, float vy, float r) {
    posicion = new PVector(x, y);
    velocidad = new PVector(vx, vy);
    R = r;
  }

  void update() {
    
    // Actualizamos la velocidad vertical
    velocidad.y += g*dt;
    
    // Rebota contras las paredes
    if (posicion.x < R || posicion.x > simulWidth - R) {
      velocidad.x *= -1;
      posicion.x = constrain(posicion.x, R, simulWidth - R);
    }
    if (posicion.y < R || posicion.y > simulHeight - R) {
      velocidad.y *= -1;
      posicion.y = constrain(posicion.y, R, simulHeight - R);
    }
    
    // Movemos la partícula
    posicion.add(velocidad.mult(dt));
    
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
    fill(0, 0, 255);
    noStroke();
    circle(posicion.x, posicion.y, 2*R);
  }

}

// Variables globales
int num_particulas = 500;
float radio = 5;
float dt = 1.0;
float g = 0.0;
boolean pausa = true;

ArrayList<Particula> particulas;
float simulWidth;
float simulHeight;

void setup() {
  
  size(800, 1000);
  
  simulWidth = 800;
  simulHeight = 800;
  
  particulas = new ArrayList<Particula>();
  for (int i = 0; i < num_particulas; i++) {
    float vel = random(10, 20);
    float x = random(0, simulWidth);
    float y = random(0, simulHeight);
    float dir = random(0, 2*PI);
    float vx = vel * cos(dir);
    float vy = vel * sin(dir);
    particulas.add(new Particula(x, y, vx, vy, radio));
  }

}

void draw() {
  background(255);
  
  
  if (!pausa) {
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
      
  }
  
  for (Particula p : particulas) {
    p.display();
  }
  
  stroke(0);
  line(0, width, simulHeight+5, simulHeight+5);
  
  drawVelocityHistogram();  
  
}

void mousePressed() {
  pausa = !pausa;
}

void drawVelocityHistogram() {

  float h = 150;
  float x = 20;
  float w = width - 40;
  float y = height - h - 20;
  int num_bins = 20; 
  
  float[] speeds = new float[num_particulas];
  float minSpeed = 1e30;
  float maxSpeed = 0;

  for (int i = 0; i < num_particulas; i++) {
    speeds[i] = particulas.get(i).velocidad.mag();
    if (speeds[i] < minSpeed) {
      minSpeed = speeds[i];
    }
    if (speeds[i] > maxSpeed) {
      maxSpeed = speeds[i];
    }    
  }

  int[] histogram = new int[num_bins];
  for (float speed : speeds) {
    int bin = int(map(speed, minSpeed, maxSpeed, 0, num_bins));
    bin = constrain(bin, 0, num_bins - 1);
    histogram[bin]++;
  }

  int maxCount = max(histogram);
  float binWidth = w / num_bins;

  // Draw axes
  stroke(0);
  noFill();
  rect(x, y, w, h);

  // Draw histogram bars
  for (int i = 0; i < num_bins; i++) {
    float binHeight = map(histogram[i], 0, maxCount, 0, h);
    fill(100, 200, 255);
    noStroke();
    rect(x + i * binWidth, y + h - binHeight, binWidth - 2, binHeight);
  }

  fill(0);
  textAlign(LEFT, TOP);
  textSize(18);
  text("Histograma de velocidades", x, y - 16);

}
