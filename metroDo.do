clear all
cd "C:\Users\whittington.100\OneDrive - The Ohio State University\Documents\2ndYearPaper"

import delimited "C:\Users\whittington.100\OneDrive - The Ohio State University\Documents\2ndYearPaper\AHS 2021 Metropolitan PUF v1.0 CSV\household.csv"

global metroList `r(varlist)'
save "metro.dta", replace

clear all
import delimited "C:\Users\whittington.100\OneDrive - The Ohio State University\Documents\2ndYearPaper\AHS 2021 National PUF v1.0 CSV\household.csv"

save "national.dta", replace
use national
append using metro

drop sp2re*
drop sp1re*
drop j*
drop repweig*

save "fullData.dta", replace

