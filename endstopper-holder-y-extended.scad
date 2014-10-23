//--------------------------------------------------------------------//
// Prusa i3 clip on y endstop holder                                  //
//--------------------------------------------------------------------//
// Author        : Patrick Henry                                      //
// Email         : phenry@pontetec.com                                //
// License       : MIT - http://opensource.org/licenses/MIT           //
//--------------------------------------------------------------------//
// With the Prusa i3 from 3dprinterczar.com, the y endstop has to be
// placed in such a way that it dramatically reduces the available
// print area. In my desire to fix this, I was inspired by the snap on
// motor mount found here: http://www.thingiverse.com/thing:21716
// Of course, that mount is made for a different arrangement of the
// frame on which the print bed sits, so it won't work for this
// particular model, but the idea can be adapted for an endstop holder
// that does.
// This increased my usable Y area from 144.5mm to 184mm. Since the
// glass plate is 200mm, I could push it a little further, but it's
// good enough for my needs.
//--------------------------------------------------------------------//

//--------------------------------------------------------------------//
// Useful constants                                                   //
//--------------------------------------------------------------------//

$fn=50;
eps=0.01;
wall=2.5;
z=wall * 4;
slip = 0.5;
rod1_y = 10;
rod2_y = 30;
rod_r = 4;
rod2_to_top = 45;


//--------------------------------------------------------------------//
// Reference design: y-corner.stl from i3stl.rar                      //
//--------------------------------------------------------------------//

module y_corner()
{
  translate([-11,0,-20])
  {
    rotate([-90,270,0])
    {
      color([1,0,0])
      {
        import("y-corner.stl");
      }
    }
  }
  translate([0,rod1_y,-50])
  {
    %cylinder(r=rod_r, h=100);
  }
  translate([0,rod2_y,-50])
  {
    %cylinder(r=rod_r, h=100);
  }
}

//--------------------------------------------------------------------//
// Module: snap_mount could be reused in other designs                //
//--------------------------------------------------------------------//

module snap_mount()
{
  difference()
  {
    union()
    {
      translate([4-slip,10-4+slip-wall,0])
        cube([wall, 32.4, z]);
      translate([-6,10-4+slip-wall,0])
        cube([12, 2*(wall-slip)+8.4, z]);
      translate([-6,30-4+slip-wall/2,0])
        cube([12, 3*wall/2-2*slip+8.4, z]);
    }
    translate([-6-eps,10-4+slip,-eps])
    {
      cube([6, 2*(rod_r-slip), z+2*eps]);
      translate([0,-1,0])
        cube([2, 2*(rod_r-slip)+2, z+2*eps]);
    }
    translate([0-4+slip,23,-eps])
    {
      cube([2*(rod_r-slip), 6, z+2*eps]);
      translate([-1,0,0])
        cube([2*(rod_r-slip)+1, 2, z+2*eps]);
    }
    translate([0,rod1_y,-eps])
    {
      cylinder(r=rod_r, h=z + 2*eps);
    }
    translate([-5,20.75,-eps])
    {
      cylinder(r=rod_r, h=z + 2*eps);
    }
    translate([0,rod2_y,-eps])
    {
      cylinder(r=rod_r, h=z + 2*eps);
    }
  }
}

//--------------------------------------------------------------------//
// Module: endstop_plate                                              //
//--------------------------------------------------------------------//

module endstop_plate()
{
  difference()
  {
    union()
    {
      translate([5,26.4,0])
        cube([25, 10, wall]);
      translate([20,30,0])
        cube([10, rod2_to_top, wall]);
      translate([5,30-wall/2,0])
        cube([20+wall/2,wall, wall*2]);
      translate([25-wall/2,30,0])
        cube([wall, rod2_to_top-22, wall*2]);
    }

    translate([25,30+rod2_to_top-4,-eps])
    {
      cylinder(r=1.25, h=wall+2*eps);
    }
    translate([25,30+rod2_to_top-4-9.75,-eps])
    {
      cylinder(r=1.25, h=wall+2*eps);
    }
  }
}

//--------------------------------------------------------------------//
// Main body                                                          //
//--------------------------------------------------------------------//

//y_corner();
snap_mount();
endstop_plate();
