include <BOSL2/std.scad>;

// --------- variables

// ------ user preference
x_vent_enabled=true;

// ------ fixed dimensions
// --- alu = aluminium case
alu_d=83.6;
alu_w=110.5;
alu_h=30.25;
alu_r=6.5; // edge radius

// ------ object sizing
// --- alu = aluminium case
alu_margin=0.00;
// --- vert = vertical (impacts in X/Y)
vert_thick=3; // how thick between sides of alu case and object exterior; >=3 ensures infill with 2 wall-loops
vert_lip=9;   // how far from alu case sides to empty space on flat surface
// --- hori = horizontal (imacta in Z)
hori_thick=2; // how thick between alu case top/bottom to object exterior
hori_lip=8;  // how far from top/bottom of case to reach on alu case sides
// --- leg platform = extra horizontal lip for leg holes
leg_base=12;
leg_base_offset=4;
/// --- legs = legs and holes for them
leg_edge=8;
leg_r=2; // edge radius - can't be too large

// ------ airflow
airflow_radius=1*hori_thick;
airflow_dist=2.25*hori_thick;

// ------ system
$fn=360;

// ------ computed only
total_w=alu_w+alu_margin+2*vert_thick;
total_d=alu_d+alu_margin+2*vert_thick;
leg_o=leg_base+leg_base_offset;
leg_platform_link_edge=leg_r;

// --------- modules

// ------ common top/bottom part 
module exterior() {
  color("orange")
  linear_extrude(height=hori_lip+hori_thick)
    round2d(r=alu_r)
      square([total_w,total_d], center=true);
}
module alu_and_margin(in_thick=0) {
  color("#666")
  linear_extrude(height=alu_h)
    round2d(r=alu_r)
      square([alu_w+alu_margin+in_thick,alu_d+alu_margin+in_thick], center=true);
}
module hori_hole(){
  color("pink")
  linear_extrude(height=2*alu_h)
    round2d(r=alu_r)
      square([alu_w-vert_lip,alu_d-vert_lip], center=true);

}
module cover_lip(in_thick=0.0){
  difference() {
    exterior();
    translate([0,0,hori_thick])
      alu_and_margin(in_thick);
    translate([0,0,-alu_h])
      hori_hole();
  }
}
module leg_platform(edge=leg_base, h=hori_thick){
  color("purple")
  difference(){
    linear_extrude(height=h)
      round2d(r=leg_r)
        square([edge,edge], center=true);
    leg(h);
  }
}
module leg(h=hori_thick,e=leg_edge){
  color("red")
    linear_extrude(height=h)
      round2d(r=leg_r)
        square([e,e], center=true);
}
module leg_platform_link(edge=leg_base) {
  color("blue")
  difference(){
    linear_extrude(height=hori_thick)
      square([leg_platform_link_edge,leg_platform_link_edge], center=true);
    translate([leg_platform_link_edge/2,leg_platform_link_edge/2,0])
      cylinder(h=hori_thick, r=leg_platform_link_edge);
  }
}

module leg_platform_links_fl() {
  translate([+(-alu_w+vert_lip+leg_platform_link_edge)/2,(-total_d+leg_o)/2+leg_base/2+leg_platform_link_edge/2,0]) leg_platform_link();
  translate([+(-total_w-leg_platform_link_edge+2*leg_o)/2,(-alu_d+vert_lip+leg_platform_link_edge)/2,0]) leg_platform_link();
}

module leg_platforms(){
  translate([(-total_w+leg_o)/2,(-total_d+leg_o)/2,0]) leg_platform();
  translate([(-total_w+leg_o)/2,(+total_d-leg_o)/2,0]) leg_platform();
  translate([(+total_w-leg_o)/2,(+total_d-leg_o)/2,0]) leg_platform();
  translate([(+total_w-leg_o)/2,(-total_d+leg_o)/2,0]) leg_platform();
  
  mirror([0,0,0]) leg_platform_links_fl();
  mirror([1,0,0]) leg_platform_links_fl();
  zrot(180)       leg_platform_links_fl();
  mirror([0,1,0]) leg_platform_links_fl();  
}
module legs(h=hori_thick,e=leg_edge){
  translate([(-total_w+leg_o)/2,(-total_d+leg_o)/2,0]) leg(h,e);
  translate([(-total_w+leg_o)/2,(+total_d-leg_o)/2,0]) leg(h,e);
  translate([(+total_w-leg_o)/2,(+total_d-leg_o)/2,0]) leg(h,e);
  translate([(+total_w-leg_o)/2,(-total_d+leg_o)/2,0]) leg(h,e);
}
module x_vent_old() {
  color("#ccc")
  //cube([total_w,safe_overhang,2*(hori_thick)], center=true);
  translate([-total_w/2,0,0])
    rotate([0,90,0])
      cylinder(h=total_w, r=airflow_radius);
  
}
module x_vent() {
  color("#ccc")
  rotate([0,0,90])
    teardrop(r=airflow_radius, h=total_w, ang=45);
  
}
module x_vents() {
  x_vent();
  for (y = [ 2*airflow_radius+airflow_dist : 2*airflow_radius+airflow_dist : total_d/2-leg_o-airflow_radius  ]) {
    translate([0,y,0]) x_vent();
    translate([0,-y,0]) x_vent();
  }
}
module cover(in_thick=0) {
  difference(){
    union(){
      cover_lip(in_thick);
      leg_platforms();
    }
    legs();
    if (x_vent_enabled) x_vents();
  }
}

// --------- rendering

//cover();

