import subprocess

# Example 1: Run a simple Bash command
script_path = "/nafs/kcross/PROJECTS/Cueing_Noninvasive_Auditory/mri/code/congrads/congrads"
result = subprocess.run(["bash", script_path], check=True, stdout=subprocess.PIPE, text=True)
print(result.stdout)

