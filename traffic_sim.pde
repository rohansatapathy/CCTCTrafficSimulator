import interfascia.*;
import java.util.Optional;

GUIController c;

IFCheckBox addPath, addPoint, addIntersection, addTrafficSignal;
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
  //addTrafficSignal = new IFCheckBox
  delete = new IFButton("Delete", configurationPanelXPos + 10, 170);
  colorOption = new IFTextField("Color", configurationPanelXPos + 10, 210, 130, "R G B");
  enterColor = new IFButton("Enter Color", configurationPanelXPos + 10, 250);
  numCommuter = new IFTextField("# of Commuters", configurationPanelXPos + 10, 280, 130, "1");
  
  commuterType = new IFRadioController("Type of Commuter");
  ped = new IFRadioButton("Pedestrian", configurationPanelXPos + 10, 310, commuterType);
  bus = new IFRadioButton("Bus", configurationPanelXPos + 10, 330, commuterType);
  car = new IFRadioButton("Car", configurationPanelXPos + 10, 350, commuterType);
  addCommuters = new IFButton("Add Commuters", configurationPanelXPos + 10, 380);
  
  collisionCounter = new IFLabel("Collision Counter: 0", configurationPanelXPos + 10, 410);
  totalPersonDelay = new IFLabel("Total Person Delay: 0", configurationPanelXPos + 10, 430);
  time = new IFLabel("Time Elapsed: ", configurationPanelXPos + 10, 450);
  // TODO: display total person delay
  
  
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
       
                              
  Point[] NUniversityAveInPoints = {new Point(26.0, 220.0), new Point(117.0, 213.0), new Point(209.0, 212.0), new Point(297.0, 218.0),
                                    new Point(364.0, 236.0), new Point(425.0, 265.0), new Point(490.0, 303.0), new Point(542.0, 350.0),
                                    new Point(589.0, 401.0), new Point(638.0, 450.0), new Point(693.0, 509.0), new Point(743.0, 563.0),
                                    new Point(804.0, 632.0), new Point(860.0, 690.0)};
                                    
  Point[] HillToCentralPoints = { new Point(1041.0, 159.0), new Point(939.0, 170.0), new Point(842.0, 172.0), new Point(754.0, 178.0), new Point(668.0, 196.0),
                                  new Point(588.0, 223.0), new Point(532.0, 280.0), new Point(487.0, 326.0), new Point(420.0, 403.0), new Point(401.0, 480.0), new Point(400.0, 542.0)};
    
  Point[] NUniversityAveOutPoints = {new Point(908.0, 657.0), new Point(845.0, 591.0), new Point(781.0, 527.0), new Point(717.0, 461.0),
                                     new Point(662.0, 398.0), new Point(607.0, 342.0), new Point(548.0, 278.0), new Point(494.0, 230.0),
                                     new Point(430.0, 188.0), new Point(346.0, 164.0), new Point(254.0, 158.0), new Point(152.0, 152.0), new Point(44.0, 152.0)};

  Point[] CentralToHillPoints = {new Point(347.0, 401.0), new Point(385.0, 396.0), new Point(429.0, 362.0), new Point(462.0, 317.0),
                                 new Point(505.0, 270.0), new Point(550.0, 227.0), new Point(581.0, 184.0), new Point(602.0, 125.0), new Point(629.0, 67.0)};
                           
  Path NUniversityAveIn = new Path(NUniversityAveInPoints, color(0, 0, 0), "NUniveristyAveIn");
  Path NUniversityAveOut = new Path(NUniversityAveOutPoints, color(0, 0, 0), "NUniversityAveOut");
  Path HillToCentral = new Path(HillToCentralPoints, color(0, 0, 0), "HillToCentral");
  Path CentralToHill = new Path(CentralToHillPoints, color(0, 0, 0), "CentralToHill");
  
 
  Intersection HillToCentral_NUniversityAveOut = new Intersection(new Point(540.5078, 271.34027), NUniversityAveOut,  HillToCentral);
  Intersection CentralToHill_NUniversityAveOut = new Intersection(new Point(521.38556, 254.3427), NUniversityAveOut, CentralToHill);
  Intersection HillToCentral_NUniversityAveIn = new Intersection(new Point(500.34924, 312.35413), NUniversityAveIn, HillToCentral);
  Intersection CentralToHill_NUniversityAveIn = new Intersection(new Point(480.10236, 297.21368), NUniversityAveIn, CentralToHill);
  
  mySim.addPath(NUniversityAveIn);
  mySim.addPath(NUniversityAveOut);
  mySim.addPath(HillToCentral);
  mySim.addPath(CentralToHill);
  
  mySim.addIntersection(HillToCentral_NUniversityAveOut);
  mySim.addIntersection(CentralToHill_NUniversityAveOut);
  mySim.addIntersection(HillToCentral_NUniversityAveIn);
  mySim.addIntersection(CentralToHill_NUniversityAveIn);
  mySim.addTrafficSignal(HillToCentral_NUniversityAveOut, HillToCentral);
  mySim.addTrafficSignal(HillToCentral_NUniversityAveOut, NUniversityAveOut);
  mySim.addTrafficSignal(CentralToHill_NUniversityAveIn, CentralToHill);
  
  
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
            mySim.addCommuter(new Pedestrian(random(0.1, 0.12), "Student", color(242, 133, 0)), (Path)selection.get());
          }
        }
        else if (commuterType.getSelected() == car) {
          for (int i = 0; i < num; i++) {
            mySim.addCommuter(new Car(12, 9, random(0.3, 0.4), "Rando Car", color(251, 236, 93)), (Path)selection.get());
          }
        }
        else if (commuterType.getSelected() == bus) {
          for (int i = 0; i < num; i++) {
            mySim.addCommuter(new Bus(20, 15, random(1, 1.1), "MBus", color(62, 142, 222)), (Path)selection.get());
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
