
void addFileTab()
{
  cp5.addTab("Files");
  
  println("addFileTab");

  float xPos = 0;
  float yPos = 20;

  int widthButton = 100;
  int heightButton = 20;

  cp5.addButton("LoadJson")
    .setPosition(xPos, yPos)
    .setSize(widthButton, heightButton)
    .moveTo("Files");        

  xPos += widthButton;

  cp5.addButton("SaveJson")
    .setPosition(xPos, yPos)
    .setSize(widthButton, heightButton)
    .moveTo("Files");    

  yPos += heightButton;
  xPos = 0;

  cp5.addButton("ExportPDF")
    .setPosition(xPos, yPos)
    .setSize(widthButton, heightButton)
    .moveTo("Files");      

  xPos += widthButton;

  cp5.addButton("ExportSVG")
    .setPosition(xPos, yPos)
    .setSize(widthButton, heightButton)
    .moveTo("Files");    

  xPos += widthButton;
}

void LoadJson()
{
  println("LoadJson ");
  selectInput("Select data file ", "loadSelected", dataFile("../Settings/default.json")  );
}

void loadSelected(File selection) 
{
  if (selection != null) 
  {
    data.LoadSettings(selection.getAbsolutePath());
    dataGui.setGUIValues();
  }
}

void SaveJson()
{
  selectInput("Save data file ", "saveSelected", dataFile("../Settings/default.json"));
}

void saveSelected(File selection) 
{
  if (selection == null) 
  {
  } else 
  {
    String path = selection.getAbsolutePath();
    if (path.length() < 5 || !path.substring(path.length() - 5).equals(".json"))
      path = path + ".json";

    data.SaveSettings(path);
    
    String name = selection.getName();
    data.name = name.substring(0, name.length() - 5);
  }
}

boolean record = false;
int mode  = 0;

String fileName = "";
void ExportPDF()
{
  record = true;
  mode = 0;
}

void ExportDXF()
{
  record = true;
  mode = 1;
}  

void ExportSVG()
{
  record = true;
  mode = 2;
}

void start_draw()
{
  dataGui.update_ui();

  if (data.changed)
  {
    if (data.auto_save)
      data.save();

    data.changed = false;
  }

  if (record) 
  {
    String name = data.name;
    if (name == "")
      name = "default";
      
    float sizeMultiplier = 1;
    
    println("saving " + name);
      
   // sizeMultiplier = (float) width  / 28;
      
    float newWidth = width * sizeMultiplier;
    float newheight = height * sizeMultiplier;
      
    fileName = "Export/"+ name + "_" + year() + "-" + month() + "-" + day() + "_" + hour() + "-" + minute() + "-" + second(); 
    
    if (mode == 0)
       current_graphics = createGraphics((int)newWidth, (int)newheight, PDF, fileName+ ".pdf");       
    else if (mode == 1)
      current_graphics = createGraphics((int)newWidth, (int)newheight, DXF, fileName+ ".dxf");       
    else if (mode ==2)
      current_graphics = createGraphics((int)newWidth, (int)newheight, SVG, fileName+ ".svg");       
    
    data.setSize(newWidth, newheight); 
    
    current_graphics.beginDraw();
    current_graphics.strokeWeight(data.style.lineWidth*sizeMultiplier);
    
    current_graphics.rotate(-PI/2);
    current_graphics.translate(-newWidth,newheight/2);
    
  } else {
    
    current_graphics = g;

    background(data.style.backgroundColor.col);
    strokeWeight(data.style.lineWidth);

    stroke(data.style.lineColor.col);
    
    current_graphics = g;

    data.setSize(width, height);
  } 
}

void end_draw()
{
  if (record) 
  {
    current_graphics.dispose();
    current_graphics.endDraw();
    record = false;
  }
}
