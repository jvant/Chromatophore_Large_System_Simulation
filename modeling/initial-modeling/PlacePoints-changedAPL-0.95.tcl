######################################################################
# This file contains procedures to place lipids in several 
# different geometries, including planes, spheres, and curves
# with well-defined local curvature
#
# The procedures rely upon the file GeneralTools.tcl
# The geometries are arranged as:
#		1. plane
#		2. sphere
#		3. curve
######################################################################

#source GeneralTools.tcl
source GeneralTools-changedAPL-0.95.tcl

######################################################################
# Geometry 1: plane
######################################################################

proc placePointsRect { lipids width xMax yMax spacing layer } {

# lipids - list of lipid types and percentages like {POPE 1.0 POPC 0.75}
# phosphate to phosphate distance (z direction)
# xMax - length in x direction
# yMax - length in y direction
# spacing - phosphate to phosphate distance (x-y plane)
# layer - determines segname (ex. T** are names in top layer, B** are names in bottom layer)

			
	global M_PI	
	# Switches the direction of the lipid based on whether it is in the top or bottom layer
	if [string match T $layer] { 
		set zCoeff "1"; # zCoeff determines whether segment points up or down (1 = +z, -1 = -z)
		set theta "0"
	} else {
		set zCoeff "-1"
		set theta "$M_PI"
	}	
	
	set z [expr {$zCoeff * (0.7*($width + 0.5))}]; # 0.7, 0.5 are arbitrary to get reasonable lipid width
	set x 0
	set y 0
	set counter 0
	
	while {$x < $xMax} {
		while {$y < $yMax} {
			set segname [chainName $counter]
			pickType $lipids
			placeLip $theta 0.0 "$x $y $z"
			makeSeg $layer$segname
			
			set y [expr {$y + $spacing}]
			incr counter
		}

		set x [expr {$x + $spacing}]
		set y 0
	}
}

######################################################################
# Geometry 2: sphere
######################################################################

proc placePointsSphere {lipids radius tolerance layer start finish totalPoints} {

# lipids - see above
# radius - outer radius (to phosphates) of vesicle
# tolerance - arclength between phosphates on vesicle
# layer - designates segname (see above)
# start, finish - select arbitrary starting and ending point for solid angle


# changed to be able to make a small hole through both layers

	global M_PI	
	
	set numLipsInSegment 10

	# place lipids on the poles	
	set A [chainName 0]
	set B [chainName 1]
		
	set tot $totalPoints
	set tot [expr {$tot*1.0}]
		
	set lipids [pickType $lipids $tot]
	set tot [expr {$tot - 1}]
	placeLip $M_PI 0 "0.0 0.0 [expr {-1*$radius}]" 0	
	# makeSeg $layer$B

	set lipids [pickType $lipids $tot]
	set tot [expr {$tot - 1}]
	placeLip 0 0 "0.0 0.0 $radius" 1	
	# makeSeg $layer$A 
	

	set counter 2
	set chainCounter 0
	set pdbCounter 0
	
	set n [expr {ceil(abs($radius/$tolerance))}]
	for {set i [expr {1 + $start}] } {$i < [expr {$n- $finish}]} {incr i} {
				
	
		set theta [expr {($i * $M_PI)/($n)}]
		set space [expr {2*round(($n) * sin($theta))}]
		
		for {set j 1} {$j <= $space} {incr j} {
		
			if {[expr {$counter % $numLipsInSegment}] == 0} {
				set segname [chainName $chainCounter]
				makeSeg $layer$segname $numLipsInSegment
				incr chainCounter
			}
			
			if {[expr {$counter % 1500 == 0}]} {
				writepdb Sys$pdbCounter.pdb
				writepsf Sys$pdbCounter.psf
				resetpsf
				incr pdbCounter
			}
			
			set phi [expr {((($j - 1) * 2 * $M_PI)/($space))}]
			set angle1 $theta
			set angle2 $phi
			
			#set angle1 [expr {(2*(rand() - 0.5)*($M_PI/90) + $theta)}]; #Adds a random phase shift to the theta spacing of grid points centered around grid points.
			#set angle2 [expr {(2*(rand() - 0.5)*($M_PI/90) + $phi)}]; #Adds a random phase shift to the phi spacing of grid points centered around grid points

			set x [expr {$radius*sin($angle1)*cos($angle2)}]
			set y [expr {$radius*sin($angle1)*sin($angle2)}]
			set z [expr {$radius*cos($angle1)}]

			# set segname [chainName $counter]
			
			set lipids [pickType $lipids $tot]
			set tot [expr {$tot - 1}]
			placeLip $theta $phi "$x $y $z" [expr {$counter % $numLipsInSegment}]

			incr counter
		}
	}
	
	if {1} {
		set segname [chainName $chainCounter]
		makeSeg $layer$segname [expr {$counter % $numLipsInSegment}]
		
		writepdb Sys$pdbCounter.pdb
		writepsf Sys$pdbCounter.psf
		resetpsf
		incr pdbCounter
	}
	
	for {set i 0} {$i < $pdbCounter} {incr i} {
		readpsf Sys$i.psf
		coordpdb Sys$i.pdb
		file delete Sys$i.pdb Sys$i.psf
	}
	
	for {set i 0} {$i < $numLipsInSegment} {incr i} {
		file delete temp$i.pdb
	}
		
	writepsf Vesicle$layer.psf
	writepdb Vesicle$layer.pdb
	
	resetpsf
	
	
}

######################################################################
# Geometry 3: Curves
######################################################################

proc placePointsCurve {lipids radius tolerance width disp layer name box numSmooth} {
	
# Revise at a later date


	global M_PI
	
	set A [chainName 0]

	pickType $lipids
	placeLip [expr {0.0 + ($layer*$M_PI)}] 0 "0.0 0.0 [expr {$radius-$disp}]"	
	makeSeg $name$A 

	set limit [expr {asin($width/(2*$radius))}]

	set counter 1
	set n [expr {ceil(abs($radius/$tolerance))}]

	for {set i 1} {$i < $n} {incr i} {
	
		set theta [expr {($i * $M_PI)/($n)}]
		if {$theta > $limit} { 

			smoothCurve $lipids $radius $tolerance $theta $counter $disp $layer $name [expr {double($box/2)}] $numSmooth
			break	
		}
		set space [expr {round(($n) * sin($theta))}]
		set space [expr {$space * 2}]

		for {set j 1} {$j <= $space} {incr j} {
			
			
			set phi [expr {((($j - 1) * $M_PI)/($space/2))}]
 			
			set angle1 [expr {$theta + ($layer*$M_PI)}]
			set angle2 $phi
			
			set x [expr {$radius*sin($theta)*cos($angle2)}]
			set y [expr {$radius*sin($theta)*sin($angle2)}]
			set z [expr {$radius*cos($theta)}]

			set segname [chainName $counter]
			
			pickType $lipids
			placeLip $angle1 $phi "$x $y [expr {$z-$disp}]"
			makeSeg $name$segname
			incr counter
		}
	}
	
}
