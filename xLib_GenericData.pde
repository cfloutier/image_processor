import java.lang.reflect.Field;

// classe de base des données sauvegardable
class GenericDataClass
{
    GenericDataClass(String chapter_name)
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
        } catch (NoSuchFieldException e) {
            println("Field '" + name + "' does not exist.");
        } catch (IllegalAccessException e) {
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
            } catch (IllegalAccessException e) {
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
            } catch (IllegalAccessException e) {
                e.printStackTrace(); // Handle exceptions gracefully
            }
        }

        return json;
    }
}
