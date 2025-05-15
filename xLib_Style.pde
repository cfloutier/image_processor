


class Style extends GenericDataClass
{
  Style(){ super("Style"); }
  
  ColorRef lineColor = new ColorRef(color(255, 255, 255), "lineColor");
  ColorRef backgroundColor = new ColorRef(color(0, 0, 0), "backgroundColor");
  float lineWidth = 1;

  void LoadJson(JSONObject src)
  {
    if (src == null)
      return;

    backgroundColor.LoadJson(src);
    lineColor.LoadJson(src);

    lineWidth = src.getFloat("lineWidth", lineWidth);
  }

  JSONObject SaveJson()
  {
    JSONObject dest = new JSONObject();

    backgroundColor.SaveJson(dest);
    lineColor.SaveJson(dest);

    dest.setFloat("lineWidth", lineWidth);

    return dest;
  }
}


class StyleGUI extends GUIPanel
{
  Style style;
  
  Slider lineWidth;
  ColorGroup backgroundColor;
  ColorGroup lineColor;

  void setGUIValues()  
  {
    lineWidth.setValue(style.lineWidth);
  }

  void setupControls()
  {
    style = global_data.style;
    super.Init("Style", style);
    lineWidth = addSlider("lineWidth", "Line Width", 0, 5, false);
    lineColor = addColorGroup("Line Color", style.lineColor);
    backgroundColor = addColorGroup("background Color", style.backgroundColor);
  }

  void update_ui()
  {
    var _color = style.backgroundColor.col;
   LabelsHandler.set_labels_colors( color(255-red(_color),255-green(_color),255-blue(_color))   );
  }
}
