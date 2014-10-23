//--------------------------------------------------------------------//
// Prusa i3 RAMPS 1.4 hanging mount                                   //
//--------------------------------------------------------------------//
// Author        : Patrick Henry                                      //
// Email         : phenry@pontetec.com                                //
// License       : MIT - http://opensource.org/licenses/MIT           //
//--------------------------------------------------------------------//
//
// This fits the frame_thickness or wooden laser cut frames found here:
// http://www.thingiverse.com/thing:40465
// The value of frame_thickness should be adjusted accordingly. Here I
// have it set to 6mm acrylic. It may or may not work with the
// aluminum frame: http://www.thingiverse.com/thing:68296
// 
// Once you've built your Prusa i3, the obvious question is what to
// do with the RAMPS and Arduino module? I've seen various box ideas,
// but they don't affort easy access, and besides when you start out
// printing, your calibration is probably off so you won't get a snug
// fit box.
//
// My solution is to attach a small mount which hangs from the top of
// the acrylic frame on the right hand side. This has screw holes to
// line up with those of the Arduino and RAMPS boards, and the whole
// unit can simply be slid on to those screws.
//
// Additionally, to reduce any torsion between the two boards as they
// hang in place, I have a simple surround that snaps onto the bottom
// of the Arduino MEGA 2560. More screws can be inserted to help keep
// the Arduino and RAMPS board together. I would not recommend using
// nuts on the RAMPS side, as that board is very cramped. However,
// the holes in the middle of the Arduino board lead through to
// relatively uncrowded areas where a washer and nut could be used.
//
//--------------------------------------------------------------------//

include <arduino/arduino.scad>

//--------------------------------------------------------------------//
// Useful constants                                                   //
//--------------------------------------------------------------------//

eps=0.01;
pz=2;
nz=2+eps*2;
mz=pz+10;
wall=2;
acrylic=6;
over=wall+acrylic;
surround=wall*2+acrylic;

//--------------------------------------------------------------------//
// Module: base for Arduino board.                                    //
//--------------------------------------------------------------------//

module base() {
  translate([0,0,2])
    bumper(boardType=MEGA2560, mountingHoles=false);
  difference()
  {
    union()
    {
      boardShape(MEGA2560,1.4,pz);
      holePlacement(MEGA2560)
        cylinder(r = 3.2/2+2, h = 2+pz, $fn = 32);
    }
    translate([0,0,-eps])
      holePlacement(MEGA2560)
        cylinder(r = 3.2/2+.5, h = 2+nz, $fn = 32);
    translate([7,5,-eps])
      cube([40,55,nz]);
    translate([7,72,-eps])
      cube([40,23,nz]);
  }
}

//--------------------------------------------------------------------//
// Module: hanger can be used to hang anything on the frame.          //
//--------------------------------------------------------------------//

module hanger() {
  cube([surround,50,pz]);
  translate([surround-33,0,0])
    cube([33,surround,pz]);

  translate([over,5,0])
    cube([wall,45,mz]);
  translate([0,over,0])
    cube([wall,50-over,mz]);

  translate([surround-33,0,0])
    cube([33-over,wall,mz-wall]);
  translate([surround-33,over,0])
    cube([33-over,wall,mz]);
}

//--------------------------------------------------------------------//
// Module: hanger_mount extends hangar to mount the Arduino.          //
//--------------------------------------------------------------------//

module hanger_mount() {
  translate([-20.0,-wall,0])
  {
    difference()
    {
      cube([20+wall,wall*2,mz-wall+70]);
      translate([14.5,wall*2+eps,mz-wall+15])
        rotate([90,0,0])
        {
          cylinder(r = 1+5.6/2, h = 2.5, $fn = 32);
          cylinder(r = .25+3/2, h = wall*2+2*eps, $fn = 32);
        }
      translate([8.15,wall*2+eps,mz-wall+63.25])
        rotate([90,0,0])
        {
          cylinder(r = 1+5.6/2, h = 2.5, $fn = 32);
          cylinder(r = .25+3/2, h = wall*2+2*eps+10, $fn = 32);
        }
      // This is the hole placement given by the arduino library,
      // for reference. I find that mine fit better.
      /*
      translate([-82,2*wall+eps,mz-wall+65.75])
        rotate([0,90,-90])
          holePlacement(MEGA2560)
            union()
            {
              cylinder(r = 1+5.6/2, h = 2.5, $fn = 32);
              cylinder(r = .5+3/2, h = wall*2+2*eps, $fn = 32);
            }
      */
    }
  }
}

//--------------------------------------------------------------------//
// Module: display_model shows how the whole thing hangs together.    //
//--------------------------------------------------------------------//
module display_model() {
  rotate([0,180,0])
  {
    hanger();
    hanger_mount();
  }
  
  translate([102,0,-75.8])
    rotate([90,-90,0])
      base();
}

//--------------------------------------------------------------------//
// Main body. Note that I found the measurements in base slightly off //
// (these come from the arduino library). Therefore a small scaling   //
// factor was needed to print a close fitting base. YMMV.             //
//--------------------------------------------------------------------//

//display_model();
//scale([105/104,58/57,1])
//scale([101.5/101,53.8/53,1])
//{
//  rotate([0,0,90])
//  {
//    base();
//  }
//}
hanger();
hanger_mount();
