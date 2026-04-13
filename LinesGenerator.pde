
class ImageLine extends Polyline
{
}

abstract class LinesGenerator {

  ArrayList<ImageLine> lines =  new ArrayList<ImageLine>();

  DataLines data_lines;

  public LinesGenerator(DataLines data_lines) {
    this.data_lines = data_lines;
  }

  ImageLine current_line = null;

  void addPoint(PVector point)
  {
    if (current_line == null)
    {
      current_line = new ImageLine();
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
      ImageLine line = lines.get(i);
      line.draw();
    }
  }
}

class MoultiLinesGenerator extends LinesGenerator
{
  public MoultiLinesGenerator(DataLines data_lines) {

    super(data_lines);
  }

  StraightLines straight;
  CircleLines circle;
  SinusLines sinus;

  void buildLines() {

    if (data_lines.precision < 0.5)
      data_lines.precision = 0.5;

    //println("MoultiLinesGenerator buildLines");

    switch(data_lines.type)
    {
    default:
    case 0:
      straight.buildLines(this);
      break;
    case 1:
      circle.buildLines(this);
      break;
    case 2:
      sinus.buildLines(this);
      break;
    }
  }
}
