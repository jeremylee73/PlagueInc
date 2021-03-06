class City {
  String name;
  int population;
  int diseased;
  int dead;
  int pointRate;
  int x;
  int y;
  ArrayList<String> adjacent;
  boolean hasAirport;
  boolean hasDock;
  boolean airportOpen;
  boolean dockOpen;
  boolean hasBubble;
  float red, green, blue;
  boolean bubblePopped;
  PImage planeImg1 = loadImage("healthyplane.png");
  PImage planeImg2 = loadImage("infectedplane.png");
  boolean hasSporadicBubble;
  double GB, R;
  int RGBbubbleIncr;

  City(String name, int population, ArrayList<String> adjacent, boolean hasAirport, boolean hasDock, int x, int y) {
    this.name = name;
    this.population = population;
    this.adjacent = adjacent;
    this.hasAirport = hasAirport;
    this.hasDock = hasDock;
    this.airportOpen = true;
    this.dockOpen = true;
    diseased = 0;
    dead = 0;
    this.x = x;
    this.y = y;
    green = 0; 
    blue = 0;
    red = 255;
    drawRoutes();
    drawAirports();
    //drawDocks();
  }

  void drawRoutes() {
    strokeWeight(4);
    stroke(0);
    for (int i=0; i<cities.size(); i++) {
      for (int j=0; j<adjacent.size(); j++) {
        if (cities.get(i).name.equals(adjacent.get(j))) {
          line(cities.get(i).x, cities.get(i).y, x, y);
        }
      }
    }
  }

  void drawAirports() {
    for (int i=0; i<cities.size(); i++) {
      if (cities.get(i).hasAirport) {
        rect(cities.get(i).x + 40, cities.get(i).y - 25, 20, 20);
      }
    }
  }

  void drawDocks() {
    for (int i=0; i<cities.size(); i++) {
      if (cities.get(i).hasDock) {
        triangle(cities.get(i).x+40, cities.get(i).y+20, cities.get(i).x+50, cities.get(i).y+5, cities.get(i).x + 60, cities.get(i).y + 20);
      }
    }
  }

  void writeNames() {
    for (int i=0; i<cities.size(); i++) {
      int cityx = cities.get(i).x;
      int cityy = cities.get(i).y;
      fill(255);
      rect(cityx-85, cityy, 55, 35);
      fill(0,0,0);
      textSize(10);
      text(cities.get(i).name,cityx-80,cityy+5,50,30);
    }
  }

  void updateColor() {
    GB = (population - diseased) / (population * 1.0) * 255;
    R = (population - dead) / (population * 1.0) * 255;
    if (diseased + dead == population) {
      if (R > 62) {
        fill((int) R, 0, 0);
      } else {
        fill(62, 0, 0);
      }
    } else if (dead > 0 && diseased == 0) {
      //calculates correct shading of cities from white to gray
      if (R > 62) {
        fill((int) R, (int)(R - 4.1129), (int)(R - 4.1129));
      } else {
        fill(62, (int)(R - 4.1129), (int)(R - 4.1129));
      }
    } else {
      fill((int) R, (int) GB, (int) GB);
    }
    ellipse(x, y, 65, 65);
    if (GB > 254.9 && (diseased > 0 || dead > 0) && !bubblePopped && (green < 255 || blue < 255) && diseased + dead != population) {
      hasBubble = true;
      fill(255, green, blue);
      noStroke();
      ellipse(x, y, 30, 30);
      green++; 
      blue++;
    } else {
      hasBubble = false;
    }
    if (bubblePopped && GB > 254.9 && diseased + dead != population) {
      fill(255, 255, 255);
      noStroke();
      ellipse(x, y, 30, 30);
    }

    if (hasSporadicBubble) {
      if (RGBbubbleIncr == 1) {
        hasSporadicBubble = false;
        return;
      }
      RGBbubbleIncr--;
      double redIncr;
      double greenIncr;
      double blueIncr;
      //Determines direction incrementing based on current RGB color.
      //180 frames is 3 seconds.
      //How this formula works is red = red - (red - R)/180 then on next frame
      //it's red = red - (red - R)/179 then on next frame it's
      //red = red - (red - R)/178 ... until red = red - (red - R)/1
      redIncr = (red - R)/RGBbubbleIncr;
      red -= (float)redIncr;
      if (red < 62 && diseased + dead == population && dead > 0) {
        red = 62;
      }
      //to fix shading issues with sporadic bubbles where it would not turn 
      //dark red as cities turned dark red
      if (diseased + dead == population && dead > 0) {
        greenIncr = green/RGBbubbleIncr;
        blueIncr = blue/RGBbubbleIncr;
      } else {
        greenIncr = (green - GB)/RGBbubbleIncr;
        blueIncr = (blue - GB)/RGBbubbleIncr;
      }
      green -= (float)greenIncr;
      blue -= (float)blueIncr;
      noStroke();
      fill(red, green, blue);
      ellipse(x, y, 30, 30);
    }
  }

  void sporadicBubble() {
    if (!hasSporadicBubble && !hasBubble && diseased > 0) {
      RGBbubbleIncr = 180;
      hasSporadicBubble = true;
      //RGB code for sickly orange color
      red = 247;
      green = 172;
      blue = 30;
    }
  }

  void updateDeadCount() {
    fill(0, 0, 0);
    noStroke();
    int digits = 0;
    int temp = dead;
    while (temp > 9) {
      digits++;
      temp = temp / 10;
    }
    rect(x-32, y+52, 100 + (10*digits), 20);
    textSize(16);
    fill(255, 255, 255);
    text(dead + " / " + population, x - 32, y + 70);
  }

  void updateDiseasedCount() {
    fill(255, 255, 255);
    noStroke();
    int digits = 0;
    int temp = diseased;
    while (temp > 9) {
      digits++;
      temp = temp / 10;
    }
    rect(x-32, y+32, 100 + (10*digits), 20);
    textSize(16);
    fill(0, 0, 0);
    text(diseased + " / " + population, x - 32, y + 50);
  }

  void landTransmission() {
    for (int i=0; i<cities.size(); i++) {
      for (int j=0; j<adjacent.size(); j++) {
        if (cities.get(i).name.equals(adjacent.get(j))) {
          if (Math.random() < (diseased / (population * 2.0)) && cities.get(i).diseased == 0) {
            cities.get(i).diseased = 1;
            hasBubble = true;
            if (dead == 0) {
              //adds infection message to news and shows it on screen
              news.add(cities.get(i).name+" has become infected.");
              fill(205);
              rect(1220, 215, 160, 100);
              fill(0, 0, 0);
              text(news.get(news.size() - 1), 1220, 220, 150, 100);
            }
          }
        }
      }
    }
  }

  void sendPlane(PImage img, City c) {
    float dx = Math.abs(c.x - x);
    float dy = Math.abs(c.y - y);
    float theta = atan(dy / dx);
    float angle = 0;
    if (c.x > x && c.y > y) {
      angle = PI - theta;
    } else if (c.x > x && c.y < y) {
      angle = (PI/2) - theta;
    } else if (c.x < x && c.y > y) {
      angle = PI + theta;
    } else if (c.x < x && c.y < y) {
      angle = (3*PI / 2) + theta;
    }
    pushMatrix();
    rotate(angle);
    translate(dx / 100, dy / 100);
    image(img, x, y);
    popMatrix();
  }

  void planeTransmission() {
    if (hasAirport && airportOpen) {
      if (Math.random() > ((diseased) / (population * 1.0))) {
        for (int i=0; i<cities.size(); i++) {
          if (!(cities.get(i).equals(this)) && cities.get(i).hasAirport && cities.get(i).airportOpen) {
            if (Math.random() < 0.0001) {
              Plane newPlane = new Plane(x, y, this, cities.get(i), false);
              planes.add(newPlane);
            }
          }
        }
      } else {
        if (Math.random() < ((diseased) / (population * 1.0))) {
          for (int i=0; i<cities.size(); i++) {
            if (!(cities.get(i).equals(this)) && cities.get(i).hasAirport && cities.get(i).airportOpen) {
              if (Math.random() < 0.0001) {
                Plane newPlane = new Plane(x, y, this, cities.get(i), true);
                planes.add(newPlane);
              }
            }
          }
        }
      }
    }
  }

  void closeAirport() {
    if (airportOpen) {
      news.add(name+"'s airport has closed.");
      noStroke();
      fill(205);
      rect(1220, 215, 160, 100);
      fill(0, 0, 0);
      text(news.get(news.size() - 1), 1220, 220, 150, 100);
    }
    airportOpen = false;
    fill(255, 0, 0);
    stroke(0);
    strokeWeight(4);
    rect(x + 40, y - 25, 20, 20);
  }
}
