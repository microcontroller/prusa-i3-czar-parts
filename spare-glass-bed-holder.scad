//--------------------------------------------------------------------//
// Prusa i3 spare glass plate holder                                  //
//--------------------------------------------------------------------//
// Author        : Patrick Henry                                      //
// Email         : phenry@pontetec.com                                //
// License       : MIT - http://opensource.org/licenses/MIT           //
//--------------------------------------------------------------------//
//
// This fits the frame_thickness or wooden laser cut frames found here:
// http://www.thingiverse.com/thing:40465
// The value of frame_thickness should be adjusted accordingly. Here I
// have it set to 6mm acrylic, with an additional 0.75mm to allow the
// piece to twist into place. I don't think it'll work with the
// aluminum frame: http://www.thingiverse.com/thing:68296
// 
// The idea is that this goes into the slot at the back left of the
// frame and can be inserted with the leg parallel to the frame and
// then twisted 90 degrees. It gives you a safe place to store a
// spare borosilicate plate, so you can have one for PLA with blue
// tape, and another for ABS with kapton, or whatever you prefer.
//
// Once printed, it's best to cover the upper gridboard with blue
// tape to ensure that it doesn't scratch up the glass plate.
//
//--------------------------------------------------------------------//

//--------------------------------------------------------------------//
// Useful constants                                                   //
//--------------------------------------------------------------------//
leg_z = 24;
gap_z = 8.5;
top_z = 5;
gap_twist = 1.5;
stand_z = 50;
stand_y = 100;
stand_angle = 0;
stand_offset = 4;
frame_thickness = 6+.75;
wall_x = 4;
wall_y = gap_z;
eps = 0.01;

//--------------------------------------------------------------------//
// Utility module: gridboard                                          //
//--------------------------------------------------------------------//
module gridboard(gx, gy, gz, gs, gt)
{
  grid_cutaway = gs - gt;
  // These offsets are supposed to center the grid.
  // They are wrong, but good enough.
  interior_y = gy - 2*gt;
  whole_y = floor(interior_y / gs);
  offset_y = -(interior_y - gs * whole_y) / 2;
  interior_z = gz - 2*gt;
  whole_z = floor(interior_z / gs);
  offset_z = -(interior_z - gs * whole_z) / 2;
  echo([gy,interior_y,whole_y,offset_y,gz,interior_z,whole_z,offset_z]);
  union()
  {
    cube([gx, gy, gt]);
    cube([gx, gt, gz]);
    translate([0, gy-gt,0])
      cube([gx, gt, gz]);
    translate([0, 0, gz-gt])
      cube([gx, gy, gt]);
    difference()
    {
      cube([gx, gy, gz]);
      for(y = [1 : gs : gy])
      {
        for(z = [0 : gs : gz])
        {
          translate([-eps, offset_y + y, offset_z + z-eps])
            cube([wall_x + 2*eps, grid_cutaway, grid_cutaway + eps]);
        }
      }
    }
  }


}

//--------------------------------------------------------------------//
// Main module: stand                                                 //
//--------------------------------------------------------------------//
module stand()
{
translate([0,-wall_y, 0])
  cube([wall_x, wall_y, leg_z + gap_z + top_z]);

translate([0,-stand_y, 0])
  cube([wall_x, wall_y, leg_z + gap_z + top_z]);
translate([wall_x + frame_thickness, -wall_y, 0])
  cube([wall_x, wall_y, leg_z + gap_z]);
translate([0, gap_twist-wall_y, leg_z])
  cube([wall_x + frame_thickness + wall_x, wall_y - gap_twist, gap_z]);
translate([-stand_offset, -stand_y, leg_z + gap_z + top_z - wall_x])
  cube([wall_x + stand_offset, stand_y, wall_x]);
translate([wall_x-stand_offset, 0, leg_z + gap_z + top_z])
  rotate([0, stand_angle, 180])
    gridboard(wall_x, stand_y, stand_z, 7, 1.25);

translate([0, wall_y - stand_y, 0])
  gridboard(wall_x, stand_y - 2 * wall_y, leg_z + gap_z + top_z - wall_x,8, 1);
}

//--------------------------------------------------------------------//
// The stand, rotated for easier printing                             //
//--------------------------------------------------------------------//
rotate([-90,0,0])
  stand();
