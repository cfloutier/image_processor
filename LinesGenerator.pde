
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

    // print("data_lines.use_canvas: " + data_lines.use_canvas);
    
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
    
    if (data_lines.precision < 0.5)
       data_lines.precision = 0.5;
      
    println("MoultiLinesGenerator buildLines");   
    
    switch(data_lines.type)
    {
      default:
      case 0: build_straight_lines(); break;
      case 1: build_circle_lines(); break;   
      case 2: build_sinuses_lines(); break;
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

  void build_sinuses_lines()
  {
    lines.clear();

    float radius = data_lines.size;
    float spacing = data_lines.lines_spacing;

    data_lines.setNbLines( int(2*radius / spacing));
    
    // compute orientation vectors from direction
    float cos_x = cos(radians(data_lines.direction));
    float sin_x = sin(radians(data_lines.direction));

    PVector forward = new PVector(cos_x, sin_x);
    PVector right = new PVector(-sin_x, cos_x);

    float advance = -radius;

    while (advance <= radius)
    {
      Line line = new Line();
      float advance_forward = -radius;
      while (advance_forward <= radius)
      {
        // local coordinates: x along forward, y along right
        float x_local = advance_forward;
        float y_local = data_lines.high * sin(TWO_PI * x_local / data_lines.period) + advance;
        // convert to global position using orientation
        PVector pA = new PVector(
            forward.x * x_local + right.x * y_local,
            forward.y * x_local + right.y * y_local);
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
