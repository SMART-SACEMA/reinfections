# This file is made available under a CC-BY-NC 4.0 International License.
# Details of the license can be found at
# <https://creativecommons.org/licenses/by-nc/4.0/legalcode>. 
# 
# Giving appropriate credit includes citation of the related publication and
# providing a link to the repository:
# 
# Citation: Pulliam, JRC, C van Schalkwyk, N Govender, A von Gottberg, C Cohen,
# MJ Groome, J Dushoff, K Mlisana, and H Moultrie. (2021) _SARS-CoV-2 reinfection
# trends in South Africa: analysis of routine surveillance data_. _medRxiv_
# <https://www.medrxiv.org/content/10.1101/2021.11.11.21266068>
# 
# Repository: <https://github.com/jrcpulliam/reinfections>

R = Rscript $^ $@
Rstar = Rscript $^ $* $@

### DATA PREPARATION (create RDS / RData files for analysis / plotting
### from CSV files provided)

data/ts_data_for_analysis.RDS: code/prep_ts_data.R data/ts_data.csv pub.json
	${R}

data/demog_data.RData: code/prep_demog_data.R data/demog_data.csv
	${R}

all_data: data/ts_data_for_analysis.RDS data/demog_data.RData

### UTILITY FUNCTIONS

utils/emp_haz_fxn.RDS: code/empirical_hazard_fxn.R
	${R}

utils/fit_fxn_null.RData: code/fit_fxn_null.R
	${R}

utils/plotting_fxns.RData: code/plotting_fxns.R
	${R}

utils/wave_defs.RDS: code/wave_defs.R data/ts_data_for_analysis.RDS pub.json
	${R}

all_utils: utils/plotting_fxns.RData utils/emp_haz_fxn.RDS \
utils/fit_fxn_null.RData utils/plotting_fxns.RData utils/wave_defs.RDS

### DESCRIPTIVE ANALYSIS

# TO BE ADDED

### APPROACH 1

# TO BE ADDED

### APPROACH 2

# TO BE ADDED

