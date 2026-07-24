# Architecture

> Diese Datei ist **projektspezifisch**: was *dieses* Projekt tut. Das firmweite Schichtenmodell
> (Landing → Vault → Consumption → Tabular → Report, Namenskonventionen) steht in
> [`datenarchitektur.md`](datenarchitektur.md) und muss hier **nicht** wiederholt werden.

> TODO: Architektur dieses Projekts beschreiben (konkrete Hubs/Links/Sats, Schemas, Modell-Fluss,
> Forecast-Pipeline, BI-Konsum). Von CLAUDE.md referenziert. `<PLACEHOLDER>` füllen.

## Schichten (dieses Projekt)
- Einordnung ins firmweite Modell (siehe [`datenarchitektur.md`](datenarchitektur.md)):
  welche Entitäten in Raw/Business Vault, welche Consumption-Views entstehen.
- ML: `<LANDING_DB>.{ML, ML_REGISTRY, ML_INFERENCE, ML_MONITORING}`

## Forecast-Pipeline
- TODO: Training, Inferenz, Output-Views, Airflow-DAG, Monitoring.
