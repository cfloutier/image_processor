
class StraightLinesData extends GenericData
{
  StraightLinesData() {
    super("StraightLines");
  }

  float direction = 0;
  float size = 500;
}

class CircleLinesData extends GenericData
{
  CircleLinesData() {
    super("CircleLines");
  }

  float min_radius = 0;
  float max_radius = 1000;

  float center_x = 0;
  float center_y = 0;

  float ellipse = 0;
}

class SinusLinesData extends GenericData
{
  SinusLinesData() {
    super("SinusLines");
  }

  float size = 500;
  float high = 20;
  float period = 100;
  float direction_sinus = 0;
}

class DataLines extends GenericData
{
  DataLines() {
    super("Lines");

    addChapter(straight_line);
    addChapter(circle_line);
    addChapter(sinus_line);


    
  }


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

  StraightLinesData straight_line =new StraightLinesData();
  CircleLinesData circle_line = new CircleLinesData();
  SinusLinesData sinus_line = new SinusLinesData();

  //////////////////// for straight lines ///////////////
  // for circle lines
  float min_radius = 0;
  float max_radius = 1000;

  float center_x = 0;
  float center_y = 0;

  float ellipse = 0;

  //////////////////// for Sinus ///////////////
  // for sinus lines
  float high = 20;
  float period = 100;
  float direction_sinus = 0;

  void setNbLines(int nb_lines)
  {
    if (this.nb_lines == nb_lines)
      return;

    this.nb_lines = nb_lines;
    data.need_ui_update();
  }

  void LoadJson(JSONObject json)
  {
    super.LoadJson(json);

    // copy from old format
    straight_line.direction = direction;
    straight_line.size = size;

    circle_line.min_radius = min_radius;
    circle_line.max_radius = max_radius;
    circle_line.center_x = center_x;
    circle_line.center_y = center_y;
    circle_line.ellipse = ellipse;

    sinus_line.size = size;
    sinus_line.high = high;
    sinus_line.period = period;
    sinus_line.direction_sinus = direction_sinus;

    // println("DataLines.LoadJson : direction = " + direction + " size = " + size );

    setNbLines(nb_lines);
    changed = true;
  }


}

class LinesGUI extends GUIPanel
{
  DataLines data;

  // groupings for easier visibility toggling and value sync
  ControlsGroup straightGroup;
  ControlsGroup circleGroup;
  ControlsGroup sinusGroup;

  public LinesGUI(DataLines data)
  {
    super("Lines", data);
    this.data = data;
    straightGroup = new ControlsGroup(data);
    circleGroup = new ControlsGroup(data);
    sinusGroup = new ControlsGroup(data);
  }

  RadioButton type;
  Toggle draw;
  Toggle use_canvas;
  Textlabel nb_lines;
  Slider precision;
  Slider lines_spacing;

  Slider canvas_width;
  Slider canvas_height;

  // kept only for use in helper methods
  Slider center_x;
  Slider center_y;
  Slider ellipse;

  void setupControls()
  {
    super.Init();

    draw = addToggle("draw", "Draw");

    nextLine();

    nb_lines = addLabel("Nb Lines = ????");

    lines_spacing = addSlider("lines_spacing", "Lines Spacing", 0.5, 10);

    precision = addSlider("precision", "Precision", 0.2, 10);
    nextLine();
    space();

    use_canvas = addToggle("use_canvas", "Canvas");

    canvas_width = addIntSlider("canvas_width", "Width", 100, 1000);
    canvas_height = addIntSlider("canvas_height", "Height", 100, 1000);
    nextLine();

    ArrayList<String> labels = new ArrayList<String>();
    labels.add("Lines");
    labels.add("Circles");
    labels.add("Sinus");

    addLabel("Curve type");
    type = addRadio("type", labels);
    nextLine();
    float start_yPos = yPos;

    // straight Line
    straightGroup.add(addSlider("direction", "Direction", -90, 90));
    straightGroup.add(addSlider("size", "Size", 10, 2000));
    nextLine();

    // Circle Line
    yPos = start_yPos;
    circleGroup.add(addSlider("min_radius", "Min Radius", 0, 3000));
    circleGroup.add(addSlider("max_radius", "Max radius", 0, 3000));
    nextLine();
    space();

    center_x = addSlider("center_x", "Center X", -2000, 2000);
    circleGroup.add(center_x);
    center_y  = addSlider("center_y", "Center Y", -2000, 2000);
    circleGroup.add(center_y);

    circleGroup.add(addButton("Center").plugTo(this, "center"));
    nextLine();

    ellipse = addSlider("ellipse", "Ellipse", -3, 3);
    circleGroup.add(ellipse);
    circleGroup.add(addButton("Circle").plugTo(this, "circle_me"));
    nextLine();

    // Sinus
    yPos = start_yPos;
    sinusGroup.add(addSlider("size", "Size", 10, 2000));
    sinusGroup.add(addSlider("high", "High", 0, 100));
    nextLine();
    sinusGroup.add(addSlider("period", "Period", 1, 400));
    nextLine();
    sinusGroup.add(addSlider("direction_sinus", "Direction", -90, 90));

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

  // helper methods for visibility
  void showControls(ControlsGroup grp) {
    grp.show();
  }
  void hideControls(ControlsGroup grp) {
    grp.hide();
  }

  void update_ui()
  {
    nb_lines.setText("Nb Lines : " + data.nb_lines);

    // hide everything first, then show the needed group
    hideControls(straightGroup);
    hideControls(circleGroup);
    hideControls(sinusGroup);

    switch(data.type)
    {
    default:
    case 0: // Straight lines
      showControls(straightGroup);
      break;
    case 1:
      showControls(circleGroup);
      break;
    case 2:
      showControls(sinusGroup);
      break;
    }

    if (data.use_canvas)
    {
      canvas_width.show();
      canvas_height.show();
    } else
    {
      canvas_width.hide();
      canvas_height.hide();
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

    precision.setValue(data.precision);
    nb_lines.setText("Nb Lines : " + data.nb_lines);

    // sync type-specific controls using reflection
    straightGroup.updateFromData();
    circleGroup.updateFromData();
    sinusGroup.updateFromData();
  }
}


// base class for line mode generation
// includes data gui and build methods
class LineMode extends ControlsGroup
{
  LineMode( GenericData data )
  {
    super(data);
  }
}



// class StraightLines extends LineMode
// {
//   StraightLinesData line_data;

//   StraightLines() {
//     super(new StraightLinesData());
//     line_data = (StraightLinesData) data;
//   }
// }

