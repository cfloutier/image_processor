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

DataGlobal global_data;
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
    
    global_data = new DataGlobal();
    dataGui = new DataGUI(global_data);
    
    lines_generator = new MoultiLinesGenerator(global_data.lines);
    threshold_filter = new ThresholdFilter(global_data.lines, global_data.threshold);
    
    setupControls();
    
    global_data.LoadSettings("./Settings/default.json");
    global_data.name = "default";
    
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
  
    background(global_data.style.backgroundColor.col);
    
    global_data.image.buildBlurredImage();   
    global_data.image.draw();
    
    // recenter
    pushMatrix();
    translate(width/2, height/2);

    if (global_data.lines.changed)
      lines_generator.buildLines();
    if (global_data.lines.changed || global_data.threshold.changed || global_data.image.changed)
      threshold_filter.buildLines(lines_generator, global_data.image);
    
    strokeWeight(global_data.style.lineWidth);   
    stroke(global_data.style.lineColor.col);
      
    smooth();
    if (global_data.lines.draw)
      lines_generator.draw();

    if (global_data.threshold.draw)
      threshold_filter.draw();

    popMatrix();
    end_draw();

    global_data.image.changed = false;
    global_data.lines.changed = false;
    global_data.threshold.changed = false;
}
