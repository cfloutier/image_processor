import java.util.Locale;

class DataPage extends GenericData
{
  String name = "";

  float global_scale = 1;

  boolean clipping = false;
  float clip_width = 800;
  float clip_height = 600;

  DataPage() {
    super("Page");
  }
}

class FileGUI extends GUIPanel
{

  DataGlobal global_data;
  DataPage page_data;

  FileGUI(DataGlobal data)
  {
    super("Files", data.page);
    this.global_data = data;
    this.page_data = data.page;
  }

  void setGUIValues()
  {
    main_label.setText("Files : " + data.name);
    scale_slider.setValue(page_data.global_scale -1);
    clip_toggle.setValue(page_data.clipping);
    clip_slider_width.setValue(page_data.clip_width);
    clip_slider_height.setValue(page_data.clip_height);
  }

  void update_ui()
  {
    if (page_data.clipping)
    {
      clip_slider_width.show();
      clip_slider_height.show();
    } else
    {
      clip_slider_width.hide();
      clip_slider_height.hide();
    }
  }

  Textlabel main_label;
  ScaleSlider scale_slider;

  Toggle clip_toggle;

  Slider clip_slider_width;
  Slider clip_slider_height;

  void setupControls()
  {
    super.Init();

    main_label = addLabel("Files : ");

    addButton("Load").plugTo(this, "LoadJson");
    addButton("Save as...").plugTo(this, "SaveJson");
    addButton("Save").plugTo(this, "Save");

    nextLine();

    addLabel("Export : ");

    addButton("Export PDF").plugTo(this, "ExportPDF");
    addButton("Export SVG").plugTo(this, "ExportSVG");

    nextLine();
    addLabel("Page : ");
    nextLine();
    scale_slider = new ScaleSlider(cp5, "Scale");

    scale_slider.setPosition(xPos, yPos)
      .setSize(widthCtrl, heightCtrl)
      .setRange(-9, 9)
      .moveTo("Files")
      .setValue(0)
      .getCaptionLabel().align(ControlP5.LEFT, ControlP5.TOP_OUTSIDE).setPaddingX(0);

    xPos += widthCtrl + 10;

    addButton("Reset Scale").plugTo(this, "Reset_Scale");

    nextLine();

    clip_toggle = addToggle("clipping", "Clip", page_data);

    clip_slider_width = addSlider("clip_width", "Clip width", 0, 2000);
    clip_slider_height = addSlider("clip_height", "Clip height", 0, 2000);
  }


  String default_path()
  {
    if (data.name == "")
      data.name = "default";

    String default_file = "../Settings/"+data.name+".json";
    return default_file;
  }


  void LoadJson()
  {
    println("LoadJson ");
    selectInput("Select data file ", "loadSelected", dataFile("../Settings/default.json")  );
  }

  void SaveJson()
  {
    println("SaveJson ");

    selectInput("Save data file ", "saveSelected", dataFile(default_path()));
  }

  void Save()
  {
    if (data.settings_path != "")
      data.SaveSettings(data.settings_path);
  }

  void ExportPDF()
  {
    _record = true;
    data.changed = true;
    mode = 0;
  }

  void ExportSVG()
  {
    _record = true;
    data.changed = true;
    mode = 2;
  }

  void Reset_Scale()
  {
    scale_slider.setValue(0);
  }
}


Slider slider_crop_width;
Slider slider_crop_height;

// void addFileTab()
// {
//   cp5.addTab("Files");

//   println("addFileTab");

//   float xPos = 0;
//   float yPos = 20;

//   int widthButton = 100;
//   int heightButton = 20;

//   cp5.addButton("LoadJson")
//     .setPosition(xPos, yPos)
//     .setSize(widthButton, heightButton)
//     .moveTo("Files");

//   xPos += widthButton;

//   cp5.addButton("SaveJson")
//     .setPosition(xPos, yPos)
//     .setSize(widthButton, heightButton)
//     .moveTo("Files");

//   yPos += heightButton;
//   xPos = 0;

//   cp5.addButton("ExportPDF")
//     .setPosition(xPos, yPos)
//     .setSize(widthButton, heightButton)
//     .moveTo("Files");

//   xPos += widthButton;

//   cp5.addButton("ExportSVG")
//     .setPosition(xPos, yPos)
//     .setSize(widthButton, heightButton)
//     .moveTo("Files");

//   // xPos += widthButton;

//   yPos += heightButton+20;
//   xPos = 0;



//   cp5.addButton("Reset_Scale")
//     .setPosition(xPos, yPos)
//     .setSize(widthButton, heightButton)
//     .moveTo("Files");

//   xPos = 0;
//   yPos += heightButton+20;

//   cp5.addToggle("onCrop")
//     .setPosition(xPos, yPos)
//     .setSize(widthButton, heightButton)
//     .moveTo("Files")
//     .getCaptionLabel().align(ControlP5.LEFT, ControlP5.TOP_OUTSIDE).setPaddingX(0);

//   xPos = 0;
//   yPos += heightButton+10;

//   slider_crop_width = cp5.addSlider("on_crop_width")
//     .setLabel("Width")
//     .setPosition(xPos, yPos)
//     .setSize(200, heightButton)
//     .setRange(0, 2000)
//     .setValue(data.page.crop_width)
//     .moveTo("Files")
//     .hide();

//   yPos += heightButton+10;

//   slider_crop_height = cp5.addSlider("on_crop_height")
//     .setLabel("Height")
//     .setPosition(xPos, yPos)
//     .setSize(200, heightButton)
//     .setRange(0, 2000)
//     .setValue(data.page.crop_height)
//     .moveTo("Files")
//     .hide();
// // }

// void on_crop_height(float value) {
//   data.page.crop_height = value;
// }
// void on_crop_width(float value) {
//   data.page.crop_width = value;
// }

// void onCrop()
// {
//   data.page.crop = !data.page.crop;

//   if (data.page.crop)
//   {
//     slider_crop_width.show();
//     slider_crop_height.show();
//   } else
//   {
//     slider_crop_width.hide();
//     slider_crop_height.hide();
//   }
// }

//subclass slider
public class ScaleSlider extends Slider {
  //constructor
  public ScaleSlider( ControlP5 cp5, String name ) {
    super(cp5, name);
  }

  void computeScale()
  {
    float value =  getValue();
    if (value >= 0)
    {
      data.page.global_scale = 1 + value;
      getValueLabel().setText(String.format(Locale.US, " x %.1f", 1 + value));
    } else
    {
      data.page.global_scale = 1 / (1-value);
      getValueLabel().setText(String.format(Locale.US, " / %.1f", 1 - value));
    }
  }

  @Override public Slider setValue( float theValue ) {
    super.setValue(theValue);
    computeScale();
    return this;
  }
}

void loadSelected(File selection)
{
  if (selection != null)
  {
    data.LoadSettings(selection.getAbsolutePath());
    dataGui.setGUIValues();
  }
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
    if (name.endsWith(".json"))
      data.name = name.substring(0, name.length() - 5);
    else
      data.name = name;
  }
}

boolean _record = false;
int mode  = 0;

String export_fileName = "";
void ExportPDF()
{
  _record = true;
  data.changed = true;
  mode = 0;
}

void ExportDXF()
{
  _record = true;
  mode = 1;
}

void ExportSVG()
{
  _record = true;
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

  if (_record)
  {
    String name = data.name;
    if (name == "")
      name = "default";

    float sizeMultiplier = 1;

    // sizeMultiplier = (float) width  / 28;

    float newWidth = width * sizeMultiplier;
    float newheight = height * sizeMultiplier;

    export_fileName = "Export/"+ name + "_" + year() + "-" + month() + "-" + day() + "_" + hour() + "-" + minute() + "-" + second();

    if (mode == 0)
    {
      export_fileName = export_fileName + ".pdf";
      current_graphics = createGraphics((int)newWidth, (int)newheight, PDF, export_fileName);
    } else if (mode == 1)
    {
      export_fileName = export_fileName + ".dxf";
      current_graphics = createGraphics((int)newWidth, (int)newheight, DXF, export_fileName);
    } else if (mode == 2)
    {
      export_fileName = export_fileName + ".svg";
      current_graphics = createGraphics((int)newWidth, (int)newheight, SVG, export_fileName);
    }

    println("Exported to " + export_fileName);

    data.setSize(newWidth, newheight);

    current_graphics.beginDraw();
    current_graphics.strokeWeight(data.style.lineWidth*sizeMultiplier);

    current_graphics.rotate(-PI/2);
    current_graphics.translate(-newWidth, newheight/2);
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
  if (_record)
  {
    current_graphics.dispose();
    current_graphics.endDraw();
    _record = false;
  }
}

