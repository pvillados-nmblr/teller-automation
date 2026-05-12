# Teller Automation

End-to-end test automation framework for the **Higala Alegre** teller application. Covers all six rural bank partners — one shared test suite runs against each bank by simply swapping the environment config at runtime.

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

### SBX (Sandbox)

| Bank | Config File |
|---|---|
| Banco Abucay | `resources/variables/abucay-SBX.yaml` |
| Rural Bank of Hermosa | `resources/variables/hermosa-SBX.yaml` |
| BDO Rural Bank | `resources/variables/BDO-SBX.yaml` |
| Guagua Rural Bank | `resources/variables/Guagua-SBX.yaml` |
| Rural Bank of San Narciso | `resources/variables/SNR-SBX.yaml` |
| University Savings Rural Bank | `resources/variables/USB-SBX.yaml` |

### ITG (Integration)

| Bank | Config File |
|---|---|
| Banco Abucay | `resources/variables/abucay-ITG.yaml` |
| Rural Bank of San Antonio | `resources/variables/rural-bank-san-antonio.yaml` |

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

> **Rate limit warning:** Running the full test suite in one command can trigger a 60-requests/minute API rate limit that blocks the user for 60 minutes. Always run tests **per suite file** with a brief pause between suites to stay within limits.

### Run a specific test case

Use `--test` with the exact test case name:

```bash
source .venv/bin/activate && robot \
  --variablefile resources/variables/abucay-ITG.yaml \
  --test "t3.2.2 Pagination in Viewing Transaction History" \
  --outputdir results/abucay-ITG/t3.2.2-debug \
  "tests/3_accounts/t3.2_view_the_list_of_transactions_of_a_bank_account.robot" 2>&1
```

The `--outputdir` name can be anything — use a descriptive suffix (e.g. `t3.2.2-debug`, `t3.2.2-may11`) to keep reruns isolated.

### Teller types

| Type | Features | When to use `--exclude` |
|---|---|---|
| **Type 1** | Core modules only (no Products or Loans) | Add `--exclude type2` |
| **Type 2** | All modules including Products and Loans | No exclusion needed |

Tests are tagged `type1` or `type2` accordingly. When running against a Type 1 bank, add `--exclude type2` so Products and Loans tests are automatically skipped.

### Recommended run order

Run suites in this order to stay within the rate limit. Auth is always last because it has the most API-intensive tests (OTP flows, password resets).

**Reports → Transactions → Accounts → Customers → Products → Loans → Auth**

For Auth: run smoke first, then wait **15 minutes** before running negative/slow regression tests to avoid the 60-request/minute IP block.

#### Type 2 bank (e.g. Rural Bank of San Antonio)

```bash
source .venv/bin/activate

# 6 — Reports
robot --variablefile resources/variables/rural-bank-san-antonio.yaml --include smoke --outputdir results/rural-bank-san-antonio/t6.1-smoke "tests/6_reports/t6.1 Generate Reports.robot"

# 4 — Transactions
robot --variablefile resources/variables/rural-bank-san-antonio.yaml --include smoke --outputdir results/rural-bank-san-antonio/t4.1-smoke "tests/4_transactions/t4.1 View all list of Transactions.robot"
robot --variablefile resources/variables/rural-bank-san-antonio.yaml --include smoke --outputdir results/rural-bank-san-antonio/t4.2-smoke "tests/4_transactions/t4.2 Create a Withdrawal Transaction via Teller.robot"
robot --variablefile resources/variables/rural-bank-san-antonio.yaml --include smoke --outputdir results/rural-bank-san-antonio/t4.3-smoke "tests/4_transactions/t4.3 Create a Deposit Transaction via Teller.robot"

# 3 — Accounts
robot --variablefile resources/variables/rural-bank-san-antonio.yaml --include smoke --outputdir results/rural-bank-san-antonio/t3.1-smoke tests/3_accounts/t3.1_view_the_list_of_accounts.robot
robot --variablefile resources/variables/rural-bank-san-antonio.yaml --include smoke --outputdir results/rural-bank-san-antonio/t3.2-smoke tests/3_accounts/t3.2_view_the_list_of_transactions_of_a_bank_account.robot

# 2 — Customers
robot --variablefile resources/variables/rural-bank-san-antonio.yaml --include smoke --outputdir results/rural-bank-san-antonio/t2.1-smoke tests/2_customers/t2.1_view_customer_list.robot
robot --variablefile resources/variables/rural-bank-san-antonio.yaml --include smoke --outputdir results/rural-bank-san-antonio/t2.2-smoke tests/2_customers/t2.2_view_customer_accounts.robot
robot --variablefile resources/variables/rural-bank-san-antonio.yaml --include smoke --outputdir results/rural-bank-san-antonio/t2.3-smoke tests/2_customers/t2.3_view_customer_account_transactions.robot
robot --variablefile resources/variables/rural-bank-san-antonio.yaml --include smoke --outputdir results/rural-bank-san-antonio/t2.4-smoke "tests/2_customers/t2.4 View Availed and Eligible Products.robot"
robot --variablefile resources/variables/rural-bank-san-antonio.yaml --include smoke --outputdir results/rural-bank-san-antonio/t2.5-smoke tests/2_customers/t2.5_avail_savings_product.robot

# 5 — Products
robot --variablefile resources/variables/rural-bank-san-antonio.yaml --include smoke --outputdir results/rural-bank-san-antonio/t5.1-smoke tests/5_products/t5.1_view_active_products.robot
robot --variablefile resources/variables/rural-bank-san-antonio.yaml --include smoke --outputdir results/rural-bank-san-antonio/t5.2-smoke tests/5_products/t5.2_view_archived_products.robot
robot --variablefile resources/variables/rural-bank-san-antonio.yaml --include smoke --outputdir results/rural-bank-san-antonio/t5.3-smoke tests/5_products/t5.3_create_new_product.robot

# 1 — Auth smoke (run per suite; exclude slow to avoid rate limit)
robot --variablefile resources/variables/rural-bank-san-antonio.yaml --include smoke --exclude slow --outputdir results/rural-bank-san-antonio/t1.1-auth-smoke tests/1_auth/t1.1_reset_password.robot
robot --variablefile resources/variables/rural-bank-san-antonio.yaml --include smoke --exclude slow --outputdir results/rural-bank-san-antonio/t1.2-auth-smoke tests/1_auth/t1.2_login.robot
robot --variablefile resources/variables/rural-bank-san-antonio.yaml --include smoke --exclude slow --outputdir results/rural-bank-san-antonio/t1.3-auth-smoke tests/1_auth/t1.3_forgot_password.robot
robot --variablefile resources/variables/rural-bank-san-antonio.yaml --include smoke --exclude slow --outputdir results/rural-bank-san-antonio/t1.4-auth-smoke tests/1_auth/t1.4_change_password.robot
# ⏳ Wait 15 minutes before running regression
robot --variablefile resources/variables/rural-bank-san-antonio.yaml --include regression --outputdir results/rural-bank-san-antonio/t1.1-auth-regression tests/1_auth/t1.1_reset_password.robot
robot --variablefile resources/variables/rural-bank-san-antonio.yaml --include regression --outputdir results/rural-bank-san-antonio/t1.2-auth-regression tests/1_auth/t1.2_login.robot
robot --variablefile resources/variables/rural-bank-san-antonio.yaml --include regression --outputdir results/rural-bank-san-antonio/t1.3-auth-regression tests/1_auth/t1.3_forgot_password.robot
robot --variablefile resources/variables/rural-bank-san-antonio.yaml --include regression --outputdir results/rural-bank-san-antonio/t1.4-auth-regression tests/1_auth/t1.4_change_password.robot
```

#### Type 1 bank (e.g. Banco Abucay ITG) — add `--exclude type2`

```bash
source .venv/bin/activate

# 6 — Reports
robot --variablefile resources/variables/abucay-ITG.yaml --include smoke --exclude type2 --outputdir results/abucay-ITG/t6.1-smoke "tests/6_reports/t6.1 Generate Reports.robot"

# 4 — Transactions
robot --variablefile resources/variables/abucay-ITG.yaml --include smoke --exclude type2 --outputdir results/abucay-ITG/t4.1-smoke "tests/4_transactions/t4.1 View all list of Transactions.robot"
robot --variablefile resources/variables/abucay-ITG.yaml --include smoke --exclude type2 --outputdir results/abucay-ITG/t4.2-smoke "tests/4_transactions/t4.2 Create a Withdrawal Transaction via Teller.robot"
robot --variablefile resources/variables/abucay-ITG.yaml --include smoke --exclude type2 --outputdir results/abucay-ITG/t4.3-smoke "tests/4_transactions/t4.3 Create a Deposit Transaction via Teller.robot"

# 3 — Accounts
robot --variablefile resources/variables/abucay-ITG.yaml --include smoke --exclude type2 --outputdir results/abucay-ITG/t3.1-smoke tests/3_accounts/t3.1_view_the_list_of_accounts.robot
robot --variablefile resources/variables/abucay-ITG.yaml --include smoke --exclude type2 --outputdir results/abucay-ITG/t3.2-smoke tests/3_accounts/t3.2_view_the_list_of_transactions_of_a_bank_account.robot

# 2 — Customers
robot --variablefile resources/variables/abucay-ITG.yaml --include smoke --exclude type2 --outputdir results/abucay-ITG/t2.1-smoke tests/2_customers/t2.1_view_customer_list.robot
robot --variablefile resources/variables/abucay-ITG.yaml --include smoke --exclude type2 --outputdir results/abucay-ITG/t2.2-smoke tests/2_customers/t2.2_view_customer_accounts.robot
robot --variablefile resources/variables/abucay-ITG.yaml --include smoke --exclude type2 --outputdir results/abucay-ITG/t2.3-smoke tests/2_customers/t2.3_view_customer_account_transactions.robot

# 1 — Auth smoke (run per suite; exclude slow to avoid rate limit)
robot --variablefile resources/variables/abucay-ITG.yaml --include smoke --exclude slow --exclude type2 --outputdir results/abucay-ITG/t1.1-auth-smoke tests/1_auth/t1.1_reset_password.robot
robot --variablefile resources/variables/abucay-ITG.yaml --include smoke --exclude slow --exclude type2 --outputdir results/abucay-ITG/t1.2-auth-smoke tests/1_auth/t1.2_login.robot
robot --variablefile resources/variables/abucay-ITG.yaml --include smoke --exclude slow --exclude type2 --outputdir results/abucay-ITG/t1.3-auth-smoke tests/1_auth/t1.3_forgot_password.robot
robot --variablefile resources/variables/abucay-ITG.yaml --include smoke --exclude slow --exclude type2 --outputdir results/abucay-ITG/t1.4-auth-smoke tests/1_auth/t1.4_change_password.robot
# ⏳ Wait 15 minutes before running regression
robot --variablefile resources/variables/abucay-ITG.yaml --include regression --exclude type2 --outputdir results/abucay-ITG/t1.1-auth-regression tests/1_auth/t1.1_reset_password.robot
robot --variablefile resources/variables/abucay-ITG.yaml --include regression --exclude type2 --outputdir results/abucay-ITG/t1.2-auth-regression tests/1_auth/t1.2_login.robot
robot --variablefile resources/variables/abucay-ITG.yaml --include regression --exclude type2 --outputdir results/abucay-ITG/t1.3-auth-regression tests/1_auth/t1.3_forgot_password.robot
robot --variablefile resources/variables/abucay-ITG.yaml --include regression --exclude type2 --outputdir results/abucay-ITG/t1.4-auth-regression tests/1_auth/t1.4_change_password.robot
```

Results are saved per suite under `results/<bank-name>/<suite>/` so each run is isolated and never overwrites previous results.

---

## Tag System

Every test case carries a combination of the following tags:

| Tag | Meaning |
|---|---|
| `smoke` | Core happy-path tests; run on every cycle |
| `regression` | Extended tests; run for deeper coverage |
| `negative` | Invalid input / error-state tests |
| `mvp` | Tests covering MVP-scoped functionality |
| `type1` | Core tests available on all teller types (Type 1 and Type 2 banks) |
| `type2` | Tests for Type 2 teller features: Products module, Loans module, and newer transaction types (Cash Withdrawal, Cash Deposit, Savings Interest, Loan Disbursement, Loan Payment). Add `--exclude type2` when running against Type 1 banks. |
| `status-change` | Tests that mutate account or customer status (t2.1, t2.2) |
| `daily-limit` | OTC withdrawal daily limit tests (t4.2) |
| `phase2` | Tests for features not yet implemented; skipped by default |

### Common tag combinations

```bash
# Smoke only — Type 1 bank
--include smoke --exclude type2

# Smoke only — Type 2 bank
--include smoke

# Auth smoke only (run first, before negative tests)
--include smoke --exclude slow

# Auth regression / negative tests (run after 15-min cooldown)
--include regression

# Regression only — Type 1 bank
--include regression --exclude type2
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
