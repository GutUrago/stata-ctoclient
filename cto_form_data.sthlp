{smcl}
{* *! version 1.0.0  20jan2026}{...}
{viewerjumpto "Syntax" "cto_form_data##syntax"}{...}
{viewerjumpto "Description" "cto_form_data##description"}{...}
{viewerjumpto "Options" "cto_form_data##options"}{...}
{viewerjumpto "Dependencies" "cto_form_data##dependencies"}{...}
{viewerjumpto "Examples" "cto_form_data##examples"}{...}
{title:Title}

{phang}
{bf:cto_form_data} {hline 2} Download SurveyCTO form data directly into Stata using R's ctoclient API.

{marker syntax}{...}
{title:Syntax}

{p 8 17 2}
{cmdab:cto_form_data}{cmd:,}
{opt server(string)}
{opt user:name(string)}
{opt pass:word(string)}
{opt form:id(string)}
[{it:options}]

{synoptset 25 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Required}
{synopt:{opt server(string)}}Your SurveyCTO server name (e.g., "myserver").{p_end}
{synopt:{opt user:name(string)}}Your SurveyCTO login username.{p_end}
{synopt:{opt pass:word(string)}}Your SurveyCTO login password.{p_end}
{synopt:{opt form:id(string)}}The unique ID of the SurveyCTO form to download.{p_end}

{syntab:Optional}
{synopt:{opt key(string)}}Path to your private key file if the data is encrypted.{p_end}
{synopt:{opt d:ate(real)}}UNIX timestamp for the start date to filter data. Default is Jan 1, 2000 ({it:946674000}).{p_end}
{synopt:{opt t:idy(real)}}Set to 1 to format the data neatly via R (default), or 0 for raw format.{p_end}
{synopt:{opt l:abel(real)}}Set to 1 to automatically download and apply value/variable labels (default).{p_end}
{synopt:{opt s:ave(string)}}File path to save the resulting Stata dataset.{p_end}
{synoptline}
{p2colreset}{...}

{marker description}{...}
{title:Description}

{pstd}
{cmd:cto_form_data} creates a seamless pipeline between Stata and SurveyCTO. It uses the Stata package {browse "https://haghish.github.io/rcall/":rcall} to execute R in the background, authenticates with the SurveyCTO API via the {browse "https://CRAN.R-project.org/package=ctoclient":ctoclient R package}, pulls the specified form data, applies Stata labels, and loads the data cleanly into memory.

{marker dependencies}{...}
{title:Dependencies}

{pstd}
This package requires the {cmd:rcall} Stata package and a local installation of R (version 4.1.0 or higher). If {cmd:rcall} is not detected, the program will attempt to install it automatically via the {cmd:github} package. The R packages {it:ctoclient} and {it:sjlabelled} will also be installed automatically in R if missing.

{marker examples}{...}
{title:Examples}

{pstd}Download form data and load it into memory:{p_end}
{phang2}{cmd:. cto_form_data, server("myserver") username("admin@email.com") password("MyPassword123") formid("household_survey_v1")}

{pstd}Download encrypted data, apply labels, and save the file:{p_end}
{phang2}{cmd:. cto_form_data, server("myserver") username("admin@email.com") password("MyPassword123") formid("household_survey_v1") key("C:/keys/private_key.pem") save("C:/data/clean_data.dta")}

{title:Author}
{pstd}Gutama Girja Urago, Laterite Consulting PLC, Addis Ababa{p_end}