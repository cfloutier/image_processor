
class DataLines extends GenericDataClass
{
  DataLines(){ super("Lines"); }
  
  boolean draw = true;
  
  int nb_lines = 100;
  float lines_spacing = 1;
  
  // pixel precision
  float precision = 1;
  
  boolean use_canvas = true;
  
  float canvas_width = 500;
  float canvas_height = 500;
  
  // 0: Straight_line, 
  // 1 : Circle_line
  // 2 : sinuses
  int type = 0;
  
  //////////////////// for straight lines ///////////////
  // angle of the lines
  float direction = 0;
  // size of straight lines
  float size = 500;
  
  
  float min_radius = 0;
  float max_radius = 1000;
  
  float center_x = 0;
  float center_y = 0;
  
  float ellipse = 0;
  
  void setNbLines(int nb_lines)
  {
    if (this.nb_lines == nb_lines)
      return;
      
    this.nb_lines = nb_lines;
    data.need_ui_update();
    
  }
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
  Toggle use_canvas;
  Textlabel nb_lines;
  Slider precision;
  Slider lines_spacing;
    
  Slider canvas_width;
  Slider canvas_height;

  Slider direction;
  Slider size;
  
  Slider min_radius;
  Slider max_radius;
  
  Slider center_x;
  Slider center_y; 
  
  Slider ellipse; 
  
  Button center_bt;
  Button ellipse_bt;

  void setupControls()
  {
    super.Init("Lines", data);

    draw = addToggle("draw", "Draw", false);
    
    nb_lines = addLabel("Nb Lines = ????");
    
    lines_spacing = addSlider("lines_spacing", "Lines Spacing", 0.05, 1, true);

    precision = addSlider("precision", "Precision", 0.2, 10, true);
    nextLine();space();
    
    use_canvas = addToggle("use_canvas", "Canvas", false);
    
    canvas_width = addIntSlider("canvas_width", "Width", 100, 1000, true);
    canvas_height = addIntSlider("canvas_height", "Height", 100, 1000, true);
    nextLine();

    ArrayList<String> labels = new ArrayList<String>();
    labels.add("Lines");
    labels.add("Circles");
    labels.add("Sinus");  
    
    addLabel("Curve type");
    type = addRadio("type", labels);  
    space();
    
    float start_yPos = yPos;

    direction = addSlider("direction", "Direction", -90, 90, true);
    size = addSlider("size", "Size", 10, 2000, true);
    nextLine();
    
    yPos = start_yPos;
    
    min_radius = addSlider("min_radius", "Min Radius", 0, 3000, true);
    max_radius  = addSlider("max_radius", "Max radius", 0, 3000, true);
    nextLine();
    space();
    
    center_x = addSlider("center_x", "Center X", -2000, 2000, true);
    center_y  = addSlider("center_y", "Center Y", -2000, 2000, true);
    
    center_bt = addButton("Center").plugTo(this, "center");
    nextLine();  
    
    ellipse = addSlider("ellipse", "Ellipse", -3, 3, true);   
    ellipse_bt = addButton("Circle").plugTo(this, "circle_me");
    
    nextLine();  

  }
  
  void center()
  {
    data.center_x = 0;
    data.center_y = 0;
    
    center_x.setValue(data.center_x);
    center_y.setValue(data.center_y);
  }
  
  void circle_me()
  {
    data.ellipse =0;
    ellipse.setValue(0);
    
  }

  void update_ui()
  {
    nb_lines.setText("Nb Lines : " + data.nb_lines);

     switch(data.type)
     {
       default:
       case 0: // Straight lines
         direction.show();
         size.show();
         
         min_radius.hide();
         max_radius.hide();
         center_x.hide();
         center_y.hide();    
         ellipse.hide();  
         center_bt.hide();  
         ellipse_bt.hide();  
         
         break;
       case 1: 
         direction.hide();
         size.hide();
         min_radius.show();
         max_radius.show();
         center_x.show();
         center_y.show();  
         ellipse.show();  
         center_bt.show();  
         ellipse_bt.show();  
         break; 
     }
       
    if (data.use_canvas)
    {
      canvas_width.show();
      canvas_height.show();
    }
    else
    {
      canvas_width.show();
      canvas_height.show();  
    } 
  }

  void setGUIValues()
  {
    println("LinesGUI.setGUIValues");
    
    draw.setValue(data.draw);
    type.activate(data.type);
    
    lines_spacing.setValue(data.lines_spacing);

    use_canvas.setValue(data.use_canvas); 
    canvas_width.setValue(data.canvas_width);
    canvas_height.setValue(data.canvas_height);

    direction.setValue(data.direction);
    
    precision.setValue(data.precision);
    size.setValue(data.size);
    
    min_radius.setValue(data.min_radius);
    max_radius.setValue(data.max_radius);
    
    center_x.setValue(data.center_x);
    center_y.setValue(data.center_y);
    
    ellipse.setValue(data.ellipse);
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
  
  Line current_line = null;

    void addPoint(PVector point)
    {
        if (current_line == null)
        {
            current_line = new Line();
        }

        current_line.points.add(point);
    }  

    void closeLine()
    {
        if (current_line != null)
        {
            lines.add(current_line);
            current_line = null;
        }
    }

  boolean point_in_canvas(PVector p) {
    
    if (!data_lines.use_canvas)
      return true;
    
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

class MoultiLinesGenerator extends LinesGenerator
{
  public MoultiLinesGenerator(DataLines data_lines) {

    super(data_lines);
  }
  
  void buildLines() {
    
     if (!data_lines.changed)
      return;
      
      
     if (data_lines.precision < 0.2)
       data_lines.precision = 0.2;
      
    println("StraightLinesGenerator buildLines");   
    
    switch(data_lines.type)
    {
      default:
      case 0: build_straight_lines(); break;
      case 1: build_circle_lines(); break;   
    }
    
  }
  
  PVector _circle_point(float radius_x, float radius_y, float angle)
  {
     return new PVector(
         data_lines.center_x +  radius_x * cos(angle), 
         data_lines.center_y + radius_y * sin(angle));
  }
    
  
  void _addCircle(float radius_x, float radius_y)
  {
    float mean_radius = (radius_x + radius_y)/2;
    
    float len = 2 * PI * mean_radius;
    int nb_parts = ceil(len / data_lines.precision);
    float delta_angle = 2*PI / nb_parts;
    
    float angle = 0;
    PVector start_pos = _circle_point(radius_x, radius_y, angle);
    
    if (point_in_canvas(start_pos))
        addPoint(start_pos);
        
    angle += delta_angle;
    while (angle < 2* PI)
    {
      
      PVector pos = _circle_point(radius_x, radius_y, angle);
       if (point_in_canvas(pos))
        addPoint(pos);
       else
         closeLine();
         
      
      angle += delta_angle;
  
    }
    
    if (point_in_canvas(start_pos))
        addPoint(start_pos);
    
    closeLine();
    
    
  }
  
  void build_circle_lines()
  {
     lines.clear();
     
     float delta_radius = data_lines.max_radius - data_lines.min_radius;

     data_lines.setNbLines(int(delta_radius / data_lines.lines_spacing));
     
     float radius = data_lines.min_radius;
     
     float strech = 1;
     if (data_lines.ellipse >= 0)
         strech = 1 + data_lines.ellipse;
     else
         strech = 1 / (1 - data_lines.ellipse);
     
     while (radius < data_lines.max_radius)
     { 
         float radius_x = radius*strech;
         float radius_y = radius/strech;
       
       
         _addCircle(radius_x, radius_y);
        radius += data_lines.lines_spacing;
     }
 
  }
  
  void build_straight_lines()
  {
    lines.clear();

    // build a set of lines in the direction of the angle
    // and with a radius of the circle

    float cos_x = cos(radians(data_lines.direction));
    float sin_x = sin(radians(data_lines.direction));

    PVector forward = new PVector(cos_x, sin_x);
    PVector right = new PVector(-sin_x, cos_x);
    //PVector left = new PVector(sin_x, -cos_x);

    float radius = data_lines.size;
    float spacing = data_lines.lines_spacing;

    data_lines.setNbLines( int(2*radius / spacing));
    
    float advance = -radius;

    while (advance <= radius)
    {
      PVector center_line = new PVector(advance * right.x, advance * right.y );
      PVector start_pos = new PVector(center_line.x-forward.x*radius, center_line.y-forward.y*radius);

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

        advance_forward += data_lines.precision;
      }

      advance += spacing;

      if (line.points.size() > 0)
        lines.add(line);  
    }
  }
}
