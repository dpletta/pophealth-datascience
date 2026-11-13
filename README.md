# Data Science for Population Health Sciences

A Quarto book of beginner-friendly, annotated R walkthroughs in two parts:

1. **Foundations.** Data preparation, SQL with `sqldf()`, dplyr queries, and joins, on
   small fictional files.
2. **Survey-weighted analysis with BRFSS 2024.** A complete analysis of the 2024
   Behavioral Risk Factor Surveillance System (BRFSS): importing, data engineering
   (stacking questionnaire versions and joining a lookup table), cleaning, survey-weighted
   descriptive statistics, multiple imputation, and bivariate and multivariable
   survey-weighted regression. The question: is household income associated with
reported diagnosed diabetes among adults in the participating jurisdictions?

This repository is one book. Its source is `_quarto.yml` (settings and chapter order),
`index.qmd` (the welcome page), and the chapters in `chapters/`, all at the repository
root. `quarto render` builds it into `_book/`, which is not committed.

## Run locally

Install R (the lockfile records R 4.6.2) and Quarto separately. Open
`pophealth-datascience.Rproj` or start R from this directory. The project
automatically activates **renv**, which keeps its R packages in a project library.
On a fresh checkout, allow renv to bootstrap if prompted, then restore the packages
in the R console:

```r
renv::restore()
```

This restores the foundation and survey dependencies to the versions recorded in
`renv.lock`, including dplyr and RSQLite. Use the recorded R version for the closest
match; renv manages packages, not the R installation. The SQL right/full join
examples need SQLite 3.39 or later, supplied by `RSQLite` (a dependency of `sqldf`).

```bash
quarto preview
quarto render
```

### Python with uv

Install [uv](https://docs.astral.sh/uv/getting-started/installation/), then run from
the repository root:

```bash
uv sync --locked
uv run python --version
```

uv creates `.venv/` using Python 3.13, selected by `.python-version` and constrained
in `pyproject.toml`. It can download Python if a suitable interpreter is unavailable.
The book currently uses only R, so Python has no third-party dependencies and is
optional for rendering. Use `uv run python script.py` for Python scripts, or select
`.venv/bin/python` in your editor (`.venv/Scripts/python.exe` on Windows).
Shell activation is optional: `source .venv/bin/activate` on macOS/Linux.

### Maintaining the environments

- R: use `renv::install("package")`, reference it in the source, then run
  `renv::snapshot()`. The default implicit snapshot detects dependencies in the
  chapters and includes their dependencies. Check with `renv::status()`; use
  `renv::restore()` after pulling lockfile changes.
- Python: use `uv add package` or `uv remove package`, then commit both
  `pyproject.toml` and `uv.lock`. Run `uv sync --locked` after pulling changes.
- Commit `.Rprofile`, `renv.lock`, `renv/activate.R`, `renv/settings.json`,
  `renv/.gitignore`, `.python-version`, `pyproject.toml`, and `uv.lock`.
  Local R libraries, caches, and `.venv/` are ignored by Git.

uv owns Python dependencies and renv owns R dependencies; leave renv's Python
integration disabled so that there is only one Python lockfile. See the
[renv guide](https://rstudio.github.io/renv/articles/renv.html) and
[uv project guide](https://docs.astral.sh/uv/guides/projects/) for details.

### The survey chapters

The survey packages are included in `renv.lock` and installed by `renv::restore()`.
The survey chapters also need the BRFSS data, several GB of free disk space,
and at least 8 GB of memory.

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
