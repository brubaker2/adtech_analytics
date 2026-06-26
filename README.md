# adtech_analytics

A dbt project modeling social-media ad-campaign performance on BigQuery. Built on a real relational dataset (campaigns → ads → events, plus users) to practice staging/intermediate/marts layering, tests, and documentation.

## Data

Source: Kaggle "Social Media Advertisement Performance" (synthetic, Meta-Ads-Manager-style). Pulled via the Kaggle API into `seeds/`:

```
kaggle datasets download -d alperenmyung/social-media-advertisement-performance -p seeds/ --unzip
```

Four CSVs are loaded as seeds: `campaigns`, `ads`, `users`, `ad_events`. The bundled `.sqlite` file is not used (gitignored). Note `ad_events.csv` (~25 MB) is large for a seed; it loads fine but is a candidate to migrate to a proper BigQuery source later.

## Star schema

- **fct_ad_events** — central fact, one row per ad interaction (Impression/Click/Like/Share).
- **fct_ad_performance** — ad-level aggregate with CTR and engagement rate (built from `int_ad_performance`).
- **dim_campaigns / dim_ads / dim_users** — conformed dimensions.

Flow: seeds → `stg_adtech__*` (rename/cast) → `int_ad_performance` (aggregate events) → marts.

## Setup

```
py -3.12 -m venv venv          # dbt needs Python <= 3.12; 3.14 is not yet supported
.\venv\Scripts\Activate.ps1    # Windows PowerShell
pip install dbt-bigquery kaggle
gcloud auth application-default login
```

Put `profiles.yml` at `~/.dbt/profiles.yml` (or use `--profiles-dir .`). Confirm `project`, `dataset` (`adtech_dev`), and `location`.

## Run

```
dbt seed     # loads the 4 CSVs into adtech_dev_raw
dbt run      # builds staging -> intermediate -> marts
dbt test     # schema + singular tests
dbt docs generate && dbt docs serve
```

Or `dbt build` to do it all in dependency order.

## Notes

- `event_type` accepted_values are set to Impression/Click/Like/Share — adjust in `_adtech__models.yml` if `dbt test` reveals other values.
- `ad_platform` accepted_values are set to Facebook/Instagram/TikTok/Google — likewise adjust if needed.
- Each developer should point `dataset:` at their own schema to avoid clobbering shared tables.
