include <common.scad>;

// --------- variables

// ------ user preference
pwr_led_cover_enabled=true;
print_improvement_enabled=true; // break layer continuity to make better print


// ------ microSD card slot (front)
sd_o=22.5;     // X offset from center to left edge of slot
sd_w=13.5;     // width of slot
sd_h=5;        // height from bottom of alu case

// ------ Power LED cover (front)
pwr_led_o=9.5; // X offset from center to left edge of cover
pwr_led_w=13;  // width
pwr_led_h=18;  // height from bottom of alu case
pwr_led_m=0.75;// margin = how much leds pertrude outside alu case
pwr_led_e=1.0; // edge = how much margin on left and right between ara with full vert_thick and vert_thick-pwr_led_m

// ------ Flex out (back)
flex_o=0;      // X offset from center to left edge of slot
flex_w=50;     // width of slot
flex_h=6;      // height from bottom of alu case

// ------ Print improvement (back)
pi_w=1;


// --------- modules
module pwr_led_cover_old() {
  color("darkgreen")
  translate([pwr_led_o,-total_d/2,hori_thick])
    cube([pwr_led_w, vert_thick-pwr_led_m, pwr_led_h]);
}
module pwr_led_cover() {
  difference(){
    color("darkgreen")
    translate([pwr_led_o,-total_d/2,hori_thick])
      cube([pwr_led_w, vert_thick, pwr_led_h]);
    color("lightgreen")
    translate([pwr_led_o+pwr_led_e,-total_d/2+vert_thick-pwr_led_m,hori_thick])
      cube([pwr_led_w-2*pwr_led_e, pwr_led_m, pwr_led_h]);
  }
}
module sd_cutout() {
  color("lightgreen")
  translate([sd_o,-total_d/2,hori_thick+sd_h])
    cube([sd_w, vert_thick, hori_lip]);
}
module flex_cutout() {
  color("lightgreen")
  translate([-flex_o-flex_w,total_d/2-2*vert_thick,hori_thick+flex_h])
    cube([flex_w, 3*vert_thick, hori_lip]);
}
module print_improvement(){
  color("teal")
  translate([0,total_d/2-2*vert_thick,hori_thick])
    cube([pi_w, 3*vert_thick, hori_lip]);
}

// --------- rendering

difference(){
  union(){
    if (pwr_led_cover_enabled) pwr_led_cover();
    cover();
  }
  sd_cutout();
  flex_cutout();
  if (print_improvement_enabled) print_improvement();
}