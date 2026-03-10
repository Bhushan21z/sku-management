# README

API for order sku managements

1. POST /api/v1/orders
REQUEST

```json
{
  "external_id": "abcd",
  "plcaed_at": "2026-03-10",
  "line_items": [
      { "sku": "SKU1", "quantity": 10 }, 
      { "sku": "SKU2", "quantity": 5 }
   ]
}
```

2. POST /api/v1/orders/:id/lock

3. GET /api/v1/sku-summary/:id

RESPONSE

```json
{
    "sku": "SKU1",
    "summary": [
      { "week": "2026-W15", "total_quantity": 10 }, 
      { "week": "2026-W16", "total_quantity": 5 }
   ]
}
```


Background (Async) Job to calculate sku stats

1. When new order query is recieved either (create/update) we will update order details and line_items.
2. Enqueue a job to recalculate sku_stats for new entries per week.
3. Skus are grouped by weeks and total quantity for the sku is calculated.

* ...
