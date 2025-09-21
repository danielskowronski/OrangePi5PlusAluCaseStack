include <common.scad>;

// --------- variables

// ------ user preference
eth_led_cover_enabled=true;


// ------ alu case
top_alu_margin=-0.00; // extra margin change for alu_margin on top since this is fractionally smaller

// ------ USB 3.0 ports (front)
// --- USB 3.0 ports
usb3_ox=28.0;  // X offset from center to left side of USB ports cutouts
usb3_oz=0;     // Z offset from top of alu case to safe zone above USB ports
usb3_w=20;     // width of USB port cutouts

// ------ Ethernet ports (back)
// --- Ethernet ports
eth_o=24.5; // X offset from center to center between 2 ethernet ports
eth_port_w=15;
eth_cutout=5; // Z offset from top of case 
// --- Ethernet LEDs
eth_led_w=5.25;
eth_led_h=9.5; // from top of alu case to bottom of eth led

// ------ USB 2.0 and HDMI ports (back)
// --- HDMI ports
hdmi_ox=7.5;  // X offset from center to right side of HDMI ports cutouts
hdmi_oz=0;    // Z offset from top of alu case to safe zone above HDMI ports
hdmi_w=38;    // width of HDMI port cutouts
// --- USB 2.0 ports
usb2_ox=-30.5; // X offset from center to right side of USB ports cutouts
usb2_oz=0;     // Z offset from top of alu case to safe zone above USB ports
usb2_w=20;     // width of USB port cutouts


// ------ computed only
top_vert_thick=vert_thick-top_alu_margin/2;
eth_port_middle_cutout_w=eth_port_w-2*eth_led_w;
back_oy=total_d/2-top_vert_thick;
back_oz=hori_thick;
eth_vector=[eth_o,back_oy,back_oz];

// --------- modules

module eth_led_cover() {
  color("darkgreen")
  translate(eth_vector){
    // right port - left led
    cube([eth_led_w, top_vert_thick, eth_led_h]);
    // right port - right led
    translate([eth_led_w+eth_port_middle_cutout_w,0,0]) cube([eth_led_w, top_vert_thick, eth_led_h]);
    // left port - right led
    translate([-eth_led_w,0,0]) cube([eth_led_w, top_vert_thick, eth_led_h]);
    // left port - left led
    translate([-eth_port_w,0,0]) cube([eth_led_w, top_vert_thick, eth_led_h]);
  }
}
module eth_cutout() {
  color("lightgreen")
  translate(eth_vector)
  translate([0,0,eth_cutout]) {
    translate([eth_led_w,0,0]) cube([eth_port_middle_cutout_w, top_vert_thick, hori_lip-eth_cutout]);
    translate([-eth_port_w+eth_led_w,0,0]) cube([eth_port_middle_cutout_w, top_vert_thick, hori_lip-eth_cutout]);
  }
}
module tall_port_cutout(ox,oz,w, y_multiplier, vert_lip_multiplier=2) {
  color("lightgreen")
  translate([ox-w,y_multiplier*(back_oy)-vert_lip_multiplier*(vert_lip),back_oz+oz])
    cube([w, top_vert_thick+vert_lip_multiplier*vert_lip, hori_lip-oz]);
}

// --------- rendering

difference(){
  cover(top_alu_margin);
  
  //front
  tall_port_cutout(usb3_ox, usb3_oz, usb3_w, -1);
  
  // back
  eth_cutout();
  tall_port_cutout(hdmi_ox, hdmi_oz, hdmi_w, 1, 0);
  tall_port_cutout(usb2_ox, usb2_oz, usb2_w, 1);
}
if (eth_led_cover_enabled) eth_led_cover();