-- Beispiel-Mart: Tagesaggregat auf Basis des Staging-Models.
-- Zeitintelligenz laeuft in echten Projekten ueber DIM_DATE (siehe Rules).
select
    ORDER_DATE,
    count(ORDER_ID) as ORDER_COUNT,
    sum(AMOUNT) as TOTAL_AMOUNT
from {{ ref('stg_example__orders') }}
group by ORDER_DATE
