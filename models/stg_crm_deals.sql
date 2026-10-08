{{ config(materialized='view') }}

with raw_deals as (
    select * from {{ source('sales_ops', 'src_crm_deals') }}
)

select
    opportunity_id,
    account_name,
    upper(provider_specialty) as provider_specialty, -- Standardizing to uppercase
    stage,
    deal_value,
    lead_source,
    created_date,
    closed_date,
    -- Adding Sales Ops business logic to flag active pipeline vs historical wins
    case 
        when stage = 'Closed Won' then true 
        else false 
    end as is_won,
    case 
        when stage not in ('Closed Won', 'Closed Lost') then true 
        else false 
    end as is_active_pipeline
from raw_deals
