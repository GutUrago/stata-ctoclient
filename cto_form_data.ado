

*! version 1.0.0 20jan2026
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
				Tidy(real 1)				///
				Label(real 1)				///
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

	rcall_check ctoclient>=0.0.1, r(4.1.0)
	
*--- 2. Format optional arguments
	local r_tidy = cond(`tidy' == 1, "TRUE", "FALSE")
	local r_key = subinstr("`key'", "\", "/", .)
	local r_key = cond("`r_key'" == "", "NULL", "'`r_key''")
	local r_label = cond(`label' == 1, "TRUE", "FALSE")
	
*--- 3. Prepare temporary file paths
	tempfile dta_path do_path
    local dta_path "`dta_path'.dta"
    local do_path "`do_path'.do"
    local dta_path_r = subinstr("`dta_path'", "\", "/", .)
    local do_path_r = subinstr("`do_path'", "\", "/", .)

*--- 4. Call R in vanilla mode
	rcall vanilla																///
		pkgs <- c("ctoclient", "sjlabelled");									///
		loaded <- sapply(pkgs, function(pkg) require(pkg, quietly = TRUE, 		///
							character.only = TRUE)); 							///
		install.packages(pkgs[!loaded], quiet = TRUE, 							///
					repos = "https://cloud.r-project.org/");					///
		sapply(pkgs, function(pkg) require(pkg, quietly = TRUE, 				///
							character.only = TRUE));							///
		cto_connect("`server'", "`username'", "`password'");					///
		df <- cto_form_data("`formid'", `r_key', tidy = `r_tidy',				///
							start_date = as.POSIXct(`date'));					///
		write_stata(df, "`dta_path_r'");										///
		if (`r_label') {														///
			cto_form_dofile("`formid'", "`do_path_r'")							///
		}
			
*--- 5. Import the data
    use "`dta_path'", clear
    if fileexists("`do_path'") run "`do_path'"
	if "`save'" != "" save "`save'", replace
end
