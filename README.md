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
- [Tag System](#tag-system)
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
| Banco Abucay (ITG) | `/banco-abucay` | `resources/variables/abucay-ITG.yaml` |
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
│   ├── 1_auth/
│   ├── 2_customers/
│   ├── 3_accounts/
│   ├── 4_transactions/
│   ├── 5_products/
│   ├── 6_reports/
│   └── 7_loans/
├── resources/
│   ├── keywords/              # Reusable keyword definitions per module
│   ├── locators/              # UI element selectors per module
│   ├── libraries/             # Custom Python libraries (e.g. CsvVerifier)
│   └── variables/
│       ├── rural-bank-san-antonio.yaml
│       ├── abucay-ITG.yaml
│       ├── banco-abucay.yaml
│       ├── rural-bank-hermosa.yaml
│       └── alegre.yaml
├── results/                   # Auto-generated test reports (gitignored)
├── run_all.sh                 # Script to run tests for all banks
└── .venv/                     # Python virtual environment (gitignored)
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
python -m venv .venv
source .venv/bin/activate        # macOS/Linux
.venv\Scripts\activate           # Windows
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

```bash
# Rural Bank of San Antonio — all smoke tests
robot --variablefile resources/variables/rural-bank-san-antonio.yaml \
      --include smoke \
      --outputdir results/rural-bank-san-antonio \
      tests/

# Banco Abucay ITG — smoke tests, skip type2
robot --variablefile resources/variables/abucay-ITG.yaml \
      --include smoke --exclude type2 \
      --outputdir results/abucay-ITG \
      tests/
```

### Run a specific module for a bank

```bash
robot --variablefile resources/variables/rural-bank-san-antonio.yaml \
      --include smoke \
      --outputdir results/rural-bank-san-antonio/customers \
      tests/2_customers/

robot --variablefile resources/variables/rural-bank-san-antonio.yaml \
      --include smoke \
      --outputdir results/rural-bank-san-antonio/transactions \
      tests/4_transactions/
```

### Run a specific test suite file

```bash
source .venv/bin/activate && robot \
  --variablefile resources/variables/rural-bank-san-antonio.yaml \
  --include smoke \
  --outputdir results/rural-bank-san-antonio/reports \
  tests/6_reports/
```

### Run all banks at once

Use the included `run_all.sh` script:

```bash
# Smoke tests for all banks
bash run_all.sh --tag smoke

# One bank only
bash run_all.sh --bank rural-bank-san-antonio --tag smoke

# One module only
bash run_all.sh --module reports --tag smoke

# Smoke tests, skip a specific tag
bash run_all.sh --tag smoke --exclude reset-password
```

Results are saved under `results/<bank-name>/` so each run is isolated.

---

## Tag System

Every test case carries a combination of the following tags:

| Tag | Meaning |
|---|---|
| `smoke` | Core happy-path tests; run on every cycle |
| `regression` | Extended tests; run for deeper coverage |
| `negative` | Invalid input / error-state tests |
| `mvp` | Tests covering MVP-scoped functionality |
| `type1` | Standard tests that run across all banks |
| `type2` | Tests involving newer transaction types (Cash Withdrawal, Cash Deposit, Savings Interest, Loan Disbursement, Loan Payment) or bank-specific features; use `--exclude type2` to skip on banks where these types are not yet available |
| `status-change` | Tests that mutate account or customer status (t2.1, t2.2) |
| `daily-limit` | OTC withdrawal daily limit tests (t4.2) |
| `phase2` | Tests for features not yet implemented; skipped by default |

### Common tag combinations

```bash
# Core smoke only (no type2)
--include smoke --exclude type2

# All smoke including type2
--include smoke

# Regression only
--include regression --exclude type2

# Auth tests with rate-limit protection
--include smoke --module auth
```

---

## Test Modules

### Auth (`tests/1_auth/`)
- Reset password via temporary password (t1.1)
- Login — valid/invalid credentials, case-insensitive email (t1.2)
- Forgot password flow (t1.3)
- Change password (t1.4)

### Customers (`tests/2_customers/`)

> Customers are created exclusively via the mobile app onboarding flow. The teller app is read-only for customer records in the MVP.

- **t2.1** View customer list, search by ID/name, filter by status (Active, Inactive, Dormant, Closed, Blocked, Suspended), change customer status
- **t2.2** View accounts of a customer, search by account ID/name, filter by account status, change account status (Active/Dormant/Frozen/Closed)
- **t2.3** View transactions of a customer account, search by transaction ID, date range filter, filter by transaction type (Send Money, Receive Money, Fund Transfer, Cash Withdrawal, Cash Deposit, Savings Interest, Loan Disbursement, Loan Payment) and status (Pending, Success, Failed)
- **t2.4** View availed and eligible products per customer
- **t2.5** Avail a savings product for a customer

### Accounts (`tests/3_accounts/`)

> The initial bank account is created during mobile app onboarding. Send money transactions (internal and external) originate from the mobile app but are visible in this module.

- **t3.1** View account list, search, filter by status, view account details
- **t3.2** View transaction history of an account, search by ID, date range filter, filter by transaction type (all 8 types) and status (Pending, Success, Failed), view transaction details

### Transactions (`tests/4_transactions/`)

> Deposit and withdrawal transactions are teller-exclusive. Send money transactions are mobile-only but appear in this module as read-only records.

- **t4.1** View all transactions, search by ID, date range filter, filter by transaction type (External Transfer, Internal Transfer, Cash Withdrawal, Cash Deposit, Interest Crediting, Loan Disbursement, Loan Payment) and status
- **t4.2** Create a cash withdrawal transaction; OTC daily limit enforcement and validation (t4.2 uses `type2` tag)
- **t4.3** Create a cash deposit transaction; validation for invalid account, high deposit amounts (t4.3 uses `type2` tag)

### Products (`tests/5_products/`)
- **t5.1** View active products list, search and pagination
- **t5.2** View archived products list
- **t5.3** Create new savings product and loan product

### Reports (`tests/6_reports/`)
- **t6.1** Generate End of Day Balance report (download CSV, verify headers, balance, date format); Generate Total Balance report with date range
- CSV balance formula: sum of `Cash Deposit`, `Cash Withdrawal`, and `External Transfer` amounts; `Internal Transfer` rows are excluded

### Loans (`tests/7_loans/`)
- In progress

---

## Resource Architecture

**Keywords** (`resources/keywords/`)

Each module has a corresponding `.resource` file with reusable keywords:

- `common.resource` — Open App, Login, Logout, Navigate To Module, Wait For Load Spinner
- `customers.resource` — Navigate To Customers, Search For Customer, Filter By Status, Navigate To Customer Accounts
- `accounts.resource` — Navigate To Account Transactions, Filter Acct Txn Results
- `transactions.resource` — Select Txn Date Range From AntD Picker, Filter Txn Results
- `products.resource` — Navigate To Products, Create Savings Product, Create Loan Product
- `reports.resource` — Select Closing Date From AntD Picker, Select Report Date Range From AntD Picker, Download Report CSV

**Locators** (`resources/locators/`)

CSS selectors are centralized per module, keeping test logic separate from element definitions. All bank apps share the same UI structure so locators are bank-agnostic.

- `customers_locators.resource` — customer table, account table, transaction table, transaction type/status filter dropdowns, account status badge/dropdown, status change modal
- `transactions_locators.resource` — transactions table, type/status filter dropdowns, date range picker, transaction detail modal
- `products_locators.resource`, `accounts_locators.resource`, `reports_locators.resource`, `common_locators.resource`

**Libraries** (`resources/libraries/`)

- `CsvVerifier.py` — Custom Python library for verifying downloaded CSV reports: file name pattern, column headers, date format, date range, balance computation vs summary row
