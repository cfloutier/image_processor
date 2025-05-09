import controlP5.*; 


class DataGlobal
{
    String name = "";
    String settings_path = "";
    
    boolean auto_save = false;

    DataImage image = new DataImage();
    DataLines lines  = new DataLines();
    DataThreshold threshold = new DataThreshold();
    Style style = new Style();

    DataGlobal()
    {
      addChapter(image);
      addChapter(lines);
      addChapter(threshold);
      addChapter(style);
    }

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
    
    String sketch_name()
    {
        return image.source_file.substring(0, image.source_file.length() - 4);  
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

}
