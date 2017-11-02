# Finding incidents in the Bay Area


```sql
select * 
from fatal_encounters
WHERE (city like '%palo alto%' or city like '%stanford%'
  or city like '%menlo park%')

  AND state = 'CA'
```
