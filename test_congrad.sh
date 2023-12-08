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
input='/nafs/kcross/PROJECTS/Cueing_Noninvasive_Auditory/mri/data/preprocess2/CM01/MNINonLinear/Results/rest_AP_PA/rest_AP_PA_hp2000_clean.nii.gz'
#roi='/nafs/kcross/PROJECTS/Cueing_Noninvasive_Auditory/mri/data/ROIs/harvardoxford-subcortical_prob_LeftCaudate_LeftAccumbens_MNI152_T1_2mm_bin.nii'
roi='/nafs/kcross/PROJECTS/Cueing_Noninvasive_Auditory/mri/data/ROIs/harvardoxford-subcortical_prob_LeftPutamen_MNI152_T1_2mm_bin.nii.gz'

mask='/nafs/kcross/PROJECTS/Cueing_Noninvasive_Auditory/mri/data/MNI152_T1_2mm_brain_mask.nii.gz'
#out='/nafs/kcross/PROJECTS/Cueing_Noninvasive_Auditory/mri/data/preprocess/CM01/test_result'

#input_dir='/nafs/kcross/PROJECTS/Cueing_Noninvasive_Auditory/mri/data/preprocess2/CM01/MNINonLinear/Results/rest_AP_PA/'
input_dir='/nafs/kcross/PROJECTS/Cueing_Noninvasive_Auditory/mri/data/preprocess2/'
roi_dir='/nafs/kcross/PROJECTS/Cueing_Noninvasive_Auditory/mri/data/ROIs/'


module load anaconda/3.7
source /nafs/dtward/torch_venv/bin/activate

log_file="./environment.log"

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
files=$(find "$input_dir" -maxdepth 1 -type d -name 'CM*' -exec find {}/MNINonLinear/Results/rest_AP_PA/rest_AP_PA_hp2000.ica/  -type f -name '*filtered_func_data_clean.nii.gz' \;)
#files=$(find "$input_dir" -type d -name 'CM*' -exec find {}'CM*/MNINonLinear/Results/rest_AP_PA/rest_AP_PA_hp2000.ica/' -type f -name '*rest_AP_PA_hp2000_clean.nii.gz' \;)

#find . -type d -name 'CM*' -exec find {} -type f -name '*rest_AP_PA_hp2000_clean.nii.gz' \;
if [ -d "$roi_dir" ]; then
    # Use find to get a list of files directly in the directory (not in subdirectories)
  roi_files=$(find "$roi_dir" -maxdepth 1 -type f)
fi
# Loop through each file and run congrads
for input_file in $files; do
  # Check if the directory exists
  # Loop over files
  for roi_file in $roi_files; do
      # Call the congrad function with the current file as input
    job_start_time=$(date +"%Y-%m-%d %H:%M:%S")
    echo "Job started for $input_file at $job_start_time" >> "$log_file"
    echo "Job started for $input_file at $job_start_time" >> "$error_log"

    cm_subdirectory=$(echo "$input_file" | grep -oP '/CM[^/]+/')
    cm_subdirectory=${cm_subdirectory//\//}  # Remove slashes

    # Extract the filename (excluding extension) from the full path
    filename=$(basename "$roi_file")
    filename_noext="${filename%.*}"  # Remove the extension

    # Construct the output directory based on the filename
    out_dir="/nafs/kcross/PROJECTS/Cueing_Noninvasive_Auditory/mri/data/preprocess/$cm_subdirectory/$filename_noext"
    mkdir -p "$out_dir"
    ./congrads -i "$input_file" -r "$roi_file" -m "$mask" -o "$out_dir" -s -p -f 2 2>> "$error_log"
  done
done