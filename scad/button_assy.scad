include <../utils/rect.scad>

$fn=50;


BUTTON_SZ = 10;
BUTTON_HT = 6;
ROUNDING_RD = 2;

HOLE_EXTRA = 0.8;

hole_sz_coeff = (BUTTON_SZ + HOLE_EXTRA) / BUTTON_SZ;

// To find the right expansion size for the holes 
// we will iterate over a range of values

hole_extras = [0.8, 1.0,1.25,1.5, 1.75, 2.0];
hole_coeffs = [for (hole_extra = hole_extras) (hole_extra + BUTTON_SZ)/BUTTON_SZ];


module button(){
    rect_array = rect(BUTTON_SZ - (2 * ROUNDING_RD), 
                          BUTTON_SZ - (2 * ROUNDING_RD));
    hull(){
        for (coord = rect_array){
            translate([coord[0], coord[1], 0]){
                cylinder(h = BUTTON_HT, r = ROUNDING_RD, center = true);
            }
        }
    }
    translate([0, 0, -BUTTON_HT/2 + 0.75]){
        cube([BUTTON_SZ+2, BUTTON_SZ+2, 1.5], center=true);
    }
}



difference(){
    cube([120,20 ,2 ], center=true);

    // // for hole size testing
    // for (i = [0:5]){

    //     translate([(-120/2) + 10 + (i * 20), 0, 0]){
    //         scale([hole_coeffs[i], hole_coeffs[i],1]){
    //             button();
    //         }
    //     } 
    // }
    // // chop off a corner so we know which end is which
    // #translate([-60, 8, 0]){
    //     rotate([0, 0, 45]){
    //         cube([20,5 , 5], center=true);
    //     }
    // }
    scale([hole_sz_coeff, hole_sz_coeff,1]){
        button();
    } 
}

color("blue",1.0){
    button();
}



