// Generic Polyline class for shared use across projects
// Used by: spiral, image_processor, perlin_mountains

class Polyline
{
  ArrayList<PVector> points = new ArrayList<PVector>();

  void draw()
  {
    if (points.size() < 2)
      return;

    current_graphics.noFill();
    current_graphics.beginShape();

    for (int i = 0; i < points.size(); i++)
    {
      PVector p = points.get(i);
      current_graphics.vertex(p.x, p.y);
    }

    current_graphics.endShape();
  }

  void addPoint(PVector p)
  {
    points.add(p);
  }

  void clear()
  {
    points.clear();
  }

  int size()
  {
    return points.size();
  }

  PVector get(int index)
  {
    return points.get(index);
  }
}

// Extended Polyline with per-point validity and Y offset for line-based rendering
// Used by: perlin_mountains
class ValidatedPolylineWithOffset extends Polyline
{
  boolean[] validity = null;
  float y_offset = 0;

  void setValidity(boolean[] valid)
  {
    this.validity = valid;
  }

  void setYOffset(float offset)
  {
    this.y_offset = offset;
  }

  void draw()
  {
    if (points.size() < 1)
      return;

    if (validity == null)
    {
      // No validity check, draw as simple polyline
      super.draw();
      return;
    }

    // Draw with validity checks - may create multiple line segments
    current_graphics.noFill();
    boolean drawing = false;

    for (int i = 0; i < points.size(); i++)
    {
      boolean valid = validity[i];
      if (valid)
      {
        PVector p = points.get(i);
        if (!drawing)
        {
          drawing = true;
          current_graphics.beginShape();
        }

        current_graphics.vertex(p.x, p.y + y_offset);
      }
      else
      {
        if (drawing)
        {
          drawing = false;
          current_graphics.endShape();
        }
      }
    }

    if (drawing)
    {
      current_graphics.endShape();
    }
  }
}

// Polyline for spiral: draws points as individual line segments (point-to-point)
// Used by: spiral
class SegmentedPolyline extends Polyline
{
  void draw()
  {
    if (points.size() < 2)
      return;

    // Draw as individual line segments, not a continuous polyline
    for (int i = 0; i < points.size() - 1; i += 2)
    {
      PVector p1 = points.get(i);
      PVector p2 = points.get(i + 1);
      current_graphics.line(p1.x, p1.y, p2.x, p2.y);
    }
  }
}
