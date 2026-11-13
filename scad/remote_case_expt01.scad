include <../mylib/model_raspi_pico.scad>;

CASE_WD = 80;
CASE_LN = 160;
CASE_HT = 60;
CASE_TN = 2.5;

// difference(){
//     cube([CASE_LN, CASE_WD, CASE_HT], center=true);
//     translate([0, 0, CASE_TN]){
//         cube([CASE_LN - (2*CASE_TN), CASE_WD - (2*CASE_TN), CASE_HT], center=true);
//     }
// }

BODY_LN = 140;
BODY_WD = 75;
BODY_RD = 35/2;
BODY_TN = 2;
dbl_tn = 2*BODY_TN;


module case_body(){
    hull() {
            cylinder(h = BODY_LN, r = BODY_RD);
            translate([0, BODY_WD-(BODY_RD*2), 0]){
                cylinder(h = BODY_LN, r = BODY_RD);
            }
        }
}

difference(){
    rotate([0, 90, 0]){
        difference(){
            case_body();
            translate([0, 0, CASE_TN]){
                scale([((BODY_RD*2)-dbl_tn)/(BODY_RD*2),
                         (BODY_WD-dbl_tn)/BODY_WD, 
                         (BODY_LN-dbl_tn)/BODY_LN]){
                    case_body();
                }
            }
        }
    }

    translate([BODY_LN/2, BODY_WD/2 - BODY_RD, BODY_RD]){
        cube([BODY_LN * 1.1,BODY_WD* 1.1,BODY_RD*2.1], center=true);
    }
    
    
}



//raspberrypi_zero_model();
raspi_pico();


