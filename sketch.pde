float x;
float time;
int[][] res;

boolean recEnable = false;
int elementsNum = 7000;
float shutterAngle = 1.5;

int framesN = 200;  
int frameSamples = 5;

class Elem{
  float delta;
  float size = random(0.5, 2.5);
  float offset = random(0.2, 0.8);
   
  Elem(float delta_n) {
    delta = delta_n;
  }
   
  void show(){
    float radius = 150 - 100 * cos(TWO_PI * time - size * size * offset);
    float x = 350 + radius * cos(delta * offset);
    float y = 350 - radius * sin(delta / offset);
    
    stroke(255, 1000);
    strokeWeight(size);
    point(x, y);
  }
}

Elem[] array = new Elem[elementsNum];

void draw() {

  if (recEnable) {
    x = 0;
    for (int i = 0; i < height * width; i++) {
      for (int a = 0; a < 3; a++)
        res[i][a] = 0;
    }

    for (int sa = 0; sa < frameSamples; sa++) {
      draw_n();
      loadPixels();
      time = map(frameCount - 1 + sa * shutterAngle / frameSamples, 0, framesN, 0, 1);
      for (int i=0; i < pixels.length; i++) {
        res[i][0] += pixels[i] >> 16 & 0xff;
        res[i][1] += pixels[i] >> 8 & 0xff;
        res[i][2] += pixels[i] & 0xff;
      }
    }

    loadPixels();
    for (int i = 0; i < pixels.length; i++)
      pixels[i] = 0xff << 24 | 
        int(res[i][0] * 1.0 / frameSamples) << 16 | 
        int(res[i][1] * 1.0 / frameSamples) << 8 | 
        int(res[i][2] * 1.0 / frameSamples);
    updatePixels();

    saveFrame("frame###.png");
    println(frameCount, "/", framesN);
    if (frameCount == framesN) exit();
  } else {
    time = mouseX * 1.0 / width;
    x = mouseY * 1.0 / height;
    if (mousePressed) println(x);
    draw_n();
  } 
}
 
void setup() {
  size(500, 500, P3D);
  res = new int[width * height][3];
  for (int i = 0; i < elementsNum; i++) {
    float delta = TWO_PI * i / elementsNum;
    array[i] = new Elem(delta);
  }
}
 
void draw_n(){
  background(#000000);
  for (int i = 0; i < elementsNum; i++) {
    array[i].show();
  }
}
