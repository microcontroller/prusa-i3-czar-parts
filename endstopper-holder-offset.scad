// Prusa i3 endstop holder with offset.
//
// The endstop holder from 3dprinterczar.com is designed to clamp onto the
// M8 rod, and hold the microswitch in place with a zip tie. However, the switch
// protrudes from the holder, which reduces the range of motion for the Y axis,
// and makes it much harder to place the Z axis endstop without impacting the
// coupler on that axis.
//
// This part simply offsets the microswitch to reduce the amount by which it
// protrudes from the holder.

include <MCAD/nuts_and_bolts.scad>

$fn=50;
eps=0.01;
wall=4.3;
z=9.95;
z_offset=3.5;
rod=4;
slip = 0.5;
nut_x = METRIC_NUT_AC_WIDTHS[3];
nut_y = METRIC_NUT_THICKNESS[3];
nut_z = sqrt(3) * nut_x / 2;
nut_scale = z/nut_z;
difference() {
  union() {
    cube([40.75, wall, z]);
    translate([z+2*rod+wall-3*slip,0, 0])
      cube([40.75-nut_x-2*rod-wall-3*slip, wall, z+z_offset]);
    translate([0,wall + 2*rod - 2*slip, 0])
      cube([z+wall, wall, z]);
    translate([z+rod, wall + rod - slip, 0])
      cylinder(r=rod+wall-slip, h=z);
  translate([nut_scale*nut_x/2,2*(wall+rod-slip),z/2])
    rotate([-90,0,0])
      scale([nut_scale,nut_scale,1])
        nutHole(3);
  }
  translate([z+rod, wall + rod - slip, -eps])
    cylinder(r=rod, h=z+2*eps);
  translate([0, wall, -eps])
    cube([z+rod, 2*rod - 2*slip, z+2*eps]);
  translate([nut_scale*nut_x/2,2*(wall+rod-slip)+eps,z/2])
    rotate([-90,0,0])
      scale([1.2,1.2,1])
        nutHole(3);
  translate([nut_scale*nut_x/2,-eps,z/2])
    rotate([-90,0,0])
      //#cylinder(r=3/2,h=2*(wall+rod+eps));
      boltHole(3, length=2*(wall+rod-slip)+3*eps);
  translate([26, -eps, z_offset+z/2])
    rotate([-90,0,0])
      cylinder(r=1.25,h=wall+2*eps);
  translate([35.75, -eps, z_offset+z/2])
    rotate([-90,0,0])
      cylinder(r=1.25,h=wall+2*eps);
}
