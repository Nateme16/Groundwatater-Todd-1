/* 

------------------------
VISUALLY-WEIGHTED LOWESS -----------------------------------------
------------------------

S. HSIANG
SHSIANG@PRINCETON.EDU
6/2012

------------------USAGE

vwlowess Y X, [COLORing(string) XTITle(string) YTITle(string) TITle(string)]

------------------DESCRIPTION

Plots lowess of Y vs X, using the sqrt of the kernel density as the color saturation.

------------------OPTIONS

	COLORing(color) - color of the ploted line, default = "black"
	XTITle(), YTITle, TITle - same as under usual scatter commands

------------------RELATED

	vwregress.m is a Matlab function that is similar in spirit, however the regression is 
	a Nadaray-Watson moving average, not lowess
	
------------------CITATION

	Solomon M. Hsiang, 2012 "Visually Weighted Regression", working paper

------------------EXAMPLE

clear
set more off
set obs 100
gen x=rnormal()
gen e = 1.5*(1 + x^2)*rnormal()
gen y = 1 + 6*x + 2*x^2 - x^3 + e 
vwlowess y x, color("black") title("Example from Hsiang (2010)")


*/

program vwlowess
version 11.2
syntax varlist(min=2 max=2 numeric ts) [if] [, COLORing(string) XTITle(string) YTITle(string) TITle(string)]


capture drop touse
marksample touse				// indicator for inclusion in the sample
gen touse = `touse'

loc y = word("`varlist'",1)		
loc x = word("`varlist'",2)

if "`coloring'" == ""{
	disp("no color specified, default is black")
	loc coloring "black"
} 

if "`xtitle'" == ""{
	loc xtitle "X"
} 

if "`ytitle'" == ""{
	loc ytitle "Y (lowess)"
} 


capture drop y_hat_vwl 
capture drop obs_id_vwl 
capture drop kd_x_vwl 
capture drop kd_d_vwl 
capture drop relative_color_vwl

sort `x'
gen obs_id_vwl = _n

//first, run lowess to generate predicted values
lowess `y' `x' if `touse', generate(y_hat_vwl) nograph 

//second, run kdensity to compute the observational density at each point
kdensity `x', generate(kd_x_vwl kd_d_vwl) at(x) nograph 


//--------AN ALTERNATIVE PLOTTING SCHEME THAT IS ALSO VISUALLY WEIGHTED (USING MARKER SIZE)
//tw (sc y_hat_vwl x [aweight = kd_d_vwl], mcolor(none) mlcolor(black))(line y_hat_vwl x, lcolor(black)), legend(lab(1 "observational density") lab(2 "lowess"))


//third, compute the color for each segment in the lowess plot
quietly: sum obs_id_vwl
loc obs_less_one = r(N)-1
quietly: sum kd_d_vwl
loc max_color = sqrt(r(max))
gen relative_color_vwl = sqrt(kd_d)/`max_color'

// generate a large plotting command
loc command_string "tw "

forvalues i = 1/`obs_less_one' {
	quietly{
	loc iplusone = `i'+ 1
	sum relative_color_vwl if obs_id_vwl >= `i' & obs_id_vwl <= `iplusone'
	loc segment_color = int(r(mean)*100)/100
	loc new_command "(line y_hat_vwl x if obs_id_vwl >= `i' & obs_id_vwl <= `iplusone', lcolor("`coloring'*`segment_color'"))"
	loc command_string "`command_string' `new_command'"
	}
}

loc command_string "`command_string' , legend(off) xtit(`xtitle') ytit(`ytitle') tit(`title') name(visually_weighted_lowess, replace) "

//finally, run the final plotting command
`command_string'

//cleaning up
capture drop y_hat_vwl obs_id_vwl kd_x_vwl kd_d_vwl relative_color_vwl

end

