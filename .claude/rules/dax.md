---
paths:
  - "powerbi/**"
---

# Power BI / DAX rules

- Measures return numeric or `BLANK()`, never a Variant type and never text
  for numeric KPIs.
- No implicit measures: every aggregation is an explicit measure.
- Naming: `M_<Bereich>_<Kennzahl>` (e.g. `M_Sales_UmsatzNetto`).
- Filter-context pitfalls to check on every measure:
  - `CALCULATE` replaces filters - be explicit about `ALL`/`ALLSELECTED`/`KEEPFILTERS`.
  - No `FILTER` over whole fact tables; filter on columns instead.
  - Time intelligence only on a proper, contiguous date table marked as such.
- Prefer measures over calculated columns; no bidirectional cross-filtering
  without a documented reason.
- Git format is PBIP/TMDL (see `powerbi/README.md`); never commit `.pbix` binaries.
