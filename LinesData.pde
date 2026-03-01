
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

  StraightLinesData straight_line =new StraightLinesData();
  CircleLinesData circle_line = new CircleLinesData();
  SinusLinesData sinus_line = new SinusLinesData();

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

    // println("DataLines.LoadJson : direction = " + direction + " size = " + size );

    setNbLines(nb_lines);
    changed = true;
  }
}

class LinesGUI extends GUIPanel
{
  DataLines data;

  // groupings for easier visibility toggling and value sync
  StraightLines straightGroup;
  CircleLines circleGroup;
  SinusLines sinusGroup;

  public LinesGUI(DataLines data)
  {
    super("Lines", data);
    this.data = data;
    straightGroup = new StraightLines(data, data.straight_line);
    circleGroup = new CircleLines(data, data.circle_line);
    sinusGroup = new SinusLines(data, data.sinus_line);
  }

  RadioButton type;
  Toggle draw;
  Toggle use_canvas;
  Textlabel nb_lines;
  Slider precision;
  Slider lines_spacing;

  Slider canvas_width;
  Slider canvas_height;



  Button circle_bt;

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
    straightGroup.buildUI(this);
    
    nextLine();

    // Circle Line
    yPos = start_yPos;
    circleGroup.buildUI(this);

    
    


    nextLine();

    // Sinus
    yPos = start_yPos;
    sinusGroup.buildUI(this);
    

    nextLine();
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

  LinesGenerator generator;
}


