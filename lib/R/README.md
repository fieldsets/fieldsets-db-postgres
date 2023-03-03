# R Fieldsets package
Our R library of commonly used functions can be updated via the R CLI interface. Simply add new files and function or edit any existing functions. After making edits you can update the package with the following commands in the R CLI.

```R
library(devtools)
library(roxygen2)
setwd("/fieldsets-lib/R/fieldsets")
document()
setwd("..")
install("fieldsets")
```
