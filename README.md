# Spotify Genre Classification

Multiclass music genre classification using audio features from the Spotify API. Built and evaluated in R with `tidymodels`.

---

## Overview

The goal was to predict the genre of a track (9 classes) from audio metadata returned by the Spotify API — features like danceability, energy, acousticness, and tempo — without using any audio signal directly. Data was collected manually via the `spotifyr` package, then cleaned, explored, and used to train and compare seven classifiers. The best model (Random Forest) achieved **87.1% balanced accuracy** on the held-out test set.

**Genres:** blues, classical, country, folk, hip-hop, jazz, metal, reggae, rock

---

## Repository Structure

```
spotify-genre-classification/
├── dataset_prep.R                        # Spotify API data collection script
├── raport.qmd                            # Full analysis (Quarto document)
├── raport.html                           # Rendered report
├── spotify-genres-classification-new.csv # Raw dataset from API
├── data/
│   ├── grid_results_tune_changed_ts.rds  # Tuning results (reduced feature set)
│   └── grid_results_tune_wla.rds         # Tuning results (full feature set)
├── images/
│   └── enao.png                          # Every Noise at Once genre map
└── Projekt.Rproj                         # RStudio project file
```

---

## Methodology

### Data Collection

Tracks were fetched from 24 curated Spotify playlists (2–4 per genre) using the `spotifyr` package, targeting ~200–300 tracks per genre for a balanced dataset.

### Features

| Feature | Type | Description |
|---|---|---|
| `danceability` | continuous [0,1] | Suitability for dancing |
| `energy` | continuous [0,1] | Perceptual intensity |
| `loudness` | continuous (dB) | Overall loudness |
| `speechiness` | continuous [0,1] | Presence of spoken words |
| `acousticness` | continuous [0,1] | Likelihood of being acoustic |
| `instrumentalness` | continuous [0,1] | Likelihood of no vocals |
| `liveness` | continuous [0,1] | Likelihood of live performance |
| `valence` | continuous [0,1] | Musical positivity |
| `tempo` | continuous (BPM) | Track tempo |
| `key` | categorical | Pitch class |
| `mode` | categorical | Major / minor |
| `time_signature` | categorical | 4/4 or other |
| `track.explicit` | binary | Explicit content flag |
| `decade` | categorical | Release decade |
| `track.duration_s` | continuous (s) | Track duration |

### Preprocessing & Cleaning

- Removed API metadata columns (playlist URLs, IDs, etc.)
- Dropped `track.popularity` — 245 tracks had implausible zero values
- Fixed `time_signature`: rare values (1, 3, 5) collapsed into `"other"`
- Converted `track.album.release_date` → `decade` categorical variable
- Removed 1 row with zero tempo, 1 row of all-NA values, 162 duplicate tracks
- Investigated high Spearman correlations (>0.7) among `energy`, `loudness`, `acousticness` via PCA → trained two model variants: one with all three features (**Model 2**), one with only `energy` (**Model 1**)

### Models & Preprocessing Recipes

Seven classifiers compared via 10-fold cross-validation with 25-point grid search:

| Model | Recipe |
|---|---|
| Random Forest | basic (no dummy encoding) |
| Bagging | basic |
| Naive Bayes | basic |
| XGBoost | dummy encoding |
| MLP | dummy + Yeo-Johnson transform + normalise |
| KNN | dummy + Yeo-Johnson transform + normalise |
| SVM (RBF) | dummy + Yeo-Johnson transform + normalise |

---

## Results

Random Forest was the best-performing model in both feature configurations.

| Model | Balanced Accuracy (test) |
|---|---|
| Random Forest — full features (Model 2) | **0.871** |
| Random Forest — reduced features (Model 1) | 0.857 |

Key findings from the confusion matrices and ROC curves:
- **Best classified:** hip-hop and metal (high feature separability)
- **Hardest to classify:** blues, rock, country (frequent mutual confusion)
- Most common misclassification: blues ↔ jazz (10 errors in both models)
- `acousticness` was the second most important feature in Model 2 despite being dropped in Model 1 due to collinearity — confirming that the correlation did not harm the model

---

## How to Run

**Prerequisites:** R ≥ 4.0, RStudio (recommended), Quarto CLI

```r
# Install required packages
install.packages(c(
  "tidyverse", "tidymodels", "ggplot2", "plotly",
  "rpart", "baguette", "discrim", "rules",
  "sparsediscrim", "ranger", "kknn", "kernlab", "klaR", "xgboost",
  "vip", "cvms", "kableExtra", "corrplot", "PerformanceAnalytics",
  "psych", "hrbrthemes", "agricolae", "FSA", "rstatix", "ggpubr",
  "doParallel", "factoextra", "spotifyr"
))
```

**Render the report:**
```bash
quarto render raport.qmd
```

The tuning results are pre-saved as `.rds` files so the grid search (~hours of compute) is skipped automatically on render.

**Re-collect data** (optional — requires Spotify API credentials):
```r
# Set credentials in dataset_prep.R
Sys.setenv(SPOTIFY_CLIENT_ID = 'your_id')
Sys.setenv(SPOTIFY_CLIENT_SECRET = 'your_secret')
source("dataset_prep.R")
```

---

## Tech Stack

| | |
|---|---|
| **Language** | R 4.x |
| **Modelling** | tidymodels, ranger, xgboost, nnet, kknn, kernlab, klaR |
| **Data collection** | spotifyr |
| **Visualisation** | ggplot2, plotly |
| **Report** | Quarto |

---

## License

Academic project. Dataset collected via the Spotify Web API subject to [Spotify's Developer Terms of Service](https://developer.spotify.com/terms).
