#!/bin/bash

# Set the directory that contains the data folders

dataDir=$HOME/Projects/ds102
scriptDir=$HOME/Projects/scripts

# Change to the data directory
cd $dataDir

# Generate the subject list.  Do it this way to make modifying this script
# to run just a subset of subjects easier.  Otherwise we might end up with
# a bunch of feat+ directories.

# Running from sub-02 onward
for id in {01..01} ; do
    subj="sub-$id"
    echo "===> Starting processing of $subj"
    echo
    cd $subj

        # If the brain mask doesn’t exist, create it
        if [ ! -f anat/${subj}_T1w_brain.nii.gz ]; then
            echo bet anat/${subj}_T1w.nii.gz \
                anat/${subj}_T1w_brain.nii.gz # Note: changed from bet2
        fi
    
        # Copy the design files into the subject directory, and then
        # change “sub-01” to the current subject number
        cp $scriptDir/design_run1.fsf .
        cp $scriptDir/design_run2.fsf .

        # Note that we are using the | character to delimit the patterns
        # instead of the usual / character because there are / characters
        # in the pattern.  This is a handy trick; remember it; you may
        # use it again; and again.
        sed -i "s|DS102DATADIR|${dataDir}|g ; s|sub-01|${subj}|g" \
            design_run1.fsf
        sed -i "s|DS102DATADIR|${dataDir}|g ; s|sub-01|${subj}|g" \
            design_run2.fsf

        # Now everything is set up to run feat
        echo "===> Starting feat for run 1"
        echo feat design_run1.fsf
        echo "===> Starting feat for run 2"
        echo feat design_run2.fsf
        echo

    cd $dataDir
done
echo
