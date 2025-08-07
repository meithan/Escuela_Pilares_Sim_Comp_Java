class Particula {
  
  float x, y;
  float vx, vy;
  float R;

  Particula(float _x, float _y, float _r) {
    x = _x;
    y = _y;
    vx = 0;
    vy = 0;
    R = _r;
  }

  void update() {
    
    // Actualizamos la velocidad vertical
    vy -= g;
    
    // Movemos la partícula
    x += vx * dt;
    y += vy * dt;

    // Rebota contras las paredes
    if (x < R || x > width - R) {
      vx *= -1;
      x = constrain(x, R, width - R);
    }
    if (y < R || y > height - R) {
      vy *= -1;
      y = constrain(y, R, height - R);
    }
  }

  void display() {
    fill(0, 0, 255);
    noStroke();
    circle(x, y, 2*R);
  }

}

// Variables globales
Particula part;
float dt = 1.0;
float g = -1.0;

void setup() {
  size(800, 800);
  part = new Particula(width/2, height/2, 40);
  float vel = 10;
  float dir = random(0, 2*PI);
  part.vx = vel * cos(dir);
  part.vy = vel * sin(dir);
}

void draw() {
  background(255);
  part.update();
  part.display();
}
