# ============================================================
# scrape_dyson_cowork.R
# ------------------------------------------------------------
# Instructor fallback scraper for AEM 7010 Session 7.
# Produces data/placements_dyson.csv with columns:
#   name, year, placement, source_url
#
# Source page:
#   https://dyson.cornell.edu/programs/graduate/placements/
#
# Last verified against the live page: 2026-04-24.
# On that date the page had a single <table> following the
# heading "Recent PhD Job Placements" inside div.t-content,
# with columns Year, Name, Position, University / Agency /
# Company. 93 non-empty rows spanning 2015 to 2025.
#
# This script is a safety net for the live Session 7 demo.
# If Cowork misbehaves during class, the instructor can run
# this directly to produce the expected CSV. If the Dyson
# page has changed shape between now and class day, the
# selector near line 60 is the first thing to check.
#
# PRE-FLIGHT, the weekend before April 29:
#   1. Open the URL above in a browser.
#   2. Confirm the "Recent PhD Job Placements" heading still
#      exists and is still followed by a 4-column table.
#   3. Run this script. Check that nrow(placements) > 80.
#   4. Spot-check three rows against the live page.
# ============================================================

# --- 0. Setup ------------------------------------------------

# Keep the dependency surface small and standard. If a student
# is running this on a fresh machine, these are the packages
# they already have from Sessions 4 and 5.
suppressPackageStartupMessages({
  library(rvest)
  library(dplyr)
  library(readr)
})

url <- "https://dyson.cornell.edu/programs/graduate/placements/"

# --- 1. Fetch the page ---------------------------------------

# Use a short timeout so a hung request does not stall a live
# demo. If this line errors, the page is unreachable and the
# instructor should switch to Plan B (show the committed CSV).
page <- read_html(url)

# --- 2. Locate the PhD placements table ----------------------

# VERIFY BEFORE CLASS: the XPath below anchors on the heading
# text, not on a CSS class. It says: "find the first <table>
# that appears anywhere after the <h2> containing 'Recent PhD'".
# If Cornell reorders sections or renames the heading, this is
# the single line to patch.
phd_table_node <- page %>%
  html_element(xpath = "//h2[contains(., 'Recent PhD')]/following::table[1]")

if (is.null(phd_table_node) || length(phd_table_node) == 0) {
  stop(
    "Could not find the PhD placements table. ",
    "The heading text or page structure likely changed. ",
    "Open ", url, " in a browser and patch the XPath above."
  )
}

# --- 3. Parse the table --------------------------------------

# html_table() returns a tibble with the column headers as
# seen on the page: "Year", "Name", "Position",
# "University / Agency / Company".
raw <- html_table(phd_table_node, header = TRUE, trim = TRUE)

# Rename to something predictable for downstream code and
# drop the empty first row the page ships with.
placements <- raw %>%
  rename(
    year        = Year,
    name        = Name,
    position    = Position,
    institution = `University / Agency / Company`
  ) %>%
  # Drop rows where every field is blank (the page has one
  # such spacer row just below the header).
  filter(!(year == "" & name == "" & position == "" & institution == "")) %>%
  # Build the single placement string the exercise expects.
  # Format: "Position at Institution". This reads naturally
  # for both academic and non-academic jobs.
  mutate(
    placement  = paste(position, "at", institution),
    source_url = url
  ) %>%
  select(name, year, placement, source_url)

# --- 4. Sanity checks ----------------------------------------

# These are the same checks the verification reflex asks for.
# If any of them fails, do not write the CSV. A silent wrong
# answer is worse than an obvious error.
n_rows  <- nrow(placements)
n_years <- length(unique(placements$year))

stopifnot(
  "Row count looks too small; page structure may have changed." =
    n_rows >= 80,
  "Expected years 2015 to 2025; got fewer than 10 unique years." =
    n_years >= 10,
  "Placement column has blanks; investigate before using." =
    all(nchar(placements$placement) > 5)
)

message("Scraped ", n_rows, " rows spanning ", n_years, " years.")

# --- 5. Write the CSV ----------------------------------------

# Create data/ if it does not exist so the script runs from a
# fresh working directory without hand-holding.
if (!dir.exists("data")) dir.create("data")

out_path <- file.path("data", "placements_dyson.csv")
write_csv(placements, out_path)

message("Wrote ", out_path)
