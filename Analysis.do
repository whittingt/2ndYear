clear all
use consolidata

table metroCat, statistic(m DivisionElec DivisionGas DivisionOil) statistic(freq) nformat(%09.3gc) //Can also add metro prices, but it looked bad
collect export metros.tex, tableonly replace
estpost sum energyAmt elecamt gasamt oilamt emit elecVolDiv gasVolDiv oilVolDiv
esttab . using DescriptEnergy, cells("mean sd min max") tex replace
outreg2 using DescriptEnergy2, sum(log) keep(energyAmt elecamt gasamt oilamt emit elecVolDiv gasVolDiv oilVolDiv) tex(frag pr) eqdrop(N) addn("n=28,176 for all values") ti("Summary Statistics for Dependent Variables") label replace
// estpost sum age unitsizeNumb numpeople numelders hincp hhage marketval totrooms attached if unitsizeCat>=1
// esttab . using covariates, cells("count mean sd min max") tex replace
outreg2 using covariates, sum(log) replace keep(age numpeople numelders hincp hhage marketval totrooms attached) tex(frag pr) label ti("Summary Statistics for Covariates") addn("n=28,176 for all values") eqdrop(N) //Resolve how to show unitsize
*estpost tab metroCat
*esttab . using metros, cells("b pct") tex replace
estpost tab decadebuilt
esttab . using decades, cells("b pct") collabels("Count" "Pct.") tex replace


xtset metro
// *Linear Models (Unnecessary?)
// xtreg energyAmt age i.unitsizeCat numpeople numelders linc hhage lnMarkVal totrooms attached, fe vce(robust)
// est sto energyExp
// xtreg gasamt age i.unitsizeCat numpeople numelders linc hhage lnMarkVal totrooms attached, fe vce(robust)
// est sto gasExp
// xtreg elecamt age i.unitsizeCat numpeople numelders linc hhage lnMarkVal totrooms attached, fe vce(robust)
// est sto elecExp
// xtreg oilamt age i.unitsizeCat numpeople numelders linc hhage lnMarkVal totrooms attached, fe vce(robust)
// est sto oilExp
// outreg2 using expendituresLin.tex, tex(frag pr) label ti("Energy Expenditures: Variance by Decade of Construction") replace

*Binned (Primary) Models
xtreg energyAmt i.decadebuilt i.unitsizeCat numpeople numelders linc hhage lnMarkVal totrooms attached, fe
test 1920.decadebuilt 1930.decadebuilt 1940.decadebuilt 1950.decadebuilt 1960.decadebuilt 1970.decadebuilt 1980.decadebuilt 1990.decadebuilt 2000.decadebuilt 2010.decadebuilt
est sto energyExpBin
outreg2 using expendituresBin.tex, tex(frag pr) keep(1920.decadebuilt 1930.decadebuilt 1940.decadebuilt 1950.decadebuilt 1960.decadebuilt 1970.decadebuilt 1980.decadebuilt 1990.decadebuilt 2000.decadebuilt 2010.decadebuilt) label ti("Energy Expenditures Decade of Construction") replace
xtreg gasamt i.decadebuilt i.unitsizeCat numpeople numelders linc hhage lnMarkVal totrooms attached, fe vce(robust)
est sto gasExpBin
outreg2 using expendituresBin.tex, tex(frag pr) keep(1920.decadebuilt 1930.decadebuilt 1940.decadebuilt 1950.decadebuilt 1960.decadebuilt 1970.decadebuilt 1980.decadebuilt 1990.decadebuilt 2000.decadebuilt 2010.decadebuilt) label append
xtreg elecamt i.decadebuilt i.unitsizeCat numpeople numelders linc hhage lnMarkVal totrooms attached, fe vce(robust)
est sto elecExpBin
outreg2 using expendituresBin.tex, tex(frag pr) keep(1920.decadebuilt 1930.decadebuilt 1940.decadebuilt 1950.decadebuilt 1960.decadebuilt 1970.decadebuilt 1980.decadebuilt 1990.decadebuilt 2000.decadebuilt 2010.decadebuilt) label append
xtreg oilamt i.decadebuilt i.unitsizeCat numpeople numelders linc hhage lnMarkVal totrooms attached, fe vce(robust)
est sto oilExpBin
outreg2 using expendituresBin.tex, tex(frag pr) keep(1920.decadebuilt 1930.decadebuilt 1940.decadebuilt 1950.decadebuilt 1960.decadebuilt 1970.decadebuilt 1980.decadebuilt 1990.decadebuilt 2000.decadebuilt 2010.decadebuilt) label append

xtreg heatpump i.decadebuilt i.unitsizeCat numpeople numelders linc hhage lnMarkVal totrooms attached, fe
xtreg energyAmt heatpump i.decadebuilt i.unitsizeCat numpeople numelders linc hhage lnMarkVal totrooms attached, fe
xtreg energyAmt heatpump i.unitsizeCat numpeople numelders linc hhage lnMarkVal totrooms attached, fe


*esttab energyExp energyExpBin using PrimarySpec, tex replace noomit drop(1919.decadebuilt numelders linc totrooms attached) star(* 0.10 ** 0.05 *** 0.01) mti("Energy Exp" "Energy Exp")
*esttab energyExp energyExpBin using PrimarySpecControls, tex replace noomit drop(*decadebuilt) star(* 0.10 ** 0.05 *** 0.01) mti("Energy Exp" "Energy Exp")
*esttab gasExpBin gasExp elecExpBin elecExp oilExpBin oilExp using Decomposition, tex replace noomit drop(1919.decadebuilt numelders linc totrooms attached) star(* 0.10 ** 0.05 *** 0.01)
coefplot (energyExpBin, label(Total)) (gasExpBin, label(Gas)) (elecExpBin, label(Electricity)) (oilExpBin, label(Oil)), keep(*decadebuilt) xtitle(Decade Built)  yline(0) vert xlabel(1 "1920s" 2 "1930s" 3 "1940s" 4 "1950s" 5 "1960s" 6 "1970s" 7 "1980s" 8 "1990s" 9 "2000s" 10 "2010s") ytitle("Change in Monthly Expenditure (US$)") scheme(s1mono) legend(c(4)) ti("Energy Expenditure by Decade of Construction") xscale(titlegap(*3))
graph export ExpGraph.png, replace

*Volume Models
*Deprecated Linear Age Models
// xtreg gasVolDiv age unitsizeNumb numpeople numelders linc hhage lnMarkVal totrooms attached, fe 
// est sto GasTherms
// xtreg elecVolDiv age unitsizeNumb numpeople numelders linc hhage lnMarkVal totrooms attached, fe 
// est sto elecKWH
// xtreg oilVolDiv age unitsizeNumb numpeople numelders linc hhage lnMarkVal totrooms attached, fe 
// est sto oilGallon


// *Absolute Models--Currently omitted from paper
// xtreg gasVolDiv i.decadebuilt i.unitsizeCat numpeople numelders linc hhage lnMarkVal totrooms attached, fe vce(robust)
// est sto GasThermsBins
// outreg2 using absVolumesBin.tex, tex(frag pr) label ti("Energy Usage: Variance by Age") replace keep(1920.decadebuilt 1930.decadebuilt 1940.decadebuilt 1950.decadebuilt 1960.decadebuilt 1970.decadebuilt 1980.decadebuilt 1990.decadebuilt 2000.decadebuilt 2010.decadebuilt)
// xtreg elecVolDiv i.decadebuilt i.unitsizeCat numpeople numelders linc hhage lnMarkVal totrooms attached, fe vce(robust)
// est sto elecKWHBins
// outreg2 using absVolumesBin.tex, tex(frag pr) label append keep(1920.decadebuilt 1930.decadebuilt 1940.decadebuilt 1950.decadebuilt 1960.decadebuilt 1970.decadebuilt 1980.decadebuilt 1990.decadebuilt 2000.decadebuilt 2010.decadebuilt)
// xtreg oilVolDiv i.decadebuilt i.unitsizeCat numpeople numelders linc hhage lnMarkVal totrooms attached, fe vce(robust)
// est sto oilGallonBins
// outreg2 using absVolumesBin.tex, tex(frag pr) label append keep(1920.decadebuilt 1930.decadebuilt 1940.decadebuilt 1950.decadebuilt 1960.decadebuilt 1970.decadebuilt 1980.decadebuilt 1990.decadebuilt 2000.decadebuilt 2010.decadebuilt)
// xtreg totalBTU i.decadebuilt i.unitsizeCat numpeople numelders linc hhage lnMarkVal totrooms attached, fe vce(robust)
// outreg2 using absVolumesBin.tex, tex(frag pr) label append keep(1920.decadebuilt 1930.decadebuilt 1940.decadebuilt 1950.decadebuilt 1960.decadebuilt 1970.decadebuilt 1980.decadebuilt 1990.decadebuilt 2000.decadebuilt 2010.decadebuilt)
// // esttab GasTherms elecKWH oilGallon using VolumeSpec, tex replace noomit star(* 0.10 ** 0.05 *** 0.01)

*Fractional Models (Note 5/21: Need to clean up tables: remove unitsizeCat: it's ugly as sin)
xtreg gaspct i.decadebuilt i.unitsizeCat numpeople numelders linc hhage lnMarkVal totrooms attached, fe vce(robust)
est sto GasThermsBinspct
outreg2 using relVolumesBin.tex, tex(frag pr) label replace keep(1920.decadebuilt 1930.decadebuilt 1940.decadebuilt 1950.decadebuilt 1960.decadebuilt 1970.decadebuilt 1980.decadebuilt 1990.decadebuilt 2000.decadebuilt 2010.decadebuilt) ti("Change in Energy Usage as a Fraction of Average and Resulting Emissions by Decade of Construction")
xtreg elecpct i.decadebuilt i.unitsizeCat numpeople numelders linc hhage lnMarkVal totrooms attached, fe vce(robust)
est sto elecKWHBinspct
outreg2 using relVolumesBin.tex, tex(frag pr) label append keep(1920.decadebuilt 1930.decadebuilt 1940.decadebuilt 1950.decadebuilt 1960.decadebuilt 1970.decadebuilt 1980.decadebuilt 1990.decadebuilt 2000.decadebuilt 2010.decadebuilt)
xtreg oilpct i.decadebuilt i.unitsizeCat numpeople numelders linc hhage lnMarkVal totrooms attached, fe vce(robust)
est sto oilGallonBinspct
outreg2 using relVolumesBin.tex, tex(frag pr) label append keep(1920.decadebuilt 1930.decadebuilt 1940.decadebuilt 1950.decadebuilt 1960.decadebuilt 1970.decadebuilt 1980.decadebuilt 1990.decadebuilt 2000.decadebuilt 2010.decadebuilt)
xtreg BTUpct i.decadebuilt i.unitsizeCat numpeople numelders linc hhage lnMarkVal totrooms attached, fe vce(robust)
est sto BTUBinspct
outreg2 using relVolumesBin.tex, tex(frag pr) label append keep(1920.decadebuilt 1930.decadebuilt 1940.decadebuilt 1950.decadebuilt 1960.decadebuilt 1970.decadebuilt 1980.decadebuilt 1990.decadebuilt 2000.decadebuilt 2010.decadebuilt)


*esttab GasThermspct elecKWHpct oilGallonpct using VolumeSpecpct, tex replace noomit star(* 0.10 ** 0.05 *** 0.01) keep(*decadebuilt)
coefplot (BTUBinspct, label(BTUs) msymbol(O)) (GasThermsBinspct, label(Gas) msymbol(D)) (elecKWHBinspct, label(Electricity) msymbol(T)) (oilGallonBinspct, label(Oil) msymbol(S)), keep(*decadebuilt) xtitle(Decade Built)  yline(0) vert xlabel(1 "1920s" 2 "1930s" 3 "1940s" 4 "1950s" 5 "1960s" 6 "1970s" 7 "1980s" 8 "1990s" 9 "2000s" 10 "2010s") ytitle("Change in volume used/average") scheme(s1mono) legend(c(4)) ti("Energy Usage by Decade of Construction") xscale(titlegap(*3))
graph export ExpPctGraph.png, replace

*SocialCosts
*xtreg emit age i.unitsizeCat numpeople numelders linc hhage lnMarkVal totrooms attached, fe 
*eststo Emissions
xtreg emit i.decadebuilt i.unitsizeCat numpeople numelders linc hhage lnMarkVal totrooms attached, fe vce(robust)
est sto EmissionsBin
outreg2 using relVolumesBin.tex, tex(frag pr) label append keep(1920.decadebuilt 1930.decadebuilt 1940.decadebuilt 1950.decadebuilt 1960.decadebuilt 1970.decadebuilt 1980.decadebuilt 1990.decadebuilt 2000.decadebuilt 2010.decadebuilt)
xtreg emitMROE i.decadebuilt i.unitsizeCat numpeople numelders linc hhage lnMarkVal totrooms attached, fe vce(robust)
est sto MROE
xtreg emitNYUP i.decadebuilt i.unitsizeCat numpeople numelders linc hhage lnMarkVal totrooms attached, fe vce(robust)
est sto NYUP
xtreg emitZero i.decadebuilt i.unitsizeCat numpeople numelders linc hhage lnMarkVal totrooms attached, fe vce(robust)
est sto Zero
*esttab EmissionsBin Emissions using Emissions, tex replace noomit drop(1919.decadebuilt *.unitsizeCat numpeople numelders linc hhage lnMarkVal totrooms attached) star(* 0.10 ** 0.05 *** 0.01) mti(Emissions Emissions)
coefplot (EmissionsBin, label(Current Emissions))  (NYUP, label(Low Emissions)) (Zero, label(0 Emissions)) (MROE, label(High Emissions)), keep(*decadebuilt) xtitle(Decade Built)  yline(0) vert xlabel(1 "1920s" 2 "1930s" 3 "1940s" 4 "1950s" 5 "1960s" 6 "1970s" 7 "1980s" 8 "1990s" 9 "2000s" 10 "2010s") ytitle("Change in monthly emissions (metric tons)") scheme(s1mono) legend(c(4)) ti("Carbon Dioxide Emissions by Decade of Construction") xscale(titlegap(*3))
graph export Emissions.png, replace

*keep energyAmt elecamt gasamt oilamt age unitsizeNumb numpeople numelders linc hhage lnMarkVal totrooms
sum energyAmt elecamt gasamt oilamt age unitsizeCat numpeople numelders linc hhage lnMarkVal totrooms if unitsizeCat>=1