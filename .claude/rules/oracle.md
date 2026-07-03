---
paths:
  - "oracle/**"
---

# Oracle SQL rules

- Dialect is Oracle SQL / PL-SQL. Snowflake specifics do NOT apply here:
  no DIM_DATE, no `COPY INTO`, no Snowsight.
- Dates: always explicit format masks (`TO_DATE(:x, 'YYYY-MM-DD')`); never rely
  on NLS session defaults. Day-level comparisons via `TRUNC(<date>)`.
- No `SELECT *`; qualify columns with table aliases.
- Use bind variables; never build SQL by string concatenation.
- PL/SQL: explicit transaction handling, one COMMIT per logical unit of work;
  handle exceptions explicitly instead of `WHEN OTHERS THEN NULL`.
- Prefer ANSI join syntax over Oracle `(+)` outer-join notation.
