include <common.scad>;

// --------- variables

// ------ user preference
is_bottom_leg=true;   // bottom leg has wider area on bottom for adhesive rubber
leg_height=2;         // working height = excluding part that go into case itself
bottom_leg_base_w=16; // edge for is_bottom_leg

// ------ object sizing
leg_toleration=0.05; // ensure leg stays in position

// ------ computed only
leg_height_full=leg_height+2*hori_thick;
leg_edge_positive=leg_edge-leg_toleration;

// --------- modules

// --------- rendering

leg(leg_height_full, leg_edge_positive);
if (is_bottom_leg) leg(hori_thick, bottom_leg_base_w);