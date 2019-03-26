package require Tk
source MEM_header.tcl

set w [toplevel ".membrane"]

# setup root and give title
wm title $w "Membrane Structure Builder"

# make a paned window object ($w.c) using grid
grid [ttk::panedwindow $w.c -orient vertical] -column 0 -row 0 -sticky nwes

# add first pane to window
grid [ttk::labelframe $w.c.f1] -column 0 -row 0 -columnspan 4 -rowspan 4
$w.c add $w.c.f1

# add label for first pane
grid [ttk::label $w.c.f1.lipComp -text "1. Lipid Composition" -width 17 -anchor w] -column 1 -row 1 -padx 5 -pady 5
grid [ttk::label $w.c.f1.emptyOne -text "" -width 17 -anchor w] -column 2 -row 1 -padx 5 -pady 5

# configure options for picking lipid type
grid [ttk::label $w.c.f1.lipT -text "Lipid Type" -padding 3 -relief solid] -column 1 -row 2 -padx 5 -pady 5
grid [ttk::combobox $w.c.f1.lipType -textvariable lipidName -state readonly -width 6] -column 1 -row 3 
$w.c.f1.lipType configure -values [list POPC POPE POPS]

# configure options for picking percent composition
grid [ttk::label $w.c.f1.lipP -text "Percent Composition" -padding 3 -relief solid] -column 2 -row 2 
grid [ttk::entry $w.c.f1.lipPerc -textvariable percent -width 5] -column 2 -row 3 

# creat Add Lipid button, which is linked to proc lipSummary
grid [ttk::button $w.c.f1.addLip -text "Add Lipid" -command lipSummary] -column 3 -row 4 -padx 5 -pady 5

# add second pane to window
grid [ttk::labelframe $w.c.f2] -column 0 -row 4 -columnspan 4 -rowspan 5 -sticky nwes
$w.c add $w.c.f2

# add label for second pane
grid [ttk::label $w.c.f2.lipBilayer -text "2. Structure" -width 17 -anchor w] -column 1 -row 1 -padx 5 -pady 5  
grid [ttk::label $w.c.f2.emptyOne -text "" -width 17 -anchor w] -column 2 -row 1 -padx 5 -pady 5

# add a radiobutton
grid [ttk::radiobutton $w.c.f2.bilayer -text "Bilayer" -variable geometry -value bilayer -command entBil] -column 1 -row 2 -sticky s
grid [ttk::radiobutton $w.c.f2.vesicle -text "Vesicle" -variable geometry -value vesicle -command entVes] -column 1 -row 3 
grid [ttk::radiobutton $w.c.f2.micelle -text "Micelle" -variable geometry -value micelle -command entMic] -column 1 -row 4 -sticky n

# configure options for picking x length of bilayer
grid [ttk::label $w.c.f2.xD -text "X-Length" -padding 3 -relief solid] -column 2 -row 2 -padx 5 -pady 5
grid [ttk::entry $w.c.f2.xDim -textvariable xLength -width 5 -state disabled] -column 3 -row 2 

# configure options for picking y length of bilayer
grid [ttk::label $w.c.f2.yD -text "Y-Length" -padding 3 -relief solid] -column 2 -row 3 
grid [ttk::entry $w.c.f2.yDim -textvariable yLength -width 5 -state disabled] -column 3 -row 3  

# options for setting radius for vesicle/micelle
grid [ttk::label $w.c.f2.lipR -text "Radius" -padding 3 -relief solid] -column 2 -row 4 
grid [ttk::entry $w.c.f2.lipRad -textvariable radius -width 5 -state disabled] -column 3 -row 4 -pady 5

# add space below entry box
#grid [ttk::label $w.c.f2.empty -text " "] -column 3 -row 4 -padx 5 -pady 7

# add third pane to window
grid [ttk::labelframe $w.c.f3] -column 0 -row 8 -columnspan 4 -rowspan 5 -sticky nwes
$w.c add $w.c.f3

# add label for third frame
grid [ttk::label $w.c.f3.lipBilayer -text "3. Summary" -width 17 -anchor w] -column 1 -row 1 -padx 5 -pady 5  
grid [ttk::label $w.c.f3.emptyOne -text "" -width 17 -anchor w] -column 2 -row 1 -padx 5 -pady 5

# display structure
grid [ttk::label $w.c.f3.lipS -text "Structure" -padding 3 -relief solid] -column 1 -row 2 -padx 5 -pady 5
grid [ttk::entry $w.c.f3.lipStruc -textvariable structure -state readonly -width 8] -column 1 -row 3 

# display lipids
grid [ttk::label $w.c.f3.lipC -text "Lipids" -padding 3 -relief solid] -column 2 -row 2 -padx 5 -pady 5
grid [tk::listbox $w.c.f3.lipComp -listvariable lipids -height 5 -width 10] -column 2 -row 3 

# set output file
grid [ttk::label $w.c.f3.lipO -text "Output File" -padding 3 -relief solid] -column 3 -row 2 -padx 10 -pady 5
grid [ttk::entry $w.c.f3.lipOut -textvariable output -width 8] -column 3 -row 3 -padx 5 -pady 5

# create Make Structure button, which is linked to proc makeStruc
grid [ttk::button $w.c.f3.addLip -text "Make Structure" -command makeStruc -padding 3] -column 2 -row 5 -padx 5 -pady 15 -sticky w

# create delete lipid composition button
grid [ttk::button $w.c.f3.delLip -text "Delete Lipid" -command delSummary] -column 1 -row 5 -padx 5 -pady 5

proc entBil {} {
	if {[catch {
		.membrane.c.f2.lipRad configure -state disabled
		.membrane.c.f2.xDim configure -state normal
		.membrane.c.f2.yDim configure -state normal
		set ::structure "bilayer"
		set ::radius ""
	}]!=0} {
		puts "Something went wrong"
	}
}

proc entVes {} {
	if {[catch {
		.membrane.c.f2.lipRad configure -state normal
		.membrane.c.f2.xDim configure -state disabled
		.membrane.c.f2.yDim configure -state disabled
		set ::structure "vesicle"
		set ::xLength ""
		set ::yLength ""
	}]!=0} {
		puts "Something went wrong"
	}
}

proc entMic {} {
	if {[catch {
		.membrane.c.f2.lipRad configure -state disabled
		.membrane.c.f2.xDim configure -state disabled
		.membrane.c.f2.yDim configure -state disabled
		set ::structure "micelle"
		set ::xLength ""
		set ::yLength ""
		set ::radius ""
	}]!=0} {
		puts "Something went wrong"
	}
}

proc lipSummary {} {
	if {[catch {
		lappend ::lipids "$::lipidName $::percent"
	}]!=0} {
		set ::lipids ""
	}
}

proc makeStruc {} {
	if {[catch {
	
		set lipList []
		for {set i 0} {$i< [llength $::lipids]} {incr i} {
			set temp [lindex $::lipids $i]
			lappend lipList [lindex $temp 0]
			lappend lipList [lindex $temp 1]
		}
		
		if {$::structure == "bilayer"} {
			memstruc -s $::structure -l $lipList -x $::xLength -y $::yLength -o $::output
		} else {
			memstruc -s $::structure -l $lipList -r $::radius -o $::output
		}
	}]!=0} {
		puts "Something went wrong"
	}

}

proc delSummary {} {
	if {[catch {
		set ::lipids [lreplace $::lipids [.membrane.c.f3.lipComp curselection] [.membrane.c.f3.lipComp curselection]]
	}]!=0} {
		puts "Something went wrong"
	}

}


