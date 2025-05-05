
int indexControler = 0;

static final int StartX = 20;
static final int StartY = 20;

class GUIPanel implements ControlListener
{
  String pageName;
  
  float xPos = 0;
  float yPos = 0;

  int xspace = 15;

  int widthCtrl = 300;
  int heightCtrl = 20;

  void Init(String pageName)
  {
    this.pageName = pageName;
    cp5.addTab(pageName);
    println("add tab " + pageName);
    cp5.addListener(this);

    yPos = StartY;
    xPos = StartX;
  }

  public void onUIChanged()
  {
    data.changed = true;
  }

  public void controlEvent(ControlEvent theEvent) {
    onUIChanged();
  }
  
  
  
  

  Textlabel inlineLabel(String content, int width)
  {
    Textlabel l = cp5.addTextlabel("Label" + indexControler)
      .setText(content)
      .setPosition(xPos, yPos)
      .setSize(width, heightCtrl)
      .moveTo(pageName);
  
    xPos += width;

    indexControler++;

    return l;
  }

  Textlabel addLabel(String content)
  {
    yPos += 10;

    Textlabel l = cp5.addTextlabel("Label" + indexControler)
      .setText(content)
      .setPosition(xPos, yPos)
      .setSize(100, heightCtrl)
      .moveTo(pageName);

    yPos += 15;

    indexControler++;

    return l;
  }


  Slider addIntSlider(String field, String label, Object data_Class, int min, int max, boolean horizontal)
  {
    Slider s = addSlider( field, label, data_Class, min, max, horizontal);
    int nbTicks = (int) (max - min + 1);
    s.setNumberOfTickMarks(nbTicks);
    s.showTickMarks(false);
    s.snapToTickMarks(true);

    return s;
  }


  Slider addSlider(String field, String label, Object data_Class, float min, float max, boolean horizontal)
  {
    Slider s = cp5.addSlider(data_Class, field)
      .setLabel(label)
      .setPosition(xPos, yPos)
      .setSize(widthCtrl, heightCtrl)
      .setRange(min, max)
      .moveTo(pageName);

    if (horizontal)
    {
      xPos += xspace + widthCtrl;
    } else
    {
      yPos+=heightCtrl+2;
      xPos = StartX;
    }

    controlP5.Label l = s.getCaptionLabel();
    l.getStyle().marginTop = 0; //move upwards (relative to button size)
    l.getStyle().marginLeft = -65; //move to the right

    return s;
  }
  
  Toggle addToggle(String name, String label, Object data_Class)
  {
    Toggle t = cp5.addToggle(data_Class, name)
      .setLabel(label)
      .setPosition(xPos, yPos)
      .setSize(100, heightCtrl)
      .setMode(ControlP5.SWITCH)
      .moveTo(pageName);

    CColor controlerColor = t.getColor();
    int tmp = controlerColor.getActive();
    controlerColor.setActive( controlerColor.getBackground());
    controlerColor.setBackground(tmp);

    yPos+=heightCtrl+2;

    //t.setLabel("The Toggle Name");
    controlP5.Label l = t.getCaptionLabel();
    l.getStyle().marginTop = -heightCtrl + 2; //move upwards (relative to button size)
    l.getStyle().marginLeft = 10; //move to the right

    return t;
  }

  ColorPicker addColorPicker(String name, String label, Object data_Class)
  {
    addLabel(label);

    ColorPicker cp = cp5.addColorPicker(data_Class, name)

      .setPosition(xPos, yPos)
      .setSize(100, heightCtrl*3)
      .moveTo(pageName);

    yPos+=heightCtrl*3;

    return cp;
  }


  ColorGroup addColorGroup(String name, ColorRef colorRef)
  {
    ColorGroup grp = new ColorGroup(colorRef, name );

    grp.Init(this);

    return grp;
  }

  Button addButton(String name)
  {
    
    int width_bt = 100;
    
    Button bt = cp5.addButton(name + indexControler)
      .setPosition(xPos, yPos)
      .setLabel(name)
      .setSize(width_bt, heightCtrl)
      .moveTo(pageName);
      
    xPos += width_bt+5;

    indexControler++;
    return bt;
  }
  
  
  void start()
  {
    xPos = 20;
    yPos = 20;
  }
  
   void nextLine()
  {
    xPos = 20;
    yPos += heightCtrl + 1;
    
    }
}
