# ALX Airbnb Database — ERD Requirements

## Overview
This document defines the **entities, attributes, and relationships** for an Airbnb-like relational database.  
It supports core flows: **hosting properties, searching & booking stays, paying for bookings, and reviewing experiences**.

> **Actors**
> - **Host**: a user who lists properties.
> - **Guest**: a user who books properties.  
> (Both are stored in the same **User** entity; roles are handled via fields.)

---

## Entity Catalog

### 1) `users`
**Purpose:** store both hosts and guests.

| Field | Type | Constraints | Notes |
|---|---|---|---|
| id | UUID | PK | unique user id |
| full_name | varchar(150) | NOT NULL |  |
| email | varchar(255) | NOT NULL, UNIQUE | login identifier |
| phone | varchar(30) | NULL | E.164 preferred |
| role | enum('guest','host','both') | NOT NULL, DEFAULT 'guest' |  |
| created_at | timestamptz | NOT NULL |  |
| updated_at | timestamptz | NOT NULL |  |

**Indexes:** `UNIQUE(email)`

---

### 2) `properties`
**Purpose:** listings created by hosts.

| Field | Type | Constraints | Notes |
|---|---|---|---|
| id | UUID | PK |  |
| host_id | UUID | FK → users.id | NOT NULL |
| title | varchar(150) | NOT NULL |  |
| description | text | NULL |  |
| property_type | enum('apartment','house','room','villa','other') | NOT NULL |
| max_guests | int | NOT NULL, CHECK >= 1 |  |
| bedrooms | int | NOT NULL, DEFAULT 1 |  |
| beds | int | NOT NULL, DEFAULT 1 |  |
| bathrooms | numeric(3,1) | NOT NULL, DEFAULT 1.0 |  |
| price_per_night | numeric(10,2) | NOT NULL | base price |
| currency | char(3) | NOT NULL | ISO 4217 |
| address_line1 | varchar(255) | NOT NULL |  |
| address_line2 | varchar(255) | NULL |  |
| city | varchar(120) | NOT NULL |  |
| state | varchar(120) | NULL |  |
| country | varchar(2) | NOT NULL | ISO 3166-1 alpha-2 |
| postal_code | varchar(20) | NULL |  |
| latitude | numeric(9,6) | NULL |  |
| longitude | numeric(9,6) | NULL |  |
| is_active | boolean | NOT NULL, DEFAULT true |  |
| created_at | timestamptz | NOT NULL |  |
| updated_at | timestamptz | NOT NULL |  |

**Indexes:** `(host_id)`, `(city,country)`, `GIN on (to_tsvector(title, description))` (optional)

---

### 3) `property_images`
**Purpose:** images per property.

| Field | Type | Constraints | Notes |
|---|---|---|---|
| id | UUID | PK |  |
| property_id | UUID | FK → properties.id | NOT NULL |
| url | text | NOT NULL | CDN / storage path |
| is_primary | boolean | NOT NULL, DEFAULT false |  |
| created_at | timestamptz | NOT NULL |  |

**Index:** `(property_id, is_primary DESC)`

---

### 4) `amenities`
**Purpose:** list of available amenity types.

| Field | Type | Constraints |
|---|---|---|
| id | UUID | PK |
| code | varchar(60) | UNIQUE, NOT NULL |
| label | varchar(120) | NOT NULL |

---

### 5) `property_amenities` (junction)
**Purpose:** map amenities to properties (M:N).

| Field | Type | Constraints |
|---|---|---|
| property_id | UUID | PK, FK → properties.id |
| amenity_id | UUID | PK, FK → amenities.id |

**Composite PK:** `(property_id, amenity_id)`

---

### 6) `bookings`
**Purpose:** guest reservations for a property.

| Field | Type | Constraints | Notes |
|---|---|---|---|
| id | UUID | PK |  |
| property_id | UUID | FK → properties.id | NOT NULL |
| guest_id | UUID | FK → users.id | NOT NULL |
| check_in | date | NOT NULL |  |
| check_out | date | NOT NULL, CHECK check_out > check_in |  |
| nights | int | NOT NULL | derived or stored |
| guests_count | int | NOT NULL, CHECK >= 1 |  |
| subtotal_amount | numeric(10,2) | NOT NULL | rate × nights |
| cleaning_fee | numeric(10,2) | NOT NULL, DEFAULT 0 | optional |
| service_fee | numeric(10,2) | NOT NULL, DEFAULT 0 | optional |
| total_amount | numeric(10,2) | NOT NULL |  |
| currency | char(3) | NOT NULL |  |
| status | enum('pending','confirmed','cancelled','completed','no_show') | NOT NULL, DEFAULT 'pending' |
| created_at | timestamptz | NOT NULL |
| updated_at | timestamptz | NOT NULL |

**Indexes:** `(property_id, check_in, check_out)`, `(guest_id, created_at DESC)`  
**Business rule:** prevent date overlaps for the same `property_id` when `status IN ('pending','confirmed')`.

---

### 7) `payments`
**Purpose:** record payments for bookings (allow multiple—deposit, balance, refund).

| Field | Type | Constraints | Notes |
|---|---|---|---|
| id | UUID | PK |  |
| booking_id | UUID | FK → bookings.id | NOT NULL |
| provider | enum('stripe','paypal','flutterwave','paystack','other') | NOT NULL |
| transaction_id | varchar(120) | UNIQUE, NULL | gateway id |
| amount | numeric(10,2) | NOT NULL |
| currency | char(3) | NOT NULL |
| status | enum('initiated','succeeded','failed','refunded','partially_refunded') | NOT NULL |
| paid_at | timestamptz | NULL |
| created_at | timestamptz | NOT NULL |

**Indexes:** `(booking_id)`, `UNIQUE(transaction_id)` (nullable unique)

---

### 8) `property_reviews`
**Purpose:** guest reviews about properties.

| Field | Type | Constraints | Notes |
|---|---|---|---|
| id | UUID | PK |  |
| booking_id | UUID | FK → bookings.id | NOT NULL |
| property_id | UUID | FK → properties.id | NOT NULL |
| author_id | UUID | FK → users.id | NOT NULL (guest) |
| rating | int | NOT NULL, CHECK between 1 and 5 |  |
| comment | text | NULL |  |
| created_at | timestamptz | NOT NULL |

**Index:** `(property_id, created_at DESC)`, `UNIQUE(booking_id)` (1 review per completed booking)

---

### 9) `user_reviews`
**Purpose:** optional reputation system (e.g., hosts review guests).

| Field | Type | Constraints |
|---|---|---|
| id | UUID | PK |
| booking_id | UUID | FK → bookings.id, UNIQUE |
| reviewee_id | UUID | FK → users.id |
| reviewer_id | UUID | FK → users.id |
| rating | int | CHECK 1..5 |
| comment | text | NULL |
| created_at | timestamptz | NOT NULL |

**Indexes:** `(reviewee_id, created_at DESC)`

---

### 10) `availability_calendar` (optional)
**Purpose:** explicit availability blocks; can be derived from bookings but useful for overrides/blackouts.

| Field | Type | Constraints | Notes |
|---|---|---|---|
| id | UUID | PK |  |
| property_id | UUID | FK → properties.id | NOT NULL |
| date | date | NOT NULL |
| is_available | boolean | NOT NULL |
| min_nights | int | NULL |
| price_override | numeric(10,2) | NULL |

**Unique:** `UNIQUE(property_id, date)`

---

## Relationships (Cardinality & Direction)

- **users (host) 1—N properties**
  - `properties.host_id → users.id`

- **users (guest) 1—N bookings**
  - `bookings.guest_id → users.id`

- **properties 1—N bookings**
  - `bookings.property_id → properties.id`

- **bookings 1—N payments**
  - `payments.booking_id → bookings.id`

- **properties M—N amenities**
  - via `property_amenities (property_id, amenity_id)`

- **properties 1—N property_images**
  - `property_images.property_id → properties.id`

- **bookings 1—1 property_reviews**
  - `property_reviews.booking_id → bookings.id (UNIQUE)`

- **users 1—N user_reviews (as reviewee)**
  - `user_reviews.reviewee_id → users.id`

- **users 1—N user_reviews (as reviewer)**
  - `user_reviews.reviewer_id → users.id`

- **properties 1—N availability_calendar**
  - `availability_calendar.property_id → properties.id`

**Optionalities:**
- A **user** may be a host, guest, or both.
- A **property** must have a host; it may have zero or more bookings.
- A **booking** must have a guest and property; it may have zero or more payments; review is optional until completed.

---

## Mermaid ER Diagram (GitHub-Previewable)

> Paste this in any Markdown viewer that supports Mermaid (GitHub does 🎉).  
> Also export a PNG from Draw.io named **`alx-airbnb-erd.png`** and store it in `ERD/`.

```mermaid
erDiagram
  USERS ||--o{ PROPERTIES : "hosts"
  USERS ||--o{ BOOKINGS : "makes"
  PROPERTIES ||--o{ BOOKINGS : "is booked in"
  BOOKINGS ||--o{ PAYMENTS : "has"
  PROPERTIES ||--o{ PROPERTY_IMAGES : "has"
  PROPERTIES ||--o{ PROPERTY_AMENITIES : ""
  AMENITIES ||--o{ PROPERTY_AMENITIES : ""
  BOOKINGS ||--o| PROPERTY_REVIEWS : "gets"
  USERS ||--o{ USER_REVIEWS : "receives"
  USERS ||--o{ USER_REVIEWS : "writes"
  PROPERTIES ||--o{ AVAILABILITY_CALENDAR : "sets"

  USERS {
    uuid id PK
    varchar full_name
    varchar email UNIQUE
    varchar phone
    enum role
    timestamptz created_at
    timestamptz updated_at
  }

  PROPERTIES {
    uuid id PK
    uuid host_id FK
    varchar title
    text description
    enum property_type
    int max_guests
    int bedrooms
    int beds
    numeric bathrooms
    numeric price_per_night
    char currency
    varchar address_line1
    varchar address_line2
    varchar city
    varchar state
    char country
    varchar postal_code
    numeric latitude
    numeric longitude
    boolean is_active
    timestamptz created_at
    timestamptz updated_at
  }

  PROPERTY_IMAGES {
    uuid id PK
    uuid property_id FK
    text url
    boolean is_primary
    timestamptz created_at
  }

  AMENITIES {
    uuid id PK
    varchar code UNIQUE
    varchar label
  }

  PROPERTY_AMENITIES {
    uuid property_id PK, FK
    uuid amenity_id  PK, FK
  }

  BOOKINGS {
    uuid id PK
    uuid property_id FK
    uuid guest_id FK
    date check_in
    date check_out
    int nights
    int guests_count
    numeric subtotal_amount
    numeric cleaning_fee
    numeric service_fee
    numeric total_amount
    char currency
    enum status
    timestamptz created_at
    timestamptz updated_at
  }

  PAYMENTS {
    uuid id PK
    uuid booking_id FK
    enum provider
    varchar transaction_id
    numeric amount
    char currency
    enum status
    timestamptz paid_at
    timestamptz created_at
  }

  PROPERTY_REVIEWS {
    uuid id PK
    uuid booking_id FK UNIQUE
    uuid property_id FK
    uuid author_id FK
    int rating
    text comment
    timestamptz created_at
  }

  USER_REVIEWS {
    uuid id PK
    uuid booking_id FK UNIQUE
    uuid reviewee_id FK
    uuid reviewer_id FK
    int rating
    text comment
    timestamptz created_at
  }

  AVAILABILITY_CALENDAR {
    uuid id PK
    uuid property_id FK
    date date
    boolean is_available
    int min_nights
    numeric price_override
  }
