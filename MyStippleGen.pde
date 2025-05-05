/**

 StippleGen_3

 SVG Stipple Generator, v. 3.0
 Copyright (C) 2024 by Christophe Floutier

 based on :
 
 SVG Stipple Generator, v. 2.50
 Copyright (C) 2019 by Windell H. Oskay, www.evilmadscientist.com

 Full Documentation: http://wiki.evilmadscientist.com/StippleGen
 Blog post about the release: http://www.evilmadscientist.com/go/stipple2

 An implementation of Weighted Voronoi Stippling:
 http://mrl.nyu.edu/~ajsecord/stipples.html

 *******************************************************************************


/*  
 * 
 * This is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 * 
 * http://creativecommons.org/licenses/LGPL/2.1/
 * 
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 */

import controlP5.*;
import processing.pdf.*;
import processing.dxf.*;
import processing.svg.*;
 
DataGlobal data;
DataGUI dataGui;
DrawingGenerator drawer;


//SourceFiles sourceFilesGui;
PGraphics current_graphics;

ControlP5 cp5;

void setup() 
{
  size(1200, 800); //<>//

  drawer =  new DrawingGenerator();

  data = new DataGlobal();
  dataGui = new DataGUI(data);
  
  setupControls();
   
    data.LoadJson("./Settings/default.json");
  data.name = "default";

  dataGui.setGUIValues();
  surface.setResizable(true);
}

void setupControls()
{ 
  cp5 = new ControlP5(this); 
  cp5.getTab("default").setLabel("Hide GUI");
  
  addFileTab();
  dataGui.setupControls( );     

}

void draw()
{
  start_draw();

  if (data.changed)
  {
    dataGui.updateUI();
  }
  
  //drawer.center = new PVector(width/2, height/2);

  //drawer.draw();

  if (data.image.image != null)
  {
    //drawer.buildBlurredImage();

    // draw centered 
    PImage image =  data.image.image;
    float image_w = image.width;
    float image_h = image.height;

    tint(255, data.image.ImageAlpha);  
    image(image, width/2 - image_w/2, height/2- image_h/2, image_w, image_h);
  }

  end_draw();
}
