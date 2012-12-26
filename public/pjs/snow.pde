/* @pjs preload="../image/london-1-mask.png, ../image/london-1-preview.png"; */

final int NUMBEROFBOIDS = 500;
final float INITIALACCL = .05;
final float AIRFRICTION = 0;
final int EMITATONCE = 4;
final int MAXPILES = 5000;
final int ONEIN = 5;

Storm storm;
City city;

void setup() {
  size(800,800);
  colorMode(RGB,255,255,255,100);
  frameRate(25);
  city = new City();
  storm = new Storm(city.getPixels());
  
  smooth();
}

void draw() {
  background(0);
  city.run(storm.getPile());
  storm.run();


}

void mousePressed() {
   city = new City();
   storm = new Storm(city.getPixels());
}

class City {
  PImage maskImage;
  ArrayList pilings;

  City(){
      PVector hitpoint;
      maskImage = loadImage("../image/london-1-preview.png"); 
      pilings = new ArrayList();
      hitpoint = new PVector();

	  hitpoint.x=200;
	  hitpoint.y=200;

	  pilings.add(hitpoint); 
  }
  

 color[] getPixels(){
    color[] thePixels;
    maskImage.loadPixels();
    thePixels=maskImage.pixels;
    return thePixels;
  }


  void run(ArrayList pile){
    	 PVector pv;
	     for (i=0; i<pile.size() ; i++){
	            pv = pile.get(i);
	      	    fill(200,180);
			    noStroke();
				ellipse (pv.x, pv.y, random (1,4),random (1,4));
		 } 
		 
		     fill(min(128,128*(pile.size()/1000)),255);
		     text("London", 400, 700);
      }
}

class Storm {
  ArrayList flakes;
  ArrayList thePile;
  color[] theCity;
  int pileCount=5;
  Storm(color[] cityPixels) {
  flakes = new ArrayList();
  thePile = new ArrayList();
  theCity = cityPixels;
  }

  void run() {
    PVector theSpot;
   
	if (flakes.size()<NUMBEROFBOIDS) {
		for (init i = 0; i < EMITATONCE; i++) {
			addFlake(new Flake(new Vector3D(random(20,width-20),20),2.0f,0.05f,color(random(128,200))));
		}
	}
	
    for (int i = 0; i < flakes.size(); i++) {

      Flake b = (Flake) flakes.get(i);  
      theSpot = new PVector (b.loc.x, b.loc.y);

      if (b.loc.y>height) removeFlake(b);

      if (red(theCity[int(b.loc.y)*800+int(b.loc.x)])>200) {
           removeFlake(b);
           addToPile(theSpot);
      }
      b.fall();     
    }
  }

  ArrayList getPile(){
      return thePile;
   } 

  void addToPile(PVector p) {
    p.y+=random(-2,2);
    p.x+=random(-2,2);
    if (thePile.size()<MAXPILES) 
      if (random(1,ONEIN)>ONEIN-1) thePile.add(p);
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
		    acc = new Vector3D(0,random(INITIALACCL/2,INITIALACCL));
		    vel = new Vector3D(0,random(.1,.5));
		    swing = 0;
		    swingmag = random(2,5);
			swinginc = random(.01,.05);
		    loc = l.copy();
		    r = random(.5,4);
		    thecolor = c;
		    maxspeed = ms;
		    maxforce = mf;
		  }
		
        // Iterate
		  //void fall(ArrayList boids) {
		  void fall() {
		    update();
		    borders();
		    render();
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