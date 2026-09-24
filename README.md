# ctoclient (Stata)

Stata client for the SurveyCTO API: download form data and media files into
Stata. Stata companion of the R package **ctoclient**, with consistent command
names.

The JSON parser is written in **Mata**, which makes `ctoclient` very fast,
memory-efficient and robust:

* **Fast:** whole blocks of the file are processed with vectorised Mata
operations instead of looping over keys and values in Stata.
* **Memory-efficient:** the file is read in pieces of 8 MB, so memory use stays
low even for very large downloads.
* **Robust:** text in any language (for example Amharic) is kept exactly as
SurveyCTO sent it; a wrong login, server name or form ID is reported with a
clear message; working files are always cleaned up.
* **Media files:** all missing files are downloaded in one `curl` call, and files
already on disk are skipped.

|Command|Purpose|
|-|-|
|`cto\_form\_data`|Download the submissions of a form and load them into Stata|
|`cto\_form\_data\_attachment`|Download the submissions and their media files|

## Requirements

* Stata 15 or newer
* `curl` (included in Windows 10 version 1803 and later, macOS and most Linux
distributions). Check with `shell curl --version` in Stata.
* A SurveyCTO user that is allowed to use the server API and download data.

## Installation

From SSC (recommended):

```stata
ssc install ctoclient
```

To update to the latest version:

```stata
ssc install ctoclient, replace
```

From a local or network folder that contains this package:

```stata
net install ctoclient, from("C:/path/to/ctoclient") replace
```

From GitHub:

```stata
net install ctoclient, from("https://raw.githubusercontent.com/GutUrago/ctoclient/main/") replace
```

Then type `help ctoclient`.

## Usage

### Storing the password

Store the password once in `profile.do`, the do-file that Stata runs
automatically every time it starts. Add this line to `profile.do`:

```stata
global sctopassword "your-password"
```

The global macro `$sctopassword` is then defined in every Stata session, so your
do-files only contain `password("$sctopassword")`. Save `profile.do` in your home
folder or in your `PERSONAL` folder (type `sysdir` in Stata to see where it is),
not in a shared project folder, and keep it private: the password is stored as
plain text. Restart Stata once for the macro to be defined.

### Examples

Form data only:

```stata
cto\_form\_data hh\_survey, server(myserver) username(me@org.org) pass("$sctopassword") ///
      save("data/hh\_survey.dta") replace clear
```

Form data and media files (only files not yet in the folder are downloaded):

```stata
cto\_form\_data\_attachment hh\_survey, media("data/media") server(myserver) ///
      username(me@org.org) pass("$sctopassword") save("data/hh\_survey.dta") replace clear
```

Only submissions after a given moment (Unix timestamp in seconds, UTC):

```stata
cto\_form\_data hh\_survey, server(myserver) username(me@org.org) pass("$sctopassword") ///
      date(1758672000) clear
```

## Files

|File|Purpose|
|-|-|
|`stata.toc`|Table of contents read by `net from` / `net install`|
|`ctoclient.pkg`|Package description and file list|
|`ctoclient.sthlp`|Package overview help|
|`cto\_form\_data.ado`, `.sthlp`|Form data command and help|
|`cto\_form\_data\_attachment.ado`, `.sthlp`|Form data + media command and help|

## Author

Gutama Girja Urago, Laterite

