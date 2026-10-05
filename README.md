# Data Science for Population Health Sciences

A Quarto book of beginner-friendly, annotated R walkthroughs. The first chapter
covers data preparation, SQL with `sqldf()`, dplyr queries, and joins.

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

The rendered book starts at `_book/index.html`. Rendering executes the chapter
from the project root and writes three teaching outputs to `data/derived/`.
Re-rendering replaces those derived files; the raw files are never overwritten.
No packages are installed and no research data are downloaded during rendering.

## Contents

- `_quarto.yml`: title, chapter order, and HTML settings.
- `index.qmd`: reader introduction.
- `chapters/data-preparation.qmd`: all instructional R and SQL code, in order.
- `data/raw/`: small, fictional CSV inputs.
- `data/README.md`: data provenance, units, and cleaning rules.
- `images/`: original, accessible SVG diagrams used by the chapter.

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
