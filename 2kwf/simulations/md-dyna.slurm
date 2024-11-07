#!/bin/bash
#SBATCH --partition=large
#SBATCH --job-name="multinode_job"
#SBATCH --nodes=1
#SBATCH --tasks-per-node=16
#SBATCH --cpus-per-task=1
#SBATCH --time=5-00:00:00
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

for ((i=2; i<=11; i++))
do
    prev=`expr $i - 1`
    # go to home directory
    cd $HOMEDIR

    # create md simulation NAMD script
    ./gen_scripts.sh ${i}

    # copy files for running simulations over to scratch directory
    cp par_all27_prot_na.prm \
	${SIMID}_wbi.psf \
	${SIMID}_wbi.pdb \
	dyna_${i}e.conf \
	${SIMID}_wbi_${prev}e.restart.coor \
	${SIMID}_wbi_${prev}e.restart.vel \
	${SIMID}_wbi_${prev}e.restart.xsc \
	${SIMID}_wbi_${prev}e.xsc \
	$SCRATCHDIR

    # go to scratch directory
    cd $SCRATCHDIR

    # run NAMD scripts 
    namd3 +auto-provision $SCRATCHDIR/dyna_${i}e.conf > $SCRATCHDIR/dyna_${i}e.out

    # copy everything over
    cp dyna_${i}e.out \
	${SIMID}_wbi_${i}e.coor \
	${SIMID}_wbi_${i}e.vel \
	${SIMID}_wbi_${i}e.xsc \
	${SIMID}_wbi_${i}e.xst \
	${SIMID}_wbi_${i}e.dcd \
	$HOMEDIR

    # go back home
    cd $HOMEDIR
done

# delete scratch directory and its contents
rm -rf $SCRATCHDIR
