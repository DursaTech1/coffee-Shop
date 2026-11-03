# CoffeeHub Django REST Backend

A robust, production-ready Django REST Framework API powering the **CoffeeHub** mobile application.

---

## 🚀 Quick Start

### 1. Activate Environment & Run Server
```bash
cd backend
venv/bin/python manage.py runserver 0.0.0.0:8000
```
The API is now live at `http://127.0.0.1:8000/api/` (or `http://10.0.2.2:8000/api/` from the Android emulator).

### 2. Database Migrations & Seed Data
The database is pre-configured and seeded with all initial data. If you ever need to re-seed:
```bash
venv/bin/python manage.py migrate
venv/bin/python manage.py seed_data
```

---

## 📡 API Endpoints

### 🔐 Authentication & Profile
- `POST /api/auth/register/` — Create new user account (returns auth token & user profile)
- `POST /api/auth/login/` — Sign in with email and password (returns auth token)
- `GET /api/auth/profile/` — Retrieve user profile (name, address, email, phone)
- `PUT /api/auth/profile/` — Update user profile

### ☕ Menu & Categories
- `GET /api/categories/` — List all drink categories (Coffee, Tea, Latte, Others)
- `GET /api/coffees/` — List all coffees with optional query filters:
  - `?category=Coffee` — Filter by category
  - `?search=cappuccino` — Real-time search across drink names & descriptions
  - `?popular=true` — Filter by popular items

### 📦 Orders & Tracking
- `GET /api/orders/` — List user order history with optional status filter:
  - `?status=delivered`
  - `?status=pending`
- `POST /api/orders/` — Place a new coffee order with items, subtotal, delivery fee, and address
- `GET /api/orders/<id>/` — Order detail and status tracking

### 🔔 Notifications
- `GET /api/notifications/` — List user notifications and delivery alerts

---

## 👤 Pre-configured Test Account
- **Email**: `murad@gmail.com`
- **Password**: `password123`
- **Name**: Murad Demelash
- **Address**: 221B Baker Street, London

