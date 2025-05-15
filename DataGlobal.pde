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

  
}
