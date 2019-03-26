######################################################################
#  This file contains general procedures used in the construction    
#  of membrane geometries.                                           
#                                                                     
#  Currently, there are 4 categories of procedures:
#  1. Psfgen 
#  2. Lipid Information
#  3. Lipid Processing (VMD)
#  4. Arbitrary Curves
#
#  Psfgen: interacts with the psfgen package of vmd to create a pdb
#  and psf file of the final structure
#		procedures:
#			1. chainName - generates a segname (order A,B,C,... AA,AB,
#			   ...
#      			2. makeSeg - makes a segment using psfgen
#
#  Lipid Information: Reads the current lipid types and returns info.
#		procedures:
#			1. AreaPerLipid - returns the max APL of the lipid types
#			2. minMax - returns the max length of the lipid types
#
#  Lipid Processing (VMD): Manipulates lipid (from pdb files) to 
#  build the desired geometry
#		procedures:
#			1. readLip - reads in the desired lipid types
#			2. placeLip - place lipid in desired configuration
#			3. pickType - randomly picks a lipid type 
#
#  Arbitrary Curves: Specifically used with making local curves
#		procedures:
#			1. makeLoop - places lipid in a circle
#			2. makeBox - trucates a membrane to fit into a box
#			3. smoothCurve - places lipids by decreasing gradient
#			4. findStep - placing lipids by equal arclength
######################################################################

######################################################################
# Category 1: Psfgen
######################################################################

proc chainName { numChain } {

    # template names
    set listTemplate "A B C D E F G H I J K L M N O P Q R S T U V W X Y Z";
    set lengthTemplate 26;
    
    #
    set temp [ expr $numChain%26 ];
    set chainName [ lindex $listTemplate $temp ];
    
    if {$numChain > 25} {
    
    	set prefixIndex [ expr {(($numChain-26)/26) % 26}];
    	set prefix [ lindex $listTemplate $prefixIndex ];
    } else {
	set prefix {}
    }

    if {$numChain > 701} { 

	set temp2 [expr {$numChain - 26}]
   	set altPrefixIndex [ expr {(($temp2-676)/676) % 26} ];
    	set altPrefix [ lindex $listTemplate $altPrefixIndex ];
    } else {
	set altPrefix {}
    }

    if {$numChain > 18277} {

	set temp3 [expr {$numChain - 702}]
    	set altaltPrefixIndex [expr {(($temp3-17576)/17576) % 26}];
    	set altaltPrefix [lindex $listTemplate $altaltPrefixIndex];
    } else {
	set altaltPrefix {}
    }

    return "$altaltPrefix$altPrefix$prefix$chainName" 
    #return "$chainName$prefix$altPrefix$altaltPrefix"

}

proc makeSeg {segname number} {

	if {$number == 0} {
		set limit 10
	} else {
		set limit $number
	}

	segment $segname {
		first none; puts ""
		last none; puts ""
		
		for {set i 0} {$i < $limit} {incr i} {
			pdb temp$i.pdb; puts ""
		}
	}
	
	for {set j 0} {$j < $limit} {incr j} {
		coordpdb temp$j.pdb $segname; puts ""
	}
	
	guesscoord; puts ""
}

######################################################################
# Category 2: Lipid Information 
######################################################################

proc AreaPerLipid {lipids} {
		
#calculate weighted average of lipid types

	set apl 0
	set len [llength $lipids]
	for {set i 0} {$i < $len} {set i [expr {$i + 2}]} {
		set name [lindex $lipids $i]
		set perc [lindex $lipids [expr {$i + 1}]]

		switch $name {
		
			POPE { set apl [expr {(63.0*$perc) + $apl}] }
			POPC { set apl [expr {(68.3*$perc) + $apl}] }
			POPS { set apl [expr {(62.0*$perc) + $apl}] }
			POPG { set apl [expr {(62.0*$perc) + $apl}] }
		}
	}
	return $apl
}

proc minMax {} {

	set id [molinfo list]
	set memWidth 0	
	
	# return maximum membrane width for all lipids
	foreach S $id {	
		set lipid [atomselect $S all]
		set pPos [atomselect $S "name P"]
		set minmax [measure minmax $lipid]
		set min [lindex $minmax 0]
		set max [lindex [$pPos get {x y z}] 0]
		set minMaxDif [vecsub $max $min]
		set lipidLength [expr {abs([lindex $minMaxDif 2])}]
		if {$lipidLength > $memWidth} {
			set memWidth $lipidLength
		}
	}
	
	return $memWidth
}

######################################################################
# Category 3: Lipid Processing (VMD)
######################################################################

proc readLip {lipids} {
	mol delete all
	set len [llength $lipids]
	for {set i 0} {$i < $len} {set i [expr {$i + 2}]} {
		set name [lindex $lipids $i]
		mol new $name.pdb
		set all [atomselect top all]
		$all moveby [vecinvert [measure center $all]]
		
		$all delete
	}

}

proc placeLip {theta phi x number} {
	global M_PI
	
	#set angle0 [expr {720*(rand() - 0.5)}]; #rotates aligned molecule around the z-axis (0,360]. Introduces randomness in molecules rotational oreintation.	
	set angle0 0
	
	set angle1 [expr {360*($theta/(2*$M_PI))}]
	set angle2 [expr {360*($phi/(2*$M_PI))}]
	
	set all [atomselect top all]

	$all move [transaxis z $angle0]	
	$all move [transaxis y $angle1]
	$all move [transaxis z $angle2]
	
	set sel [atomselect top "name P"]
	set A [measure center $sel]
	set diff [vecsub $x $A]
	$all moveby $diff
	

	#set sel [atomselect top "name P"]
	#set A [measure center $sel]	
	#set d [expr {abs([lindex $A 2])}]
	#set magX [veclength $x]
	#set newRad [expr $magX - $d]
	#set newX "[expr {$newRad*sin($theta)*cos($phi)}] [expr {$newRad*sin($theta)*sin($phi)}] [expr {$newRad*cos($theta)}]"
	#set diff [vecsub $x $A]
	#$all moveby $newX
	
	$all set resid [expr {(2*$number) + 1}]
	
	$all writepdb temp$number.pdb

	$all moveby [vecinvert [measure center $all]]
	$all move [transaxis z [expr {-1*$angle2}]]
	$all move [transaxis y [expr {-1*$angle1}]]

	$sel delete
	$all delete
}

proc pickType {lipids total} {
	set len [llength $lipids]
	set num [expr {rand()}]
	
	set id [molinfo list]
	set perc 0.0
	set counter 0
	for {set i 1} {$i < $len} {set i [expr {$i + 2}]} {
		set perc [expr {[lindex $lipids $i]+ $perc}]
		if {$num <= $perc} {
			mol top [lindex $id $counter]
			
			if {$total != 1} {
				set lipids [lreplace $lipids $i $i [expr {([lindex $lipids $i] - (1/$total))*($total/($total-1))}]]
			
				for {set j [expr {$i + 2}]} {$j < $len} {set j [expr {$j + 2}]} {
					set lipids [lreplace $lipids $j $j [expr {[lindex $lipids $j]*($total/($total-1))}]]	
				}
			}	
			
			return $lipids
		} else {
		
			if {$total != 1} {
		
			set lipids [lreplace $lipids $i $i [expr {[lindex $lipids $i]*($total/($total-1))}]]
			
			}
		}
		incr counter
	}
}

######################################################################
# Category 4: Arbitrary Curves
######################################################################

proc makeLoop {lipids radius size theta z counter disp layer name} {
	global M_PI
	set temp $counter
	for {set j 1} {$j <= $size} {incr j} {
		set ang [expr {($j-1)*2*$M_PI/$size}]
		set x [expr {$radius*cos($ang)}]
		set y [expr {$radius*sin($ang)}]

		set angle1 [expr {$theta + ($layer*$M_PI)}]
		pickType $lipids
		placeLip $angle1 $ang "$x $y [expr {$z-$disp}]"
		set segname [chainName $temp]
		makeSeg $name$segname
		incr temp
	}
	return [expr {$temp - $counter}]
}

proc makeBox {size name} {
	set xhigh [lindex $size 0]
	set yhigh [lindex $size 0]

	set xlow [expr {-1*[lindex $size 0]}]
	set ylow [expr {-1*[lindex $size 0]}]
	
	mol delete all
	mol new $name.pdb

	set sel [atomselect top "name P and ((x > $xhigh) or (x < $xlow) or (y > $yhigh) or (y < $ylow))"]
	set seglist [$sel get segid]
	set reslist [$sel get resid]

	mol delete all

	resetpsf
	readpsf $name.psf
	coordpdb $name.pdb

	foreach segid $seglist resid $reslist {
		delatom $segid $resid
	}
}

proc smoothCurve {lipids radius tolerance theta counter disp layer name box numSmooth} {
	global M_PI
	set x [expr {$radius*sin($theta)}]
	set z [expr {$radius*cos($theta)}]
		
	set add [makeLoop $lipids $x [expr {2*round(abs($x/$tolerance))}] $theta $z $counter $disp $layer $name]
	set counter [expr {$counter + $add}]	

	set der [expr {tan($theta)}]
	set step [findStep $der $tolerance]

	set i 1

	set limit [expr {(2*$box)/sqrt(2)}]
		while {$x < $limit} {
				
			set x [expr {$x + $step}]
			set z [expr {$z - ($der*$step)}]
				
			set add [makeLoop $lipids $x [expr {2*round($x/$tolerance)}] $theta $z $counter $disp $layer $name]
			set counter [expr {$counter + $add}]				
			
			if {$i < $numSmooth} {
				set der [expr {$der - ($i*$der/$numSmooth)}]
				set theta [expr {1*atan($der)}]
			} else {
				set der 0
				set theta 0
			}
			incr i
		}

}

proc findStep {der tolerance} {
	global M_PI
	set temp [expr {sqrt(1 + ($der**2))}]	
	set step [expr {($M_PI*$tolerance)/$temp}]
	return $step
}
