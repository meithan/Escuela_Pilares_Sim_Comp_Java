import java.util.LinkedList;

int cols = 50;
int rows = 50;

float treeProbability = 0.70;

// 0: dirt
// 1: forest, not on fire
// 2: forest, on fire
// 3: forest, burnt
int[][] grid;

int cellSize;
boolean percolates = false;

LinkedList<int[]> burningQueue;
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
    doFloodFill(10);
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
  grid = new int[cols][rows];
  burningQueue = new LinkedList<int[]>();

  // Generate random grid
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      grid[i][j] = random(1) < treeProbability ? 1 : 0;
    }
  }

  // Set a random open site on fire
  while (true) {
    int i = (int) random(cols);
    int j = (int) random(rows);
    if (grid[i][j] == 1) {
      grid[i][j] = 2;
      burningQueue.add(new int[] { i, j });
      break;
    }
    
  }

}

void doFloodFill(int stepsPerFrame) {
  int ni, nj;
  int steps = 0;
  final int[][] offsets = {{1, 0}, {-1, 0}, {0, 1}, {0, -1}};
  while (!burningQueue.isEmpty() && steps < stepsPerFrame) {
    
    int[] current = burningQueue.poll();
    int i = current[0];
    int j = current[1];
    grid[i][j] = 3;

    for (int[] offset : offsets) {
      ni = i + offset[0]; nj = j + offset[1];
      if ((ni >= 0) && (ni < cols) && (nj >= 0) && (nj < rows)) {
        if (grid[ni][nj] == 1) {
          grid[ni][nj] = 2;
          burningQueue.add(new int[] {ni, nj});
        }
      }
    }

    steps++;

  }
 
  // End simulation if no more sites
  if (burningQueue.isEmpty()) {
    simulationEnded = true;
  }
 
}

void drawGrid() {
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      int x = i * cellSize;
      int y = j * cellSize;

      if (grid[i][j] == 0) {
        fill(#967a4b);
      } else if (grid[i][j] == 1) {
        fill(#08610f);
      } else if (grid[i][j] == 2) {
        fill(#ff3c00);
      } else if (grid[i][j] == 3) {
        fill(#1c170a);
      }
      noStroke();
      rect(x, y, cellSize, cellSize);
    }
  }
}
