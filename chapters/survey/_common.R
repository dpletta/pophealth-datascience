# Settings shared by every chapter in the survey-weighted part of the book. Quarto runs
# each chapter in a fresh R session, so every chapter starts by sourcing this file.
# Paths are relative to the book's root folder (where _quarto.yml is), because the
# project sets `execute-dir: project`.

# Seed: every chapter starts from the same random-number state.
seed <- 2024
set.seed(seed)

# Number of imputations. The book uses 5. A smoke test
# (`quarto render chapters/survey --profile smoke`) sets N_IMPUTATIONS=2 through the
# file `_environment-smoke`.
n_imputations_book <- 5L
n_imputations <- as.integer(Sys.getenv(
  "N_IMPUTATIONS",
  unset = n_imputations_book
))
smoke_test <- n_imputations != n_imputations_book

# Where the BRFSS files live. Nothing in data/brfss/ is shared through Git.
raw_dir <- "data/brfss/raw"
# Any other number of imputations is a test run. Its results go to their own folder, so
# they can never replace the book's results.
processed_dir <- if (smoke_test) {
  "data/brfss/processed-smoke"
} else {
  "data/brfss/processed"
}
dir.create(processed_dir, showWarnings = FALSE, recursive = TRUE)

# Strata with a single PSU: center them on the overall mean when estimating variances.
options(survey.lonely.psu = "adjust")

# Cache only the expensive chunks marked `cache: true` in each chapter.
# Code, data, settings and package changes invalidate their results.
loadNamespace("survey")
cache_context <- list(
  code = knitr::knit_code$get(),
  settings = tools::md5sum("chapters/survey/_common.R"),
  packages = utils::installed.packages()[, c("Package", "Version")],
  R = R.version.string,
  imputations = n_imputations,
  survey_options = options()[grep("^survey[.]", names(options()))]
)
knitr::opts_chunk$set(
  cache.path = paste0(
    processed_dir,
    "/cache/",
    tools::file_path_sans_ext(basename(knitr::current_input())),
    "/"
  ),
  cache.extra = cache_context
)
