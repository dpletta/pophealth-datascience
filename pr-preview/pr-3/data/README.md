# Teaching data and codebook

The files in `raw/` are for the data-preparation chapter. All of their records were
manually invented for this book. No record comes from the two
formatting-reference documents or an actual study. There is no random data
generation step. These files illustrate data operations, not population estimates
or a validated health instrument.

Keep `raw/` unchanged. The chapter writes new outputs to `derived/`.

## participants.csv

Intended unit: one participant. The file has 13 rows for 12 participants; the
second occurrence of participant 002 is a confirmed duplicate export row with
identical values. This confirmation is part of the fictional teaching scenario.

| Raw column | Meaning and cleaning rule |
|---|---|
| Participant ID | Three-character study identifier; preserve leading zeros. |
| Clinic | Enrolling clinic; links to `clinics.csv`. |
| Age | Age in years; `999` means not reported. Blank means missing. |
| Smoking | Current smoking response; yes/y and no/n ignore capitalization and surrounding spaces. Unknown/refused remain missing in the cleaned variable. |
| Enrollment Date | Date in year-month-day format. |
| Activity Minutes | Self-reported minutes of activity in the past seven days. `-9` means not reported; blank means missing. Zero is a reported value. `-20` is an unresolved invalid entry, retained in the raw file and set to missing in the cleaned value. |

For this fictional adult study, ages outside 18–100 and activity minutes outside
0–10,080 are flagged for review. Those are teaching rules, not universal
eligibility rules or clinical thresholds. The activity upper bound is the total
number of minutes in seven days, not a threshold for recommended activity.

## clinics.csv

Unit: one clinic; key: `clinic_id`. Three rows, with unique, nonmissing keys.

| Column | Meaning |
|---|---|
| clinic_id | C01, C02, or C03. |
| clinic_name | Invented clinic name. |
| area | Fictional Urban/Rural label for demonstrating grouping. |

## visits.csv

Unit: one recorded study visit; key: `visit_id`. Eleven rows. A participant can
have more than one visit. In this extract, `(participant_id, visit_type)` also
identifies each row uniquely; that would not necessarily hold in another study.

| Column | Meaning |
|---|---|
| visit_id | Unique record identifier. |
| participant_id | Intended link to the participant roster. |
| visit_type | `baseline` or `follow_up`. |
| visit_date | Date in year-month-day format. |
| wellbeing_score | Invented score from 0 to 10 for demonstrating missingness; not a validated measure. Blank means a missing score on a recorded visit. |

Participant 099 deliberately has a visit but no roster record. Participants 007,
009, 010, and 012 have no matching visit in this extract. Absence of a visit record
does not establish whether a visit occurred outside this extract. Participant
004 has a recorded visit with a missing score; participant 003 has one observed
score and one missing score.

## lookup/states.csv

Unit: one state, district, or territory; key: `fips`. 54 rows: the 50 states, the
District of Columbia, Guam, Puerto Rico, and the US Virgin Islands. Used in the data
engineering chapter of the survey part to add readable labels to the BRFSS `_STATE`
codes.

| Column | Meaning |
|---|---|
| fips | Federal Information Processing Standards (FIPS) state code, as in BRFSS `_STATE`. |
| state_name | Name of the state, district, or territory. |
| state_abbr | US Postal Service abbreviation. |
| census_region | US Census Bureau region (Northeast, Midwest, South, West); `US territory` for Guam, Puerto Rico, and the US Virgin Islands, which are not in a Census region. |

## brfss/ (not shared through Git)

The Behavioral Risk Factor Surveillance System (BRFSS) files are public but large. Each
reader downloads them from the Centers for Disease Control and Prevention (CDC) into
`brfss/raw/` (see `chapters/survey/01-import.qmd`). Rendering the survey chapters writes
one file per chapter to `brfss/processed/` (or `brfss/processed-smoke/` for a smoke
test), along with the chunk caches.
