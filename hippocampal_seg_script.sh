#!/bin/bash

#Johnny Rao 04.29.19
#bash script to run freesurfer hippocampal segementation on T1 with T2 scan

export SUBJECTS_DIR="../data"

if [ -z "$1" ]; then

	echo " ./hippocamp_seg_script <T2 file> <SUbject ID> <Optional Threads count>\n"
	exit 0
	
fi

subject=$1

if [ -z "$2" ]; then
	
	echo " ./hippocamp_seg_script <T2 file> <SUbject ID> <Optional Threads count>\n"
	exit 0
	
fi

ID=$2

if [ -z "$3" ]; then
	
	echo " Threads count will be set to 4 (default)\n"
	Threads=4
	
fi

Threads=$3

if [ -n "$4" ]; then
	
	echo " ./hippocamp_seg_script <T2 file> <SUbject ID> <Optional Threads count>\n"
	exit 0
	
fi

	

#Running recon-all subject by subject in the directory
"recon-all -s $subject -hippocampal-subfields-T1T2 $T2Scan*.nii $ID \
	-itkthreads $Threads"
	
