set molref  [mol load psf [ID]_wbi.psf pdb [ID]_wbi.pdb]
set moltraj [mol load psf [ID]_wbi.psf dcd [ID]_wbi_6e.dcd]

set outfile [open rmsf.dat w]  
set nf [molinfo $moltraj get numframes]  

# "orient" alignment loop
set frame0 [atomselect $molref "protein and noh and chain B"]
for {set i 0} { $i <= $nf } {incr i} {
    set selframe [atomselect $moltraj "protein and noh and chain B" frame $i]
    set all [atomselect $moltraj all frame $i]
    $all move [measure fit $selframe $frame0]
}


# rmsf loop
set sel [atomselect $moltraj "protein and name CA and chain B"]
set i 1
foreach {rmsf} [measure rmsf $sel] {

    puts $outfile "$i $rmsf"
    incr i
}

close $outfile 

exit
