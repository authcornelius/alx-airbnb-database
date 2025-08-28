# Database Normalization (3NF)

## Objective

The goal of normalization is to eliminate redundancy and ensure data is stored efficiently. For this task, the database schema was reviewed and adjusted to meet the requirements of **Third Normal Form (3NF)**.

---

## Normalization Steps

### 1. First Normal Form (1NF)

* Ensured that all tables have a primary key.
* Removed repeating groups and multi-valued attributes.
* Each field contains only atomic (indivisible) values.

### 2. Second Normal Form (2NF)

* Ensured the schema is already in 1NF.
* Removed partial dependencies (i.e., no non-prime attribute depends only on part of a composite primary key).
* Each non-key attribute is fully dependent on the entire primary key.

### 3. Third Normal Form (3NF)

* Ensured the schema is already in 2NF.
* Removed transitive dependencies (i.e., non-key attributes depending on other non-key attributes).
* Ensured that every non-key attribute depends only on the primary key.

---

## Example: Airbnb Database

### Before Normalization

**Bookings Table**

```
booking_id | guest_name | guest_email | property_name | property_address | host_name | host_contact | booking_date
```

Issues:

* Repetition of guest info across multiple bookings.
* Repetition of property and host info.
* Violation of 3NF due to transitive dependencies.

---

### After Normalization (3NF)

**Guests Table**

```
guest_id | guest_name | guest_email
```

**Hosts Table**

```
host_id | host_name | host_contact
```

**Properties Table**

```
property_id | property_name | property_address | host_id
```

**Bookings Table**

```
booking_id | booking_date | guest_id | property_id
```

---

## Benefits of 3NF

* Eliminates redundancy (guest, host, and property details stored once).
* Ensures consistency and integrity.
* Easier to maintain and update.

---

✅ Database schema is now in **Third Normal Form (3NF)**.
