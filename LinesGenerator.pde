
class DataLines
{
  boolean enable = true;

  int nb_lines = 100;
  float canvas_width = 500;
  float canvas_height = 500;

  // angle of the lines
  float direction = 0;
  float step_size = 10;

  void LoadJson(JSONObject src)
  {
    if (src == null)
      return;

    enable = src.getBoolean("enable", enable);
    nb_lines = src.getInt("nb_lines", nb_lines);
    canvas_width = src.getFloat("canvas_width", canvas_width);
    canvas_height = src.getFloat("canvas_height", canvas_height);
    direction = src.getFloat("direction", direction);

    step_size = src.getFloat("step_size", step_size);
  }

  JSONObject SaveJson()
  {
    JSONObject dest = new JSONObject();

    dest.setBoolean("enable", enable);
    dest.setInt("nb_lines", nb_lines);
    dest.setFloat("canvas_width", canvas_width);
    dest.setFloat("canvas_height", canvas_height);
    dest.setFloat("direction", direction);

    dest.setFloat("step_size", step_size);

    return dest;
  }
}

class LinesGUI extends GUIPanel
{
  DataLines data;

  public LinesGUI(DataLines data)
  {
    this.data = data;
  }

  Toggle enable;
  Slider nb_lines;
  Slider canvas_width;
  Slider canvas_height;

  Slider direction;
  Slider step_size;

  void setupControls()
  {
    super.Init("Lines");

    enable = addToggle("enable", "Enabled", data);
    nextLine();
    nb_lines = addIntSlider("nb_lines", "Nb Lines", data, 2, 2000, true);
    nextLine();
    canvas_width = addIntSlider("canvas_width", "Width", data, 100, 1000, true);
    nextLine();
    canvas_height = addIntSlider("canvas_height", "Height", data, 100, 1000, true);
    nextLine();
    direction = addSlider("direction", "Direction", data, -90, 90, true);
    nextLine();
    step_size = addSlider("step_size", "Step Size", data, 1, 100, true);
  }

  void update()
  {
  }

  void setGUIValues()
  {
    enable.setValue(data.enable);
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

  DataLines data;

  public LinesGenerator(DataLines data) {
    this.data = data;
  }

  boolean point_in_canvas(PVector p) {
    return (p.x >= -data.canvas_width/2 &&
      p.x <= data.canvas_width/2 &&
      p.y >= -data.canvas_height/2 &&
      p.y <= data.canvas_height/2);
  }
  
  void draw() {
    for (int i = 0; i < lines.size(); i++)
    {
      Line line = lines.get(i);
      line.draw();
    }
  }
}

class ThresholdFilter extends LinesGenerator
{
    public ThresholdFilter(DataLines data) {

        super(data);
    }

    void buildLines(LinesGenerator source_generator, DataImage image)
    {
        buildLines(source_generator.lines, image);
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
  
    void buildLines(ArrayList<Line> source_lines, DataImage image)
    {
        lines.clear();

        for (int i_line = 0; i_line < source_lines.size(); i_line++)
        {
            Line source_line = source_lines.get(i_line);       
            for (int i_point = 0; i_point < source_line.points.size(); i_point++ )
            {
                PVector point = source_line.points.get(i_point);
                float value = image.getValue(point);
                if (value < 125)
                {
                    addPoint(point);
                }  
                else
                {
                    closeLine();
                }
            }
            closeLine();
        }    
    }
}

class StraightLinesGenerator extends LinesGenerator
{
  public StraightLinesGenerator(DataLines data) {

    super(data);
  }

  void buildLines() {

    lines.clear();

    // build a set of lines in the direction of the angle
    // and with a radius of the circle

    float cos_x = cos(radians(data.direction));
    float sin_x = sin(radians(data.direction));

    PVector forward = new PVector(cos_x, sin_x);
    PVector right = new PVector(-sin_x, cos_x);
    //PVector left = new PVector(sin_x, -cos_x);

    float radius = sqrt(data.canvas_width*data.canvas_width+data.canvas_height*data.canvas_height);

    //println("-----------------------------------------------------------------");
    //println("forward " + forward);
    //println("right " + right);

    float spacing = 2*radius / data.nb_lines;
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

        //println("pA" + pA);

        advance_forward += data.step_size;
      }

      //println("end_pos " + pA);

      advance += spacing;

      if (line.points.size() > 0)
        lines.add(line);
    }
  }
}
