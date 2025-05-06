import controlP5.*;  

class DataGUI
{
   public DataGUI(DataGlobal data)
  {
    this.data = data;
    images_ui = new ImageGUI(data.image); 
    style_gui = new StyleGUI(); 
    lines_ui = new LinesGUI(data.lines); 
  }

  DataGlobal data;
  ImageGUI images_ui;
  StyleGUI style_gui;
  LinesGUI lines_ui;

  void updateUI()
  {
    if (!data.changed)
      return;

    images_ui.update();
    lines_ui.update();  
    style_gui.update();  
  }

  void setupControls()
  { 
    images_ui.setupControls(  ) ;
    lines_ui.setupControls(  );   
    style_gui.setupControls();  
    
    cp5.getTab("Image").bringToFront();
  }
  
  void setGUIValues()
  {
    images_ui.setGUIValues();
    lines_ui.setGUIValues();
  }
}
