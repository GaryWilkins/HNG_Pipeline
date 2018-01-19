#!/bin/bash
#SBATCH -n 1
#SBATCH -t 1:00:00

module add python/3.5.1
make -f /proj/hng/hng_pipeline/Top_Level_Pass.mk GROUP_SWITCH= PROJECT_HOME_local= CONTROL_PANEL=
