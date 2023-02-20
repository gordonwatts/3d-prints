// Uses rails to hold spice jars in place
$fn=500;

include <spice jar sizing.scad>

// Size of the holder
n_jar_rows = 2;
n_jars_per_row = 2;

// Holder spacing and construction
gap_between_jar_sides = 10/7; // mm - spacing between adjacent jars
gap_jar_height = 1; // mm - extra space in jar hold
jar_holder_height = 5; // mm
width_rail = 2; // mm - How thick the rails should be


// Calculated sizes
jar_height = height_glass + height_top + gap_jar_height;
jar_width = diameter_lid;
row_height = jar_height + width_rail;

col_width = gap_between_jar_sides + jar_width;

length_tray = col_width*n_jars_per_row;
tray_height = jar_holder_height;

// Lay out limit rails
for(i_row = [0:n_jar_rows]) {
    // The rails, one at bottom and one at the top
    translate([0, i_row*row_height, 0])
        cube([length_tray, width_rail, tray_height]);
}

// Supports between rails (which also keep jars from rolling)
for(i_row = [0:n_jar_rows-1]) {
    // Supports between columns
    for(i_col = [0:n_jars_per_row-1]) {
        translate([i_col*col_width, i_row*row_height, 0])
            cube([width_rail, row_height, jar_holder_height]);
    }
    // Last jar support
    translate([n_jars_per_row*col_width, i_row*row_height, 0])
        cube([width_rail, row_height + width_rail, jar_holder_height]);
    
}
