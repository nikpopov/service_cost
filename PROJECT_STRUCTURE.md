# Project Structure

## Overview
This Flutter application helps families track spare parts and service costs for multiple automobiles, with special support for imported and locally purchased parts.

## Architecture

The app follows a clean architecture pattern with clear separation of concerns:

```
lib/
├── models/              # Data models
│   ├── automobile.dart
│   ├── spare_part.dart
│   ├── service_record.dart
│   └── cost_summary.dart
│
├── services/            # Business logic and data layer
│   ├── database_service.dart           # SQLite database setup
│   ├── automobile_repository.dart      # CRUD for automobiles
│   ├── spare_part_repository.dart      # CRUD for spare parts
│   ├── service_record_repository.dart  # CRUD for service records
│   ├── cost_calculation_service.dart   # Cost aggregation logic
│   ├── automobile_provider.dart        # State management
│   ├── spare_part_provider.dart        # State management
│   └── service_record_provider.dart    # State management
│
├── screens/             # UI screens
│   ├── home_screen.dart                # List of automobiles
│   ├── automobile_detail_screen.dart   # Details, parts, services
│   ├── add_automobile_screen.dart      # Add/edit automobile
│   ├── add_spare_part_screen.dart      # Add/edit spare part
│   └── add_service_record_screen.dart  # Add/edit service record
│
├── widgets/             # Reusable UI components
│   ├── spare_parts_tab.dart            # Tab showing spare parts list
│   └── service_records_tab.dart        # Tab showing service records list
│
├── utils/               # Utilities and constants
│   ├── constants.dart                   # App constants and colors
│   └── formatters.dart                  # Formatting utilities
│
└── main.dart            # App entry point
```

## Data Models

### Automobile
Represents a vehicle with make, model, year, license plate, and optional VIN.

### SparePart
Represents a spare part with:
- Basic info: name, part number, price
- Source: imported or local
- Import details: import cost, shipping cost, customs clearance cost, origin country
- Purchase info: supplier, date, notes

### ServiceRecord
Represents a service/maintenance record with:
- Type: maintenance, repair, inspection, other
- Cost and date
- Optional: mileage, service provider, description

### CostSummary
Aggregates costs for an automobile:
- Total spare parts cost (imported + local)
- Total services cost
- Breakdown by category

## State Management

Uses Provider package for state management:
- **AutomobileProvider**: Manages automobile list
- **SparePartProvider**: Manages spare parts for selected automobile
- **ServiceRecordProvider**: Manages service records for selected automobile

## Database

Uses SQLite for local data persistence with three main tables:
- `automobiles`: Vehicle information
- `spare_parts`: Spare parts with import details
- `service_records`: Service and maintenance records

Foreign key constraints ensure data integrity (CASCADE DELETE).

## Features

### Multi-Automobile Management
- Add, edit, and view multiple family vehicles
- Each automobile has its own parts and service history

### Spare Parts Tracking
- Track both imported and locally purchased parts
- For imported parts: track import costs, shipping, customs clearance, and origin
- Calculate total cost including all fees
- Record supplier and purchase date

### Service Cost Tracking
- Track maintenance, repairs, inspections
- Record mileage, service provider, and descriptions
- Categorize by service type

### Cost Analysis
- View total costs per automobile
- Breakdown by parts vs. services
- Separate imported vs. local part costs
- Summary cards with visual indicators

## UI Screens

1. **Home Screen**: Lists all automobiles with total costs
2. **Automobile Detail**: Tabbed view showing parts and services
3. **Add Forms**: Comprehensive forms for adding/editing data

## Color Coding

- **Primary**: Blue (#2196F3)
- **Imported Parts**: Green (#4CAF50)
- **Local Parts**: Blue (#2196F3)
- **Service Types**:
  - Maintenance: Blue
  - Repair: Orange
  - Inspection: Green
  - Other: Grey

## Dependencies

- `provider`: State management
- `sqflite`: Local database
- `shared_preferences`: Simple key-value storage
- `intl`: Internationalization and formatting
- `uuid`: Generate unique IDs
- `path_provider`: Access file system paths
