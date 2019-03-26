package require Tk
#package require Img
source MEM_header.tcl

# make new toplevel window
set w [toplevel ".membrane"]

# setup root and give title
wm title $w "Membrane Structure Builder"

# disable resize capabilities
wm resizable $w 0 0

# make a notebook
grid [ttk::notebook $w.n] -column 0 -row 0

# create three paned windows for sections of notebook
grid [ttk::panedwindow $w.n.f1 -orient vertical] -column 0 -row 0 -sticky nwes
grid [ttk::panedwindow $w.n.f2 -orient vertical] -column 0 -row 0 -sticky nwes 
grid [ttk::panedwindow $w.n.f3 -orient vertical] -column 0 -row 0 -sticky nwes 

# add frames to first paned window
$w.n add $w.n.f2 -text "Membrane Geometry"
$w.n add $w.n.f1 -text "Lipid Composition"
$w.n add $w.n.f3 -text "Summary"

############################################################################################
# Lipid Composition Window
############################################################################################

set l $w.n.f1; # clean up paths

############################################################################################
# Pick Lipid Type Section
############################################################################################

ttk::labelframe $l.a -text "Pick Lipid Type"
$l add $l.a

# make a treeview
grid [ttk::treeview $l.a.tree -height 5] -column 0 -row 0 -padx 15 -pady 15 



#grid [ttk::scrollbar $l.a.s -orient vertical -command "$l.a.tree yview"] -column 1 -row 0
#$l.a.tree configure -yscrollcommand "$l.a.s set"

$l.a.tree column "#0" -width 120 -minwidth 120

# make three columns and configure text headings
$l.a.tree configure -columns "number APL length"

$l.a.tree heading number -text "Number of Atoms"
$l.a.tree column number -width 120 -minwidth 50 -anchor center

$l.a.tree heading APL -text "Area Per Lipid"
$l.a.tree column APL -width 100 -minwidth 50 -anchor center

$l.a.tree heading length -text "Length"
$l.a.tree column length -width 100 -minwidth 50 -anchor center

# make main type of lipids in tree
$l.a.tree insert {} end -id PL -text "Phospholipids"

# add subtype of PL (specific lipid names)
$l.a.tree insert PL end -id POPC -text "POPC" -values [list "x" "x" "x"] 
$l.a.tree insert PL end -id POPE -text "POPE" -values [list "x" "x" "x"]
$l.a.tree insert PL end -id POPS -text "POPS" -values [list "x" "x" "x"]

# bind a click on the possible types to populate a name category
bind $l.a.tree <<TreeviewSelect>> {
	if {[$l.a.tree item [$l.a.tree selection] -text] == "Phospholipids" } {
		set ::name ""
	} else {
		set ::name [$l.a.tree item [$l.a.tree selection] -text]
	}
}

############################################################################################
# Specify Percent Composition Section
############################################################################################

ttk::labelframe $l.b -text "Specify Percent and Location"
$l add $l.b

grid [ttk::label $l.b.lipN -text "Lipid Name" -padding 3] -column 0 -row 0 -padx {15 5} -pady {15 5}
grid [ttk::entry $l.b.lipName -textvariable name -width 5 -state readonly] -column 0 -row 1 -pady {0 15}
set ::name ""

grid [ttk::label $l.b.lipP -text "Percent Composition" -padding 3] -column 1 -row 0 -padx {15 5} -pady {15 5}
grid [ttk::entry $l.b.lipPerc -textvariable percent -width 5] -column 1 -row 1 -pady {0 15}
set ::percent ""

grid [ttk::label $l.b.lipL -text "Layer" -padding 3] -column 2 -row 0 -padx {15 5} -pady {15 5}
grid [ttk::combobox $l.b.lipLay -textvariable lipidLay -state readonly -width 5] -column 2 -row 1 -pady {0 15} -padx {15 0}
$l.b.lipLay configure -values [list Inner Outer Both]
set ::lipidLay ""

grid [ttk::button $l.b.makeSel -text "Make Selection" -command addLip] -column 4 -row 2 -pady {10 15} -padx {5 15} -sticky e

proc addLip {} {
	if {[catch {
	
		if {$::name != "" && $::percent != "" && $::lipidLay != ""} {
	
			if {$::lipidLay == "Inner"} {
				.membrane.n.f1.c.tree1 insert {} end -text "$::name\t$::percent"
			} elseif {$::lipidLay == "Outer"} {
				.membrane.n.f1.c.tree2 insert {} end -text "$::name\t$::percent"
			} else {
				.membrane.n.f1.c.tree1 insert {} end -text "$::name\t$::percent"
				.membrane.n.f1.c.tree2 insert {} end -text "$::name\t$::percent"
			}
		}
	}]!=0} {
		puts "Something went wrong"
	}
}

############################################################################################
# Composition Summary Section
############################################################################################

ttk::labelframe $l.c -text "Composition Summary"
$l add $l.c

grid [ttk::treeview $l.c.tree1 -height 5] -column 0 -row 0 -padx 15 -pady 15
grid [ttk::treeview $l.c.tree2 -height 5] -column 1 -row 0 -padx 5 -pady 15

$l.c.tree1 heading "#0" -text "Inner Layer"
$l.c.tree2 heading "#0" -text "Outer Layer"

$l.c.tree1 column "#0" -width 150 -anchor w
$l.c.tree2 column "#0" -width 150 -anchor w

bind $l.c.tree1 <<TreeviewSelect>> {

	if {[$l.c.tree2 selection] != ""} {
		$l.c.tree2 selection remove [$l.c.tree2 selection]
	}
	
}

bind $l.c.tree2 <<TreeviewSelect>> {

	if {[$l.c.tree1 selection] != ""} {
		$l.c.tree1 selection remove [$l.c.tree1 selection]
	}

}

grid [ttk::button $l.c.delL -text "Delete Selection" -command delLip] -column 0 -row 1 -columnspan 2 -pady {0 15}
grid [ttk::button $l.c.finalSel -text "Final Selection" -command finalLip] -column 3 -row 1 -pady {0 15}

proc delLip {} {
	if {[catch {
		if {[.membrane.n.f1.c.tree1 selection] != ""} {
			.membrane.n.f1.c.tree1 delete [.membrane.n.f1.c.tree1 selection]
		} elseif {[.membrane.n.f1.c.tree2 selection] != ""} {
			.membrane.n.f1.c.tree2 delete [.membrane.n.f1.c.tree2 selection]
		}
	}]!=0} {
		puts "Something went wrong"
	}

}

proc finalLip {} {
	if {[catch {
	
		foreach S [.membrane.n.f3.a.tree1 children {}] {
			.membrane.n.f3.a.tree1 delete $S
		}
		
		foreach S [.membrane.n.f3.a.tree2 children {}] {
			.membrane.n.f3.a.tree2 delete $S
		}
		
	
		foreach S [.membrane.n.f1.c.tree1 children {}] {
			.membrane.n.f3.a.tree1 insert {} end -text [.membrane.n.f1.c.tree1 item $S -text]
		}
		
		foreach S [.membrane.n.f1.c.tree2 children {}] {
			.membrane.n.f3.a.tree2 insert {} end -text [.membrane.n.f1.c.tree2 item $S -text]
		}

	}]!=0} {
		puts "Something went wrong"
	}

}

############################################################################################
# Membrane Geometry Window
############################################################################################

set k .membrane.n.f2

############################################################################################
# Pick Membrane Geometry Section
############################################################################################

ttk::labelframe $k.a -text "Pick Membrane Geometry"
$k add $k.a


grid [ttk::radiobutton $k.a.bilayer -text "Bilayer" -variable geometry -value bilayer -command entBil] -column 0 -row 0 -padx {15 0} -pady {15 0}
grid [ttk::radiobutton $k.a.vesicle -text "Vesicle" -variable geometry -value vesicle -command entVes] -column 1 -row 0 -pady {15 0}
grid [ttk::radiobutton $k.a.micelle -text "Micelle" -variable geometry -value micelle -command entMic] -column 2 -row 0 -pady {15 0}

# configure options for picking x length of bilayer
grid [ttk::label $k.a.xD -text "X-Length:" -padding 3] -column 2 -row 2 -pady {20 5} -sticky e
grid [ttk::entry $k.a.xDim -textvariable xLength -width 5 -state disabled] -column 3 -row 2 -pady {20 5} -sticky w
set ::xLength ""

# configure options for picking y length of bilayer
grid [ttk::label $k.a.yD -text "Y-Length:" -padding 3] -column 2 -row 3 -pady {0 5} -sticky e
grid [ttk::entry $k.a.yDim -textvariable yLength -width 5 -state disabled] -column 3  -row 3  -sticky w
set ::yLength ""

# options for setting radius for vesicle/micelle
grid [ttk::label $k.a.lipR -text "Radius:" -padding 3] -column 2 -row 4 -pady {0 15} -sticky e
grid [ttk::entry $k.a.lipRad -textvariable radius -width 5 -state disabled] -column 3 -row 4 -pady {5 15} -sticky w
set ::radius ""

grid [ttk::button $k.a.makeSel -text "Make Selection" -command addGeom] -column 4 -row 5 -columnspan 2 -pady {10 15} -padx {75 15} -sticky e

proc addGeom {} {
	if {[catch {
		
		set tmp1 [.membrane.n.f2.a.bilayer state]
		set tmp2 [.membrane.n.f2.a.vesicle state]
		set tmp3 [.membrane.n.f2.a.micelle state]
		
		if {$tmp1 == "selected"} {
			set ::geomSel "Structure: Bilayer\nX-Length: $::xLength\nY-Length: $::yLength"
			.membrane.n.f1.b.lipLay configure -values [list Inner Outer Both]
		} elseif {$tmp2 == "selected"} {
			set ::geomSel "Structure: Vesicle\nRadius: $::radius"
			.membrane.n.f1.b.lipLay configure -values [list Inner Outer Both]
		} elseif {$tmp3 == "selected"} {
			set ::geomSel "Structure: Micelle"
			.membrane.n.f1.b.lipLay configure -values [list Inner]
		} else {
			set ::geomSel "Structure:"
		}
	}]!=0} {
		puts "Something went wrong"
	}
}

proc entBil {} {
	if {[catch {
		.membrane.n.f2.a.lipRad configure -state disabled
		.membrane.n.f2.a.xDim configure -state normal
		.membrane.n.f2.a.yDim configure -state normal
		set ::radius ""
	}]!=0} {
		puts "Something went wrong"
	}
}

proc entVes {} {
	if {[catch {
		.membrane.n.f2.a.lipRad configure -state normal
		.membrane.n.f2.a.xDim configure -state disabled
		.membrane.n.f2.a.yDim configure -state disabled
		set ::xLength ""
		set ::yLength ""
	}]!=0} {
		puts "Something went wrong"
	}
}

proc entMic {} {
	if {[catch {
		.membrane.n.f2.a.lipRad configure -state disabled
		.membrane.n.f2.a.xDim configure -state disabled
		.membrane.n.f2.a.yDim configure -state disabled
		set ::xLength ""
		set ::yLength ""
		set ::radius ""
	}]!=0} {
		puts "Something went wrong"
	}
}

############################################################################################
# Example System Section
############################################################################################

ttk::labelframe $k.b -text "Example System"
$k add $k.b

grid [ttk::label $k.b.memPic] -column 0 -row 0 -padx {15 0} -pady {15 15}
grid [ttk::label $k.b.memPic2] -column 1 -row 0 -padx {15 0} -pady {15 15}
image create photo mem -file "membrane2.gif"

$k.b.memPic configure -image mem
$k.b.memPic2 configure -image mem

############################################################################################
# Summary Window
############################################################################################

set j .membrane.n.f3

############################################################################################
# Lipid Composition Section
############################################################################################

ttk::labelframe $j.a -text "Lipids and Geometry"
$j add $j.a

grid [ttk::treeview $j.a.tree1 -height 5] -column 1 -row 0 -padx {5 15} -pady 15
grid [ttk::treeview $j.a.tree2 -height 5] -column 2 -row 0 -padx {5 15} -pady 15

$j.a.tree1 heading "#0" -text "Inner Layer"
$j.a.tree2 heading "#0" -text "Outer Layer"

$j.a.tree1 column "#0" -width 150 -anchor w
$j.a.tree2 column "#0" -width 150 -anchor w

grid [ttk::label $j.a.lipG -textvariable geomSel] -column 0 -row 0 -pady {15 0} -padx 15 -sticky n

############################################################################################
# Output File Section
############################################################################################

ttk::labelframe $j.b -text "Output"
$j add $j.b

grid [ttk::label $j.b.lipO1 -text "Output pdb" -relief ridge -padding 3] -column 0 -row 0 -pady {15 0} -padx 15 -sticky n
grid [ttk::entry $j.b.lipOut1 -textvariable outFile1] -column 1 -row 0 -padx 5 -pady {15 0}
set ::outFile1 ""

grid [ttk::label $j.b.lipO2 -text "Output psf" -relief ridge -padding 3] -column 0 -row 1 -pady {15 0} -padx 15 -sticky n
grid [ttk::entry $j.b.lipOut2 -textvariable outFile2] -column 1 -row 1 -padx 5 -pady {15 15}
set outFile2 ""

grid [ttk::button $j.b.genMem -text "Generate Membrane" -command generateMEM] -column 2 -row 2 -sticky nwes -padx 20 -pady 20

proc generateMEM {} {
	if {[catch {

		set OUTFILE1 $::outFile1
		set OUTFILE2 $::outFile2

		set LIPIDSIN {}
		set LIPIDSOUT {}
		
		foreach S [.membrane.n.f3.a.tree1 children {}] {
			lappend LIPIDSIN [lindex [.membrane.n.f3.a.tree1 item $S -text] 0]
			lappend LIPIDSIN [lindex [.membrane.n.f3.a.tree1 item $S -text] 1]
		}
		
		foreach S [.membrane.n.f3.a.tree2 children {}] {
			lappend LIPIDSOUT [lindex [.membrane.n.f3.a.tree2 item $S -text] 0]
			lappend LIPIDSOUT [lindex [.membrane.n.f3.a.tree2 item $S -text] 1]
		}
		
		set STRUCTURE [lindex $::geomSel 1]
		
		puts $LIPIDSIN
		puts $OUTFILE1
		puts $STRUCTURE
		
		if {$STRUCTURE == "Vesicle"} {
			set RADIUS [lindex $::geomSel 3]
			puts $RADIUS
			memstruc -s vesicle -l $LIPIDSIN -r $RADIUS -o $OUTFILE1	
		} elseif {$STRUCTURE == "Bilayer"} {
			set XLENGTH [lindex $::geomSel 3]
			set YLENGTH [lindex $::geomSel 5]
			memstruc -s bilayer -l $LIPIDSIN -x $XLENGTH -y $YLENGTH -o $OUTFILE1
		} else {
			memstruc -s micelle -l $LIPIDSIN -o $OUTFILE1	
		}	
	}]!=0} {
		puts "Something went wrong"
	}
}

