# Data Science for Population Health Sciences

A Quarto book of beginner-friendly, annotated R walkthroughs in two parts:

1. **Foundations.** Data preparation, SQL with `sqldf()`, dplyr queries, and joins, on
   small fictional files.
2. **Survey-weighted analysis with BRFSS 2024.** A complete analysis of the 2024
   Behavioral Risk Factor Surveillance System (BRFSS): importing, data engineering
   (stacking questionnaire versions and joining a lookup table), cleaning, survey-weighted
   descriptive statistics, multiple imputation, and bivariate and multivariable
   survey-weighted regression. The question: is household income associated with
   diabetes among US adults?

This repository is one book. Its source is `_quarto.yml` (settings and chapter order),
`index.qmd` (the welcome page), and the chapters in `chapters/`, all at the repository
root. `quarto render` builds it into `_book/`, which is not committed.

## Run locally

Install R 4.1 or later and Quarto. Open `pophealth-datascience.Rproj` or work from
this directory. Run this once in the R console:

```r
install.packages(c("dplyr", "sqldf", "knitr", "rmarkdown"))
```

Use dplyr 1.1.1 or later. The SQL right/full join examples need SQLite 3.39 or
later, supplied by a recent `RSQLite` (a dependency of `sqldf`). The chapter
prints the SQLite version. If it is too old, update `RSQLite` and restart R.

```bash
quarto preview
quarto render
```

### The survey chapters

The survey chapters need more packages, the BRFSS data, several GB of free disk space,
and at least 8 GB of memory:

```r
install.packages(c(
  "broom", "dplyr", "furrr", "future", "gtsummary", "haven", "knitr", "mice",
  "mitml", "parallelly", "purrr", "rmarkdown", "sqldf", "srvyr", "survey", "tibble",
  "tidylog", "tidyr"
))
```

They need dplyr 1.2.0 or later. Download the data once by running the `download` chunk in
`chapters/survey/01-import.qmd` from the R console in this folder, or download "2024 BRFSS
Data (SAS Transport Format)" from the
[CDC BRFSS 2024 page](https://www.cdc.gov/brfss/annual_data/annual_2024.html), unzip it,
and save it as `data/brfss/raw/LLCP2024.XPT`. The stacking example in the data
engineering chapter also uses the questionnaire version 1, 2 and 3 files from the
[CDC multiple-questionnaire page](https://www.cdc.gov/brfss/annual_data/2024/llcp_multiq.html),
saved as `data/brfss/raw/LLCP24V1.XPT`, `LLCP24V2.XPT` and `LLCP24V3.XPT` (the chapter has a
download chunk); without them, that section is shown but not run. Nothing in `data/brfss/` is shared through Git.

```bash
# Quick test with 2 imputations; writes to _book-smoke/ and data/brfss/processed-smoke/
quarto render chapters/survey --profile smoke
# Full run (5 imputations)
quarto render chapters/survey
```

The survey chapters use `freeze: auto`. After a full run with the data, commit `_freeze/`
so that `quarto render` builds the whole book, including the survey results, on a
computer without the data.

The rendered book starts at `_book/index.html`. Rendering executes the chapter
from the project root and writes three teaching outputs to `data/derived/`.
Re-rendering replaces those derived files; the raw files are never overwritten.
No packages are installed and no research data are downloaded during rendering.

## Contents

- `_quarto.yml`: title, chapter order, and HTML settings.
- `index.qmd`: reader introduction.
- `chapters/data-preparation.qmd`: all instructional R and SQL code, in order.
- `chapters/survey/`: the survey-weighted chapters, their appendices (coding decisions;
  reproducibility), and `_common.R`, the settings every survey chapter uses.
- `data/lookup/states.csv`: state names, postal abbreviations, and US Census Bureau
  regions for the Federal Information Processing Standards (FIPS) codes used in BRFSS.
- `data/raw/`: small, fictional CSV inputs.
- `data/README.md`: data provenance, units, and cleaning rules.
- `images/`: original, accessible SVG diagrams used by the chapters.
- `_quarto-smoke.yml`, `_environment-smoke`: the smoke-test profile for the survey chapters.
- `_freeze/`: stored results of the survey chapters, so the book renders without the BRFSS data.

The supplied social-epidemiology Qmd and legacy Rmd informed the progression of
short code blocks and nearby checks. Their data, study-specific paths, and
statistical choices were not reused. `local/` remains excluded from version
control and from the rendered book.

## Add another chapter

Create a `.qmd` in `chapters/` with one top-level chapter heading, then add its path
under `book.chapters` in `_quarto.yml`. Keep setup and analytical code in that
chapter. Include purpose, annotated steps, interpretation, and practice questions.
See [Quarto's book documentation](https://quarto.org/docs/books/).

## Validation

Checked on 2026-10-05 with Quarto 1.10.18, R 4.6.1, dplyr 1.2.1, sqldf 0.4.12,
and SQLite 3.52.0. All 47 R chunks executed in order in a fresh R session without
warnings; all ten assigned SQL/dplyr result pairs agreed. Independent checks
confirmed the codebook's expected counts and missingness, leading-zero IDs in
the exported CSV, and unchanged raw-file checksums. The HTML book rendered
successfully; local links, diagrams, navigation, tabs, and section folding were
checked. These checks apply to the included teaching data and these versions.
