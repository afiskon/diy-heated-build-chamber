/* vim: set ai et ts=4 sw=4: */
// http://www.openscad.org/cheatsheet/

width = 110;
depth = 70;
height = 40; // real enclosure hight will be height+thickness
thickness = 2;
hole_dia = 2.7;
xt60_width = 18;
xt60_height = 12;
thermocouple_dia = 9;
st7735_width = 43;
st7735_height = 33;
st7735_offset = 12;
button_offset = 2.5;
button_dia = 11;
button_h_space = 15.7;
button_v_space = 17.2;

stand_width = 20;
stand_height = 7;

render_bottom_part = true;
render_top_part = true;
render_bottom_part_b_stand = false;

cut_bottom_part_a = false;
cut_bottom_part_b = false;

module bottom_screw_hole(x, y) {
    translate([x, y, 0]) {
        difference() {
            cylinder(h=height, d=hole_dia+thickness*2);
            cylinder(h=height, d=hole_dia);
        }
    }
}

module top_screw_hole(x, y) {
    translate([x, y, -height/2]) {
        cylinder(h=height, d=hole_dia);
    }
}

module button_hole(x_off, y_off) {
    translate([st7735_offset+st7735_width+
               button_offset+button_dia/2+x_off,
               depth/2 + y_off,
               -thickness]) {
        cylinder(h=thickness*3, d = button_dia);
    }
}

module bottom_part_base() {
    union() {
        // bottom
        cube([width, depth, thickness]);
        // left wall
        cube([thickness, depth, height]);
        // right wall
        translate([width-thickness, 0, 0]) {
            cube([thickness, depth, height]);
        }
        // front wall
        cube([width, thickness, height]);
        // back wall
        translate([0, depth-thickness, 0]) {
            cube([width, thickness, height]);
        }

        bottom_screw_hole(hole_dia/2+thickness, hole_dia/2+thickness);
        bottom_screw_hole(width-hole_dia/2-thickness, hole_dia/2+thickness);
        bottom_screw_hole(hole_dia/2+thickness, depth-hole_dia/2-thickness);
        bottom_screw_hole(width-hole_dia/2-thickness, depth-hole_dia/2-thickness);
    }
}

module cut_corner(x, y, angle) {
    translate([x, y, height/2]) {
        rotate([0, 0, angle]) rotate([0,-90,0]) {
            cube([height*1.2, height, thickness], true);
        }
    }
}
 
translate([-width/2, -depth/2, 0]) {
    // bottom part of the enclosure
    if(render_bottom_part) {
        difference() {
            bottom_part_base();
            // cut two holes for XT60 connectors
            translate([-width*0.1,
                       (depth-xt60_width)/2,
                       (height-xt60_height)/2]) {
                cube([width*1.2, xt60_width, xt60_height]);
            }

            // cut a hole for a thermocouple
            translate([width*0.9,
                       -thermocouple_dia + ((depth-xt60_width)/2),
                       height/2]) {
                rotate([0,90,0]) {
                    cylinder(h=width*0.2, d = thermocouple_dia); 
                }
            }

            // "round" corners
            cut_corner(0, 0, 45);
            cut_corner(width, 0, -45);
            cut_corner(0, depth, -45);
            cut_corner(width, depth, 45);

            if(cut_bottom_part_a) {
                translate([0, 0, (height-xt60_height)/2])
                    cube([width, depth, height - (height-xt60_height)/2]);
            }

            if(cut_bottom_part_b) {
                cube([width, depth, (height-xt60_height)/2]);
            }

        }
    } // if

    if(render_bottom_part_b_stand) {
        translate([-stand_width/4, -stand_width/4, height]) {
            difference() {
                cube([width+stand_width/2, depth+stand_width/2, stand_height]);
                translate([stand_width/2, stand_width/2, 0])
                    cube([width-stand_width/2, depth-stand_width/2, stand_height]);
            }
        }
    } // if

    if(render_top_part) {
        translate([0, 0, height]) difference() {
            // base
            cube([width, depth, thickness]);

            // hole for ST7735
            translate([st7735_offset,
                      (depth-st7735_height)/2,
                      -thickness]) {
                cube([st7735_width, st7735_height, thickness*3]);


            }

            // "round" corners
            cut_corner(0, 0, 45);
            cut_corner(width, 0, -45);
            cut_corner(0, depth, -45);
            cut_corner(width, depth, 45);

            // button holes
            button_hole(0, -button_v_space/2);
            button_hole(0, button_v_space/2);
            button_hole(button_h_space, -button_v_space/2);
            button_hole(button_h_space, button_v_space/2);

            // screw holes
            top_screw_hole(hole_dia/2+thickness, hole_dia/2+thickness);
            top_screw_hole(width-hole_dia/2-thickness, hole_dia/2+thickness);
            top_screw_hole(hole_dia/2+thickness, depth-hole_dia/2-thickness);
            top_screw_hole(width-hole_dia/2-thickness, depth-hole_dia/2-thickness);
            
       } // translate, difference
    } // if

}
