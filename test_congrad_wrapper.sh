#/bin/bash

input='/nafs/kcross/PROJECTS/Cueing_Noninvasive_Auditory/mri/data/preprocess2/CM01/MNINonLinear/Results/rest_AP_PA/rest_AP_PA_hp2000.nii.gz'
roi='/nafs/kcross/PROJECTS/Cueing_Noninvasive_Auditory/mri/data/ROIs/harvardoxford-subcortical_prob_LeftCaudate_LeftAccumbens_MNI152_T1_2mm_bin.nii'
out='/nafs/kcross/PROJECTS/Cueing_Noninvasive_Auditory/mri/data/preprocess2/CM01/test_result'


sbatch test_congrad.sh -i "$input" -r "$roi" -m "$roi" -o "$out" 
