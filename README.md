# ctoclient for Stata

**ctoclient** is a Stata package that provides a seamless pipeline to securely download and import SurveyCTO form data directly into Stata memory. 

By leveraging the `rcall` package, this module acts as a bridge to the R `ctoclient` API. It automatically authenticates with your SurveyCTO server, downloads the requested form data, applies Stata variable and value labels seamlessly, and cleans up intermediate files to keep your working directory tidy.

---

## ⚙️ Prerequisites

Before installing this Stata package, ensure your system meets the following requirement:
* **R (version 4.1.0 or higher)** must be installed on your machine. 

> **Note:** The Stata dependency `rcall` and the required R packages (`ctoclient`, `sjlabelled`) will be **automatically installed** by this module during your first run if they are not already present on your system.

---

## 📥 Installation

You can install the latest version of the package directly from GitHub by running the following command in your Stata command window:

```stata
net install ctoclient, from("https://raw.githubusercontent.com/Guturago/stata-ctoclient/main")
```

## 📚 Documentation

Once installed, you can view the full documentation and options inside Stata by typing:

```stata
help cto_form_data
```