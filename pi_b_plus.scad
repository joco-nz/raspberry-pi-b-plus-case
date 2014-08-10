// What to Draw
drawBoard=0;
drawBoardCentered=1;
drawMicroSDCutOut=1;
drawCaseBottom=1;
drawCaseBottomCentered=1;
drawCaseTop=0;
drawCaseTopCentered=1;
renderLogo=0;
DrawVesaMount=1;

// pi B+ Board Dimensions
boardWidth=56;
boardLength=85;
boardThickness=1.33;

mountHoleDiameter=2.75;
mountHoleSideOffset=3.5;
mountHoleMidOffset=boardLength-mountHoleSideOffset-58;

usbWidth=13.28;
usbLength=17.05;
usbHeight=17.03-boardThickness;
usb1XIndent=29-(usbWidth/2);
usb2XIndent=47-(usbWidth/2);
usbOverHang=-2;

networkWidth=15.96;
networkLength=21.33;
networkHeight=15.00-boardThickness;
networkIndent=10.25-(networkWidth/2);		// 2.26
networkOverHang=-2.32;

avWidth=7.05;
avLength=14.90;
avHeight=7.38-boardThickness;
avRadius=avWidth/2;
avOverHang=-2.30;
avYset=boardLength-53.5+(avWidth/2);
avRotate=-90;

hdmiWidth=11.37;
hdmiLength=15.07;
hdmiHeight=7.86-boardThickness;
hdmiOverHang=-1.9;		//1.66
hdmiYset=boardLength-32-(hdmiWidth/2);
hdmiRotate=-90;

miniusbWidth=5.59;
miniusbLength=8.04;
miniusbHeight=4.22-boardThickness;
miniusbOverHang=-1.9;	// 1.09
miniusbYset=boardLength-10.6-(miniusbWidth/2);

gpioWidth=5.01;
gpioLength=50.27;
gpioHeight=10.2-boardThickness;
gpioYset=boardLength-29-mountHoleSideOffset-(gpioLength/2);
gpioXset=boardWidth-gpioWidth-1.05;

cpuWidth=13.42;
cpuLength=13.42;
cpuHeight=boardThickness * 1.5;
cpuYset=48.75;
cpuXset=(boardWidth/2)-(cpuWidth/2);

// Case Dimension
roundedRectRadius=4;
mountRiserHeight=7;
mountRiserScale=2;

// Case base
baseWidth=boardWidth;
baseLength=boardLength;
baseHeight=mountRiserHeight+boardThickness+miniusbHeight;
baseThickness=3;
microSDCutoutWidth=10;
microSDCutoutLength=10;
microSDCutoutHeight=20;

// Case top
topWidth=baseWidth;
topLength=baseLength;
topHeight=usbHeight;

// Locking lip around case edge
locklipWidth=2;
locklipHeight=2;

// Vesa mount
vesaMountArmLength=120;
vesaMountArmWidth=120;
vesaMountArmHeight=baseThickness;
vesaMountArmRadius=4;
vesaHoleSize=4;


baseAndLidSeperationFromZero = baseWidth + (baseWidth / 1.3);

// Special Vars
$fn=50;

// Make a rounded Rectangle.
module rounded_rect(x, y, z, radius) {
	echo("Draw Rounded Rectangle.");
	linear_extrude(height=z)
		minkowski() {
			square([x,y]);
			circle(r = radius);
		}
}

//
// pi B+
//
module pi_board(cutOutExtrude=0) {
	echo("Draw PI Board.");
	// Base board
	difference() {
		color("FireBrick", a=1.0) {
			cube([boardWidth, boardLength, boardThickness]);
		}
		// Mounting holes
		translate([mountHoleSideOffset, boardLength-mountHoleSideOffset, -5])
			cylinder(h=10, d=mountHoleDiameter);
		translate([boardWidth-mountHoleSideOffset, boardLength-mountHoleSideOffset, -5])
			cylinder(h=10, d=mountHoleDiameter);
		translate([mountHoleSideOffset, mountHoleMidOffset, -5])
			cylinder(h=10, d=mountHoleDiameter);
		translate([boardWidth-mountHoleSideOffset, mountHoleMidOffset, -5])
			cylinder(h=10, d=mountHoleDiameter);
	}
	
	color("Silver") {
	// USB
	translate([usb1XIndent,usbOverHang-cutOutExtrude,boardThickness])
		cube([usbWidth, usbLength, usbHeight]);
	translate([usb2XIndent,usbOverHang-cutOutExtrude,boardThickness])
		cube([usbWidth, usbLength, usbHeight]);

	// Network port
	translate([networkIndent,networkOverHang-cutOutExtrude,boardThickness])
		cube([networkWidth, networkLength-cutOutExtrude, networkHeight]);
	}

	// AV Plug
	translate([avOverHang-cutOutExtrude,avYset,boardThickness]) {
		rotate(a=[0,0,avRotate])
			cube([avWidth, avLength, avHeight]);
	}

	color("Silver") {
	// HDMI Plug
	translate([hdmiOverHang-cutOutExtrude,hdmiYset,boardThickness]) {
		cube([hdmiWidth, hdmiLength, hdmiHeight]);
	}

	// mini USB
	translate([miniusbOverHang-cutOutExtrude,miniusbYset,boardThickness]) {
		cube([miniusbWidth, miniusbLength, miniusbHeight]);
	}
	}

	// GPIO Headers
	color("black") {
	translate([gpioXset, gpioYset, boardThickness])
		cube([gpioWidth, gpioLength, gpioHeight]);

	// CPU
	translate([cpuXset, cpuYset, boardThickness])
		cube([cpuWidth, cpuLength, cpuHeight]);
	}
	
}

//
// Vesa Mount
//
module vesa_mount() {
	echo("Draw Vesa Mount");
	difference() {
		rounded_rect(vesaMountArmLength,vesaMountArmWidth,vesaMountArmHeight,vesaMountArmRadius);
		translate([10,10,-5])
			cylinder(h=20, r=vesaHoleSize);

		// Mount holes
		translate([10,110,-5])
			cylinder(h=20, r=vesaHoleSize);

		translate([110,10,-5])
			cylinder(h=20, r=vesaHoleSize);

		translate([110,110,-5])
			cylinder(h=20, r=vesaHoleSize);

		// Cosmetic cut outs
		translate([vesaMountArmWidth/2,-60/1.3,-5])
			cylinder(h=20, r=60);
			
		translate([-60/1.3,vesaMountArmLength/2,-5])
			cylinder(h=20, r=60);
	
		translate([(60/1.3)+vesaMountArmWidth,vesaMountArmLength/2,-5])
			cylinder(h=20, r=60);
			
		translate([vesaMountArmWidth/2,vesaMountArmLength+60/1.3,-5])
			cylinder(h=20, r=60);

	}
}


//
// Case Bottom
//
module case_bottom() {
	echo("Draw Case Bottom.");
	// Setup base rounded rectangles
	difference() {
		// Base object
		rounded_rect(baseWidth, baseLength, baseHeight, roundedRectRadius);
		// Cut out for case cavity
		translate([0,0,baseThickness])
			cube([boardWidth, boardLength, baseHeight*2]);
		// Locking lip
		translate([-locklipWidth,0,baseHeight-locklipHeight])
			cube([boardWidth+(locklipWidth*2), boardLength, 5]);
		// MicroSD card cutout
		if(drawMicroSDCutOut) {
			echo("Draw MicroSD cutout");
			translate([(baseWidth/2)-(microSDCutoutWidth/2), baseLength-5, -2])
				cube([microSDCutoutWidth, microSDCutoutLength, microSDCutoutHeight]);
		}
	}

	// Add in risers for board mount holes and cut out the screw holes.
	color("LimeGreen") {
		difference() {
			// riser pole
			translate([mountHoleSideOffset, boardLength-mountHoleSideOffset, 0])
				cylinder(h=mountRiserHeight, d=mountHoleDiameter*mountRiserScale);
			// screw hole
			translate([mountHoleSideOffset, boardLength-mountHoleSideOffset, mountRiserHeight/2])
				cylinder(h=10, d=mountHoleDiameter);
		}
		//rinse and repeat ...
		difference() {
			translate([boardWidth-mountHoleSideOffset, boardLength-mountHoleSideOffset, 0])
				cylinder(h=mountRiserHeight, d=mountHoleDiameter*mountRiserScale);
			translate([boardWidth-mountHoleSideOffset, boardLength-mountHoleSideOffset, mountRiserHeight/2])
				cylinder(h=10, d=mountHoleDiameter);
		}
	
		difference() {
			translate([mountHoleSideOffset, mountHoleMidOffset, 0])
				cylinder(h=mountRiserHeight, d=mountHoleDiameter*mountRiserScale);
			translate([mountHoleSideOffset, mountHoleMidOffset, mountRiserHeight/2])
				cylinder(h=10, d=mountHoleDiameter);
		}
	
		difference() {
			translate([boardWidth-mountHoleSideOffset, mountHoleMidOffset, 0])
				cylinder(h=mountRiserHeight, d=mountHoleDiameter*mountRiserScale);		
			translate([boardWidth-mountHoleSideOffset, mountHoleMidOffset, mountRiserHeight/2])
				cylinder(h=10, d=mountHoleDiameter);
		}
	}
}

//
// Case Top
//
module case_top() {
	echo("Draw Case Top.");
	difference() {
		difference() {
			// Base object
			rounded_rect(topWidth, topLength, topHeight, roundedRectRadius);
			// Cut out
			translate([0,0,-baseThickness]) {
				cube([boardWidth, boardLength, topHeight]);
			}
		}
		if(renderLogo) {
			translate([2,2,10])
				resize([topWidth-10, topLength-10, 10])
					linear_extrude(height=10)
						import("raspberrypi_logo.dxf");
		}
	}
	// Lock lip extensions
	translate([-locklipWidth,0,-locklipHeight]) {
		cube([locklipWidth, boardLength, locklipHeight]);
	}
	translate([topWidth,0,-locklipHeight]) {
		cube([locklipWidth, boardLength, locklipHeight]);
		}

}

// Draw PI Board
if(drawBoard) {
	if(drawBoardCentered) {
		echo("Draw PI Board Centered.");
		translate([0,0,mountRiserHeight])
			pi_board();
	} else {
		echo("Draw PI Board Offset.");
		translate([-boardWidth*2,0,0])
			pi_board();
	}
}

// Draw Vesa Mount
if(DrawVesaMount) {
	if(drawCaseBottom) {
		translate([-(vesaMountArmWidth/2)+(baseWidth/2),-(vesaMountArmLength/2)+(baseLength/2),0])
		vesa_mount();
	} else {
		vesa_mount();
	}
}

// Draw Case Bottom
if(drawCaseBottom) {
	if(drawCaseBottomCentered) {
		echo("Draw Case Bottom Centered.");
		difference() {
			case_bottom();
			translate([0,0,mountRiserHeight])
				pi_board(2.5);
		}
	} else {
		echo("Draw Case Bottom Offset.");
		difference() {
			case_bottom();
			translate([0,0,mountRiserHeight])
				pi_board(2.5);
		}
	}
}

//
// Draw Case Top
//
if(drawCaseTop) {
	if(drawCaseTopCentered) {
		echo("Draw Case Top Centered.");
		difference() {
			translate([0,0,baseHeight])
				case_top();
			translate([0,0,mountRiserHeight])
				pi_board(2.5);
		}
	} else {
		echo("Draw Case Top Offset.");
		translate([baseAndLidSeperationFromZero*1.5,0,topHeight])
			rotate([0,180,0])
				difference() {
					translate([0,0,0])
						case_top();
					translate([0,0,-(baseHeight-mountRiserHeight)])
					pi_board(2.5);
				}
	}
}