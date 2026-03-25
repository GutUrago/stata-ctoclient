

*! version 1.0.0 20mar2026
*! Download SurveyCTO data via R (rcall)
*! Author: Gutama Girja Urago

cap program drop cto_form_data
program define cto_form_data
		version 12
		syntax, 							///
				SERVER(str) 				///
				USERname(str) 				///
				PASSword(str) 				///
				FORMid(str) 				///
				[KEY(str) 					///
				Date(real 946674000)		///
				Tidy(integer 1)				///
				Label(integer 1)			///
				Save(str)]

*--- 1. Dependency Check
	cap which rcall
	if _rc {
		display as result "{hline}"
		display as result "{bf:Dependency Check:}"
		display as text "Package {it:rcall} was not found on this system."
		display as text `"Source: {browse "https://github.com/haghish/rcall":haghish/rcall (GitHub)}"'
		display as text "{bf:Action}: Attempting automatic installation..."
		display as result "{hline}"
		cap which github
		if _rc net install github, from("https://haghish.github.io/github/")
		github install haghish/rcall, stable
	}

	qui rcall_check, r(4.1.0)
	
*--- 2. Format optional arguments and flags

	local lbl 		= cond(`label' == 1, 	"TRUE", "FALSE")
	local tdy 		= cond(`tidy' == 1, 	"TRUE", "FALSE")
	local enc 		= cond("`key'" != "", 	"TRUE", "FALSE")

	if "`key'" != "" {
		if !fileexists("`key'") {
			display as error "{hline}"
			display as error "{bf:ERROR: Private Key Not Found}"
			display as error "{hline}"
			display as text  "The file specified in {bf:key()} does not exist:"
			display as result `"{it:`key'}"'
			display as text  ""
			display as text  "Please check the file path and ensure the file is accessible."
			display as error "{hline}"
			exit 601
		}
		local key_path = subinstr("`key'", "\", "/", .)
		local key_path = subinstr("`key_path'", "//", "/", .)
	}
	
*--- 3. Use Stata wd for temporary downloads
	local wd = subinstr("`c(pwd)'", "\", "/", .)
	local dta_path = "`wd'/`formid'.dta"
	local do_path = "`wd'/`formid'.do"

*--- 4. Call R in vanilla mode
	rcall vanilla:																///
		pkgs <- c("ctoclient", "sjlabelled");									///
		loaded <- sapply(pkgs, function(pkg) require(pkg, quietly = TRUE, 		///
							character.only = TRUE)); 							///
		install.packages(pkgs[!loaded], quiet = TRUE, 							///
					repos = "https://cloud.r-project.org/");					///
		sapply(pkgs, function(pkg) require(pkg, quietly = TRUE, 				///
							character.only = TRUE));							///
		cto_connect("`server'", "`username'", "`password'");					///
		df <- if (`enc') {														///
			cto_form_data("`formid'", "`key_path'", as.POSIXct(`date'), 		///
			tidy = `tdy') 														///
			} else {															///
			cto_form_data("`formid'", NULL, as.POSIXct(`date'),	tidy = `tdy') 	///
			};																	///
		write_stata(df, "`dta_path'");											///
		if (`lbl') cto_form_dofile("`formid'", "`do_path'")						///

			
*--- 5. Import the data and clear wd
    use "`dta_path'", clear
    if fileexists("`do_path'") run "`do_path'"
	
	if fileexists("`wd'/.RData") rm "`wd'/.RData"
	if fileexists("`dta_path'") rm "`dta_path'"
	if fileexists("`do_path'") rm "`do_path'"
	
	if "`save'" != "" save "`save'", replace
end
