#!/usr/bin/env bash

#SBATCH --nodes 1
#SBATCH --ntasks-per-node 1
#SBATCH --mem=90G
#SBATCH --time 120:00:00
#SBATCH --job-name task_general_func
#SBATCH -e slurm_%j.err
#SBATCH -o slurm_%j.out

echo $SLURM_JOBID

# INCLUDE
# BY: was having this uncommented creating issues?
#source "$GUNTHERDIR/include/Asourceall.sh"

#input='/nafs/kcross/PROJECTS/Cueing_Noninvasive_Auditory/mri/data/preprocess/CM01/MNINonLinear/Results/rest_AP_PA_hp2000_clean/rest_AP_PA.nii.gz'

input='/nafs/kcross/PROJECTS/Cueing_Noninvasive_Auditory/mri/data/preprocess2/CM01/MNINonLinear/Results/rest_AP_PA/rest_AP_PA_hp2000.ica/filtered_func_data_clean.nii.gz'
#roi='/nafs/kcross/PROJECTS/Cueing_Noninvasive_Auditory/mri/data/ROIs/harvardoxford-subcortical_prob_LeftCaudate_LeftAccumbens_MNI152_T1_2mm_bin.nii'
#roi='/nafs/kcross/PROJECTS/Cueing_Noninvasive_Auditory/mri/data/ROIs/harvardoxford-subcortical_prob_RightCaudate_RightAccumbens_MNI152_T1_2mm_bin.nii.gz'
roi='/nafs/kcross/PROJECTS/Cueing_Noninvasive_Auditory/mri/data/ROIs/harvardoxford-subcortical_prob_LeftPutamen_MNI152_T1_2mm_bin.nii.gz'
mask='/nafs/kcross/PROJECTS/Cueing_Noninvasive_Auditory/mri/data/MNI152_T1_2mm_brain_mask.nii.gz'
#out='/nafs/kcross/PROJECTS/Cueing_Noninvasive_Auditory/mri/data/preprocess/CM01/test_result'

input_dir='/nafs/kcross/PROJECTS/Cueing_Noninvasive_Auditory/mri/data/preprocess2/CM01/MNINonLinear/Results/'

# Extract the filename (excluding extension) from the full path
filename=$(basename "$input")
filename_noext="${filename%.*}"  # Remove the extension

# Construct the output directory based on the filename
out="/nafs/kcross/PROJECTS/Cueing_Noninvasive_Auditory/mri/data/preprocess/CM01/test_2/$filename_noext"
mkdir -p "$out"

module load anaconda/3.7
source /nafs/dtward/torch_venv/bin/activate

#log_file="./environment_example.log"

current_datetime=$(date +"%Y%m%d_%H%M%S")
error_log="error_${current_datetime}.log"

## Check if numpy is installed
#if pip show numpy > /dev/null 2>&1; then
#    echo "numpy is installed." | tee -a "$log_file"
#else
#    echo "numpy is NOT installed." | tee -a "$log_file"
#fi
#
## Check if nibabel is installed
#if pip show nibabel > /dev/null 2>&1; then
#    echo "nibabel is installed." | tee -a "$log_file"
#else
#    echo "nibabel is NOT installed." | tee -a "$log_file"
#fi
#
## Check if scipy is installed
#if pip show scipy > /dev/null 2>&1; then
#    echo "scipy is installed." | tee -a "$log_file"
#else
#    echo "scipy is NOT installed." | tee -a "$log_file"
#fi
#
## Check if networkx is installed
#if pip show networkx > /dev/null 2>&1; then
#    echo "networkx is installed." | tee -a "$log_file"
#else
#    echo "networkx is NOT installed." | tee -a "$log_file"
#fi

# Find all files with .nii or .nii.gz extensions in the specified directory and its subdirectories
#files=$(find "$input_dir" -type f \( -name "*.nii" -o -name "*.nii.gz" \))

# Loop through each file and run congrads
#for input_file in $files; do
#    job_start_time=$(date +"%Y-%m-%d %H:%M:%S")
#    echo "Job started for $input_file at $job_start_time" >> "$log_file"
#    echo "Job started for $input_file at $job_start_time" >> "$error_log"
#    ./congrads -i "$input_file" -r "$roi" -m "$mask" -o "$out" 2>> "$error_log"
#done



#sbatch --nodes=1 --ntasks=1 --cpus-per-task=2 --mem=16G --time=24:00:00 --job-name=CM01_4-5 --output=/nafs/kcross/PROJECTS/Cueing_Noninvasive_Auditory/mri/code/batch_processing/error_logs/11.28.23_HCP_preprocessing_CM01_4-5.log /nafs/kcross/PROJECTS/Cueing_Noninvasive_Auditory/mri/code/HCP_preprocessing.sh CM01

./congrads -i "$input" -r "$roi" -m "$mask" -o "$out" -n 1 -s -p -f 4 2>> "$error_log"
#./congrads -i "$input_file" -r "$roi" -m "$mask" -o "$out" -f 2