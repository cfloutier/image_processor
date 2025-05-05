import controlP5.*;  

class DataGUI
{
  public DataGUI(DataGlobal data)
  {
    this.data = data;
    images_ui = new ImageGUI(data.image); 
    dots_ui = new DotGUI(data.dots); 
  }

  DataGlobal data;
  ImageGUI images_ui;
  DotGUI dots_ui;

  void updateUI()
  {
    if (!data.changed)
      return;

    images_ui.update();
    dots_ui.update();  
  }

  void setupControls()
  { 
    images_ui.setupControls(  ) ;
    dots_ui.setupControls(  );   
    
    cp5.getTab("Image").bringToFront();
  }
  
  void setGUIValues()
  {
    images_ui.setGUIValues();
    dots_ui.setGUIValues();
  }
}
