import interfascia.*;
import java.util.Optional;

GUIController c;

IFCheckBox addPath, addPoint;
IFButton delete;
IFButton enterColor;
IFLabel label;
IFTextField colorOption;
IFTextField numCommuter;
IFRadioController commuterType;
IFRadioButton ped, car, bus;
IFButton addCommuters;


PImage backgroundImage;
int frameWidth = 1033;
int frameHeight = 720;

boolean configurationWindowToggled = false;
boolean addPointToggled = false;
boolean addPathToggled = false;

int configurationPanelXPos = frameWidth - 160;
int configurationPanelYPos = 0;
int configurationPanelWidth = 160;
int configurationPanelHeight = 370;


ArrayList<Point> buffer = new ArrayList<Point>();
Optional<SimulationEntity> selection;

Sim mySim;



void setup() {
  
  size(1033, 720);
  backgroundImage = loadImage("CCTC.png");
  backgroundImage.resize(frameWidth, frameHeight);
  
  mySim = new Sim(this);
  c = new GUIController(this);
  
  label = new IFLabel("", frameWidth - 150, 10);
  addPoint = new IFCheckBox("Add Point", frameWidth - 150, 50);
  addPath = new IFCheckBox("Add Path", frameWidth - 150, 90);
  delete = new IFButton("Delete", frameWidth - 150, 130);
  colorOption = new IFTextField("Color", frameWidth - 150, 170, 130, "R G B");
  enterColor = new IFButton("Enter Color", frameWidth - 150, 210);
  numCommuter = new IFTextField("# of Commuters", frameWidth - 150, 250, 130, "10");
  
  commuterType = new IFRadioController("Type of Commuter");
  ped = new IFRadioButton("Pedestrian", frameWidth - 150, 280, commuterType);
  bus = new IFRadioButton("Bus", frameWidth - 150, 300, commuterType);
  car = new IFRadioButton("Car", frameWidth - 150, 320, commuterType);
  addCommuters = new IFButton("Add Commuters", frameWidth - 150, 340);
  
  
  
  c.add(label);
  c.add(addPoint);
  c.add(addPath);
  c.add(delete);
  c.add(colorOption);
  c.add(enterColor);
  c.add(numCommuter);
  c.add(commuterType);
  c.add(ped);
  c.add(bus);
  c.add(car);
  c.add(addCommuters);
  
  
  addPoint.addActionListener(this);
  addPath.addActionListener(this);
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
  background(backgroundImage);
  rect(configurationPanelXPos, configurationPanelYPos, configurationPanelWidth, configurationPanelHeight);
  
  stroke(0, 0, 0);
  
  // DO NOT ADD THINGS TO THE SIM IN DRAW() FUNCTION!!!!!
  
  
  for (int i = 0; i < buffer.size(); i++) {
    buffer.get(i).draw(this);
  }
  
  mySim.update();
  mySim.draw();
  
  
  //// collision detection in abstract class
  //// give travel direction 
  
}

void actionPerformed(GUIEvent e) {
  // addPoint is toggled
  if (e.getSource() == addPoint) {
    addPointToggled = !addPointToggled;
  }
  // addPath is toggled
  else if (e.getSource() == addPath) {
    if (addPathToggled && buffer.size() >= 2) {
      Point[] nodes = new Point[buffer.size()];
      buffer.toArray(nodes);
      mySim.addPath(nodes);
      buffer.clear();
    }
    addPathToggled = !addPathToggled;
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
            mySim.addCommuter(new Pedestrian((Path)selection.get(), random(0.1, 0.4)));
          }
        }
        else if (commuterType.getSelected() == car) {
          for (int i = 0; i < num; i++) {
            mySim.addCommuter(new Car((Path)selection.get(), random(0.1, 0.4)));
          }
        }
        else if (commuterType.getSelected() == bus) {
          for (int i = 0; i < num; i++) {
            mySim.addCommuter(new Bus((Path)selection.get(), random(0.1, 0.4)));
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
      buffer.add(new Point(mouseX, mouseY));
    }
    else if (selection.isPresent()) {
      configurationWindowToggled = true;
      label.setLabel(selection.get().toString());
    }
    else {
      label.setLabel("Nothing selected");
    }
  }
  
}
