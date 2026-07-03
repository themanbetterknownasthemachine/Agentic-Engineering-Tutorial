# Architecture

> TODO: Architektur dieses Projekts beschreiben (Data Vault Layer, Schemas, Modell-Fluss,
> Forecast-Pipeline, BI-Konsum). Von CLAUDE.md referenziert. `<PLACEHOLDER>` füllen.

## Schichten
- Raw Vault -> Business Vault -> Gold / Marts (Snowflake, Data Vault 2.0)
- ML: `<LANDING_DB>.{ML, ML_REGISTRY, ML_INFERENCE, ML_MONITORING}`

## Forecast-Pipeline
- TODO: Training, Inferenz, Output-Views, Airflow-DAG, Monitoring.
