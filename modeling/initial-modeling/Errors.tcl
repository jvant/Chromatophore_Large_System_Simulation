set Infile [open Errors.txt w]	

set outerRadius 10.0
set counter 0
set aplO 80.0
set spacingO [expr {sqrt($aplO)/$M_PI}]
for {set k 1} {$k < 100} {incr k} {
	
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
	
puts $Infile "$counter [expr {abs($outerNumPoints - $realNumPoints)/$outerNumPoints}]"
incr counter
set outerRadius [expr {$outerRadius + 10.0}]

}

close $Infile