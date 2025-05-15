import controlP5.*; 


class DataGlobal
{
    String name = "";
    String settings_path = "";
    
    boolean auto_save = false;
    boolean need_update_ui = false;

    // this field is modified by the UIPanel
    // on any UI change. it is used 
    boolean changed = true;
    
    float width = 800;
    float height = 600;
    
    void setSize(float width, float height)
    {
        if (this.width != width)
        {
            changed = true;
            this.width = width;
        }
        
        if (this.height != height)
        {
            changed = true;
            this.height = height;
        }
    }
  
    ArrayList<GenericDataClass> chapters = new ArrayList<GenericDataClass>();

    void addChapter(GenericDataClass data_chapter)
    {
      chapters.add(data_chapter);
    }

  void LoadSettings(String path)
  {
    println("loading settings" + path);
    settings_path = path;

    JSONObject json = loadJSONObject(path);
    
    for (GenericDataClass chapter : chapters) {
      chapter.LoadJson(json.getJSONObject(chapter.chapter_name));
    }
  }
  
  void SaveSettings(String path)
  {
    println("Save settings " + path);
    JSONObject json = new JSONObject();
    
    for (GenericDataClass chapter : chapters) {
      json.setJSONObject(chapter.chapter_name, chapter.SaveJson());
    }

    saveJSONObject(json, path);
  }

  void save()
  {
      if (! StringUtils.isEmpty(settings_path))
    {
      SaveSettings(settings_path);
    }
  }
  
  void need_ui_update()
  {
      need_update_ui = true;
  }
  
  boolean any_change()
  {
    if (changed)
      return true;
      
     for (GenericDataClass chapter : chapters) {
       if (chapter.changed)
         return true;
     }
    
    return false;
  }
  
  
  void reset_all_changes()
  {
    changed = false;
     for (GenericDataClass chapter : chapters){
       chapter.changed = false;

     }
    
  }

}

class ImgProcData extends DataGlobal
{

  DataImage image = new DataImage();
  DataLines lines  = new DataLines();
  DataThreshold threshold = new DataThreshold();
  Style style = new Style();


  ImgProcData()
  {
      addChapter(image);
      addChapter(lines);
      addChapter(threshold);
      addChapter(style);

  }

  
}
