#!/bin/bash

#SBATCH -A afield6_gpu
#SBATCH --partition a100
#SBATCH --gres=gpu:1
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --time=12:00:00
#SBATCH --qos=qos_gpu
#SBATCH --job-name="ser_experiment"
#SBATCH --output="result.txt" # Path to store logs

module load anaconda
module load cuda/11.6.0

### init virtual environment if needed
#conda create -n ser_experiment python=3.7

### see the other environments
# conda info --envs

conda activate ser_experiment
#pip install -r requirements.txt
source .env
pip install pytorch-lightning
pip install matplotlib

# run IEMOCAP
#cd Dataset/IEMOCAP
#srun python make_16k.py $IEMOCAP_DIR
#srun python gen_meta_label.py $IEMOCAP_DIR
#srun python generate_labels_sessionwise.py
#cd ../..

# P-TAPT: 
srun bash bin/run_exp_iemocap.sh Dataset/IEMOCAP/Audio_16k/ Dataset/IEMOCAP/labels_sess/label_{$SESSION_TO_TEST}.json $OUTPUT_DIR $GPU_ID P-TAPT $NUM_EXPS $WAV2VEC_CKPT_PATH
#TAPT: datadir, labelpath, savingpath, GPUid, outputname, numexps
srun bash bin/run_exp_iemocap_baseline.sh Dataset/IEMOCAP/Audio_16k/ Dataset/IEMOCAP/labels_sess/label_{$SESSION_TO_TEST}.json $OUTPUT_DIR $GPU_ID TAPT $NUM_EXPS
#V-FT: 
srun bash bin/run_exp_iemocap_vft.sh Dataset/IEMOCAP/Audio_16k/ Dataset/IEMOCAP/labels_sess/label_{$SESSION_TO_TEST}.json $OUTPUT_DIR $GPU_ID V-FT $NUM_EXPS
