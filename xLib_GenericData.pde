import java.lang.reflect.Field;


// classe de base des données sauvegardable
class GenericData
{
  GenericData(String chapter_name)
  {
    this.chapter_name = chapter_name;
  }

  String chapter_name = "";
  boolean changed = true;

  public void setInt(String name, int value) {

    try {
      Field field = this.getClass().getDeclaredField(name); // Get the field by name
      field.setAccessible(true); // Allow access to private fields if necessary

      if (field.getType() == int.class) { // Check if the field is of type int
        field.setInt(this, value); // Set the field value
        changed = true; // Mark the object as changed
      } else {
        println("Field '" + name + "' is not of type int.");
      }
    }
    catch (NoSuchFieldException e) {
      
      String class_name = this.getClass().getSimpleName();
      println(class_name + ".'" + name + "' does not exist.");
     // println("Field '" + name + "' does not exist.");
      
    }
    catch (IllegalAccessException e) {
      e.printStackTrace(); // Handle exceptions gracefully
    }
  }

  // Method to load attributes from a JSONObject using reflection
  public void LoadJson(JSONObject json) {
    if (json == null) return;

    Field[] fields = this.getClass().getDeclaredFields();

    for (Field field : fields) {
      try {     
        field.setAccessible(true); // Allow access to private fields if necessary
        String name = field.getName();
        if (name == "changed" || name =="this$0")
        {

          continue;
        }

        if (field.getType() == boolean.class) {
          field.set(this, json.getBoolean(name, field.getBoolean(this)));
        } else if (field.getType() == int.class) {
          field.set(this, json.getInt(name, field.getInt(this)));
        } else if (field.getType() == float.class) {
          field.set(this, json.getFloat(name, field.getFloat(this)));
        } else if (field.getType() == String.class) {
          field.set(this, json.getString(name, (String) field.get(this)));
        }
        
      }
      catch (IllegalAccessException e) {
        e.printStackTrace(); // Handle exceptions gracefully
      }
    }

    changed = true;
  }

  // Method to convert all attributes to a JSONObject using reflection
  public JSONObject SaveJson() {
    JSONObject json = new JSONObject();
    Field[] fields = this.getClass().getDeclaredFields();

    for (Field field : fields) {
      try {
        field.setAccessible(true); // Allow access to private fields if necessary
        String name = field.getName();
        if (name == "changed" || name =="this$0")
        {

          continue;
        }

        Object value = field.get(this);

        if (value instanceof Boolean) {
          json.setBoolean(name, (Boolean) value);
        } else if (value instanceof Integer) {
          json.setInt(name, (Integer) value);
        } else if (value instanceof Float) {
          json.setFloat(name, (Float) value);
        } else if (value != null) {
          json.setString(name, value.toString());
        }
      }
      catch (IllegalAccessException e) {
        e.printStackTrace(); // Handle exceptions gracefully
      }
    }

    return json;
  }
  
  void CopyFrom(GenericData src)
  {
    Field[] fields = this.getClass().getDeclaredFields();
    for (Field field : fields) {
      try {
        field.setAccessible(true); // Allow access to private fields if necessary
        String name = field.getName();
        if (name == "changed" || name =="this$0")
        {
          continue;
        }
        
        field.set(this, field.get(src));
      }
      catch (IllegalAccessException e) {
        e.printStackTrace(); // Handle exceptions gracefully
      }
    }
  }
}

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
  float global_scale = 1;
  
  void reset()
  {
      println("error calling base reset");
  }

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

  ArrayList<GenericData> chapters = new ArrayList<GenericData>();

  void addChapter(GenericData data_chapter)
  {
    chapters.add(data_chapter);
  }

  String getFileNameWithoutExtension(String path) {
    File file = new File(path);
    String fileName = file.getName();
    int dotIndex = fileName.lastIndexOf('.');
    if (dotIndex > 0) {
      return fileName.substring(0, dotIndex);
    } else {
      return fileName;
    }
  }

  void LoadSettings(String path)
  {
    println("loading settings : " + path);
    reset();
    settings_path = path;

    data.name = getFileNameWithoutExtension(path);
    JSONObject json = loadJSONObject(path);

    for (GenericData chapter : chapters) {
      chapter.LoadJson(json.getJSONObject(chapter.chapter_name));
    }
    
    changed = true;
  }

  void SaveSettings(String path)
  {
    println("Save settings " + path);
    JSONObject json = new JSONObject();

    for (GenericData chapter : chapters) {
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

    for (GenericData chapter : chapters) {
      if (chapter.changed)
        return true;
    }
  
    return false;
  }

  void reset_all_changes()
  {
    changed = false;
    for (GenericData chapter : chapters) {
      chapter.changed = false;
    }
    
    
  }
}
