// Units are mm
$fn=1000;

include <spice jar sizing.scad>
use <waxbase.scad>

// Total size of tray
n_jars_per_row = 3;
n_jar_rows = 2;

// Intra-jar spacing
gap_between_jar_sides = 10/7; // mm - spacing between adjacent jars
gap_between_jar_tops = 3; // mm - spacing between one row and the next

// Tray design constants
jar_holder_height = 5; // mm
height_above_bottom = 2.5; // raising off drawer bottom [mm]
fraction_length_tray_support = 0.6; // Fraction of full tray width drawn
width_rail = 2; // mm - How thick the rails should be
width_rail_support = 7; // mm - how think should the glass holder rails be?

// Calculated constants
jar_height = height_glass + height_top;
jar_width = diameter_lid;
row_height = gap_between_jar_tops + jar_height + width_rail;
row_gap_height = row_height - height_glass;
col_width = gap_between_jar_sides + jar_width;

length_tray = col_width*n_jars_per_row;
tray_height = jar_holder_height + height_above_bottom;

jar_support_width = diameter_glass*fraction_length_tray_support;
width_raft_removal = jar_support_width - width_rail_support;

// Lay out support rails and rafts
for(i_row = [0:n_jar_rows-1]) {
    union() {
        // Bottom rail (goes all the way accross)
        translate([0, i_row*row_height, 0]) {
            cube([length_tray, width_rail, tray_height]);
        }
        
        // Top rail that holds the wood top. (goes all the way accross)
        translate([0, (i_row+1)*row_height, 0])
            cube([length_tray, width_rail, tray_height]);

        // For each column, we next have to build rails, inter layer connectors, etc.
        for(i_jar = [0:n_jars_per_row-1]) {
            // The vertical link between the two rails at the top
            translate([i_jar*col_width, (i_row)*row_height, 0])
            translate([0, height_glass, 0])
                cube([width_rail, row_gap_height, tray_height]);

            // The wax holder base
            translate([i_jar*col_width, i_row*row_height, 0])
                waxbase();

            // Now the sculpted rails that will hold the
            // jars.
            difference() {
                union() {
                    // Cube raft between
                    translate([i_jar*col_width, i_row*row_height, 0])
                    translate([col_width/2.0 - jar_support_width/2.0, 0, 0])
                            cube([jar_support_width, height_glass, tray_height]);

                    // Top trail at glass lip
                    translate([i_jar*col_width, i_row*row_height+height_glass-width_rail, 0])
                        cube([col_width, width_rail, tray_height]);

                }
                // Remove the cylinder shape from the raft
                translate([i_jar*col_width, i_row*row_height])
                translate([col_width/2.0, height_glass + width_rail, diameter_glass/2.0+height_above_bottom])
                    rotate([90, 0, 0])
                        cylinder(h = height_glass, r = diameter_glass/2.0);

                // Turn the remaining raft into rails
                translate([i_jar*col_width, i_row*row_height])
                translate([col_width/2.0 - width_raft_removal/2.0, width_rail, 0])                    cube([width_raft_removal, height_glass, tray_height]);
            }
        }
        
        // Closing link between the two rails at the top
        translate([n_jars_per_row*col_width, (i_row)*row_height, 0])
        translate([-width_rail, height_glass, 0])
            cube([width_rail, row_gap_height, tray_height]);


        // Next, the rafts between them
//            for(i_jar = [0:n_jars_per_row-1]){
//                translate([i_jar*col_width, i_row*row_height, 0])
//                translate([col_width/2.0 - jar_support_width/2.0, 0, 0])
//                        cube([jar_support_width, height_glass, tray_height]);
//            }
    }
    
    // Remove the depression to hold the jars,
    // and turn them into rail
//        for (i_jar = [0:n_jars_per_row-1]){
//            union() {
//                translate([i_jar*col_width, i_row*row_height])
//                translate([col_width/2.0, height_glass + width_rail, diameter_glass/2.0+height_above_bottom])
//                    rotate([90, 0, 0])
//                        cylinder(h = height_glass, r = diameter_glass/2.0);
//
//                translate([i_jar*col_width, i_row*row_height])
//                translate([col_width/2.0 - width_raft_removal/2.0, width_rail, 0])                
//                    cube([width_raft_removal, height_glass, tray_height]);
//            }
//        }
}

// Connections between rows
//for(i_row = [1:n_jar_rows-1]) {
//    for(i_col = [0:n_jars_per_row-1]) {
//        translate([i_col*col_width, (i_row-1)*row_height, 0])
//        translate([0, height_glass, 0])
//            cube([width_rail, row_gap_height, tray_height]);
//    }
//    // And the last one in the row
//    translate([n_jars_per_row*col_width, (i_row-1)*row_height, 0])
//    translate([-width_rail, height_glass, 0])
//        cube([width_rail, row_gap_height, tray_height]);
//}
