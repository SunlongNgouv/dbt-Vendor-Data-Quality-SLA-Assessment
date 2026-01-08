{{ config(materialized = "view") }}

with vendor_a as (
    select * from {{ ref("stg_vendor_a") }}
),
    vendor_b as (
    select * from {{ ref("stg_vendor_b") }}
),
    county_state_usa as (
    select county, state from {{ ref("stg_county_usa") }}
),
    vendor_union as (
    select * from vendor_a
    union all (select * from vendor_b)
),
    final as (
    select v.*, c.state
    from vendor_union as v
    left join county_state_usa as c
    using (county)
)

select * from final
