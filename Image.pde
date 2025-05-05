class DataImage
{
    String source_file = "eye.jpg";

    float Width = 500;
    float ImageAlpha = 0;
    int   Blur = 2; 
    int Contrast = 0;

    PImage image = null;

    public void setImage(String source_file)
    {
        this.source_file = source_file;

        try {
          String file_path = dataFile(source_file).getAbsolutePath();
          image = loadImage(file_path);
          image.filter(GRAY);
        }
        catch(Exception e) {
          image = null;

          println("error loading " + source_file);
          return;
        }
        
        println("Loading source file " + source_file);

        //image.filter(BLUR, 20);
    }

    // computed
    float Height()
    {
        if (image == null)
            return 0;
        
        return image.height * Width / image.width;
    }

    void LoadJson(JSONObject src)
    {
        if (src == null)
          return;
      
        Width = src.getFloat("Width", Width);  
        
        ImageAlpha = src.getFloat("ImageAlpha", ImageAlpha);
        Blur = src.getInt("Blur", Blur);
        Contrast = src.getInt("Contrast", Contrast);
        
        setImage(src.getString("source_file", source_file));
    }

    JSONObject SaveJson()
    {
        JSONObject dest = new JSONObject();

        dest.setFloat("Width", Width);    
        dest.setString("source_file", source_file);

        dest.setFloat("ImageAlpha", ImageAlpha);
        dest.setInt("Blur", Blur);
        dest.setFloat("Contrast", Contrast);

        return dest;
    }
}


class ImageGUI extends GUIPanel
{ 
    DataImage data;

    public ImageGUI(DataImage data)
    {
      this.data = data;
    }
    
    void SelectSourceImage() {  
      println(":::LOAD JPG, GIF or PNG FILE:::");
      
      //File file = new File("C:/dev/__tracer/stipplegen/MyStippleGen/sourcesImages/");
    
      selectInput("Select a file to process:", "imgFileSelected", dataFile(data.source_file));  // Opens file chooser
    } //End Load File

    void update()
    {   
        if (data.source_file == "")
            file_Label.setText("please select a file");
        else
            file_Label.setText(data.source_file);
    }
    
    Slider Width;
    Slider ImageAlpha;
    Slider Blur;
    Button select_bt;
    
    Textlabel file_Label;
    
    void test()
    {
      print("test");
    }
    
    void setupControls()
    {   
        super.Init("Image");
        
        select_bt = addButton("Select Source Image");
        select_bt.plugTo(this, "SelectSourceImage");
        
        file_Label = inlineLabel("File Label", 200);   
        
        nextLine();
        
        //select_bt = addButton("Select Source Image");
        //select_bt.plugTo("LoadJson");
        
        // cp5.addButton("LoadJson")
        // .setPosition(xPos, yPos)
        // .setSize(200, 200)
        // .moveTo("Files");    

        Width = addSlider("Width", "Width", data, 200, 2000, true); 
        ImageAlpha = addSlider("ImageAlpha", "Image Alpha", data, 0, 255, true);
         nextLine();
        Blur = addIntSlider("Blur", "Blur", data, 1, 20, true);
        
       // updateUI();
    }

    void setGUIValues()
    {
        Width.setValue(data.Width);
        ImageAlpha.setValue(data.ImageAlpha);
        Blur.setValue(data.Blur);
    }
}
 //<>//
 //<>//
void imgFileSelected(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    println("User selected " + selection.getAbsolutePath());

    String loadPath = selection.getAbsolutePath();
    loadPath = loadPath.replaceAll("\\\\", "/");
    String[] p = splitTokens(loadPath, "/");
    String parent_dir = p[p.length - 2];
    String file_name = p[p.length - 1];
    

    // If a file was selected, print path to file 
    println("Selected file: " + file_name); 
    println("parent_dir : " + parent_dir); 
  
    if (!parent_dir.equals("data"))
    {
        println("Invalid Folder. Image must be in data path");
        return; 
    }

    p = splitTokens(loadPath, ".");
    boolean fileOK = false;
    String extension = p[p.length - 1].toLowerCase();

    if ( extension.equals("gif"))
      fileOK = true;      
    if ( extension.equals("jpg"))
      fileOK = true;   
    if ( extension.equals("tga"))
      fileOK = true;   
    if ( extension.equals("png"))
      fileOK = true;   

    println("File extension OK: " + fileOK);

    data.image.setImage(file_name);
  }
}
