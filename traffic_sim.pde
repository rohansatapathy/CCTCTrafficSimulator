import interfascia.*;
import java.util.Optional;

GUIController c;

IFCheckBox addPath, addPoint, addIntersection;
IFButton delete;
IFButton enterColor;
IFLabel label;
IFTextField colorOption;
IFTextField numCommuter;
IFRadioController commuterType;
IFRadioButton ped, car, bus;
IFButton addCommuters;
IFLabel collisionCounter;
IFLabel totalPersonDelay;
IFLabel time;

PImage backgroundImage;
int frameWidth = 1300;
int frameHeight = 730;

boolean addPointToggled = false;
boolean addPathToggled = false;
boolean addIntersectionToggled = false;

int configurationPanelWidth = 200;
int configurationPanelHeight = 500;
int configurationPanelXPos = frameWidth - configurationPanelWidth;
int configurationPanelYPos = 0;
float simTime = 0;


ArrayList<Point> pointBuffer = new ArrayList<Point>();
ArrayList<Path> pathBuffer = new ArrayList<Path>();
boolean selectIntersectionPoint = false;
Optional<SimEntity> selection;
final int FRAME_RATE = 60;

Sim mySim;

// speeds greater than 10 pixels per frame begin to exhibit significant undefined behavior

void setup() {
  
  size(1300, 730);
  backgroundImage = loadImage("CCTC.png");
  backgroundImage.resize(frameWidth, frameHeight);
  frameRate(FRAME_RATE);
  
  mySim = new Sim(this);
  c = new GUIController(this);
  
  label = new IFLabel("", configurationPanelXPos + 10, 10);
  addPoint = new IFCheckBox("Add Point", configurationPanelXPos + 10, 50);
  addPath = new IFCheckBox("Add Path", configurationPanelXPos + 10, 90);
  addIntersection = new IFCheckBox("Add Intersection", configurationPanelXPos + 10, 130);
  delete = new IFButton("Delete", configurationPanelXPos + 10, 170);
  colorOption = new IFTextField("Color", configurationPanelXPos + 10, 210, 130, "R G B");
  enterColor = new IFButton("Enter Color", configurationPanelXPos + 10, 250);
  numCommuter = new IFTextField("# of Commuters", configurationPanelXPos + 10, 280, 130, "10");
  
  commuterType = new IFRadioController("Type of Commuter");
  ped = new IFRadioButton("Pedestrian", configurationPanelXPos + 10, 310, commuterType);
  bus = new IFRadioButton("Bus", configurationPanelXPos + 10, 330, commuterType);
  car = new IFRadioButton("Car", configurationPanelXPos + 10, 350, commuterType);
  addCommuters = new IFButton("Add Commuters", configurationPanelXPos + 10, 380);
  
  collisionCounter = new IFLabel("Collision Counter: 0", configurationPanelXPos + 10, 410);
  totalPersonDelay = new IFLabel("Total Person Delay: 0", configurationPanelXPos + 10, 430);
  time = new IFLabel("Time Elapsed: ", configurationPanelXPos + 10, 450);
  
  
  
  c.add(label);
  c.add(addPoint);
  c.add(addPath);
  c.add(addIntersection);
  c.add(delete);
  c.add(colorOption);
  c.add(enterColor);
  c.add(numCommuter);
  c.add(commuterType);
  c.add(ped);
  c.add(bus);
  c.add(car);
  c.add(addCommuters);
  c.add(collisionCounter);
  c.add(totalPersonDelay);
  c.add(time);
  
  
  addPoint.addActionListener(this);
  addPath.addActionListener(this);
  addIntersection.addActionListener(this);
  delete.addActionListener(this);
  colorOption.addActionListener(this);
  enterColor.addActionListener(this);
  addCommuters.addActionListener(this);
  
  selection = Optional.empty();
  label.setLabel("Nothing selected");
  
  // testing stuff 
  //Point[] array = {new Point(715, 121), new Point(685, 91), new Point(655, 61)};
  //Path myPath = new Path(array);
  //mySim.addPath(myPath);
  //mySim.addCommuter(new Commuter(myPath, 10, 0.2));
  //mySim.addCommuter(new Commuter(myPath, 20, 0.1));
  
}

void draw() {
  simTime += 1.0 / FRAME_RATE;
  time.setLabel("Time elapsed: " + Math.round(simTime) + "s");
  
  background(backgroundImage);
  rect(configurationPanelXPos, configurationPanelYPos, configurationPanelWidth, configurationPanelHeight);
  
  stroke(0, 0, 0);
  
  for (int i = 0; i < pointBuffer.size(); i++) {
    pointBuffer.get(i).draw(this);
  }
  
  mySim.update();
  mySim.draw();
  collisionCounter.setLabel("Collision count: " + mySim.getCollisionCount());
  
}

void actionPerformed(GUIEvent e) {
  // addPoint is toggled
  if (e.getSource() == addPoint) {
    addPointToggled = !addPointToggled;
  }
  // addPath is toggled
  else if (e.getSource() == addPath) {
    if (addPathToggled && pointBuffer.size() >= 2) {
      Point[] nodes = new Point[pointBuffer.size()];
      pointBuffer.toArray(nodes);
      mySim.addPath(nodes);
    }
    addPathToggled = !addPathToggled;
    pointBuffer.clear();
  }
  // addIntersection is toggled
  else if (e.getSource() == addIntersection) {
    if (addIntersectionToggled && pathBuffer.size() == 2 && pointBuffer.size() == 1) {
       if (!mySim.addIntersection(pointBuffer.get(0), pathBuffer.get(0), pathBuffer.get(1))) {
         label.setLabel("Failed to find intersection.");
       }
    }
    addIntersectionToggled = !addIntersectionToggled;
    selectIntersectionPoint = false;
    pathBuffer.clear();
    pointBuffer.clear();
    //label.setLabel("Nothing selected");
  }
  // delete button is clicked
  else if (e.getSource() == delete) {
    if (selection.isPresent()) {
      System.out.println("Deleting " + selection.get().toString());
      mySim.removeEntity(selection.get());
      selection = Optional.empty();
      label.setLabel("Nothing selected");
    }
  }
  // enter color button is clicked
  else if (e.getSource() == enterColor) {
    if (selection.isPresent()) {
      String contents = colorOption.getValue();
      String[] rgb = contents.split(" ", 3);
      if (rgb.length == 3) {
        int[] rgbInts = new int[rgb.length];
        try {
          for (int i = 0; i < rgb.length; i++) {
            rgbInts[i] = Integer.parseInt(rgb[i]);
          }
          selection.get().setColor(color(rgbInts[0], rgbInts[1], rgbInts[2]));
        }
        catch(NumberFormatException error) {
          label.setLabel("Improperly formatted rgb");
        }
      }
      else {
        label.setLabel("Improperly formatted rgb"); 
      }
      selection = Optional.empty();
      label.setLabel("Nothing selected");
    }
  }
  // add commuter button is clicked
  else if (e.getSource() == addCommuters) {
    if (selection.isPresent() && selection.get() instanceof Path) {
      String contents = numCommuter.getValue();
      try {
        int num = Integer.parseInt(contents);
        if (commuterType.getSelected() == ped) {
          for (int i = 0; i < num; i++) {
            if (!mySim.addCommuter(new Pedestrian(random(0.1, 0.12), "Student", color(242, 133, 0)), (Path)selection.get())) {
              label.setLabel("spawn blockage: insertion failed");
            }
          }
        }
        else if (commuterType.getSelected() == car) {
          for (int i = 0; i < num; i++) {
            if (!mySim.addCommuter(new Car(12, 9, random(0.5, 0.6), "Rando Car", color(251, 236, 93)), (Path)selection.get())) {
              label.setLabel("spawn blockage: insertion failed");
            }
          }
        }
        else if (commuterType.getSelected() == bus) {
          for (int i = 0; i < num; i++) {
            if (!mySim.addCommuter(new Bus(20, 15, random(0.3, 0.4), "MBus", color(62, 142, 222)), (Path)selection.get())) {
              label.setLabel("spawn blockage: insertion failed");
            }
          }
        }
        else {
          label.setLabel("No type chosen.");
        }
      }
      catch(NumberFormatException error) {
        label.setLabel("Improper integer #");
      }
    }
    else {
      label.setLabel("No path selected");
    }
      
  }
}

boolean configurationPanelClicked() {
  return (mouseX >= configurationPanelXPos && mouseX <= configurationPanelXPos + configurationPanelWidth && 
          mouseY >= configurationPanelYPos && mouseY <= configurationPanelYPos + configurationPanelHeight);
}



void mousePressed() {
  if (!configurationPanelClicked()) {
    selection = mySim.getClick(mouseX, mouseY);
    if (addPointToggled) {
      System.out.println(mouseX + ", " + mouseY);
      mySim.addPoint(mouseX, mouseY);
    }
    else if (addPathToggled) {
      pointBuffer.add(new Point(mouseX, mouseY));
    }
    else if (addIntersectionToggled) {
      if (selectIntersectionPoint) {
        pointBuffer.add(new Point(mouseX, mouseY));
        selectIntersectionPoint = false;
      }
      else {
        if (selection.isPresent() && selection.get() instanceof Path) {
          pathBuffer.add((Path)selection.get());
        }
        if (pathBuffer.size() == 2 && pointBuffer.size() == 0) {
          label.setLabel("Select intersection point");
          selectIntersectionPoint = true;
        }
        else {
          label.setLabel("Select 2 paths to create intersection");
        }
      }
    }
    else if (selection.isPresent()) {
      label.setLabel(selection.get().toString());
    }
    else {
      label.setLabel("Nothing selected");
    }
  }
  
}
