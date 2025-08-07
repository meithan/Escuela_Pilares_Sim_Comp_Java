
int num_cells = 200;
float car_density = 0.1;
int max_vel = 3;
float prob_slowdown = 0.01;

//int[] colors = {#ff0000, #ffa700, #fcc129, #fff400, #a3ff00, #2cba00};
int[] colors = {#ff0000, #fcc129, #a3ff00, #2cba00};
int car_size = 15;
int road_radius = 500-car_size; 

int[] cells;
int[] new_cells;
int num_cars;
boolean simulationPaused;

void setup() {
  size(2*500, 2*500);
  cells = new int[num_cells];
  new_cells = new int[num_cells];
  num_cars = int(num_cells * car_density);
  for (int i = 0; i < num_cells; i++) {
    if (i % int(num_cells/num_cars) == 0) {
      cells[i] = 0;
    } else {
      cells[i] = -1;
    }
  }
  simulationPaused = true;
  frameRate(5);
  rectMode(CENTER);
}

void draw() {
  
  background(255);
  
  if (!simulationPaused) update();
  
  draw_road();
    
}

void update() {

  // Acceleration
  for (int i = 0; i < num_cells; i++) {
    if (cells[i] >= 0) {
        if (cells[i] < max_vel) cells[i] += 1;
    }
  }

  // Slow down to avoid collision
  for (int i = 0; i < num_cells; i++) {
    if (cells[i] != -1) {
      // find distance to car in front
      int d = 1;
      while (true) {
        if (cells[(i+d) % num_cells] != -1) {
          break;
        }
        d += 1;
      }
      if (cells[i] >= d) cells[i] = d-1;
    }
  }

  // Randomization
  for (int i = 0; i < num_cells; i++) {
    if (cells[i] >= 1) {
        if (random(1) < prob_slowdown) {
            cells[i] -= 1;
        }
    }
  }
  
  // Movement
  for (int i = 0; i < num_cells; i++) {
    new_cells[i] = -1;
  }
  for (int i = 0; i < num_cells; i++) {
    if (cells[i] != -1) {
        int new_i = (i + cells[i]) % num_cells;
        new_cells[new_i] = cells[i];
    }
  }
  for (int i = 0; i < num_cells; i++) {
    cells[i] = new_cells[i];
  }
  
}

void draw_road() {
  
  noFill();
  stroke(0);
  strokeWeight(1);
  //circle(width/2, height/2, 2*road_radius);
  //circle(width/2, height/2, 2*road_radius-car_size);
  //circle(width/2, height/2, 2*road_radius+car_size);
  
  for (int i = 0; i < num_cells; i++) {
    float angle = i * 2*PI/num_cells;
    push();
    translate(width/2, height/2);      
    rotate(angle);
    if (cells[i] == -1) {
      noStroke();
      fill(230);
    } else {
      stroke(0);
      fill(colors[cells[i]]);
    }
    circle(road_radius, 0, car_size);
    pop();
  }
  
}

void mousePressed() {
  simulationPaused = !simulationPaused;
}
