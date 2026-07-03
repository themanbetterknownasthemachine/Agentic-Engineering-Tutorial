-- Beispiel-Staging-Model: ersetzt man im echten Projekt durch
-- select ... from {{ source('<quelle>', '<tabelle>') }}.
-- Hier hartkodierte Zeilen, damit das Skelett ohne Quelldaten lauffaehig ist.
with raw_orders as (
    select 1 as ORDER_ID, to_date('2026-01-05') as ORDER_DATE, 100.00 as AMOUNT
    union all
    select 2 as ORDER_ID, to_date('2026-01-05') as ORDER_DATE, 250.50 as AMOUNT
    union all
    select 3 as ORDER_ID, to_date('2026-01-06') as ORDER_DATE, 75.25 as AMOUNT
)

select
    ORDER_ID,
    ORDER_DATE,
    AMOUNT
from raw_orders
