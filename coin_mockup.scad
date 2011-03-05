//////// Constants - if you edit, change universe to match
EPSILON = 0.01;
PI = 3.14159265358;

//////// Makerbot configuration params
LAYER = 0.36;
function layers(n) = n * LAYER;

//////// Coin shape params
COIN_RADIUS = 25;
COIN_THICKNESS = layers(2);

RIM_THICKNESS = layers(1);
INSET_RADIUS = COIN_RADIUS - 2;

NUM_TEETH = 20;
TOOTH_SIZE = 1;

//////// Coin implementation
module coin_center() {
	translate([0, 0, RIM_THICKNESS])
		cylinder(r = COIN_RADIUS, h = COIN_THICKNESS, $fs = 0.1, $fa = 3);
}

module gear_teeth() {
	tooth_arc = 360 / NUM_TEETH;
	tooth_diameter = (2 * COIN_RADIUS * PI) / NUM_TEETH * 0.6;
	
	for (n = [1:NUM_TEETH]) {
		rotate([0, 0, n * tooth_arc])
			translate([-tooth_diameter/2, COIN_RADIUS - 1, 0])
			cube([tooth_diameter,
                  TOOTH_SIZE + 2,
                  COIN_THICKNESS + 2*RIM_THICKNESS]);
	}
}

module coin_rim() {
	height_with_rim = COIN_THICKNESS + 2*RIM_THICKNESS;
	difference() {
		cylinder(r = COIN_RADIUS, h = height_with_rim, $fs = 0.1, $fa = 3);
		translate([0, 0, -EPSILON])
			cylinder(r = INSET_RADIUS, h = height_with_rim + 2*EPSILON, $fs = 0.1, $fa = 3);
	}
}

module coin_mockup() {
	union() {
		coin_rim();
		gear_teeth();
		coin_center();
	}
}
coin_mockup();