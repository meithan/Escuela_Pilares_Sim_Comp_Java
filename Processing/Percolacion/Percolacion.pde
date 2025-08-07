import java.util.LinkedList;

int cols = 50;
int rows = 50;

float openProbability = 0.70;

boolean[][] open;
boolean[][] full;
int cellSize;
boolean percolates = false;

LinkedList<int[]> fillQueue;
boolean simulationPaused;
boolean simulationEnded;

void setup() {
  size(600, 600);
  cellSize = width / cols;
  resetSimulation();
}

void draw() {
  background(255);
  drawGrid();

  if (!simulationPaused && !simulationEnded) {
    doFloodFill(5);
  }

  if (simulationEnded) {
    if (percolates) {
      fill(0, 128, 30);
    } else {
      fill(170, 20, 0);
    }
    stroke(0);
    float w = 200;
    float h = 50;
    rect(width/2 - w/2, height/2 - h/2, w, h);
    textSize(40);
    textAlign(CENTER, CENTER);
    fill(255);
    if (percolates) {
      text("Percola", width / 2, height / 2);
    } else {
      text("No percola", width / 2, height / 2);
    }
  }  
  
}

void mousePressed() {
  if (!simulationEnded) {
    simulationPaused = !simulationPaused;
  } else {
    resetSimulation();
  }
}

void resetSimulation() {

  simulationPaused = true;
  simulationEnded = false;  
  percolates = false;
  open = new boolean[cols][rows];
  full = new boolean[cols][rows];
  fillQueue = new LinkedList<int[]>();

  // Generate random grid
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      open[i][j] = random(1) < openProbability;
      full[i][j] = false;
    }
  }

  // Initialize queue with top row
  for (int i = 0; i < cols; i++) {
    if (open[i][0]) {
      fillQueue.add(new int[] { i, 0 });
    }
  }

}

void doFloodFill(int stepsPerFrame) {
  int steps = 0;
  while (!fillQueue.isEmpty() && steps < stepsPerFrame) {
    int[] current = fillQueue.poll();
    int i = current[0];
    int j = current[1];

    if (i < 0 || i >= cols || j < 0 || j >= rows) continue;
    if (!open[i][j] || full[i][j]) continue;

    full[i][j] = true;

    fillQueue.add(new int[] { i + 1, j });
    fillQueue.add(new int[] { i - 1, j });
    fillQueue.add(new int[] { i, j + 1 });
    fillQueue.add(new int[] { i, j - 1 });

    steps++;
  }

  // Check if any bottom cell is full
  for (int i = 0; i < cols; i++) {
    if (full[i][rows - 1]) {
      percolates = true;
      simulationEnded = true;
      return;
    }
  }
  
  // End simulation if no more sites
  if (fillQueue.isEmpty()) {
    simulationEnded = true;
  }
 
}

void drawGrid() {
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      int x = i * cellSize;
      int y = j * cellSize;

      if (!open[i][j]) {
        fill(0); // Blocked
      } else if (full[i][j]) {
        fill(0, 0, 255); // Full (percolated)
      } else {
        fill(255); // Open
      }
      noStroke();
      rect(x, y, cellSize, cellSize);
    }
  }
}
