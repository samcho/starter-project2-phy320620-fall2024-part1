# Project 2: MD Simulations of E2A:KIX Domain Complex

Note: You are strongly encouraged to work together.  However, each person is responsible for producing and submitting their own work.

Overview: E2A is part of a TCF4 gene that is a marker for Pitt-Hopkins Syndrome. Its natural function is to bind to the KIX Domain of CREB binding protein, but large parts of the TCF4 gene are deleted in those who have Pitt-Hopkins. In addition, E2A is an intrinsically disordered protein that forms a structure upon binding to the KIX Domain. As such, this protein complex is interesting from both biomedical and basic science perspectives.

We will perform CHARMM MD simulations with NAMD of 1) KIX Domain, 2) E2A, and 3) E2A:KIX Domain Complex in explicit solvent on the DEAC cluster.  Using the production run of the simulation, we will use VMD and other programs to visualize trajectories and perform analyses on them.

## Part 1: MD simulations of E2A:KIX Domain Complex

Website References: [ NAMD Tutorial ](http://www.ks.uiuc.edu/Training/Tutorials/namd/namd-tutorial-unix-html/index.html)

Note: This portion of the project will require that you have already mastered the topics covered in Project 0. Therefore, we will be skipping some basic steps. If you run into difficulties, be sure to reference those documents.

1. Log into the DEAC HPC Cluster (see Project 0, Part 2)
2. Change directory to your project directory (see Part 0, Part 1):
   ```
   cd /deac/phy/classes/phy620/[username]
   ```
   where [username] should be replaced by your username.

3. Clone this repository by using the following command:
  ```
  git clone git@github.com:[username]/project1-phy320620-fall2024-part1.git
  ```
  You can also obtain the actual repository by using this repository's url (See Part 0, Part 4).

  This repository has a subdirectory called __2kwf__ and you will perform MD simulations of a E2A:KIX Domain Complex there. In the direcotry are three subdirectories: 1) input_data, 2) setup, and 3) simulations. The following files have been set up for you to run your MD simulations:

  | input_data/2kwf-a.pdb | PDB file containing the coordinates of a KIX Domain |
  | input_data/2kwf-b.pdb | PDB file containing the coordinates of E2A |
  | input_data/2kwf_centered.pdb | PDB file containing the centered coordinates of E2A:KIX Domain Complex |
  | input_data/2KWF.pdb | PDB file containing the coordinates of E2A:KIX Domain Complex downloaded from the PDB |
  
  | setup/top_all36_prot_na.rtf | CHARMM force field topology file |
  | setup/setup.pgn | VMD script to convert the 2kwf-a.pdb and 2kwf-b.pdb files into a format that can be readily used by NAMD. |
  | setup/solvate.pgn | VMD script to add a water box and NaCl ions. |
  | setup/Klean.sh | A “reset” script. If you get in trouble and you need to start over, run this script. It should get you back to the beginning (I think, I hope, knock on wood). |
  | simulations/par_all36_prot_na.prm | CHARMM force field parameter file |
  | simulations/equil_1e.conf | NAMD configuration file for running the “equilibration” portion of the MD simulation. |
  | simulations/dyna.temp | NAMD configuration file template for running the “production run” portion of the MD simulation. |
  | simulations/gen_scripts.sh | Script to generate NAMD configuration files during production run. |
  | simulations/md-equil.slurm | SLURM script for running equilibration MD simulation on the cluster. |
  | simulations/md-dyna.slurm | SLURM script for running production run MD simulation on the cluster. |

4. First we will make sure the PDB files are okay. We wil use VMD to visualize 2kwf-a.pdb and 2kwf-b.pdb files.

On the DEAC cluster, programs are made available to you only if you request it. To load the VMD program, you must load the module using the following command:
```
module load apps/vmd/1.9.4a57
```
Then type “vmd” and the program will load up as before. Open up and load 2kwf_a.pdb and 2kwf_b.pdb by going to the “VMD Main” window and selecting File --> New Molecule… . In the “Molecule File Browser” window, click on the “Browse…” button, locate the 2kwf-a.pdb file, and double-click on it. Then click on the “Load” button. This will load up the KIX Domain image. You can repeat the process for 2kwf_b.pdb.

![image](https://github.com/user-attachments/assets/3321d960-a38c-431c-8530-360ca2ebf140)
![image](https://github.com/user-attachments/assets/72601a04-19f6-4f41-8706-6afcec25a40f)

In the “VMD Main” window, select Graphics  Representations… . A “Graphical Representation” window will open.
 
5. To look at what a PDB file really looks like, we will use __nano__. When you open the file, it will look like the following:
![image](https://github.com/user-attachments/assets/758addf7-9e63-4044-9bd1-4638e761287c)

Notice that the PDB file has several columns of information. The 1st column (“ATOM”) denotes that the line contains information about an atom, 2nd column is the atom number, the 3rd column is the atom type, 4rd column is the nucleotide type (or residue for proteins), 5th column is the chain id, 6th is the nucleotide number (or residue for proteins), 7th, 8th, and 9th columns are the x-, y-, and z- coordinates, 10th is not important anymore and is always 1.00, and 11th is the thermal factors (how much the atom fluctuates according to experiments).

Use the scroll bar on the far right to scroll to the bottom of the file. Save the number of residues in the PDB file. 

Copy the 2kwf_a.pdb and 2kwf_b.pdb files to the “setup” subdirectory.

6. Next we will use the VMD script setup.pgn to convert the 2kwf_a.pdb and 2kwf_b.pdb files into a set of NAMD-style files that it is used to handling. 

This is a generic script for any biomolecule. You will need to modify it using the __nano__ program. 
  a. Open “setup.pgn” using __nano__.
  
  b. Replace all instances of “\[ID\]” (including brackets!) with “2kwf”.

Run the VMD script using the following command:
```
module load apps/vmd/1.9.4a57
vmd -dispdev text -e setup.pgn
```

A lot of text will show up on the screen. Unless “ERROR” or “MOLECULE MISSING!” or other ominous sounding text appears, you’re fine. “Warning” is not sufficiently worrisome.

To verify that everything really is fine, type “vmd 2kwf.namd.psf 2kwf.namd.pdb”. An image very similar to the one from step 4 will appear.

7. Next we will use the VMD script solvate.pgn file to add a water box and sodium and chloride ions to our E2A:KIX Domain Complex. Again, this is a generic script for any biomolecule. You will need to modify it using the __nano__ program. 

  a. Open “solvate.pgn” using __nano__. 
  
  b. Replace all instances of “[ID]” with “2kwf”.

After you’re done, save your changes and exit out of the program

Run the VMD script using the following command:
```
vmd -dispdev text -e solvate.pgn
```

To verify that everything really is fine, type “vmd 2kwf.namd.psf 2kwf.namd.pdb”. 

8. Use __nano__ to open up the 2kwf_wbi.pdb file. On the first line, first column is “CRYST1”. The next three sets of numbers are the x-, y-, and z-dimensions of the water box. Save the water box dimensions. Exit out of the program.

9. Next we will use the NAMD configuration file equil_1e.conf file to read in the G-quadruplex + water box + ions and run 50 ps equilibration by raising the temperature from 0 K to 298 K. We will be using periodic boundary conditions and various cutoff methods we discussed in class. Again, this is a generic script for any biomolecule. You will need to modify it using the __nano__ program. 

  a. Open “equil_1e.conf” using __nano__. 
  
  b. Replace all instances of “[ID]” with “2kwf”.
  
  c. Replace the instances of [XPBC], [YPBC], and [ZPBC] with the x-, y-, and z-dimensions of the water box (to the tenth place precision) from Step 8.

10. Next we will use the NAMD configuration file template file dyna.temp to read in the MD simulation state from the previous step and continue for 1 ns. Again, this is a generic script for any biomolecule. You will need to modify it using the __nano__ program.

  a. Open “dyna.temp” using __nano__. 
  
  b. Replace all instances of “[ID]” with “2kwf”.

After you’re done, save your changes and exit out of the program

11. Next we will set up 10 ns of MD simulations of 1 ns parts using the dyna.temp file. Type the following command:

```
for ((i=2; i<=11; i++)); do ./gen_scripts.sh $i; done
```

This is a nifty little program that I wrote that will write NAMD configuration file for doing the 1st nanosecond of MD simulation and then the 2nd nanosecond and so forth until the end.

12. Next we will set up the SLURM script for running MD simulations on the cluster. Again, this is a generic script for any biomolecule. You will need to modify it using the __nano__ program..

  a. Open “md-equil.slurm” using __nano__. 
  
  b. Replace all instances of “[username]” with your username and [ID] with “2kwf”.

After you’re done, save your changes and exit out of the program.

13. In steps 9-12, we set up the equilibration and production run portions of the MD simulation and even the SLURM script to request computers from the DEAC cluster to run it, but we did not actually run it. (No, we have not been using the full power of the DEAC cluster yet.) We will be using the SLURM queuing system.

How to use the SLURM queuing system:
Three main commands:
  1.	sbatch -> submit to the queue.
  2.	squeue -> check the status of the queue.
  3.	scancel -> cancel a submission to the queue.

To submit your md-equil.slurm script to the DEAC cluster, type “sbatch md-equil.slurm”. The check on whether everything is okay, type “squeue –u [username]” where [username] is your username. If it is running, your job will show up as below. 

![image](https://github.com/user-attachments/assets/cc67b75d-21c1-43d3-b1f8-3554b7d94063)

In the “ST” column, an “R” indicates that it is currently running and a “PD” indicates that it is waiting (or pending) in the queue.

14. Using steps 10-11 as a guide, modify and submit the “md-dyna.slurm” script. It should take roughly 1 day to complete, as long as everything goes smoothly.

I strongly recommend that you periodically “baby-sit” your MD simulation until it is finished.  Note: This should take about 24 hours, but no longer than two days. Wait patiently until your simulations are finished. If something seems wrong, contact me.

Notice that I am asking you to do 200-250 ns of MD simulations but the md-dyna.slurm script in Step 12 only goes up to 10 ns (2-11). Why is that?
Remember that E2A is an intrinsically disordered protein in the absence of a binding partner. In the presence of a binding partner, it should maintain its helical structure.

I would like for you to wait keep track of when each submission to the DEAC cluster queue completes. To help you, these are some timing data I compiled.

Approximate simulation rates:

2kwf: 2 hours per nanosecond simulation

After each queue submission completes, you will check to make sure all of the MD simulations complete correctly by typing the following:

```
tail -n 1 dyna*.out
```

This command prints out the last line of each MD simulation output file. Each file should end with “End of program”. If this is not the case, the MD simulations must be re-run starting from the point when “End of program” does not occur. While this is unlikely to happen, you must check every time just in case. It would be horrible to find out that you have 100 ns of MD simulation only to find out later that there is an error at 42 ns that could have been easily fixed if you just took the time to check.

In principle, it would be great to run MD simulations for the entire 100 ns or 200 ns, let the computer do its work, and just forget about it. Unfortunately, it is the policy of the DEAC cluster that each queue submission only lasts 60 hours. That means 2kwf should only run ~7 ns at a time. You will modify line 24 and resubmit md-dyna.slurm into the queue until the desired time length is reached.

Part of your grade on your project will depend on how long each of your MD simulations ends up by the due date.  For each 10% over or under your correct MD simulation is in length of time, you will receive an extra 10% over or under on that portion of your project grade.

15. When your MD simulation is finished, you can visualize it using VMD and even save it as a video.

__Turn in the movie on Canvas.  Feel free to use any artistic license you please.__


## Part 2: Analyze and Visualize your Trajectories

### Part 2-1: Ramachandran Plots of E2A

1. In your directory is the MD simulations of the E2A:KIX Domain Complex.  We will calculate the Ramachandran Plots of the last completed nanosecond trajectory for E2A.
2. In each of the two directories, you will find a file called “dihe.tcl”. You can run it as is by using the following command:

```
vmd -dispdev text -e dihe.tcl
```

It opens your trajectory file in the 5th nanosecond and loops over every single frame. For residues 92 and 105, the phi and psi dihedral angles are computed by selecting the four atoms that define those dihedral angles.  Then, the result will be printed out into a file called dihe.tcl.

When you open dihe.dat with __nano__, you will see 5 columns. The first column has the frame number and the next two columns will have the phi and psi angles for residue 92, and the next two columns will have the phi and psi angles for residue 105.

3. Your job is to calculate the phi and psi angles for all residues 92-105, inclusive, in the last trajectory only and plot the Ramachandran plot for all 14 residues. To do so, you will begin by modifying the dihe.tcl file in the following ways:

a)	On line 1, you will replace “2kwf_wbi_2e.dcd” with the dcd file of your last completed nanosecond trajectory.
b)	On line 14, you will introduce new lines for the phi/psi dihedral angle calculations for residues 93-104, inclusive, using the lines for the phi/psi dihedral angle calculations for residues 92 and 105 as a template.
c)	On line 19, you will modify it to print out the phi/psi dihedral angles that you calculated in (b).

Once you are complete, re-run dihe.tcl:
vmd -dispdev text -e dihe.tcl

4. Use Filezilla to copy the dihe.dat and graph the Ramachandran Plots and deposit only the images into Canvas. You will have 14 Ramachandran Plots.

### Part 2-2: Root Mean Square Fluctuations
1) In your directory is the MD simulations of the E2A:KIX Domain Complex.  We will calculate the RMSF of the last completed nanosecond trajectory for the E2A and KIX Domain.  

2) In your directory, you will find a file called “rmsf.tcl”. You can run it as is by using the following command:
```
vmd -dispdev text -e rmsf.tcl
```

It opens the initial X-ray crystallographic structure for your MD simulation and also your trajectory file in the 5th nanosecond. It loops over the entire trajectory and performs a best-fit alignment of every structure to the X-ray crystallographic structure. This is so that we eliminate any translational motion in our calculation of the structural fluctuations. Then, the program computes the RMSF for each C-alpha carbon such that we can quantify how much each residue fluctuates over the trajectory. The result will be printed out into a file called rmsf.dat.

When you open rmsf.dat with __nano__, you will see 2 columns. The first column has the residue number and the next column has the RMSF of the residue.
3) Your job is to calculate the RMSF in the last trajectory only. To do so, you will begin by modifying the rmsf.tcl file in the following ways:

a)	On line 2, you will replace “[ID]” with “2kwf” and “6e” with the number of the dcd file of your last completed nanosecond trajectory.
b)	That is all. Really.

Once you are complete, re-run rmsf.tcl:
```
vmd -dispdev text -e rmsf.tcl
```
Copy the rmsf.dat, graph a single RMSF Plot with the data and deposit only the image into Canvas.

### Part 2-3: Movie

You will use the Movie Maker in VMD to make a movie using a single trajectory from your directory. See Project 1, Part 2 for reference.

You will turn in your movie by sharing it with me using Google Drive. You will share the link on Canvas.

Unlike the previous movie, you will be graded on the following criteria:

1. Creativity
2.	Informative: a) With respect to MD simulations, b) With respect to Pitt-Hopkins Syndrome, c) With respect to Intrinsically Disordered Proteins

Each movie should be for a general audience and may be no longer than 10 minutes. 



