#!/bin/bash

# Set the directory that contains the data folders

dataDir=/nfs/psych808/mevansj/FINALPROJECT/ds214
scriptDir=/nfs/psych808/mevansj/FINALPROJECT/FINALPROJECTscripts

# Change to the data directory
cd $dataDir

# Generate the subject list.  Do it this way to make modifying this script
# to run just a subset of subjects easier.  Otherwise we might end up with
# a bunch of feat+ directories.

# Running from sub-02 onward
for id in `cat $dataDir/subjList.txt`; do
    subj="$id"
    echo "===> Starting processing of $subj"
    echo
    cd $subj

        # If the brain mask doesn’t exist, create it
        if [ ! -f anat/${subj}_T1w_brain.nii.gz ]; then
            bet2 anat/${subj}_T1w.nii.gz \
                anat/${subj}_T1w_brain.nii.gz -f 0.3
        fi
    
        # Copy the design files into the subject directory, and then
        # change “sub-08” to the current subject number
        cp $scriptDir/preprocess.fsf .

        # Note that we are using the | character to delimit the patterns
        # instead of the usual / character because there are / characters
        # in the pattern.  This is a handy trick; remember it; you may
        # use it again; and again.
        sed -i "s|sub-EESS001|${subj}|g" \
            preprocess.fsf
            
        # Now everything is set up to run feat
        echo "===> Starting feat for run 1"
        feat preprocess.fsf
                echo

    cd $dataDir
done
echo

