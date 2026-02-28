import controlP5.*; 

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

  void reset()
  {
        image.CopyFrom(new DataImage());
        lines.CopyFrom(new DataLines());
        threshold.CopyFrom(new DataThreshold());
        style.CopyFrom(new Style());
  }

}
