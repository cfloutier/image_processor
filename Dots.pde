
class DataDots
{
    boolean Black = false;
    boolean DrawCells = false;
    float CellSize = 4;
    float DotDensity = 10;
    int seed = 0;
    
    boolean drawCells = false;


    void LoadJson(JSONObject src)
    {
        if (src == null)
          return;
      
        Black = src.getBoolean("Black", Black);
        DrawCells = src.getBoolean("DrawCells", DrawCells);
        CellSize = src.getFloat("CellSize", CellSize);
        DotDensity = src.getFloat("DotDensity", DotDensity);
        seed = src.getInt("seed", seed);    
    }

    JSONObject SaveJson()
    {
        JSONObject dest = new JSONObject();


        dest.setBoolean("Black", Black);
        dest.setBoolean("DrawCells",DrawCells);
        dest.setFloat("CellSize", CellSize);
        dest.setFloat("DotDensity", DotDensity);

        return dest;
    }
}

class DotGUI extends GUIPanel
{   
    DataDots data;

    public DotGUI(DataDots data)
    {
      this.data = data;
    }
    
    Toggle Black;
    Toggle DrawCells;
    Slider CellSize;
    Slider DotDensity;
    
    void setupControls()
    {    
        super.Init("Dots");
        
        Black = addToggle("Black", "Black Dots", data); 
        nextLine();  
        DrawCells = addToggle("DrawCells", "Draw Cells", data); 
        
        CellSize = addSlider("CellSize", "Cell Size", data, 2, 40, true);          
        DotDensity = addSlider("DotDensity", "Dots Density", data, 1, 40, true);       
    }
    
    void update()        
    {
        
    }

    void setGUIValues()
    {
        Black.setValue(data.Black);
        DrawCells.setValue(data.DrawCells);

        CellSize.setValue(data.CellSize);
        DotDensity.setValue(data.DotDensity);
    }
}
