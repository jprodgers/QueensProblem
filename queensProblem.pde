/*
Written by Jimmie Rodgers

The Eight Queen's Problem is a chess puzzle where you try to place 8 queens
on the board that cannot immediately capture any other queen. While there
are many possible positions, there are only 92 possible solutions to the
problem. This program will try to solve that, but for any arbitrarily shaped
board. If it does not find a perfect solution, then it will try again with
a new board. Since it is random, this will take exponentially longer per
extra side to the board, so watch out.

I was inspired to write this by a Numberphile episode:
https://www.youtube.com/watch?v=jPcBU0Z2Hj8

*/

int xSize = 8;
int ySize = 8;
int board[][][] = new int[xSize][ySize][4];

int boxSize = 50;
int fontSize = 100; 

boolean colorToggle = true;
int generations = 0;
int genMax = xSize * ySize * 3;
int spacesLeft = xSize * ySize;

int numSolved = 0;
int maxSolve = 0;

boolean rookMode = true;
boolean bishopMode = true;

int baseColor1 = #000000;
int baseColor2 = #ffffff;

int trueColor1 = #000000;
int trueColor2 = #ffffff;

int contrastColor = #ff0000;
int backColor = #999999;

void setup() {
  size((xSize*boxSize + 2*boxSize), (ySize*boxSize + 2*boxSize + fontSize)); 
  zeroBoard();
  if (xSize >= ySize) maxSolve = ySize;
  else maxSolve = xSize;
  displayBoard();
}

void draw() {
  clear();
  background(backColor);
  if (spacesLeft > 0) {
    seedRandom();
    checkBoard();
  } 
  else if (numSolved < maxSolve) zeroBoard();
  displayBoard();
}

void zeroBoard() {
  for (int x = 0; x < xSize; x++) {
    for (int y = 0; y < ySize; y++) {
      board[x][y][0]=0;
      board[x][y][1]=0;
      board[x][y][2]=0;
      board[x][y][3]=0;
    }
  }
  spacesLeft = xSize * ySize;
  numSolved = 0;
}

void keyPressed() {
  zeroBoard();
}

void displayBoard() {
  colorToggle = true;
  for (int x = 0; x < xSize; x++) {
    for (int y = 0; y < ySize; y++) {
      colorToggle = !colorToggle;
      if (board[x][y][1] == 1 || board[x][y][2] == 1 || board[x][y][3] == 1) {
        if (colorToggle) fill(trueColor1);
        else fill(trueColor2);
      } else {
        if (colorToggle) fill(baseColor1);
        else fill(baseColor2);
      } 
      rect(x*boxSize + boxSize, y*boxSize + boxSize, boxSize, boxSize);
      if (board[x][y][0] == 1) {
        fill(contrastColor);
        ellipse(x*boxSize + boxSize*1.5, y*boxSize + boxSize*1.5, boxSize, boxSize);
      }
    }
    if(ySize % 2 == 0) colorToggle = !colorToggle;
  }
  fill(contrastColor);
  textAlign(CENTER, TOP);
  textSize(fontSize);
  text( numSolved, width/2, (height - fontSize - boxSize/2));
}

void seedRandom() {
  int xRandom = int(random(xSize));
  int yRandom = int(random(ySize));
  if (board[xRandom][yRandom][0] == 1 || board[xRandom][yRandom][1] == 1 || board[xRandom][yRandom][2] == 1 || board[xRandom][yRandom][3] == 1) {
    if (generations++ > genMax) return;
    else seedRandom();
  } else board[xRandom][yRandom][0] = 1;
  generations = 0;
}

void checkBoard() {
  int checkSpaces = 0;
  int checkSolved = 0;
  for (int x = 0; x < xSize; x++) {
    for (int y = 0; y < ySize; y++) {
      if (board[x][y][0] == 1) {
        checkSolved++;
        if (rookMode) setRookMoves(x, y);
        if (bishopMode) setBishopMoves(x, y);
      }
    }
  }
  for (int x = 0; x < xSize; x++) {
    for (int y = 0; y < ySize; y++) {
      if (board[x][y][0] == 0 && board[x][y][1] == 0 && board[x][y][2] == 0 && board[x][y][3] == 0) checkSpaces++;
    }
  }
  spacesLeft = checkSpaces;
  numSolved = checkSolved;
}

void setRookMoves(int xPos, int yPos) {
  for (int i = 0; i < xSize; i++) {
    board[i][yPos][1] = 1;
  }
  for (int i = 0; i < ySize; i++) {
    board[xPos][i][2] = 1;
  }
}

void setBishopMoves(int xPos, int yPos) {
  int numBack;
  int yTemp = yPos;
  int xTemp = xPos;
  
  if (xPos >= yPos) numBack = yPos;
  else numBack = xPos;
  for (int i = 0; i < numBack; i++) {
    xTemp--;
    yTemp--;
  }
  while (true) {
    board[xTemp][yTemp][3] = 1;
    xTemp++;
    yTemp++;
    if ( xTemp == xSize || yTemp == ySize) break;
  }

  yTemp = yPos;
  xTemp = xPos;
  while (true) {
    if ( xTemp == 0 || yTemp == ySize-1) break;
    xTemp--;
    yTemp++;
  }

  while (true) {
    board[xTemp][yTemp][3] = 1;
    if ( xTemp == xSize-1 || yTemp == 0) break;
    xTemp++;
    yTemp--;
  }
}
