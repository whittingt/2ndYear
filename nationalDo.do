clear all

cd "C:\Users\whittington.100\OneDrive - The Ohio State University\Documents\2ndYearPaper"

use fullData

*Based on RECS assumptions, setting an average for each bin in AHS (NOTE: THIS IS REALLY STUPID AND I NEED A BETTER APPROACH FOR THIS NOTe 5/21: Using a binned version, but haven't removed references to earlier variable)
gen unitsizeNumb=394 if unitsize=="'1'"
replace unitsizeNumb=642 if unitsize=="'2'"
replace unitsizeNumb=878 if unitsize=="'3'"
replace unitsizeNumb=1238 if unitsize=="'4'"
replace unitsizeNumb=1749 if unitsize=="'5'"
replace unitsizeNumb=2236 if unitsize=="'6'"
replace unitsizeNumb=2730 if unitsize=="'7'"
replace unitsizeNumb=3434 if unitsize=="'8'"
replace unitsizeNumb=5304 if unitsize=="'9'"
encode(unitsize), gen(unitsizeCat)

*Rename Key Variables
gen heatfuelName="Electricity" if heatfuel=="'01'"
replace heatfuelName="PipeGas" if heatfuel=="'02'"
replace heatfuelName="LiqGas" if heatfuel=="'03'"
replace heatfuelName="Oil" if heatfuel=="'04'"
replace heatfuelName="Kerosene" if heatfuel=="'05'"
replace heatfuelName="Coal" if heatfuel=="'06'"
replace heatfuelName="Wood" if heatfuel=="'07'"
replace heatfuelName="Solar" if heatfuel=="'08'"
replace heatfuelName="Other" if heatfuel=="'09'"
replace heatfuelName="None" if heatfuel=="'10'"
encode heatfuelName, gen(heatfuelCat)

gen heattypeName="forceFurn" if heattype=="'01'"
replace heattypeName="SteamWater" if heattype=="'02'"
replace heattypeName="HeatPump" if heattype=="'03'"
replace heattypeName="ElecResist" if heattype=="'04'"
replace heattypeName="PipelessFurn" if heattype=="'05'"
replace heattypeName="RoomHeat" if heattype=="'06'" | heattype=="'07'"
replace heattypeName="PortElecHeat" if heattype=="'08'"
replace heattypeName="WoodStove" if heattype=="'09'"
replace heattypeName="FirePlace" if heattype=="'10'" | heattype=="'11'"
replace heattypeName="None" if heattype=="'13'"
replace heattypeName="Other" if heattype=="'12'"
replace heattypeName="Cookstove" if heattype=="'14'"
encode heattypeName, gen(heattypeCat)

gen divisionName="NewEngland" if division=="'1'"
replace divisionName="MidAtlantic" if division=="'2'"
replace divisionName="ENCentral" if division=="'3'"
replace divisionName="WNCentral" if division=="'4'"
replace divisionName="SAtlantic" if division=="'5'"
replace divisionName="ESCentral" if division=="'6'"
replace divisionName="WSCentral" if division=="'7'"
replace divisionName="Mountain" if division=="'8'"
replace divisionName="Pacific" if division=="'9'"
replace division="'7'" if omb13cbsa=="'41700'"|omb13cbsa=="'36420'"
replace division="'8'" if omb13cbsa=="'29820'"
replace division="'9'" if omb13cbsa=="'41940'"
replace division="'2'" if omb13cbsa=="'40380'"
replace division="'4'" if omb13cbsa=="'33460'"
replace division="'5'" if omb13cbsa=="'40060'"|omb13cbsa=="'12580'"|omb13cbsa=="'45300'"
replace division="'6'" if omb13cbsa=="'13820'"
gen DivisionCode=usubinstr(division, "'","",.)
merge m:1 DivisionCode using pricedataDivision
rename _merge merge1
encode(divisionName), gen(divisionCat)
rename Value1 DivisionElec
rename Value2 DivisionGas
rename Value3 DivisionOil
drop Year


gen metro2 = substr(omb13cbsa, 2, length(omb13cbsa) - 2)
destring metro2, gen(MetroCode)
merge m:1 MetroCode using "priceDataMetro.dta"
rename Value1 metroElecPrice
rename Value2 metroGasPrice
*Metro Oil prices are not available. There are state level, but who are we kidding
gen metroName="Atlanta" if omb13cbsa=="'12060'"
replace metroName="Baltimore" if omb13cbsa=="'12580'"
replace metroName="Birmingham" if omb13cbsa=="'13820'"
replace metroName="Boston" if omb13cbsa=="'14460'"
replace metroName="Chicago" if omb13cbsa=="'16980'"
replace metroName="Dallas" if omb13cbsa=="'19100'"
replace metroName="Detroit" if omb13cbsa=="'19820'"
replace metroName="Houston" if omb13cbsa=="'26420'"
replace metroName="Las Vegas" if omb13cbsa=="'29820'"
replace metroName="Los Angeles" if omb13cbsa=="'31080'"
replace metroName="Miami" if omb13cbsa=="'33100'"
replace metroName="Minneapolis" if omb13cbsa=="'33460'"
replace metroName="NYC" if omb13cbsa=="'35620'"
replace metroName="Oklahoma City" if omb13cbsa=="'36420'"
replace metroName="Philadelphia" if omb13cbsa=="'37980'"
replace metroName="Phoenix" if omb13cbsa=="'38060'"
replace metroName="Richmond" if omb13cbsa=="'40060'"
replace metroName="Inland Empire" if omb13cbsa=="'40140'"
replace metroName="Rochester" if omb13cbsa=="'40380'"
replace metroName="San Antonio" if omb13cbsa=="'41700'"
replace metroName="San Francisco" if omb13cbsa=="'41860'"
replace metroName="San Jose" if omb13cbsa=="'41940'"
replace metroName="Seattle" if omb13cbsa=="'42660'"
replace metroName="Tampa" if omb13cbsa=="'45300'"
replace metroName="Washington" if omb13cbsa=="'47900'"
encode metroName, gen(metroCat)

encode omb13cbsa, gen(metro)
encode bld, gen(building)
gen decadebuilt=yrbuilt
replace decadebuilt=2010 if yrbuilt>=2010
gen linc=log(hincp+1)
gen age=2021-yrbuilt
gen energyAmt=gasamt+elecamt+oilamt
gen lnMarkVal=log(marketval+1)
gen logAmt=log(energyAmt)

save "consolidata.dta", replace


// *Dropping the stuff I haven't figured out what to do with yet
// drop if omb13cbsa=="'99999'" | omb13cbsa=="'99998'"
// drop if tenure!="'1'"