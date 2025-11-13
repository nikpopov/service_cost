# Spare Parts Calculator

A Flutter application for tracking spare parts and service costs for multiple family automobiles.

## Features

- **Multi-Vehicle Management**: Track multiple cars in your family
- **Spare Parts Tracking**:
  - Record imported/ordered parts with import costs, shipping, and customs clearance
  - Record locally purchased parts
  - Track part details (name, price, supplier, purchase date)
  - **Shipment Tracking** for imported parts:
    - Track order placement, shipment, warehouse delivery, and receiving dates
    - Monitor expected delivery dates
    - Distinguish between sea and air freight
    - Visual timeline display of shipment progress
- **Service Cost Tracking**: Monitor service and repair costs
- **Cost Analysis**:
  - Total costs per vehicle
  - Cost breakdown by category (parts vs services)
  - Vehicle cost comparison

## Project Structure

```
lib/
├── models/          # Data models
├── screens/         # UI screens
├── widgets/         # Reusable widgets
├── services/        # Business logic and data services
└── utils/           # Utility functions and constants
```

## Getting Started

1. Ensure Flutter is installed: `flutter --version`
2. Get dependencies: `flutter pub get`
3. Run the app: `flutter run`

## Architecture

The app follows a clean architecture pattern with:
- **Models**: Data structures
- **Services**: Data persistence and business logic
- **Screens**: UI presentation
- **Widgets**: Reusable UI components
- **Provider**: State management
