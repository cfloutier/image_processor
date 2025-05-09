
class DataLines extends GenericDataClass
{
  DataLines(){ super("Lines"); }
  
  boolean draw = true;
  
  // 0: Straight_line, 1 : Circle_line
  int type = 0;
  
  int nb_lines = 100;
  float canvas_width = 500;
  float canvas_height = 500;

  // angle of the lines
  float direction = 0;
  float step_size = 10;
  
}

class LinesGUI extends GUIPanel
{
  DataLines data;

  public LinesGUI(DataLines data)
  {
    this.data = data;
  }
  
  RadioButton type;
  Toggle draw;
  Slider nb_lines;
  Slider canvas_width;
  Slider canvas_height;

  Slider direction;
  Slider step_size;

  void setupControls()
  {
    super.Init("Lines", data);

    draw = addToggle("draw", "Draw", false);
    nextLine();

    ArrayList<String> labels = new ArrayList<String>();
    labels.add("Lines");
    labels.add("Circles");
    labels.add("Sinus");  

    type = addRadio("type", labels);  

    nb_lines = addIntSlider("nb_lines", "Nb Lines", 2, 10000, true);
    nextLine();
    canvas_width = addIntSlider("canvas_width", "Width", 100, 1000, true);
    nextLine();
    canvas_height = addIntSlider("canvas_height", "Height", 100, 1000, true);
    nextLine();
    direction = addSlider("direction", "Direction", -90, 90, true);
    nextLine();
    step_size = addSlider("step_size", "Step Size", 1, 100, true);
  }

  void update_labels()
  {
    
  }

  void setGUIValues()
  {
    println("LinesGUI.setGUIValues");
    
    draw.setValue(data.draw);
    type.activate(data.type);
    
    nb_lines.setValue(data.nb_lines);
    canvas_width.setValue(data.canvas_width);
    canvas_height.setValue(data.canvas_height);
    direction.setValue(data.direction);
    step_size.setValue(data.step_size);
  }
}

class Line {
  ArrayList<PVector> points =  new ArrayList<PVector>();

  void draw()
  {
    current_graphics.noFill();
    current_graphics.beginShape();

    for (int i = 0; i < points.size(); i++)
    {
      PVector pA = points.get(i);
      current_graphics.vertex(pA.x, pA.y);
    }

    current_graphics.endShape();
  }
}

abstract class LinesGenerator {

  ArrayList<Line> lines =  new ArrayList<Line>();

  DataLines data_lines;

  public LinesGenerator(DataLines data_lines) {
    this.data_lines = data_lines;
  }

  boolean point_in_canvas(PVector p) {
    return (p.x >= -data_lines.canvas_width/2 &&
      p.x <= data_lines.canvas_width/2 &&
      p.y >= -data_lines.canvas_height/2 &&
      p.y <= data_lines.canvas_height/2);
  }
  
  void draw() {
    for (int i = 0; i < lines.size(); i++)
    {
      Line line = lines.get(i);
      line.draw();
    }
  }
}



class StraightLinesGenerator extends LinesGenerator
{
  public StraightLinesGenerator(DataLines data_lines) {

    super(data_lines);
  }

  void buildLines() {
    
    if (!data_lines.changed)
      return;
      
    
    println("StraightLinesGenerator buildLines");

    lines.clear();

    // build a set of lines in the direction of the angle
    // and with a radius of the circle

    float cos_x = cos(radians(data_lines.direction));
    float sin_x = sin(radians(data_lines.direction));

    PVector forward = new PVector(cos_x, sin_x);
    PVector right = new PVector(-sin_x, cos_x);
    //PVector left = new PVector(sin_x, -cos_x);

    float radius = sqrt(data_lines.canvas_width*data_lines.canvas_width+data_lines.canvas_height*data_lines.canvas_height);

    //println("-----------------------------------------------------------------");
    //println("forward " + forward);
    //println("right " + right);

    float spacing = 2*radius / data_lines.nb_lines;
    float advance = -radius;

    while (advance <= radius)
    {
      //println("+++++");
      PVector center_line = new PVector(advance * right.x, advance * right.y );

      //println("center_line " + center_line);
      PVector start_pos = new PVector(center_line.x-forward.x*radius, center_line.y-forward.y*radius);

      //println("start_pos " + start_pos);
      float advance_forward = 0;

      Line line = new Line();
      if (point_in_canvas(start_pos)) {
        line.points.add(start_pos);
      }
      PVector pA = start_pos;
      while (advance_forward <= radius*2)
      {
        pA = new PVector(start_pos.x + forward.x * advance_forward, start_pos.y + forward.y * advance_forward);
        if (point_in_canvas(pA)) {
          line.points.add(pA);
        }

        advance_forward += data_lines.step_size;
      }

      advance += spacing;

      if (line.points.size() > 0)
        lines.add(line);  
    }
  }
}
