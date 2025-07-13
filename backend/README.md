
# Culvert API

## GET /culvert/test

```json
"Culvert API test"
```

---

## GET /culvert

```json
[
  {
    "id": "uuid",
    "address": "ул. Абая 123",
    "coordinates": "43.238949, 76.889709",
    "road": "A2",
    "serialNumber": "SN-001",
    "pipeType": "круглая",
    "material": "бетон",
    "diameter": "1000мм",
    "length": "5м",
    "headType": "прямой",
    "foundationType": "бетонная плита",
    "workType": "новое строительство",
    "constructionDate": "2024-04-13T13:45:00",
    "lastRepairDate": "2024-05-10T10:00:00",
    "lastInspectionDate": "2024-06-01T09:30:00",
    "strengthRating": 8.5,
    "safetyRating": 9.2,
    "maintainabilityRating": 7.0,
    "generalConditionRating": 8.0,
    "defects": ["трещина у основания", "разрушен угол"],
    "photos": [],
    "users": [],
    "createdAt": "2025-06-19T17:52:03.023808",
    "updatedAt": "2025-06-19T17:52:03.023849"
  }
]
```

---

## GET /culvert/culverts/{id}

```json
{
  "id": "uuid",
  "address": "ул. Абая 123",
  ...
}
```

---

## GET /culvert/by-address?address=Абая

```json
[
  {
    "id": "uuid",
    "address": "ул. Абая 123",
    ...
  }
]
```

---

## POST /culvert

**form-data:**

* `culvert` (application/json)
* `photos` (image/jpeg, optional)

```json
{
  "address": "ул. Абая 123",
  "coordinates": "43.238949, 76.889709",
  "road": "A2",
  "serialNumber": "SN-001",
  "pipeType": "круглая",
  "material": "бетон",
  "diameter": "1000мм",
  "length": "5м",
  "headType": "прямой",
  "foundationType": "бетонная плита",
  "workType": "новое строительство",
  "constructionDate": "2024-04-13T13:45:00",
  "lastRepairDate": "2024-05-10T10:00:00",
  "lastInspectionDate": "2024-06-01T09:30:00",
  "strengthRating": 8.5,
  "safetyRating": 9.2,
  "maintainabilityRating": 7.0,
  "generalConditionRating": 8.0,
  "defects": ["трещина у основания", "разрушен угол"],
  "userIDs": []
}
```

---

## PUT /culvert/{id}

```json
{
  "address": "ул. Абая 123",
  ...
  "defects": [
    "трещина у основания",
    "разрушен угол",
    "проверка добавления"
  ],
  "photos": [
    "/photos/photo1.jpg",
    "/photos/photo2.jpg"
  ]
}
```

---

## DELETE /culvert/{id}

```http
204 No Content
```

---

## GET /culvert/photos/{filename}

```http
Content-Type: image/jpeg
```

---

## PUT /culvert/photos/{id}

**form-data:**

* `photos`: файлы (image/jpeg)

```json
[
  "/photos/photo1.jpg",
  "/photos/photo2.jpg"
]
```

---

## PUT /culvert/photos/replace/{id}

**form-data:**

* `files`: новые фото

```json
[
  "/photos/new1.jpg",
  "/photos/new2.jpg"
]
```

---

## DELETE /culvert/photos/{id}?url=/photos/photo1.jpg

```json
"Фото удалено"
```

