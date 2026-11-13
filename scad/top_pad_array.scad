include <utils/rect.scad>

$fn=50;

BUTTON_SZ = 10;
BUTTON_HT = 6;
ROUNDING_RD = 2;

HOLE_EXTRA = 0.8;

hole_sz_coeff = (BUTTON_SZ + HOLE_EXTRA) / BUTTON_SZ;




// ############################################################################
// BUTTON pad to hold buttons
//#############################################################################
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

// button();

PCB_WD = 44;
PCB_HT = 90;

PAD_OVERHANG = 4;

OVERLAY_TN = 2;
overlay_wd = PCB_WD + (2 * PAD_OVERHANG);
overlay_ht = PCB_HT + (2 * PAD_OVERHANG);



BUTTON_ARRAY = [
    [-11, 39],
    [ 11, 39],
    [-16, 17 ],
    [0, 18],
    [17, 17],
    [-1.6, -7 ]
];


// difference(){
//     cube([overlay_wd, overlay_ht, OVERLAY_TN], center=true);
//     for(coord = BUTTON_ARRAY){
//         translate([coord[0], coord[1], 0]){
//             scale([hole_sz_coeff, hole_sz_coeff, 1]){
//                 button();
//             }
//         }
//     }
//     translate([-2.5, 2, 0]){
//         cube([20, 5, OVERLAY_TN*1.1], center=true);
//     }
// }



// ############################################################################
// ### SIDE frames to hold PCBs etc
//#############################################################################

PCB_TN = 1.6;


pcb_slot_ht = PCB_TN + 1.1;
PCB_SLOT_DP = 3;


HOLDER_HT = 25;
HOLDER_LN = 60;
HOLDER_TN = 10;

BOTTOM_BOARD_OS = -9;
PCB_DIST = 12.5;
PAD_DIST = 2.5;

pad_slot_ht = OVERLAY_TN*1.3;

LEG_LN = 47;
LEG_TN = 2;
LEG_GIRTH = 8;

SCREWHOLE_RD = 4/2;



module vert_straight_side(){
    
    // the vertically straight side
    difference(){
        // the main body of the side clamp thingies that the PCBs will slot into
        cube([HOLDER_TN, HOLDER_LN, HOLDER_HT], center=true);
    
        // the slots for the PCBs
        translate([(HOLDER_TN/2), 0, BOTTOM_BOARD_OS]){
            cube([PCB_SLOT_DP*2, HOLDER_LN*1.1, pcb_slot_ht], center=true);
        }
        translate([(HOLDER_TN/2), 0, BOTTOM_BOARD_OS + PCB_DIST]){
            cube([PCB_SLOT_DP*2, HOLDER_LN*1.1, pcb_slot_ht], center=true);
        }
        // the slot for the pad
        translate([(HOLDER_TN/2) - PAD_OVERHANG + 2, 0, BOTTOM_BOARD_OS + PCB_DIST+PAD_DIST + (pad_slot_ht/2) + (pcb_slot_ht/2)]){
            cube([PAD_SLOT_DP , HOLDER_LN*1.1, pad_slot_ht], center=true);
        }
        // so the top doesn't encroach too far over the pad we'll chop the lip back
        translate([6, 0, HOLDER_HT - 4]){
            cube([offset_holder_tn, HOLDER_LN * 1.1, HOLDER_HT], center=true);
        }

        // Now we need to remove as much as possible but no more
        translate([0, 0, 0]){
            difference(){
                cube([HOLDER_TN * 1.1, HOLDER_LN * 0.8, HOLDER_HT * 0.8], center=true);

                cube([HOLDER_TN * 1.2, 20, HOLDER_HT], center=true);
            }
        }
        // a screwhole for holding both sides together
        translate([0, 0, -3]){
            rotate([0, 90, 0]){
                #cylinder(h = HOLDER_TN * 1.1, r = SCREWHOLE_RD, center = true);
            }
        }
    
        // // chop out most of it for a test print
        // translate([0, -15, 0]){
        //     #cube([20, 40, 40], center=true);
        // }
    
    }
    // Now give it legs
    translate([-1, -HOLDER_LN/2 + LEG_GIRTH/2, -LEG_LN/2 - HOLDER_HT/2 + 1]){
        difference(){
            cube([LEG_GIRTH, LEG_GIRTH, LEG_LN], center=true);
            translate([LEG_TN, LEG_TN, 0]){
                cube([LEG_GIRTH, LEG_GIRTH, LEG_LN* 1.1], center=true);
            }
        }
    }
    translate([-1, HOLDER_LN/2 - LEG_GIRTH/2, -LEG_LN/2 - HOLDER_HT/2 + 1]){
        difference(){
            cube([LEG_GIRTH, LEG_GIRTH, LEG_LN], center=true);
            translate([LEG_TN, -LEG_TN, 0]){
                cube([LEG_GIRTH, LEG_GIRTH, LEG_LN* 1.1], center=true);
            }
        }
    }
}


// the vertically offset side
PCB_OS = 2;
offset_holder_tn= HOLDER_TN + PCB_OS;
PAD_SLOT_DP = 10;

module vert_offset_side(){
    difference(){
        // the main body of the side clamp thingies that the PCBs will slot into
        cube([offset_holder_tn, HOLDER_LN, HOLDER_HT], center=true);
    
        // the slots for the PCBs
        translate([(offset_holder_tn/2), 0, BOTTOM_BOARD_OS]){
            cube([PCB_SLOT_DP*2, HOLDER_LN*1.1, pcb_slot_ht], center=true);
        }
        translate([(offset_holder_tn/2) -PCB_OS, 0, BOTTOM_BOARD_OS + PCB_DIST]){
            cube([PCB_SLOT_DP*2, HOLDER_LN*1.1, pcb_slot_ht], center=true);
        }
        // the slot for the pad
        translate([(offset_holder_tn/2) -PCB_OS - PAD_OVERHANG + 2, 0, BOTTOM_BOARD_OS + PCB_DIST+PAD_DIST + (pad_slot_ht/2) + (pcb_slot_ht/2)]){
            cube([PAD_SLOT_DP, HOLDER_LN*1.1, pad_slot_ht], center=true);
        }
        // so the top doesn't encroach too far over the pad we'll chop the lip back
        translate([6, 0, HOLDER_HT - 4]){
            cube([offset_holder_tn, HOLDER_LN * 1.1, HOLDER_HT], center=true);
        }

        // Now we need to remove as much as possible but no more
        translate([0, 0, 0]){
            difference(){
                cube([offset_holder_tn * 1.1, HOLDER_LN * 0.8, HOLDER_HT * 0.8], center=true);

                cube([offset_holder_tn * 1.2, 20, HOLDER_HT], center=true);
            }
        }
        // a screwhole for holding both sides together
        translate([0, 0, -3]){
            rotate([0, 90, 0]){
                #cylinder(h = offset_holder_tn * 1.1, r = SCREWHOLE_RD, center = true);
            }
        }

        // // chop out most of it for a test print
        // translate([0, -15, 0]){
        //     #cube([20, 40, 40], center=true);
        // }
    }
    // Now give it legs
    translate([-2, -HOLDER_LN/2 + LEG_GIRTH/2, -LEG_LN/2 - HOLDER_HT/2 + 1]){
        difference(){
            cube([LEG_GIRTH, LEG_GIRTH, LEG_LN], center=true);
            translate([LEG_TN, LEG_TN, 0]){
                cube([LEG_GIRTH, LEG_GIRTH, LEG_LN* 1.1], center=true);
            }
        }
    }
    translate([-2, HOLDER_LN/2 - LEG_GIRTH/2, -LEG_LN/2 - HOLDER_HT/2 + 1]){
        difference(){
            cube([LEG_GIRTH, LEG_GIRTH, LEG_LN], center=true);
            translate([LEG_TN, -LEG_TN, 0]){
                cube([LEG_GIRTH, LEG_GIRTH, LEG_LN* 1.1], center=true);
            }
        }
    }
}


// translate([-20, 0, 0]){
//     vert_straight_side();
// }

translate([20, 0, 0]){
    rotate([0, 0, 180]){
        vert_offset_side();
    }
}
