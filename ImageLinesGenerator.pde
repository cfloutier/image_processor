class ImageLine extends Polyline
{
}

abstract class ImageLinesGenerator {

  ArrayList<ImageLine> lines =  new ArrayList<ImageLine>();

  DataLines data_lines;

  public ImageLinesGenerator(DataLines data_lines) {
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

  boolean isPointInClipRect(float x, float y)
  {
    return pointInClipRect(x, y, 0, 0, data.page.clip_width, data.page.clip_height);
  }

  ImageLine addSegmentToLine(ImageLine line, float xFrom, float yFrom, float xTo, float yTo)
  {
    if (!data.page.clipping) 
    {
      line.addPoint(new PVector(xFrom, yFrom));
      line.addPoint(new PVector(xTo, yTo));
      return line;
    }

    boolean fromInside = isPointInClipRect(xFrom, yFrom);
    boolean toInside = isPointInClipRect(xTo, yTo);
    float[] clipped = new float[4];
    boolean hasClipped = clipLineToCenteredRect(xFrom, yFrom, xTo, yTo, 
                                                0, 0, 
                                                data.page.clip_width, data.page.clip_height, clipped);

    if (fromInside && toInside)
    {
      // Les deux points dedans → ajouter le segment entier
      line.addPoint(new PVector(xFrom, yFrom));
      line.addPoint(new PVector(xTo, yTo));
    }
    else if (fromInside && !toInside)
    {
      // Dedans → Dehors: ajouter jusqu'au bord puis fermer la ligne
      if (hasClipped)
      {
        line.addPoint(new PVector(clipped[2], clipped[3])); // Point de sortie
      }
      if (line.points.size() >= 2)
      {
        lines.add(line);
      }
      line = new ImageLine();
    }
    else if (!fromInside && toInside)
    {
      // Dehors → Dedans: créer nouvelle ligne avec le point d'entrée
      if (hasClipped)
      {
        if (line.points.size() >= 2)
        {
          lines.add(line);
        }
        line = new ImageLine();
        line.addPoint(new PVector(clipped[0], clipped[1])); // Point d'entrée
        line.addPoint(new PVector(xTo, yTo)); // Point final dedans
      }
    }
    else // !fromInside && !toInside
    {
      // Les deux dehors: vérifier si le segment coupe le rectangle
      if (hasClipped)
      {
        // Le segment traverse → créer nouvelle ligne avec le segment clippé
        if (line.points.size() >= 2)
        {
          lines.add(line);
        }
        line = new ImageLine();
        line.addPoint(new PVector(clipped[0], clipped[1]));
        line.addPoint(new PVector(clipped[2], clipped[3]));
      }
      // Sinon: complètement dehors → ne rien faire
    }

    return line;
  }

  void draw() {
    for (int i = 0; i < lines.size(); i++)
    {
      ImageLine line = lines.get(i);
      line.draw();
    }
  }
}

class ImageMoultiLinesGenerator extends ImageLinesGenerator
{
  public ImageMoultiLinesGenerator(DataLines data_lines) {

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
