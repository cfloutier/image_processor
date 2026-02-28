
class DataLines extends GenericData
{
  DataLines() {
    super("Lines");
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

    setNbLines(nb_lines);
    changed = true;
  }
}

class ControlsGroup {
  ArrayList<Controller> controllers = new ArrayList<Controller>();
  DataLines data;
  
  ControlsGroup(DataLines data) {
    this.data = data;
  }
  
  void add(Controller c) {
    controllers.add(c);
  }
  
  void show() {
    for (Controller c : controllers) c.show();
  }
  
  void hide() {
    for (Controller c : controllers) c.hide();
  }
  
  void updateFromData() {
    for (Controller c : controllers) {
      String fieldName = c.getName();
      try {
        java.lang.reflect.Field dataField = DataLines.class.getField(fieldName);
        Object value = dataField.get(data);
        
        if (c instanceof Slider) {
          Slider slider = (Slider) c;
          slider.setValue(((Number) value).floatValue());
        } else if (c instanceof Toggle) {
          Toggle toggle = (Toggle) c;
          toggle.setValue((Boolean) value);
        } else if (c instanceof RadioButton) {
          RadioButton radio = (RadioButton) c;
          radio.activate(((Number) value).intValue());
        }
      } catch (Exception e) {
        println("Error updating " + fieldName + ": " + e.getMessage());
      }
    }
  }
}

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

  Slider direction;
  Slider size;

  Slider min_radius;
  Slider max_radius;

  Slider center_x;
  Slider center_y;

  Slider ellipse;

  Slider high;
  Slider period;
  Slider direction_sinus;

  Button center_bt;
  Button ellipse_bt;


  void setupControls()
  {
    super.Init();

    draw = addToggle("draw", "Draw");

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
    space();

    float start_yPos = yPos;
    xPos = 0;
    // straight Line
    direction = addSlider("direction", "Direction", -90, 90);
    straightGroup.add(direction);
    size = addSlider("size", "Size", 10, 2000);
    straightGroup.add(size);
    nextLine();

    // Circle Line
    yPos = start_yPos;
    min_radius = addSlider("min_radius", "Min Radius", 0, 3000);
    circleGroup.add(min_radius);
    max_radius  = addSlider("max_radius", "Max radius", 0, 3000);
    circleGroup.add(max_radius);
    nextLine();
    space();

    center_x = addSlider("center_x", "Center X", -2000, 2000);
    circleGroup.add(center_x);
    center_y  = addSlider("center_y", "Center Y", -2000, 2000);
    circleGroup.add(center_y);

    center_bt = addButton("Center").plugTo(this, "center");
    circleGroup.add(center_bt);
    nextLine();

    ellipse = addSlider("ellipse", "Ellipse", -3, 3);
    circleGroup.add(ellipse);
    ellipse_bt = addButton("Circle").plugTo(this, "circle_me");
    circleGroup.add(ellipse_bt);
    nextLine();

    // Sinus
    yPos = start_yPos;
    high = addSlider("high", "High", 0, 20);
    sinusGroup.add(high);
    nextLine();
    period = addSlider("period", "Period", 10, 200);
    sinusGroup.add(period);
    nextLine();
    direction_sinus = addSlider("direction_sinus", "Direction", -90, 90);
    sinusGroup.add(direction_sinus);

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

