# This file is made available under a CC-BY-NC 4.0 International License.
# Details of the license can be found at
# <https://creativecommons.org/licenses/by-nc/4.0/legalcode>. 
# 
# Giving appropriate credit includes citation of the related publication and
# providing a link to the repository:
# 
# Citation: Pulliam, JRC, C van Schalkwyk, N Govender, A von Gottberg, C 
# Cohen, MJ Groome, J Dushoff, K Mlisana, and H Moultrie. (2022) Increased
# risk of SARS-CoV-2 reinfection associated with emergence of Omicron in
# South Africa. _Science_ <https://www.science.org/doi/10.1126/science.abn4947>
# 
# Repository: <https://github.com/jrcpulliam/reinfections>

R = Rscript $^ $@

### DATA PREPARATION (create RDS / RData files for analysis / plotting
### from CSV files provided)

data/ts_data_for_analysis.RDS: code/prep_ts_data.R data/ts_data.csv pub.json
	${R}

data/demog_data_for_display.RData: code/prep_demog_data.R data/demog_data.csv
	${R}

all_data: data/ts_data_for_analysis.RDS data/demog_data_for_display.RData

### UTILITIES

utils/sessionInfo.RDS: code/install.R
	${R}

utils/emp_haz_fxn.RDS: code/empirical_hazard_fxn.R
	${R}

utils/fit_fxn_null.RData: code/fit_fxn_null.R
	${R}

utils/plotting_fxns.RData: code/plotting_fxns.R
	${R}

utils/wave_defs.RDS: code/wave_defs.R data/ts_data_for_analysis.RDS pub.json
	${R}

all_utils: utils/sessionInfo.RDS utils/plotting_fxns.RData utils/emp_haz_fxn.RDS \
utils/fit_fxn_null.RData utils/plotting_fxns.RData utils/wave_defs.RDS

### DESCRIPTIVE ANALYSIS

# Figure 1
output/ts_plot.RDS output/ts_plot.png: code/ts_plot.R data/ts_data_for_analysis.RDS \
utils/wave_defs.RDS utils/plotting_fxns.RData
	${R}

# Figure S1 and S2 (panel A)
output/demog_plot.RDS output/demog_plot.png: code/demog_plot.R \
data/demog_data_for_display.RData
	${R}

### APPROACH 1

# NOTE: This will overwrite the version of output/posterior_90_null.RData
# downloaded from Zenodo. Change test.json to pub.json to do a full run.
output/posterior_90_null.RData: code/mcmc_fit.R data/ts_data_for_analysis.RDS \
utils/fit_fxn_null.RData test.json
	${R}

# NOTE: This will overwrite the version of output/sim_90_null.RDS
# downloaded from Zenodo. Change test.json to pub.json to do a full run.
output/sim_90_null.RDS: code/sim_null.R output/posterior_90_null.RData \
data/ts_data_for_analysis.RDS utils/fit_fxn_null.RData test.json
	${R}

sim_out: output/posterior_90_null.RData output/sim_90_null.RDS

# NOTE: Change test.json to pub.json to run simulations for full posterior.
# This script only runs 1 simulation per parameter set due to long computational
# time (ignores n_sims_per_param defined in the json configuration files).
output/sim_90_null_dyn.RDS: code/sim_null_dyn.R output/posterior_90_null.RData \
data/ts_data_for_analysis.RDS utils/fit_fxn_null.RData test.json
	${R}

# Figure 4
output/sim_plot.RDS output/sim_plot.png: code/sim_plot.R output/sim_90_null.RDS \
data/ts_data_for_analysis.RDS pub.json utils/plotting_fxns.RData
	${R}

# Figure S4
output/convergence_plot.RDS output/convergence_plot.png: code/convergence_plot.R \
output/posterior_90_null.RData pub.json
	${R}

### APPROACH 2

output/reconstructed_dat_for_reg.RDS: code/reconstruct_data_for_reg.R \
data/ts_data_for_analysis.RDS utils/emp_haz_fxn.RDS pub.json utils/wave_defs.RDS
	${R}

output/reg_out.RDS: code/reg_out.R output/reconstructed_dat_for_reg.RDS
	${R}

reg_out: output/reconstructed_dat_for_reg.RDS output/reg_out.RDS

output/emp_haz_sens_an.RDS: code/sens_an.R data/ts_data_for_analysis.RDS \
utils/emp_haz_fxn.RDS pub.json utils/wave_defs.RDS
	${R}

# Figure 5
output/emp_haz_plot.RDS output/emp_haz_plot.png: code/emp_haz_plot.R \
data/ts_data_for_analysis.RDS utils/emp_haz_fxn.RDS pub.json utils/wave_defs.RDS \
utils/plotting_fxns.RData
	${R}

# Figure S8
output/emp_haz_sens_an_plot.RDS output/emp_haz_sens_an_plot.png: \
code/sens_an_plot.R output/emp_haz_sens_an.RDS \
utils/emp_haz_fxn.RDS pub.json utils/wave_defs.RDS
	${R}

### PLOTS

all_plots: output/ts_plot.png output/demog_plot.png output/sim_plot.png \
output/emp_haz_plot.png output/convergence_plot.png output/emp_haz_sens_an_plot.png