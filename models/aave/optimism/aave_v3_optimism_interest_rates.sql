{{ config(
  schema = 'aave_v3_optimism'
  , alias='interest'
  , post_hook='{{ expose_spells(\'["optimism"]\',
                                  "project",
                                  "aave_v3",
                                  \'["batwayne", "chuxin"]\') }}'
  )
}}

select 
  a.reserve, 
  t.symbol,
  date_trunc('hour',a.evt_block_time) as hour, 
  avg(CAST(a.liquidityRate AS DOUBLE)) / 1e27 as deposit_apy, 
  avg(CAST(a.stableBorrowRate AS DOUBLE)) / 1e27 as stable_borrow_apy, 
  avg(CAST(a.variableBorrowRate AS DOUBLE)) / 1e27 as variable_borrow_apy
from {{ source('aave_v3_optimism', 'Pool_evt_ReserveDataUpdated') }} a
left join {{ ref('tokens_optimism_erc20') }} t
on a.reserve=t.contract_address
group by 1,2,3
