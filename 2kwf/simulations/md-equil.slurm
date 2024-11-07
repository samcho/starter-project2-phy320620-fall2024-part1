#!/bin/bash
#SBATCH --partition=large
#SBATCH --job-name="multinode_job"
#SBATCH --nodes=1
#SBATCH --tasks-per-node=16
#SBATCH --cpus-per-task=1
#SBATCH --time=0-24:00:00
#SBATCH --account="classes"
#SBATCH --output="multinode_job.o"
#SBATCH --error="multinode_job.e"
#SBATCH --mem=2000mb                                                           #SBATCH --constraint=intel                                                     

# load the NAMD module
module load apps/namd/3.0b6

# set home directory
HOMEDIR=/deac/phy/classes/phy620/[username]/[repository-id]/2kwf/simulations

# set scratch directory
SCRATCHDIR=/scratch/$SLURM_JOBID
# set simulation ID
SIMID=[ID]

# go to home directory
cd $HOMEDIR

# copy files for running simulations over to scratch directory
cp par_all36_prot_na.prm \
    ${SIMID}_wbi.psf \
    ${SIMID}_wbi.pdb \
    equil_1e.conf \
    $SCRATCHDIR

# go to scratch directory
cd $SCRATCHDIR

# run NAMD scripts 
namd3 +auto-provision $SCRATCHDIR/equil_1e.conf > $SCRATCHDIR/equil_1e.out

# copy everything over
cp equil_1e.out \
    ${SIMID}_wbi_1e.restart.coor \
    ${SIMID}_wbi_1e.restart.vel \
    ${SIMID}_wbi_1e.restart.xsc \
    ${SIMID}_wbi_1e.coor \
    ${SIMID}_wbi_1e.vel \
    ${SIMID}_wbi_1e.xsc \
    ${SIMID}_wbi_1e.xst \
    ${SIMID}_wbi_1e.dcd \
    $HOMEDIR

# delete scratch directory and its contents
rm -rf $SCRATCHDIR
