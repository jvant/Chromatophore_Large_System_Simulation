
for { set i 0 } { $i < 400000 } { incr i } {
  lappend long $i
}

atomselect macro huge "index $long"

