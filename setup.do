clear all
use consolidata

// *Some fiddling around. More to do.
// tab unitsizeNumb
// scatter unitsizeNumb gasamt
// scatter unitsizeNumb gasamt, by(heatfuel)
// *replace yrbuilt=yrbuilt-1900
*encode heattype, gen(heatTech)
drop if omb13cbsa=="'99999'" | omb13cbsa=="'99998'"
drop if tenure!="'1'"
//drop if missing(unitsizeNum)
gen elecVolAlt=elecamt/metroElecPrice
gen gasVolAlt=gasamt/metroGasPrice
gen oilVolAlt=oilamt/3.58*(metroElecPrice/metroElecPrice) //Oil prices?

gen elecVolDiv=elecamt/DivisionElec
gen gasVolDiv=gasamt/DivisionGas
gen oilVolDiv=oilamt/DivisionOil
replace oilVolDiv=oilamt/3.82 if oilVolDiv==.

drop if oilamt<0 //only one of these
drop if elecamt>0 & elecamt<4
drop if gasamt>0 & gasamt<4
drop if oilamt>0 & oilamt<4
//drop if marketval>99999990
//drop if unitsize=="'-9'"

gen elecEmit=elecVolDiv*.000417
gen elecEmitNYUP=elecVolDiv*0.000125
gen elecEmitZero=elecVolDiv*0
gen elecEmitMROE=elecVolDiv*0.000671
gen gasEmit=gasVolDiv*.0053 //52.91 kg per million BTU (or 10 therm): 52.91/1000/10 (tons/therms)
gen oilEmit=oilVolDiv*10.19*1.2/1000
gen emit=elecEmit+gasEmit+oilEmit
gen emitNYUP=elecEmitNYUP+gasEmit+oilEmit
gen emitZero=elecEmitZero+gasEmit+oilEmit
gen emitMROE=elecEmitMROE+gasEmit+oilEmit
gen SCC=50*emit
gen attached=1
replace attached=0 if bld=="'01'" | bld=="'02'"
gen heatpump=0
replace heatpump=1 if heattype=="'03'"
gen elecheat=0
replace elecheat=1 if heatfuel=="'01'"

gen elecBTU=elecVolDiv*3412
gen gasBTU=gasVolDiv*100000
gen oilBTU=oilVolDiv*138500
gen totalBTU=gasBTU+oilBTU+elecBTU

gen elecpct=elecVolDiv/899.21 //These are supposed to be here
gen gaspct=gasVolDiv/34.1775
gen oilpct=oilVolDiv/1.56
gen BTUpct=totalBTU/6703106

gen urbanPremiumElec=metroElecPrice-DivisionElec
gen urbanPremiumGas=metroGasPrice-DivisionGas


label var decadebuilt "Decade Built"
label var emit "Emissions"
label var DivisionElec "Electricity Price (KWh)"
label var DivisionElec "Electricity Price (KWh)"
label var DivisionGas "Gas Price (Therm)"
label var DivisionOil "Oil Price (Gallon)"
label var unitsizeNumb "Unit Size (sqft)"
label var numpeople "HH Size (People)"
label var hhage "Age of HH Head"
label var lnMarkVal "Home Market Value (log)"
label var linc "Household Income (log)"
label var numelders "Number of 65+ in HH"
label var attached "1= Attached Home"
label var totrooms "Rooms in Home" 
label var energyAmt "Total Energy Expediture"
label var gasamt "NG Expenditure"
label var oilamt "Oil Expenditure"
label var elecamt "Electricity Expenditures"
label var hincp "Household Income"
label var marketval "Home Market Value"
label var age "Home Age"
label var metroElecPrice "Metro Electric Price (KWh)"
label var metroGasPrice "Metro Gas Price (Therms)"
label var elecVolDiv "Monthly Electricity Usage (KWh)"
label var gasVolDiv "Monthly Gas Usage (Therms)"
label var oilVolDiv "Monthly Oil Usage (Gallons)"
label var totalBTU "Monthly Energy Usage (BTU)"

save "consolidata.dta", replace