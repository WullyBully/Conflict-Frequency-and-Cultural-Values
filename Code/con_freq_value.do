** Set directory and open a log file, and load in merged dataset.**
cd "C:\Users\Brady\Dropbox\Econometrics\Conflict Frequency and Cultural Values"
log using "con_freq_value_actual.smcl", replace
use "Datasets\sub_con_m_origin"

** Reorder and sort data for easier readability.**
order index country conflict_duration

** Further clean data for model building.**

* Drop missing or unusable Survey Answers.
replace Q1 = . if Q1 < 0
replace Q176 = . if Q176 < 0
replace Q179 = . if Q179 < 0
replace Q191 = . if Q191 < 0
replace Q194 = . if Q194 < 0
replace Q262 = . if Q262 < 0

* Create some dummy variables.
gen low_inc = (incomeWB == 1)
gen lmiddle_inc = (incomeWB == 2)
gen umiddle_inc = (incomeWB == 3)
gen upper_inc = (incomeWB == 4)

** Summary Statistics **
tab Q1
tab Q176
tab Q179
tab Q191
tab Q194
sum Q262
tab incomeWB
sum conflict_duration

** Generate Models **
* First models are based on conflict duration of current country
* Question 1 - Is Family Important 1 = Very important 4 = Not important
ologit Q1 conflict_duration corrupttransp militaryexp educationexp low_inc  lmiddle_inc upper_inc Q262, robust

* Question 176 - Trouble deciding which morals are right ones to follow? 1 = completely agree 10 = completely disagree
ologit Q176 conflict_duration corrupttransp militaryexp educationexp low_inc  lmiddle_inc upper_inc Q262, robust

* Question 179 - Is stealing property justifialbe 1 = never 10 = always
ologit Q179 conflict_duration corrupttransp militaryexp educationexp low_inc  lmiddle_inc upper_inc Q262, robust

* Question 191 - Violence against other people 1 = never, 10 = always
ologit Q191 conflict_duration corrupttransp militaryexp educationexp low_inc  lmiddle_inc upper_inc Q262, robust

* Question 194 - Political Violence 1 = Never 10 = always
ologit Q194 conflict_duration corrupttransp militaryexp educationexp low_inc  lmiddle_inc upper_inc Q262, robust

log close

translate "con_freq_value_actual.smcl" "con_freq_value_actual.pdf",translator (smcl2pdf) replace