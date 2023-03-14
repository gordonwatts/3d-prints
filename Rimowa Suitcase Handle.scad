$fn=500;
$fa=0.05;
use <polyround.scad>

//handle();

plunger();

plunger_depression = 15.4-8.7;

//shaft();

module handle() {
    // Create the handle with the cutout for the plunger
    // The object is positioned with center for plunger hold at (x,y)=(0,0)
    hole_depth = 15;
    back_hole_boarder = 6;
    translate([back_hole_boarder+hole_depth/2.0, 0, 0])
    difference() {
        full_handle();
        
        translate([-hole_depth/2.0-back_hole_boarder, 0, 0])
        cube([hole_depth, 20, 100], center=true);
    }
}

module plunger() {
    // Create the handle with the cutout for the plunger
    // The object is positioned with center for plunger hold at (x,y)=(0,0)
    hole_depth = 15;
    back_hole_boarder = 6;
    translate([back_hole_boarder+hole_depth/2.0, 0, 0])
    intersection() {
        full_handle();
        
        translate([-hole_depth/2.0-back_hole_boarder, 0, 0])
        cube([hole_depth, 20, 100], center=true);
    }
}


module full_handle() {
    h_width = 142;
    h_height = 27; // 27
    h_depth = 24;
    
    h_ledge_height = 4;
    
    r_front_lower = 2;
    r_back_lower = 5;
    r_back_upper = 2;

    r_points = [
        [-r_front_lower, 0, r_front_lower],
        [h_depth, 0, r_back_lower],
        [h_depth, h_height+2*r_back_upper, r_back_upper],
        [-r_front_lower, h_ledge_height, r_front_lower]
    ];

    rotate([90, 0, 0])
    translate([-h_depth, 0, -h_width/2.0])
    polyRoundExtrude(r_points, h_width, 2, 2, fn=50);
}

module shaft() {
    outter_width = 26;
    outter_depth = 21;
    cube_height = 26;
    difference() {
        translate ([-outter_width/2.0, -outter_depth/2.0, 0])
            cube([outter_width, outter_depth, cube_height]);

        // The interior
        inner_cut();
        // The wholes for the tension pin
        translate([0, 0, 6.5])
        rotate([0, 90, 90])
            pin();
        
        translate([0, 0, cube_height - 10]) {
            press_pin_hole();
        }
    }
}

module capped_pie_slice(thickness, width, height) {
    // Create a semi-circular sliver - the end of the pie slice,
    // chopped off
    // The pie slice is `thickness` high, and at its flat base
    // has a width `width`.
    
    // Calculate the length L from the raius point of the pie slice to
    // the flat surface
    L = ((width/2.0)^2 - thickness^2)/(2*thickness);
    r = L + thickness;
    
    // And the total opening angle is just now:
    a = 2*acos(L/r);
    
    // Translate so the flat part is along the + x axis.
    rotate([0, 0, 90])
        translate([0, 0, height/2.0])
            linear_extrude(height=height, center=true)
                translate([-L, 0, 0]) {
                    polygon(points=[
                        for(theta=-a/2.0; theta<(a/2.0); theta=theta+$fa)
                            [r*cos(theta), r*sin(theta)],
                        [r*cos(a/2.0), r*sin(a/2.0)]
                        ]);
                }
}

module inner_cut() {
    inner_width = 18.6;
    inner_depth = 14.70;
    inner_height = 22;
    rounded_edge_radius = 1;
    
    upper_curve_thickness = 1.5;
    lower_curve_thickenss = 1.5;

    // Some calculated values
    inner_box_depth = inner_depth - upper_curve_thickness - lower_curve_thickenss;

    translate([0, inner_depth/2.0-upper_curve_thickness, 0])
    union() {
        // The upper bowed edge
        capped_pie_slice(thickness=upper_curve_thickness, width=inner_width, height=inner_height);

        // The solid box
        translate([-inner_width/2.0, -inner_box_depth, 0]) {
            cube([inner_width, inner_box_depth, inner_height]);
        }
        
        // The lower bowed edge
        translate([0, -inner_box_depth, 0])
            rotate([0, 0, 180])
                capped_pie_slice(thickness=1.0, width=inner_width, height=inner_height);
    }
}

module pin() {
    height = 30;
    pin_diameter = 4.2;
    translate([0, 0, -height/2.0])
        cylinder(h=height, r=pin_diameter/2.0);
}

module press_pin_hole() {
    pin_height = 10;
    translate([0, 0, pin_height/2.0])
    cylinder(h=pin_height, r=3.5);
}
