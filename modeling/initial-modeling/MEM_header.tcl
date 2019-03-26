proc memstruc { args } {

source MakeGeometries.tcl
topology top_all36_lipid.inp

	# Check to make sure the right number of arguments are given
	set nargs [llength $args]
	if {$nargs == 0} {
		error "Y U NO USE ARGUMENTS?!"
	}
	if {$nargs % 2} {
		error "Y U NO USE RIGHT NUMBER OF ARGUMENTS?!"
	}
	
	foreach {name val} $args {
		switch -- $name {
			-s { set arg(structure) $val }
			-l { set arg(lipidComp) $val }
			-r { set arg(r) $val }
			-x { set arg(x) $val }
			-y { set arg(y) $val }
			-w { set arg(w) $val }
			-b { set arg(b) $val }
			-smooth { set arg(smooth) $val }
			-o { set arg(o) $val }
			default { error "unknown argument: $name $val" }
		}
	}

	#Checks to make sure both radius and (x,y)-dimensions are not given
	if [info exists arg(r)] {
		if {[info exists arg(x)] || [info exists arg(y)]} {
			error "Options -r and -x,-y are mutually exclusive. Do we need a referesher on cartesian vs. polar coordinates?"
		}
	}
	
	#Checks number of lipids. If only one lipid is specified, sets composition to 1.0. Otherwise, makes sure the number of lipids and composition terms is the same.
	if {[llength $arg(lipidComp)] == 1} {
		lappend arg(lipidComp) 1.0
	} elseif {[llength $arg(lipidComp)] > 1 && [llength $arg(lipidComp)] % 2} {
		error "Mismatched number of lipid and composition arguments. Counting by twos not a strong suit?"
	}
	
	#Checks to make sure composition arguments add to 1.00
	set numLips [llength $arg(lipidComp)]
	set totalcomp 0
	for {set i 1} {$i <= $numLips} {incr i 2} {
		set comp [lindex $arg(lipidComp) $i]
		set totalcomp [expr {$totalcomp + $comp}]
	}
	set totalcomp [format "%3.2f" $totalcomp]; # Some sums give 0.9999999... in tcl when they should be 1.00; this makes sure the script doesn't fail
	if {$totalcomp !=1.0} {
		error "Composition of membrane structure does not add to 1.0! Trouble with fractions, huh?"
	}

	#Checks to make sure if "-structure micelle", no radius is specified 
	if {[string match -nocase micelle $arg(structure)] && [info exists arg(r)] != 0} {
		puts "Micelle radius determined types of lipids! Building micelle based on $arg(lipidComp)"
	}

	#Checks to make sure radius is specified for "-structure vesicle"
	if {[string match -nocase vesicle $arg(structure)] && [info exists arg(r)] == 0} {
		error "No radius is specified for vesicle! Unless you want lipids in the shape of an Imperial II-class Star Destroyer, you should specify a radius."
	}

	#Sets the output filename to "$arg(structure)" if no output is specified
	if {[info exists arg(o)] == 0} {
		set arg(o) "$arg(structure)"
	}

	switch $arg(structure) {
		vesicle { puts "Building Vesicle..."; makeVesicle $arg(lipidComp) $arg(r) $arg(o)}
		micelle { puts "Building Micelle..."; makeMicelle $arg(lipidComp) $arg(o)}
		bilayer { puts "Building Bilayer..."; makeBilayer $arg(lipidComp) $arg(x) $arg(y) $arg(o)}
		curve   { puts "Building Curved Patch..."; makeCurve $arg(lipidComp) $arg(r) $arg(w) $arg(b) $arg(smooth) $arg(o)}
	
	}
}
