
proc contacts {mol dist} {
  set all [atomselect $mol "not hydrogen"]
  foreach {ca cb} [measure contacts $dist $all] {}
  $all delete
  set cc [concat $ca $cb]
  if { [llength $cc] == 0 } {
    error "no contacts found within distance $dist"
  }
  puts "[llength $ca] contacts found within distance $dist"
  atomselect macro contacts "index $cc"
  mol selection "contacts"
  mol rep vdw
  mol color resid
  mol material Transparent
  mol addrep top
  mol selection "not hydrogen and same residue as contacts"
  mol rep lines
  mol color resid
  mol material Opaque
  mol addrep top
}

proc rotcontacts {mol dist} {
  set all [atomselect $mol "not hydrogen"]
  display update ui
  foreach {ca cb} [measure contacts $dist $all] {}
  display update ui
  $all delete
  set cc [concat $ca $cb]
  if { [llength $cc] == 0 } {
    error "no contacts found within distance $dist"
  }
  puts "Note that fixcontacts may be interrupted with control-c."
  puts "[llength $ca] contacts found within distance $dist"
  set deg 0
  while { [llength $cc] } {
    incr deg
    puts "Trying rotations of $deg deg"
    display update ui
    set csel [atomselect $mol "same residue as index $cc"]
    display update ui
    array unset cidx
    array unset cres
    set cxyz {}
    set i 0
    foreach rec [$csel get {index residue x y z}] {
      foreach {index residue x y z} $rec {}
      set cidx($index) [list $i $residue]
      lappend cres($residue) $i
      lappend cxyz [list $x $y $z]
      incr i
    }
    set allsameres 1
    set samerescounter 0
    set dotcounter 0
    foreach a1 $ca a2 $cb {
      foreach {a1 r1} $cidx($a1) {}
      foreach {a2 r2} $cidx($a2) {}
      if { $r1 == $r2 } { incr samerescounter; continue }
      set msg "fixing $r1 $r2"
      set allsameres 0
      set r1 $cres($r1)
      set r2 $cres($r2)
      set r1c [lindex $cxyz $a1]
      set r2c [lindex $cxyz $a2]
      set r12vec [vecsub $r2c $r1c]
      # set r12vec [vecsub [lindex $cxyz $a2] [lindex $cxyz $a1]]
      set r12dist [veclength $r12vec]
      if { $r12dist < $dist + 0.01 } {
        set r1avg {0. 0. 0.}
        foreach i $r1 {
          set r1avg [vecadd [lindex $cxyz $i] $r1avg]
        }
        set r1avg [vecscale $r1avg [expr 1. / [llength $r1]]]
        set r2avg {0. 0. 0.}
        foreach i $r2 {
          set r2avg [vecadd [lindex $cxyz $i] $r2avg]
        }
        set r2avg [vecscale $r2avg [expr 1. / [llength $r2]]]
        # assumes sphere of lipids centered on origin
        set r1rot [veccross [vecsub $r2c $r1avg] [vecsub $r1c $r1avg]]
        set r1rot [vecdot $r1rot $r1avg]
        if { $r1rot > 0. } { set r1rot 1 } else { set r1rot -1 }
        puts -nonewline "$msg $r1rot"
        set r1rot [transabout $r1avg [expr $r1rot * $deg] deg]
        set r2rot [veccross [vecsub $r1c $r2avg] [vecsub $r2c $r2avg]]
        set r2rot [vecdot $r2rot $r2avg]
        if { $r2rot > 0. } { set r2rot 1 } else { set r2rot -1 }
        puts " $r2rot"
        set r2rot [transabout $r2avg [expr $r2rot * $deg] deg]
        foreach i $r1 {
          lset cxyz $i [coordtrans $r1rot [lindex $cxyz $i]]
        }
        foreach i $r2 {
          lset cxyz $i [coordtrans $r2rot [lindex $cxyz $i]]
        }
        # set r12vec [vecsub $r2avg $r1avg]
        # set r12unit [vecscale $r12vec [expr 1. / [veclength $r12vec]]]
        # foreach i $r1 {
        #   set oxyz [lindex $cxyz $i]
        #   set dxyz [vecsub $oxyz $r1avg]
        #   set dxyz \
        #     [vecscale $r12unit [expr 0.1 + 0.01 * [vecdot $r12unit $dxyz]]]
        #   lset cxyz $i [vecsub $oxyz $dxyz]
        # }
        # foreach i $r2 {
        #   set oxyz [lindex $cxyz $i]
        #   set dxyz [vecsub $oxyz $r2avg]
        #   set dxyz \
        #     [vecscale $r12unit [expr -0.1 + 0.01 * [vecdot $r12unit $dxyz]]]
        #   lset cxyz $i [vecsub $oxyz $dxyz]
        # }
      }
      if { $dotcounter % 100 == 0 } {
        puts -nonewline "."
        flush stdout
      }
      incr dotcounter
    }
    display update ui
    $csel set {x y z} $cxyz
    $csel delete
    puts ""
    if { $samerescounter } { puts "$samerescounter intra-residue contacts" }
    if { $allsameres } break
    # find bad contacts again
    display update ui
    set all [atomselect $mol "not hydrogen"]
    display update ui
    foreach {ca cb} [measure contacts $dist $all] {}
    display update ui
    $all delete
    set cc [concat $ca $cb]
    puts "[llength $ca] contacts found within distance $dist"
  }
}

