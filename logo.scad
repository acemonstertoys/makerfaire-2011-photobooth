// TODO(cbiffle): factor constants into library.
PI = 3.14159265358;
EPSILON = 1;

/////////// Design parameters: edit if it looks wrong to you.
NUM_TEETH = 6;
// Ratios are in proportion to the logo's overall width.
TOOTH_RATIO = 0.1;
TOOTH_SIZE_RATIO = 0.07;
SIDE_RATIO = 0.15;
CHIN_RATIO = 0.2;
EYE_SIZE_RATIO = 0.05;
EYE_SPACING_RATIO = 0.15;

// Here's the logo!  Set size to taste.
module logo(width, height, depth) {
	 difference() {
		union() {
			_body_shape(width, height, depth);
			_gear_teeth(width, height, depth);
		}
		_hollow_bits(width, height, depth);
	}
}


module _body_shape(width, height, depth) {
	body_width = width * (1 - (2*TOOTH_RATIO));
	body_height = body_width * 0.8;

	union() {
		cylinder(r = body_width/2, h = depth);
		translate([-body_width/2, -body_height, 0])
			cube([body_width, body_height, depth]);
	}
}

module _gear_teeth(width, height, depth) {
	// Each tooth is centered in a 180/NUM_TEETH segment of arc.
	tooth_arc = 180/NUM_TEETH;
	body_width = width * (1 - (2*TOOTH_RATIO));
	head_half_circ = PI * body_width;
	tooth_arc_len = head_half_circ / NUM_TEETH;
	tooth_size = width * TOOTH_SIZE_RATIO;
	tooth_width = tooth_arc_len * 5/16;
	for (n = [0:(NUM_TEETH - 1)]) {
		rotate([0, 0, n * tooth_arc + tooth_arc/2 - 90])
			translate([-tooth_width/2, body_width/2 - 1, 0])
			cube([tooth_width, tooth_size + 1, depth]);		
	}
}

module _hollow_bits(width, height, depth) {
	body_width = width * (1 - (2*TOOTH_RATIO) - (2*SIDE_RATIO));
	chin_thickness = body_width * CHIN_RATIO;
	body_height = width * 0.8 * (1 - (2*TOOTH_RATIO)) - chin_thickness;

	// Body hollow
	translate([-body_width/2, -body_height - chin_thickness - EPSILON, -EPSILON])
		cube([body_width, body_height + EPSILON, depth + 2*EPSILON]);

	// Head hollow
	difference() {
		intersection() {
			translate([-width/2, 0, -EPSILON])
				cube([width, height, depth + 2*EPSILON]);
			translate([0, 0, -EPSILON])
				cylinder(r = body_width/2, h = depth + 2*EPSILON);
		}

		for (n = [-1, 1]) {
			translate([n * width * EYE_SPACING_RATIO,
			           1.5 * width * EYE_SIZE_RATIO,
			           -EPSILON])
				cylinder(r = width * EYE_SIZE_RATIO, h = depth + 2*EPSILON * 10, $fs=0.1);
		}
	}

	// Tooth
	translate([-chin_thickness/2, -chin_thickness/2, -EPSILON])
		cube([chin_thickness, chin_thickness/2 + EPSILON, depth + 2*EPSILON]);
}

logo(20, 28, 4);