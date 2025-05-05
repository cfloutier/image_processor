

class Cell
{
    DataDots data;
    PVector pos;
    float value;
    Cell(DataDots data, PVector pos, float value)
    {
      this.data =  data;
      this.pos = pos;
      this.value = value;
    }
    
    void drawSquare(DrawingGenerator drawer)
    {
        PVector center = new PVector(pos.x + drawer.start_pos.x , pos.y + drawer.start_pos.y);
        float mid_size = data.CellSize/2;
        //println("pos.y " + pos.y);
        fill(value);
        strokeWeight(0);
        square(center.x-mid_size, center.y-mid_size, data.CellSize);
    }
    
    void BuildPoints(DrawingGenerator drawer)
    {
      int nb_points = 0;
      if (!data.Black)
      {
        nb_points = round(value / 255.0 * data.DotDensity);
      }
      else
      {
        nb_points = round((1-value / 255.0) * data.DotDensity);
      }
      
      //println(nb_points);
      
      PVector center = new PVector(pos.x + drawer.start_pos.x , pos.y + drawer.start_pos.y);
      float mid_size = data.CellSize/2;
      for (int i = 0; i < nb_points; i++)
      {       
          PVector pos = new PVector(center.x + random(-mid_size, mid_size), center.y+ random(-mid_size, mid_size));       
          drawer.points.add(pos);
      }
      
      
    }
}



class DrawingGenerator
{
   DrawingGenerator()
   {
     
   }

    ArrayList<Cell> cells =  new ArrayList<Cell>();
    ArrayList<PVector> points =  new ArrayList<PVector>();
    
    float last_blur = 0;
    float last_width = 0;
    PImage blurred_image = null;
    
    void buildBlurredImage()
    {
      if (last_blur != data.image.Blur || 
          last_width != data.image.Width ||   
          blurred_image == null)
      {
        blurred_image = data.image.image.copy();
        blurred_image.resize((int)data.image.Width, (int)data.image.Height());
        blurred_image.filter(BLUR, data.image.Blur);
        
        println("build blur");

        last_blur = data.image.Blur;
        last_width = data.image.Width;
        
        cells.clear();     
      }
    }
    
    int Height;
    int pixelIndex(float xPos, float yPos)
    {    
        return round(xPos) + round(yPos * Height);
    }
    
    PVector start_pos;
    
    float last_CellSize = 0;
    
    void buildCells(PVector center)
    {
        if (last_CellSize != data.dots.CellSize || 
            cells.size() == 0)
        {
               cells.clear();
               println("build cells");
        
            float xPos = data.dots.CellSize/2;
            float yPos = data.dots.CellSize/2;
            
            Height = round(data.image.Height());
            start_pos = new PVector(center.x - data.image.Width/2, center.y - data.image.Height()/2);
            
            while( yPos < Height)
            {
              while( xPos < data.image.Width)
              {
                float value = red(blurred_image.get((int)xPos, (int)yPos));
                Cell cell = new Cell(data.dots, new PVector(xPos, yPos), value); 
                cells.add(cell);
                xPos += data.dots.CellSize;
              }
    
              yPos += data.dots.CellSize;
              xPos = data.dots.CellSize/2;
            }      
            
            points.clear();
            
            last_CellSize = data.dots.CellSize;           
       }    
    }
    
    void drawCells()
    {
       for (int i =0 ; i < cells.size(); i++) 
         cells.get(i).drawSquare(this);
    }
    
    
    float last_DotDensity = 0;
   
    void buildPoints()
    {
         if (last_DotDensity  != data.dots.DotDensity || 
            points.size() == 0)
        {
          
          points.clear();
          randomSeed(data.dots.seed);
          println("build points");
          
          
          for (int i =0 ; i < cells.size(); i++) 
          {     
             cells.get(i).BuildPoints(this);
          }
          
          last_DotDensity = data.dots.DotDensity;
          
        }
    }
    
    void drawPoints()
    {
      strokeWeight(0);
      if (data.dots.Black)
         fill(0);
       else
         fill(255);
      
      for (int i =0 ; i < points.size(); i++) 
      {
         var pos = points.get(i);
         circle(pos.x, pos.y, 4); 
      }
         
    
    }
    
        /*int steps = data.NbSteps * data.NbStepsMultiplier;
        
        if(steps < 2)
        steps = 2;
        
        if(data.NbLines < 1)
        data.NbSteps = 1;
        
        
        float angle = 0;
        float deltaAngle = 360.0 / data.NbLines;
        float rotation =  data.Rotation *  data.RotationMultiplier + data.Rotation * data.RotationTwitch/100;
        
        for (int line = 0 ; line < data.NbLines; line ++)
        {        
        angle = deltaAngle*line + data.StartAngle;
        drawOneLine(steps, angle, rotation);
    }
        
        if (data.Mirror)
        {
        
        rotation = - rotation;
        for (int line = 0 ; line < data.NbLines; line ++)
        {
        
        angle = deltaAngle*line+ data.StartAngle;
        drawOneLine(steps, angle, rotation);
        }
    }*/
}
