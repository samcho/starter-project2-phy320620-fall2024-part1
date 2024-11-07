set mol [mol load psf 2kwf_wbi.psf dcd 2kwf_wbi.dcd]

set outfile [open dihe.dat w]  
set nf [molinfo $mol get numframes]  

# rmsd calculation loop  
for { set i 1 } { $i <= $nf } { incr i } {  

    # C(i-1) N(i) CA(i) C(i)
    # N(i) CA(i) C(i) N(i+1)
    set phi8 [measure dihed {1535 1537 1539 1554} frame $i]
    set psi8 [measure dihed {1537 1539 1554 1556} frame $i]

    # insert more here
    # format: measure dihed {atomnum1, atomnum2, atomnum3, atomnum4} frame #

    set phi17 [measure dihed {1668 1670 1672 1685} frame $i]
    set psi17 [measure dihed {1670 1672 1685 1687} frame $i]

    puts $outfile "$i $phi8 $psi8 $phi17 $psi17"
     
}  
close $outfile 

exit
