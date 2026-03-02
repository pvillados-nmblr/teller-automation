# Teller Automation

End-to-end test automation framework for the **Higala Alegre** teller application. Covers all four rural bank partners — one shared test suite runs against each bank by simply swapping the environment config at runtime.

---

## Table of Contents

- [Overview](#overview)
- [Supported Banks](#supported-banks)
- [Tech Stack](#tech-stack)
- [Project Structure](#project-structure)
- [Prerequisites](#prerequisites)
- [Setup](#setup)
- [Configuration](#configuration)
- [Running Tests](#running-tests)
- [Test Modules](#test-modules)
- [Resource Architecture](#resource-architecture)

---

## Overview

**Higala Alegre** is a platform banking product that enables rural banks to offer their customers a branded mobile digital bank and a teller web application. Each rural bank gets its own mobile app and teller app with their name, logo, and brand colors integrated — but the underlying functionality is identical across all banks.

### Platform Architecture

| Channel | Who uses it | Key capabilities |
|---|---|---|
| Mobile App | Customers | Onboarding, account creation, send money (internal & external transfers) |
| Teller Web App | Bank tellers | Customer management, account creation, deposits, withdrawals, loans, products, reports |

> **Note:** For the MVP, customer creation and initial account creation are done exclusively via the mobile app onboarding flow. Send money transactions (internal and external) are mobile-only but are reflected in the teller app. Deposit and withdrawal transactions are teller-only.

### Test Coverage

This framework automates teller web app testing across the following modules:

| Module | Coverage |
|---|---|
| Login | Valid/invalid credentials, case sensitivity, blank field validation |
| Customers | List view, search, status filtering, customer profile tabs, product availment |
| Accounts | View accounts, view transactions, view transaction details, create accounts |
| Transactions | View all transactions, create deposit/withdrawal transactions |
| Loans | Create, approve/reject, disburse loans |
| Products | View active/archived, create savings/loan products |
| Reports | End of Day report, Total Balance report |

All tests are bank-agnostic — the same suite is reused across all four banks. Only the URL slug and credentials differ per bank, which are managed through separate environment config files.

---

## Supported Banks

| Bank | URL Slug | Config File |
|---|---|---|
| Rural Bank of San Antonio | `/rural-bank-san-antonio` | `resources/variables/rural-bank-san-antonio.yaml` |
| Banco Abucay | `/banco-abucay` | `resources/variables/banco-abucay.yaml` |
| Rural Bank of Hermosa | `/rural-bank-hermosa` | `resources/variables/rural-bank-hermosa.yaml` |
| Alegre | `/alegre` | `resources/variables/alegre.yaml` |

---

## Tech Stack

| Tool | Version |
|---|---|
| Robot Framework | 7.4.1 |
| robotframework-browser (Playwright) | 19.12.5 |
| Playwright | 1.58.0 |
| robotframework-assertion-engine | 4.0.0 |
| Python | 3.14 |
| Browser | Chromium |

---

## Project Structure

```
teller-automation/
├── tests/
│   ├── login/
│   ├── customers/
│   ├── accounts/
│   ├── transactions/
│   ├── loans/
│   ├── products/
│   └── reports/
├── resources/
│   ├── keywords/              # Reusable keyword definitions per module
│   ├── locators/              # UI element selectors per module
│   └── variables/
│       ├── rural-bank-san-antonio.yaml
│       ├── banco-abucay.yaml
│       ├── rural-bank-hermosa.yaml
│       └── alegre.yaml
├── test_data/                 # Test data files (CSV, JSON, etc.)
├── results/                   # Auto-generated test reports (gitignored)
├── run_all.sh                 # Script to run tests for all banks
└── venv/                      # Python virtual environment (gitignored)
```

---

## Prerequisites

- Python 3.10+
- pip
- Node.js (required by Playwright internally)

---

## Setup

**1. Clone the repository**

```bash
git clone <repo-url>
cd teller-automation
```

**2. Create and activate a virtual environment**

```bash
python -m venv venv
source venv/bin/activate        # macOS/Linux
venv\Scripts\activate           # Windows
```

**3. Install dependencies**

```bash
pip install robotframework
pip install robotframework-browser
rfbrowser init
```

---

## Configuration

Each bank has its own YAML config file under `resources/variables/`. All files follow the same structure:

```yaml
BANK_NAME:        "Rural Bank of San Antonio"
BASE_URL:         "https://alegre-dashboard.int.itg.higala.ph/rural-bank-san-antonio/login"
TELLER_EMAIL:     "teller@example.com"
TELLER_PASSWORD:  "Password123!"
INVALID_EMAIL:    "invalid@email.com"
INVALID_PASSWORD: "wrongpassword"
BROWSER:          "chromium"
HEADLESS:         False
TIMEOUT:          "30s"
```

Update `TELLER_EMAIL` and `TELLER_PASSWORD` in each file with the actual credentials for that bank. Do not commit sensitive credentials to version control.

---

## Running Tests

### Run tests for a single bank

Pass the bank's config file using the `-V` flag:

```bash
# Rural Bank of San Antonio
robot -V resources/variables/rural-bank-san-antonio.yaml -d results/rural-bank-san-antonio tests/

# Banco Abucay
robot -V resources/variables/banco-abucay.yaml -d results/banco-abucay tests/

# Rural Bank of Hermosa
robot -V resources/variables/rural-bank-hermosa.yaml -d results/rural-bank-hermosa tests/

# Alegre
robot -V resources/variables/alegre.yaml -d results/alegre tests/
```

### Run a specific module for a bank

```bash
robot -V resources/variables/banco-abucay.yaml -d results/banco-abucay tests/login/
robot -V resources/variables/banco-abucay.yaml -d results/banco-abucay tests/transactions/
```

### Run by tag for a bank

```bash
# Smoke tests only
robot -V resources/variables/rural-bank-hermosa.yaml -d results/rural-bank-hermosa --include smoke tests/

# Regression tests only
robot -V resources/variables/rural-bank-hermosa.yaml -d results/rural-bank-hermosa --include regression tests/
```

### Run all banks at once

Use the included `run_all.sh` script:

```bash
# Run all tests for all banks
bash run_all.sh

# Run smoke tests only for all banks
bash run_all.sh smoke

# Run regression tests only for all banks
bash run_all.sh regression
```

Results are saved under `results/<timestamp>/<bank-name>/` so each run is isolated and never overwrites previous results.

---

## Test Modules

### Login (`tests/login/`)
- Valid login with correct credentials
- Case-insensitive email handling
- Invalid credentials error validation
- Blank field validation

### Customers (`tests/customers/`)

> Customers are created exclusively via the mobile app onboarding flow. The teller app is read-only for customer records in the MVP; teller-side customer creation is a future feature.

- View customer list and pagination
- Search by customer ID or name
- Filter by status: Active, Inactive, Dormant, Closed, Blocked, Suspended
- View customer profile — the profile page has three tabs:
  - **View Profile** — displays personal and banking details of the customer
  - **Products Availed** — displays the savings and loan products the customer has already availed
  - **Eligible Products** — displays products the customer is eligible to avail; teller can initiate the product availment process by clicking **Avail Product**
- View accounts of a customer
- View transactions of a specific customer account

### Accounts (`tests/accounts/`)

> The initial bank account is created during mobile app onboarding. Additional accounts can only be created via the teller app. Send money transactions (internal and external) originate from the mobile app but are visible here.

- View account list
- View transactions of an account
- View transaction details of a specific transaction
- Create a new bank account for an existing customer

### Transactions (`tests/transactions/`)

> Deposit and withdrawal transactions are teller-exclusive. Send money transactions are mobile-only but appear in this module as read-only records.

- View all transactions across all accounts
- Create a deposit transaction
- Create a withdrawal transaction
- Insufficient balance validation on withdrawal

### Loans (`tests/loans/`)
- View loan list
- Create loan application
- Approve loan
- Reject loan with reason
- Disburse loan

### Products (`tests/products/`)
- View active products
- View archived products
- Create savings product
- Create loan product

### Reports (`tests/reports/`)
- Generate End of Day report
- Generate Total Balance report with date range

---

## Resource Architecture

**Keywords** (`resources/keywords/`)

Each module has a corresponding `.resource` file with reusable keywords:

- `common.resource` — Open App, Login, Logout, Navigate To Module
- `customers.resource` — Search For Customer, View Customer Profile, Filter By Status
- `accounts.resource` — Create Account, View Transactions
- `transactions.resource` — Process Deposit, Process Withdrawal
- `loans.resource` — Create Loan, Approve Loan, Disburse Loan
- `products.resource` — Create Product
- `reports.resource` — Generate Report

**Locators** (`resources/locators/`)

CSS selectors and XPath expressions are centralized per module, keeping test logic separate from element definitions. Since all four bank apps share the same UI structure, locators are bank-agnostic and require no changes per bank.
