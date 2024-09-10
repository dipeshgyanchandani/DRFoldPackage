#!/bin/bash
IN="$1"                # input.fasta
WDIR=`realpath -s $2`  # working folder

mkdir -p $WDIR
export PETFOLDBIN="/home/dgyancha/DirectedStudyDipesh/projects/DRfold/bin/PETfold/bin"
PYTHON="python"
export MKL_THREADING_LAYER=GNU
full_path=$(realpath $0)
 
dir_path=$(dirname $full_path)

if [ ! -s $WDIR/seq_ss.npy ]
then
    echo "Generating ss features"
    $PYTHON $dir_path/scripts/Feature.py $(realpath $IN) $WDIR/seq_ss >>$WDIR/running.log
fi

if [ ! -s $WDIR/geo_1.npy ]
then
    echo "Predicting geo 1/3"
    $PYTHON $dir_path/DeepGeoPotential/config1/predict.py $(realpath $IN)  $WDIR/seq_ss.npy $WDIR/geo_1 >>$WDIR/running.log
fi

if [ ! -s $WDIR/geo_2.npy ]
then
    echo "Predicting geo 2/3"
    $PYTHON $dir_path/DeepGeoPotential/config2/predict.py $(realpath $IN)  $WDIR/seq_ss.npy $WDIR/geo_2 >>$WDIR/running.log
fi

if [ ! -s $WDIR/geo_3.npy ]
then
    echo "Predicting geo 3/3"
    $PYTHON $dir_path/DeepGeoPotential/config3/predict.py $(realpath $IN)  $WDIR/seq_ss.npy $WDIR/geo_3 >>$WDIR/running.log
fi

if [ ! -s $WDIR/geo.npy ]
then
    echo "Combining geo potentials"
    $PYTHON $dir_path/scripts/combine.py $WDIR/geo $WDIR/geo_1.npy $WDIR/geo_2.npy $WDIR/geo_3.npy >>$WDIR/running.log
fi

if [ ! -s $WDIR/e2e_5.npy ]
then
    echo "Predicting e2e "
    $PYTHON $dir_path/DeepE2EPotential/predict.py $(realpath $IN)  $WDIR/seq_ss.npy $WDIR/e2e >>$WDIR/running.log
fi

if [ ! -s $WDIR/DPRcg.pdb ]
then
    echo "Optimizing structure"
    $PYTHON $dir_path/PotentialFold/Fold.py $(realpath $IN) $WDIR/geo.npy $WDIR/DPRcg $WDIR/e2e_0.npy $WDIR/e2e_1.npy $WDIR/e2e_2.npy $WDIR/e2e_3.npy $WDIR/e2e_4.npy $WDIR/e2e_5.npy  >>$WDIR/running.log
fi

if [ ! -s $WDIR/DPR_5.pdb.pdb ]
then
    echo "Filling full atoms"
    $dir_path/bin/FullAtom $WDIR/DPRcg_5.pdb $WDIR/DPR_5.pdb 5 >>$WDIR/running.log
fi
if [ ! -s $WDIR/DPR_4.pdb.pdb ]
then
    echo "Filling full atoms"
    $dir_path/bin/FullAtom $WDIR/DPRcg_4.pdb $WDIR/DPR_4.pdb 5 >>$WDIR/running.log
fi
if [ ! -s $WDIR/DPR_3.pdb.pdb ]
then
    echo "Filling full atoms"
    $dir_path/bin/FullAtom $WDIR/DPRcg_3.pdb $WDIR/DPR_3.pdb 5 >>$WDIR/running.log
fi
if [ ! -s $WDIR/DPR_2.pdb.pdb ]
then
    echo "Filling full atoms"
    $dir_path/bin/FullAtom $WDIR/DPRcg_2.pdb $WDIR/DPR_2.pdb 5 >>$WDIR/running.log
fi
if [ ! -s $WDIR/DPR_1.pdb.pdb ]
then
    echo "Filling full atoms"
    $dir_path/bin/FullAtom $WDIR/DPRcg_1.pdb $WDIR/DPR_1.pdb 5 >>$WDIR/running.log
fi
if [ ! -s $WDIR/DPR_0.pdb.pdb ]
then
    echo "Filling full atoms"
    $dir_path/bin/FullAtom $WDIR/DPRcg_0.pdb $WDIR/DPR_0.pdb 5 >>$WDIR/running.log
fi

if [ ! -s $WDIR/DPR.pdb ]
then
    echo "Filling full atoms"
    $dir_path/bin/FullAtom $WDIR/DPRcg.pdb $WDIR/DPR.pdb 5 >>$WDIR/running.log
fi
