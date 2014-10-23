//--------------------------------------------------------------------//
// Prusa i3 power box clip                                            //
//--------------------------------------------------------------------//
// Author        : Patrick Henry                                      //
// Email         : phenry@pontetec.com                                //
// License       : MIT - http://opensource.org/licenses/MIT           //
//--------------------------------------------------------------------//
// The 12V power supply has a few shallow screw holes in its base,
// and the acrylic frame has some holes also. Unfortunately, these
// don't really line up except at one end.
//
// So I have the power supply bolted on to the right side of the
// printer, with the wires coming out the bottom, and two M3 bolts
// holding it in place. Since the screw holes are so shallow, I had
// to use washers and nuts to make my M3 bolts short enough that it
// is held securely (shorter bolts would also be an option) and then
// to keep the top in place I printed this clip. The clip is shown
// upside down here, to make the slope easier to print.
//
// The clip is implemented in two modules, to allow two variants.
// If you want a complete clip that wraps around the acrylic at the
// front of the frame, make sure to use clip_complete(). However,
// to snap this on requires some finesse, so by commenting out the
// call to that module you can get a clip that doesn't wrap around.
//--------------------------------------------------------------------//

//--------------------------------------------------------------------//
// Useful constants                                                   //
//--------------------------------------------------------------------//

eps = 0.01;
wall = 2;
acrylic = 6.5;
surround = wall + acrylic + wall;
over = wall + acrylic;
overhang = 10;
box_dx = 114.5;
box_dy  = 50;
box_dy2 = 14;
box_x  = 12;
box_y = -19;
dz = 10;
dx = 20;
blob_x = 20+28;

//--------------------------------------------------------------------//
// Module: clip for power box                                         //
//--------------------------------------------------------------------//

module clip() {
  cube([wall, wall + overhang, dz]);
  cube([surround, wall, dz]);
  
  translate([over,0,0])
  {
    cube([wall, box_y + wall, dz]);
  }
  
  translate([over, box_y, 0])
  {
    cube([wall, wall-box_y+overhang / 3, dz]);
    cube([box_x, wall, dz]);
  }
  translate([acrylic + box_x, box_y, 0])
  {
    cube([wall, wall + overhang, dz]);
  }
  translate([over + box_x, box_y, 0])
  {
    cube([box_dx + wall, wall, dz]);
  }
  translate([over + box_x + box_dx, box_y, 0])
  {
    cube([wall, wall + box_dy + box_dy2 + wall, dz]);
  }
  difference() {
    translate([over + box_x + box_dx - blob_x-5, box_y + box_dy + box_dy2 - acrylic, 0])
    {
      cube([blob_x+5, surround, dz]);
    }
    translate([over + box_x + box_dx - blob_x + overhang, box_y + box_dy + box_dy2 + wall - acrylic, dz])
      rotate([0,150,0])
      {
        translate([0, -eps, -dz*11])
        {
          cube([overhang * 2, acrylic+2*eps, dz * 20]);
        }
        translate([overhang, -wall-eps, -dz*11])
        {
          cube([overhang, surround+2*eps, dz * 20]);
        }
      }
  }
}

//--------------------------------------------------------------------//
// Module: clip_complete adds a locking part at the front.            //
//--------------------------------------------------------------------//

module clip_complete() {
  cube([wall, 56 + wall * 2, dz]);
  translate([0, 56 + wall, 0])
    cube([acrylic + 2 * wall, wall, dz]);
  translate([acrylic + wall, 56 + wall - overhang / 2, 0])
    cube([wall, overhang / 2 + wall, dz]);
}

//--------------------------------------------------------------------//
// Module: powerbox shows a small slice of the power supply           //
//--------------------------------------------------------------------//

module powerbox() {
  color([1,0,0])
    translate([over + box_x, box_y + wall, -100])
      cube([box_dx, box_dy, 120]);
}

//--------------------------------------------------------------------//
// Module: frame shows the acrylic frame                              //
//--------------------------------------------------------------------//

module frame() {
  color([.4, .4, .4])
  {
    translate([wall, wall, -100])
      cube([acrylic, 55, 200]);
    translate([wall + acrylic, wall + 45, -100])
    {
      rotate([90,0,0])
        linear_extrude(height = acrylic)
          polygon(points = [ [0, 0], [133, 0], [47, 200], [0, 200] ]);
    }
  }
}

//--------------------------------------------------------------------//
// Main body                                                          //
//--------------------------------------------------------------------//

rotate([0,180,0])
{
  //frame();
  //powerbox();
  clip();
  clip_complete();
}
