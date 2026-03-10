# README

REST API built with Ruby on Rails to manage orders and calculate weekly SKU statistics.
The system allows creating orders with multiple SKUs, locking orders, and retrieving weekly summaries of SKU quantities.

The application also uses a background job to asynchronously calculate SKU statistics to ensure API requests remain fast and scalable.

Deployed link: https://sku-management.codebhush.fun/

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
Response
```json
{
  "success":true,
  "order":
    {
      "id":4,
      "external_id":"abcd444",
      "placed_at":"2026-03-10T00:00:00.000Z",
      "locaked_at":null,
      "created_at":"2026-03-10T09:17:58.110Z",
      "updated_at":"2026-03-10T09:17:58.110Z"
    }
 }
 ```

2. POST /api/v1/orders/:id/lock

REQUEST => blank

RESPONSE
```json
{
  "success":true,
  "message":"Order Locked"
}
```

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

1. When an order is created or updated, the order and its associated line_items are stored in the database.
2. After saving the order, a background job is enqueued.
3. The job processes the order's SKUs and calculates aggregated statistics.
4. SKUs are grouped by week based on the placed_at date.
5. The total quantity per SKU per week is calculated.
6. The result is stored in the sku_stats table for fast retrieval.
