######################################################################
# This file contains procedures build full membrane structures
# This file relies upon the procedurs in PlacePoints.tcl, GeneralTools.tcl
#
# Membranes - Planar Bilayers, Spheres, Micelles, Curves 
# (see PlacePoints.tcl for more info)
######################################################################

#source PlacePoints.tcl
source PlacePoints-changedAPL-0.9.tcl

######################################################################
# Geometry 1: plane
######################################################################

proc makeBilayer { lipids x y outName } {
	
	package require psfgen
	resetpsf

	readLip $lipids; #Reads in lipids requested
	set apl [AreaPerLipid $lipids]; #look up experimental value of Area Per Lipid
	set width [minMax]

	set spacing [expr {sqrt($apl)}]; # spacing between phosphates in bilayer
	
	placePointsRect $lipids $width $x $y $spacing T; 
	placePointsRect $lipids $width $x $y $spacing B;
	
	writepsf $outName.psf
	writepdb $outName.pdb

	file delete temp.pdb
	mol delete all


}

######################################################################
# Geometry 2: Sphere
######################################################################

proc makeVesicle {lipidsI lipidsO outerRadius outName} {
	global M_PI

	set OuterLayer T
	set InnerLayer B

	package require psfgen
	resetpsf
	
	# now, read in the outer lipid composition	
		
	readLip $lipidsO;
	set aplO [AreaPerLipid $lipidsO]
	set widthO [minMax]
	set spacingO [expr {sqrt($aplO)/$M_PI}]
	
	set outerNumPoints [expr {ceil((4*$M_PI*abs($outerRadius*$outerRadius))/$aplO)}]
	
	set realNumPoints 2
		
	set n [expr {ceil(abs($outerRadius/$spacingO))}]
	for {set i 1} {$i < $n} {incr i} {
	
		set theta [expr {($i * $M_PI)/($n)}]
		set space [expr {2*round(($n) * sin($theta))}]
		
		for {set j 1} {$j <= $space} {incr j} {
			incr realNumPoints
		}
	}
	
	placePointsSphere $lipidsO $outerRadius $spacingO $OuterLayer 0 0 $realNumPoints
	mol delete all
	
	# now, read in the inner lipid composition

	readLip $lipidsI; #Reads in lipids requested
	set aplI [AreaPerLipid $lipidsI]
	
	set widthI [minMax]
	
	set width [expr {($widthI + $widthO)/2}]; # width is average of inner and outer
	
	# Calculates the sphere which lipids are placed on
	
	set innerRadius [expr {-1*($outerRadius - ((2*$width)+1))}]; # 1 is arbitrary spacer between layers
	set aplI [expr {$aplI*(($innerRadius/($outerRadius - 40.0))*($innerRadius/($outerRadius - 40.0)))}]
	
	set spacingI [expr {sqrt($aplI)/$M_PI}];
	
	set innerNumPoints [expr {ceil((4*$M_PI*abs($innerRadius*$innerRadius))/$aplI)}];
	
	set realNumPoints 2
		
	set n [expr {ceil(abs($innerRadius/$spacingI))}]
	for {set i 1} {$i < $n} {incr i} {
	
		set theta [expr {($i * $M_PI)/($n)}]
		set space [expr {2*round(($n) * sin($theta))}]
		
		for {set j 1} {$j <= $space} {incr j} {
			incr realNumPoints
		}
	}
	
	
	placePointsSphere $lipidsI $innerRadius $spacingI $InnerLayer 0 0 $realNumPoints;
	
	if {1} {
		
		readpsf Vesicle$OuterLayer.psf
		coordpdb Vesicle$OuterLayer.pdb
		readpsf Vesicle$InnerLayer.psf
		coordpdb Vesicle$InnerLayer.pdb
		
		writepsf $outName.psf
		writepdb $outName.pdb
		
		file delete Vesicle$OuterLayer.pdb Vesicle$OuterLayer.psf
		file delete Vesicle$InnerLayer.pdb Vesicle$InnerLayer.psf
	}
	
	puts $aplI
	
	mol delete all
	
}

proc makeMicelle {lipids outName} {
	global M_PI

	package require psfgen
	resetpsf

	readLip $lipids; #Reads in lipids requested
	set apl [AreaPerLipid $lipids]
	set width [minMax]

	set radius [expr {$width + 5}]; # 5 is an arbitrary number to ensure the lipids tails do not all meet at the center of the sphere
	
	set numPoints [expr {ceil((4*$M_PI*abs($radius*$radius))/$apl)}]
	set thetaSpacing [expr {ceil($radius/sqrt(($M_PI*$numPoints)/4))}]
	
	placePointsSphere $lipids $radius $thetaSpacing T 0 0
	
	writepsf $outName.psf
	writepdb $outName.pdb
	
	file delete temp.pdb
	mol delete all
}

######################################################################
# Geometry 3: Curves
######################################################################

proc makeCurve {lipids radius width box numSmooth outName} {
	resetpsf
	global M_PI

	readLip $lipids
	set apl [AreaPerLipid $lipids]
	#set liplength [minMax]

	set liplength 38.0

	set spacing [expr {sqrt($apl)/$M_PI}]

	placePointsCurve $lipids $radius $spacing $width 0 0 U $box $numSmooth
	placePointsCurve $lipids $radius $spacing $width $liplength 1 D $box $numSmooth

	writepsf $outName.psf
	writepdb $outName.pdb

	makeBox [expr {double($box/2)}] $outName

	writepsf $outName.psf
	writepdb $outName.pdb

	file delete temp.pdb
	mol delete all
} 
