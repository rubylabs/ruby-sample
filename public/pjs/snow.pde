/* @pjs preload="../image/london-1-mask.png, ../image/london-1-preview.png"; */

final int NUMBEROFBOIDS = 1000;
final float INITIALACCL = .15;
final float AIRFRICTION = .001;
final ini EMITATONCE = 10;
PImage maskImage;

Storm storm;

void setup() {
  size(800,800);
  colorMode(RGB,255,255,255,100);
  maskImage = loadImage("../image/london-1-preview.png");
  storm = new Storm();
  smooth();
}

void draw() {
  background(0);
  image(maskImage, 0, 0);
  loadPixels();
  storm.run();
}

void mousePressed() {
}



class Storm {
  ArrayList flakes; // An arraylist for all the boids

  Storm() {
    flakes = new ArrayList(); // Initialize the arraylist
  }

  void run() {
	if (flakes.size()<NUMBEROFBOIDS) {
		for (init i = 0; i < EMITATONCE; i++) {
			addFlake(new Flake(new Vector3D(random(20,width-20),20),2.0f,0.05f,color(random(128,200))));
		}
	}
    for (int i = 0; i < flakes.size(); i++) {
      Flake b = (Flake) flakes.get(i);  
      if (b.loc.y>height) removeFlake(b);
      if (!b.alive) removeFlake(b);

      b.fall(flakes);  // Passing the entire list of boids to each boid individually
    }
  }

  void addFlake(Flake b) {
    flakes.add(b);
  }

  void removeFlake(Flake b) {
    flakes.remove(b);
  }
}

class Flake {
  float swing;
  float swingmag;
  float swinginc;
  Vector3D loc;
  Vector3D vel;
  Vector3D acc;
  float r;
  color thecolor;
  float maxforce;    // Maximum steering force
  float maxspeed;    // Maximum speed
  boolean alive = true;


      // Initialize
		Flake(Vector3D l, float ms, float mf, color c) {
		    acc = new Vector3D(0,INITIALACCL);
		    vel = new Vector3D(0,1);
		    swing = 0;
		    swingmag = random(2,5);
			swinginc = random(.01,.05);
		    loc = l.copy();
		    r = random(.5,8);
		    thecolor = c;
		    maxspeed = ms;
		    maxforce = mf;
		  }
		
        // Iterate
		  void fall(ArrayList boids) {
		    update();
		    borders();
		    render();
		    hit();
		  }


		 // Method to update location
		  void update() {
		    // Update velocity
		    vel.add(acc);
		    loc.add(vel);

		    // Reset acceleration to 0 each cycle
		    acc.y=acc.y-AIRFRICTION;
		    vel.x=cos(swing)*swingmag;
		    swing=swing+swinginc;
		  }

		// did we hit the city
		  void hit(){
		    int tempIndex = 800*int(loc.y)+ int(loc.x);
		    float a = red(pixels[tempIndex]);
			if (a>200) {
		    	alive = false;
		     }
		  }

		// draw the flake 
		  void render() {
		    fill(thecolor);
		    stroke(thecolor);
			ellipse(loc.x, loc.y, r, r);
		  }
 
		 // Wraparound
		  void borders() {
		    if (loc.x < -r) loc.x = width+r;
		    if (loc.y < -r) loc.y = height+r;
		    if (loc.x > width+r) loc.x = -r;
		   // if (loc.y > height+r) loc.y = -r;
		  }
}

// Simple Vector3D Class 

static class Vector3D {
  float x;
  float y;
  float z;

  Vector3D(float x_, float y_, float z_) {
    x = x_; y = y_; z = z_;
  }

  Vector3D(float x_, float y_) {
    x = x_; y = y_; z = 0f;
  }

  Vector3D() {
    x = 0f; y = 0f; z = 0f;
  }

  void setX(float x_) {
    x = x_;
  }

  void setY(float y_) {
    y = y_;
  }

  void setZ(float z_) {
    z = z_;
  }

  void setXY(float x_, float y_) {
    x = x_;
    y = y_;
  }

  void setXYZ(float x_, float y_, float z_) {
    x = x_;
    y = y_;
    z = z_;
  }

  void setXYZ(Vector3D v) {
    x = v.x;
    y = v.y;
    z = v.z;
  }

  float magnitude() {
    return (float) Math.sqrt(x*x + y*y + z*z);
  }

  Vector3D copy() {
    return new Vector3D(x,y,z);
  }

  Vector3D copy(Vector3D v) {
    return new Vector3D(v.x, v.y,v.z);
  }

  

  void add(Vector3D v) {
    x += v.x;
    y += v.y;
    z += v.z;
  }



  void sub(Vector3D v) {
    x -= v.x;
    y -= v.y;
    z -= v.z;
  }



  void mult(float n) {
    x *= n;
    y *= n;
    z *= n;
  }



  void div(float n) {
    x /= n;
    y /= n;
    z /= n;
  }



  void normalize() {
    float m = magnitude();
    if (m > 0) {
       div(m);
    }
  }

  void limit(float max) {
    if (magnitude() > max) {
      normalize();
      mult(max);
    }
  }

  float heading2D() {
    float angle = (float) Math.atan2(-y, x);
    return -1*angle;
  }

  Vector3D add(Vector3D v1, Vector3D v2) {
    Vector3D v = new Vector3D(v1.x + v2.x,v1.y + v2.y, v1.z + v2.z);
    return v;
  }

  Vector3D sub(Vector3D v1, Vector3D v2) {
    Vector3D v = new Vector3D(v1.x - v2.x,v1.y - v2.y,v1.z - v2.z);
    return v;
  }

  Vector3D div(Vector3D v1, float n) {
    Vector3D v = new Vector3D(v1.x/n,v1.y/n,v1.z/n);
    return v;
  }

  Vector3D mult(Vector3D v1, float n) {
    Vector3D v = new Vector3D(v1.x*n,v1.y*n,v1.z*n);
    return v;
  }

  float distance (Vector3D v1, Vector3D v2) {
    float dx = v1.x - v2.x;
    float dy = v1.y - v2.y;
    float dz = v1.z - v2.z;
    return (float) Math.sqrt(dx*dx + dy*dy + dz*dz);
  }

}