waxbase();

module waxbase(width=10, length=20, height=3, width_walls=2) {

    // Everything in mm

    // width = 10; // mm
    // length = 20; // mm
    // height = 3; // mm

    // width_walls = 2; // mm - thickness of the walls

    // How high the inset should be
    height_inset = height - 1.5;

    difference() {
        // The basic block
        cube([width, length, height]);

        // The inset cube for the wax
        translate([width_walls, width_walls, 0])
            cube([width-2*width_walls, length-2*width_walls, height_inset]);
    }
}
