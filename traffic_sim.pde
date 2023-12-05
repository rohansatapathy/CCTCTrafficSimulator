import interfascia.*;
import java.util.Optional;
import java.io.BufferedWriter;
import java.io.FileWriter;

GUIController c;

IFCheckBox addPath, addPoint, addIntersection, addTrafficSignal, addTrafficSensor;
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
boolean addTrafficSignalToggled = false;
boolean addTrafficSensorToggled = false;

int configurationPanelWidth = 210;
int configurationPanelHeight = 520;
int configurationPanelXPos = frameWidth - configurationPanelWidth;
int configurationPanelYPos = 0;
float simTime = 0;


ArrayList<Point> pointBuffer = new ArrayList<Point>();
ArrayList<Path> pathBuffer = new ArrayList<Path>();
ArrayList<Intersection> intersectionBuffer = new ArrayList<Intersection>();
ArrayList<TrafficSignal> signalBuffer = new ArrayList<TrafficSignal>();
boolean selectSensorPoint = false;
Optional<SimEntity> selection;
final int FRAME_RATE = 60;

Sim mySim;


void setup() {
  
  size(1300, 730);
  backgroundImage = loadImage("CCTC.png");
  backgroundImage.resize(frameWidth, frameHeight);
  frameRate(FRAME_RATE);
  
  mySim = new Sim(this, FRAME_RATE);
  
 
  c = new GUIController(this);
  
  label = new IFLabel("", configurationPanelXPos + 10, 10);
  addPoint = new IFCheckBox("Add Point", configurationPanelXPos + 10, 40);
  addPath = new IFCheckBox("Add Path", configurationPanelXPos + 10, 70);
  addIntersection = new IFCheckBox("Add Intersection", configurationPanelXPos + 10, 100);
  addTrafficSignal = new IFCheckBox("Add Traffic Signal", configurationPanelXPos + 10, 130);
  addTrafficSensor = new IFCheckBox("Add Traffic Sensor", configurationPanelXPos + 10, 160);
  delete = new IFButton("Delete", configurationPanelXPos + 10, 190);
  colorOption = new IFTextField("Color", configurationPanelXPos + 10, 220, 130, "R G B");
  enterColor = new IFButton("Enter Color", configurationPanelXPos + 10, 250);
  numCommuter = new IFTextField("# of Commuters", configurationPanelXPos + 10, 280, 130, "1");
  commuterType = new IFRadioController("Type of Commuter");
  ped = new IFRadioButton("Pedestrian", configurationPanelXPos + 10, 310, commuterType);
  bus = new IFRadioButton("Bus", configurationPanelXPos + 10, 340, commuterType);
  car = new IFRadioButton("Car", configurationPanelXPos + 10, 370, commuterType);
  addCommuters = new IFButton("Add Commuters", configurationPanelXPos + 10, 400);
  collisionCounter = new IFLabel("Collision Counter: 0", configurationPanelXPos + 10, 430);
  totalPersonDelay = new IFLabel("Total Person Delay: 0", configurationPanelXPos + 10, 460);
  time = new IFLabel("Time Elapsed: ", configurationPanelXPos + 10, 490);
  
  
  c.add(label);
  c.add(addPoint);
  c.add(addPath);
  c.add(addIntersection);
  c.add(addTrafficSignal);
  c.add(addTrafficSensor);
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
  addTrafficSignal.addActionListener(this);
  addTrafficSensor.addActionListener(this);
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
                           
  Path NUniversityAveIn = mySim.addPath(NUniversityAveInPoints, color(0, 0, 0), "NUniveristyAveIn");
  Path NUniversityAveOut = mySim.addPath(NUniversityAveOutPoints, color(0, 0, 0), "NUniversityAveOut");
  Path HillToCentral = mySim.addPath(HillToCentralPoints, color(0, 0, 0), "HillToCentral");
  Path CentralToHill = mySim.addPath(CentralToHillPoints, color(0, 0, 0), "CentralToHill");
  
  Optional<Intersection> HillToCentral_NUniversityAveOut = mySim.addIntersection(NUniversityAveOut,  HillToCentral);
  Optional<Intersection> CentralToHill_NUniversityAveOut = mySim.addIntersection(NUniversityAveOut, CentralToHill);
  Optional<Intersection> HillToCentral_NUniversityAveIn = mySim.addIntersection(NUniversityAveIn, HillToCentral);
  Optional<Intersection> CentralToHill_NUniversityAveIn = mySim.addIntersection(NUniversityAveIn, CentralToHill);
  
  Optional<TrafficSignal> NUniversityOutSignal;
  Optional<TrafficSignal> HillToCentralSignal;
  Optional<TrafficSignal> CentralToHillSignal;
  Optional<TrafficSignal> NUniversityAveInSignal;
  
  ArrayList<TrafficSignal> signals = new ArrayList<TrafficSignal>();
  
  if (HillToCentral_NUniversityAveOut.isPresent()) { 
    NUniversityOutSignal = mySim.addTrafficSignal(HillToCentral_NUniversityAveOut.get(), NUniversityAveOut);
    HillToCentralSignal = mySim.addTrafficSignal(HillToCentral_NUniversityAveOut.get(), HillToCentral);
    signals.add(HillToCentralSignal.get());
  }
  
  if (CentralToHill_NUniversityAveIn.isPresent()) {
    CentralToHillSignal = mySim.addTrafficSignal(CentralToHill_NUniversityAveIn.get(), CentralToHill);
    NUniversityAveInSignal = mySim.addTrafficSignal(CentralToHill_NUniversityAveIn.get(), NUniversityAveIn);
    signals.add(CentralToHillSignal.get());
  }
  
  Point position_1 = new Point(NUniversityAveOut.getPoseDistanceFrom(HillToCentral_NUniversityAveOut.get().getXCenterPos(), HillToCentral_NUniversityAveOut.get().getYCenterPos(), -200).get().getPosition());
  mySim.addTrafficSensor(NUniversityAveOut, position_1.getX(), position_1.getY(), signals);
  
  Point position_2 = new Point(NUniversityAveIn.getPoseDistanceFrom(CentralToHill_NUniversityAveIn.get().getXCenterPos(), CentralToHill_NUniversityAveIn.get().getYCenterPos(), -200).get().getPosition());
  mySim.addTrafficSensor(NUniversityAveIn, position_2.getX(), position_2.getY(), signals);
  
  mySim.addPedestrian(20, HillToCentral);
  mySim.addPedestrian(20, CentralToHill);
  mySim.addCar(3, NUniversityAveOut);
  mySim.addBus(2, NUniversityAveOut);
  mySim.addBus(3, NUniversityAveIn);
  mySim.addCar(1, NUniversityAveIn);
  
  
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
  totalPersonDelay.setLabel("Total Person Delay: " + mySim.getTotalPersonDelay());
  
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
    if (addIntersectionToggled && pathBuffer.size() == 2) {
       if (!mySim.addIntersection(pathBuffer.get(0), pathBuffer.get(1)).isPresent()) {
         label.setLabel("Failed to find intersection.");
       }
    }
    else {
      label.setLabel("Select 2 intersection paths");
    }
    addIntersectionToggled = !addIntersectionToggled;
    //selectIntersectionPoint = false;
    pathBuffer.clear();
  }
  // addTrafficSignal is toggled
  else if (e.getSource() == addTrafficSignal) {
    if (addTrafficSignalToggled && pathBuffer.size() == 1 && intersectionBuffer.size() == 1) {
      if (!mySim.addTrafficSignal(intersectionBuffer.get(0), pathBuffer.get(0)).isPresent()) {
        label.setLabel("Failed to find signal location");
      }
    }
    addTrafficSignalToggled = !addTrafficSignalToggled;
    pathBuffer.clear();
    intersectionBuffer.clear();
  }
  // addTrafficSensor is toggled
  else if (e.getSource() == addTrafficSensor) {
    if (addTrafficSensorToggled) {
      if (pathBuffer.size() == 1 && pointBuffer.size() == 1 && signalBuffer.size() > 0) {
        mySim.addTrafficSensor(pathBuffer.get(0), pointBuffer.get(0).getX(), pointBuffer.get(0).getY(), new ArrayList<TrafficSignal>(signalBuffer));
      }
      else {
        label.setLabel("Failed to create sensor");
      }
    }
    else {
      label.setLabel("Select path point and traffic signal(s)");
    }
    addTrafficSensorToggled = !addTrafficSensorToggled;
    selectSensorPoint = true;
    signalBuffer.clear();
    pointBuffer.clear();
    pathBuffer.clear();
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
          mySim.addPedestrian(num, (Path)selection.get());
        }
        else if (commuterType.getSelected() == car) {
          mySim.addCar(num, (Path)selection.get());
        }
        else if (commuterType.getSelected() == bus) {
          mySim.addBus(num, (Path)selection.get());
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
      if (selection.isPresent() && selection.get() instanceof Path) {
        pathBuffer.add((Path)selection.get());
      }
      label.setLabel("Select 2 intersection paths");
      
    }
    else if (addTrafficSignalToggled) {
      if (selection.isPresent() && selection.get() instanceof Intersection) {
        intersectionBuffer.add((Intersection)selection.get());
      }
      if (selection.isPresent() && selection.get() instanceof Path) {
        pathBuffer.add((Path)selection.get());
      }
      
      label.setLabel("Select an intersection and path");
    }
    else if (addTrafficSensorToggled) {
      if (selectSensorPoint && selection.get() instanceof Path) {
        pointBuffer.add(new Point(mouseX, mouseY));
        pathBuffer.add((Path)selection.get());
      }
      else if (selection.isPresent() && selection.get() instanceof TrafficSignal) {
        signalBuffer.add((TrafficSignal)selection.get());
      }
      label.setLabel("Select path point and traffic signal(s)");
    }
    else if (selection.isPresent()) {
      label.setLabel(selection.get().toString());
    }
    else {
      label.setLabel("Nothing selected");
    }
  }
  
}
