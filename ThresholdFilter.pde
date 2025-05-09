
class DataThreshold extends GenericDataClass
{
  DataThreshold(){ super("Threshold"); }
  
  
  
    boolean draw = true;
    boolean black = true;
    boolean mirror = false;
    int nb_values = 1;

    float threshold_1 = 125;
    float threshold_2 = 125; 
    float threshold_3 = 125;
    float threshold_4 = 125;
    float threshold_5 = 125;
    float threshold_6 = 125;
    float threshold_7 = 125;
    float threshold_8 = 125;
    
    float get_threshold_by_index(int index)
    {
      
      switch (index)
      {
        case 0: return threshold_1; 
        case 1: return threshold_2; 
        case 2: return threshold_3; 
        case 3: return threshold_4; 
        case 4: return threshold_5; 
        case 5: return threshold_6; 
        case 6: return threshold_7;
        case 7: return threshold_8; 
        default:
          return 0;   
      }   
    }
    
}

class ThresholdGUI extends GUIPanel
{
  DataThreshold data;

  public ThresholdGUI(DataThreshold data)
  {
    this.data = data;
  }

  Toggle draw;
  Toggle black;
  Toggle mirror;
  
  Slider nb_values;

  Slider threshold_1;
  Slider threshold_2;
  Slider threshold_3;
  Slider threshold_4;
  Slider threshold_5;
  Slider threshold_6;
  Slider threshold_7;
  Slider threshold_8;

  Slider canvas_height;

  Slider direction;
  Slider step_size;
  
  void setupControls()
  {
    super.Init("Seuils", data);

    draw = addToggle("draw", "Draw", true);    
    black = addToggle("black", "Black Lines", true); 
    mirror = addToggle("mirror", "Mirror order", true); 

    nextLine();

    nb_values = addIntSlider("nb_values", "Nb values used", 1, 8, true);nextLine();
    nextLine();
    threshold_1 = addSlider("threshold_1", "Threshold 1", 0, 255, true);nextLine();
    threshold_2 = addSlider("threshold_2", "Threshold 2", 0, 255, true);nextLine();
    threshold_3 = addSlider("threshold_3", "Threshold 3", 0, 255, true);nextLine();
    threshold_4 = addSlider("threshold_4", "Threshold 4", 0, 255, true);nextLine();
    threshold_5 = addSlider("threshold_5", "Threshold 5", 0, 255, true);nextLine();
    threshold_6 = addSlider("threshold_6", "Threshold 6", 0, 255, true);nextLine();
    threshold_7 = addSlider("threshold_7", "Threshold 7", 0, 255, true);nextLine();
    threshold_8 = addSlider("threshold_8", "Threshold 8", 0, 255, true);nextLine();
  }

  void update_labels()
  {
    
  }

  void setGUIValues()
  {
    draw.setValue(data.draw);
    black.setValue(data.black);
    nb_values.setValue(data.nb_values);

    threshold_1.setValue(data.threshold_1);
    threshold_2.setValue(data.threshold_2);
    threshold_3.setValue(data.threshold_3);
    threshold_4.setValue(data.threshold_4);
    threshold_5.setValue(data.threshold_5);
    threshold_6.setValue(data.threshold_6);
    threshold_7.setValue(data.threshold_7);
    threshold_8.setValue(data.threshold_8);
  }
}

class ThresholdFilter extends LinesGenerator
{
    public ThresholdFilter(DataLines data_lines, DataThreshold data_threshold) {

        super(data_lines);
        this.data_threshold = data_threshold;
    }
    
    DataThreshold data_threshold;

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
        println("ThresholdFilter. buildLines");
      
    
        lines.clear();
        
        int direction_index = 1; 
        int threshold_index = 0;
        
        for (int i_line = 0; i_line < source_lines.size(); i_line++)
        {
            Line source_line = source_lines.get(i_line); 
            
            float threshold = data_threshold.get_threshold_by_index(threshold_index);
            //print("-" + threshold_index); 
             
            threshold_index += direction_index;
            if (data_threshold.mirror)
            {
               if (threshold_index >= data_threshold.nb_values || threshold_index < 0)
              {
                direction_index = -direction_index;
                threshold_index += direction_index*2;
              }             
            }
            else
            {
              if (threshold_index >= data_threshold.nb_values)
                threshold_index = 0;
            }

            
            for (int i_point = 0; i_point < source_line.points.size(); i_point++ )
            {
                PVector point = source_line.points.get(i_point);
                float value = image.getValue(point);
                
                
                if (value < threshold)
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
