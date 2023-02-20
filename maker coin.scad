// Units are mm
$fn=500;

// Total height
tall = 10;

// Internal rotation part of the coin
int_rad = 25/2;
int_cha=4;

// External part of the coin
ext_rad=40/2;
ext_cha=2;

ridge_rad=ext_cha;
ridge_num = 24;

// Gap between the two
offset = 0.4;

internal_hub(int_rad-offset/2.0);
external_rim();

module internal_hub(r) {
    cylinder(r1=r, r2=r-int_cha,h=int_cha);
    translate([0,0,int_cha])
        cylinder(r=r-int_cha,h=tall-2*int_cha);
    translate([0,0,tall-int_cha])
        cylinder(r1=r-int_cha, r2=r, h=int_cha);
}

module external_rim() {
    difference() {
        // Main bulk of coin
        union() {
            cylinder(r1=ext_rad-ext_cha, r2=ext_rad,h=ext_cha);
            translate([0, 0, ext_cha])
                cylinder(r=ext_rad, h=tall-2*ext_cha);
            translate([0, 0, tall-ext_cha])
                cylinder(r1=ext_rad, r2=ext_rad-ext_cha, h=ext_cha);
        }
        
        // Get rid of the ridges around the edges
        for(i=[1:1:ridge_num]) {
            rotate([0,0,i*360/ridge_num]) translate([ext_rad, 0, 0])
                cylinder(r=ridge_rad, h=tall);
        }
        
        // And the internal hub
        internal_hub(int_rad+offset/2.0);
    }
}