#!/bash/bash

#Johnny Rao 04.29.19
#Hippocampal Subfield Segmentation Script Pipeline

RAW_DATA="/space/md18/3/data/MMILDB/EPIPROJ/EPDTI/Containers/"
FSURF_DATA="/space/md18/3/data/MMILDB/EPIPROJ/FSRECONS/"
TESTING_FOLDER="/space/syn09/1/data/MMILDB/ABALA/Hippocampal_Subfields/"

FOLDER="ls | grep '$1'"

if [ FOLDER == '' ]; then
	echo "Can't find patient folder"
	exit 1
fi

"cd $RAW_DATA$FOLDER "

SERIES='rscript -e get_raw_folder.r'

"cp -r $RAW_DATA$FOLDER$SERIES $TESTING_FOLDER'temp/raw'"

"cd $TESTING_FOLDER'temp'"

"dcm2nii raw"

"cp -r $FSURF_DATA$FOLDER $TESTING_FOLDER'temp'"

template="mv *.nii.gz T2.nii.gz"
t1brain=T1.mgz

"antsRegistration --dimensionality 3 --float 0 \
    --output [$TESTING_FOLDER'temp'/Template_to_${sub}_, \
	$TESTING_FOLDER'temp'/pennTemplate_to_${sub}_Warped.nii.gz] \
    --interpolation Linear \
    --winsorize-image-intensities [0.005,0.995] \
    --use-histogram-matching 0 \
    --initial-moving-transform [$t1brain,$template,1] \
    --transform Rigid[0.1] \
    --metric MI[$t1brain,$template,1,32,Regular,0.25] \
    --convergence [1000x500x250x100,1e-6,10] \
    --shrink-factors 8x4x2x1 \
    --smoothing-sigmas 3x2x1x0vox \
    --transform Affine[0.1] \
    --metric MI[$t1brain,$template,1,32,Regular,0.25] \
    --convergence [1000x500x250x100,1e-6,10] \
    --shrink-factors 8x4x2x1 \
    --smoothing-sigmas 3x2x1x0vox \
    --transform SyN[0.1,3,0] \
    --metric CC[$t1brain,$template,1,4] \
    --convergence [100x70x50x20,1e-6,10] \
    --shrink-factors 8x4x2x1 \
    --smoothing-sigmas 3x2x1x0vox \
    -x $brainlesionmask"

"cd $TESTING_FOLDER'scripts"

"./hippocapal_seg_script `../temp/$FOLDER` `../temp/T2.nii.gz` 'Analysis ' "
