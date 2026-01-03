import java.awt.Image;
// trace parallels line on pictures

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

ImgProcData data;
DataGUI dataGui;
DrawingGenerator drawer;

MoultiLinesGenerator lines_generator;
ThresholdFilter threshold_filter;

//SourceFiles sourceFilesGui;
PGraphics current_graphics;

ControlP5 cp5;

void setup() 
{ 
    size(1200, 800); 
    
    drawer = new DrawingGenerator();
    
    data = new ImgProcData();
    dataGui = new DataGUI(data);
    
    lines_generator = new MoultiLinesGenerator(data.lines);
    threshold_filter = new ThresholdFilter(data.lines, data.threshold);
    
    setupControls();
    
    data.LoadSettings("./Settings/default.json");
    data.name = "default";
    
    dataGui.setGUIValues();
    
    surface.setResizable(true);
}

void setupControls()
{ 
    cp5 = new ControlP5(this); 
    cp5.getTab("default").setLabel("Hide GUI");
    
    addFileTab();
    dataGui.setupControls();     
}

void draw()
{
    start_draw();  
  
    background(data.style.backgroundColor.col);
    
    data.image.buildBlurredImage();   
    data.image.draw();
    
    // recenter
    pushMatrix();
    translate(width/2, height/2);

    if (data.lines.changed || data.image.changed)
      lines_generator.buildLines();
      
    if (data.lines.changed ||
       data.threshold.changed || 
       data.image.changed)
      threshold_filter.buildLines(lines_generator, data.image);
    
    strokeWeight(data.style.lineWidth);   
    stroke(data.style.lineColor.col);
      
    smooth();
    if (data.lines.draw)
      lines_generator.draw();

    if (data.threshold.draw)
      threshold_filter.draw();

    popMatrix();
    end_draw();

    data.image.changed = false;
    data.lines.changed = false;
    data.threshold.changed = false;
}
