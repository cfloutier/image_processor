
class DataLines extends GenericData
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

  void LoadJson(JSONObject json)
  {
    super.LoadJson(json);
    
    setNbLines(nb_lines);
    changed = true;
  }

  
}

class LinesGUI extends GUIPanel
{
  DataLines data;

  public LinesGUI(DataLines data)
  {
    super("Lines", data);
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
    super.Init();

    draw = addToggle("draw", "Draw");
    
    nb_lines = addLabel("Nb Lines = ????");
    
    lines_spacing = addSlider("lines_spacing", "Lines Spacing", 0.05, 5);

    precision = addSlider("precision", "Precision", 0.2, 10);
    nextLine();space();
    
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

    direction = addSlider("direction", "Direction", -90, 90);
    size = addSlider("size", "Size", 10, 2000);
    nextLine();
    
    yPos = start_yPos;
    
    min_radius = addSlider("min_radius", "Min Radius", 0, 3000);
    max_radius  = addSlider("max_radius", "Max radius", 0, 3000);
    nextLine();
    space();
    
    center_x = addSlider("center_x", "Center X", -2000, 2000);
    center_y  = addSlider("center_y", "Center Y", -2000, 2000);
    
    center_bt = addButton("Center").plugTo(this, "center");
    nextLine();  
    
    ellipse = addSlider("ellipse", "Ellipse", -3, 3);   
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
