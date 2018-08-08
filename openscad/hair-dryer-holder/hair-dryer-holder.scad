/* vim: set ai et ts=4 sw=4: */
// http://www.openscad.org/cheatsheet/

big_dia = 41;
small_dia = 41;
length = 50; // the real length willi be `length-tickness`
thickness = 2;

swtich_offset = 0; // from the center in the direction of small_dia
switch_lenth = 30;
switch_width = 20;
switch_depth = big_dia/2;

difference() {
    translate([0, 0, -(big_dia+thickness)/4])
      cube([length-thickness, big_dia+thickness, (big_dia+thickness)/2],center = true);

    rotate([0, 90, 0])
      cylinder(h = length, d1 = big_dia, d2 = small_dia, center = true);

    translate([swtich_offset, 0, -small_dia/2])
        cube([switch_lenth, switch_width, switch_depth], center = true);
}
