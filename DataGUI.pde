import controlP5.*;  

class DataGUI extends MainPanel
{
   public DataGUI(ImgProcData data)
  {
    this.data = data;
    images_ui = new ImageGUI(data.image); 
    style_ui = new StyleGUI(data.style); 
    lines_ui = new LinesGUI(data.lines); 
    threshold_ui = new ThresholdGUI(data.threshold); 
  }

  ImgProcData data;
  ImageGUI images_ui;
  StyleGUI style_ui;
  LinesGUI lines_ui;
  ThresholdGUI threshold_ui;
  
  // update UI for all non controller (labels or hide/show)
  void update_ui()
  {
    
    
    
    images_ui.update_ui();
    lines_ui.update_ui();  
    style_ui.update_ui();  
    threshold_ui.update_ui();  
    
  }
  
  void setupControls()
  { 
    images_ui.setupControls(  ) ;
    style_ui.setupControls();  
    lines_ui.setupControls(  );   
    threshold_ui.setupControls(); 
    cp5.getTab("Lines").bringToFront();
  }
  
  void setGUIValues()
  {
    images_ui.setGUIValues();
    lines_ui.setGUIValues();
    style_ui.setGUIValues();
    threshold_ui.setGUIValues();
  }
}
