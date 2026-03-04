# Contributor Workflow Guide

This document covers everything a new teammate needs to know to contribute to the teller automation codebase — from initial setup to daily Git habits.

---

## Table of Contents

- [1. Initial Setup](#1-initial-setup)
- [2. Codebase Orientation](#2-codebase-orientation)
- [3. Git Workflow](#3-git-workflow)
  - [Branching Strategy](#branching-strategy)
  - [When to Create a Branch](#when-to-create-a-branch)
  - [Daily Pull Habit](#daily-pull-habit)
  - [Pushing Your Work](#pushing-your-work)
  - [Branch Naming Convention](#branch-naming-convention)
  - [Commit Message Convention](#commit-message-convention)
- [4. Working on Tests](#4-working-on-tests)
  - [Adding a New Test Case](#adding-a-new-test-case)
  - [Adding a New Keyword](#adding-a-new-keyword)
  - [Adding a New Locator](#adding-a-new-locator)
- [5. Running Tests Locally](#5-running-tests-locally)
- [6. What NOT to Commit](#6-what-not-to-commit)
- [7. Workflow Diagram](#7-workflow-diagram)

---

## 1. Initial Setup

Do this once when you first clone the repo.

```bash
# 1. Clone the repository
git clone <repo-url>
cd teller-automation

# 2. Create and activate a virtual environment
python -m venv venv
source venv/bin/activate        # macOS / Linux
venv\Scripts\activate           # Windows

# 3. Install dependencies
pip install robotframework
pip install robotframework-browser
rfbrowser init
```

After setup, verify it works by running one test module:

```bash
robot -V resources/variables/banco-abucay.yaml -d results/banco-abucay tests/login/
```

### Activating the venv every session

You must activate the virtual environment every time you open a new terminal:

```bash
source venv/bin/activate        # macOS / Linux
venv\Scripts\activate           # Windows
```

Your shell prompt will show `(venv)` when it is active.

---

## 2. Codebase Orientation

```
teller-automation/
├── tests/                      ← Test suites, organized by module
│   ├── login/
│   ├── customers/
│   ├── accounts/
│   ├── transactions/
│   ├── loans/
│   ├── products/
│   └── reports/
├── resources/
│   ├── keywords/               ← Reusable Robot Framework keywords (.resource)
│   ├── locators/               ← CSS selectors / XPath per module (.resource)
│   └── variables/              ← Per-bank config files (.yaml)
│       ├── rural-bank-san-antonio.yaml
│       ├── banco-abucay.yaml
│       ├── rural-bank-hermosa.yaml
│       └── alegre.yaml
├── test_data/                  ← CSV / JSON input data for data-driven tests
├── results/                    ← Auto-generated reports (gitignored)
├── run_all.sh                  ← Runs full suite across all four banks
└── venv/                       ← Python virtual environment (gitignored)
```

**Key rule:** Test logic lives in `tests/`, reusable steps go in `resources/keywords/`, and element selectors go in `resources/locators/`. Never mix them.

---

## 3. Git Workflow

### Branching Strategy

| Branch | Purpose |
|--------|---------|
| `main` | Stable, working code. Never commit directly here. |
| `feature/<name>` | New test cases or new automation coverage |
| `fix/<name>` | Fixing a broken or flaky test |
| `chore/<name>` | Non-test changes: config, locators, keywords, docs |

### When to Create a Branch

Create a new branch **before** you start any work. Use the table below as a guide:

| Scenario | Create a branch? | Branch type |
|----------|-----------------|-------------|
| Adding tests for a new module (e.g., reports) | Yes | `feature/` |
| Adding a new test case inside an existing module | Yes | `feature/` |
| Fixing a failing or flaky test | Yes | `fix/` |
| Updating a locator that broke after a UI change | Yes | `fix/` |
| Adding a keyword for reuse | Yes | `chore/` |
| Updating a bank's credentials or config | Yes | `chore/` |
| Updating the README or this guide | Yes | `chore/` |
| Experimenting before writing actual tests | Yes | `feature/` |

**Never work directly on `main`.** Even small changes need a branch.

### Daily Pull Habit

Before starting work each day, sync with the latest changes on `main`:

```bash
git checkout main
git pull origin main
```

Then switch to your branch and rebase (or merge) to stay current:

```bash
git checkout feature/your-branch
git merge main
```

If you see merge conflicts, resolve them in your editor, then:

```bash
git add <conflicted-file>
git commit
```

### Pushing Your Work

Push your branch to remote so others can see it and so your work is backed up:

```bash
# First push — sets upstream tracking
git push -u origin feature/your-branch

# Subsequent pushes
git push
```

When your work is ready to merge into `main`, open a Pull Request (PR) on GitHub. Do not merge your own PR — have a teammate review it first.

### Branch Naming Convention

Use lowercase with hyphens. Be specific enough that the branch name alone explains the work.

```
feature/loans-reject-reason-validation
feature/products-create-savings-product
fix/customers-search-timeout
fix/login-blank-password-assertion
chore/update-banco-abucay-locators
chore/add-navigate-to-module-keyword
```

### Commit Message Convention

Keep commits focused and messages descriptive. Use the format:

```
<type>: <short description>

Examples:
feat: add withdrawal insufficient balance test case
fix: update deposit amount locator after UI redesign
chore: add reusable keyword for navigating to Loans module
test: cover loan disbursement happy path for all banks
```

One logical change per commit. Avoid bundling unrelated changes together.

---

## 4. Working on Tests

### Adding a New Test Case

1. Navigate to the correct module folder under `tests/`.
2. Open (or create) the `.robot` file for that module.
3. Write your test case under the `*** Test Cases ***` section.
4. Use existing keywords from `resources/keywords/` — do not duplicate logic.
5. Tag your test with `smoke` or `regression` as appropriate.

```robotframework
*** Test Cases ***
Teller Creates Withdrawal With Insufficient Balance
    [Tags]    regression    transactions
    Open App And Login
    Navigate To Module    Transactions
    Process Withdrawal    amount=9999999
    Verify Error Message    Insufficient balance
```

### Adding a New Keyword

If your test requires a step that doesn't exist yet or is used more than once:

1. Open the relevant `.resource` file in `resources/keywords/`.
2. Add the keyword under `*** Keywords ***`.
3. If the keyword is truly general (e.g., navigation, login), add it to `common.resource`.

```robotframework
*** Keywords ***
Process Withdrawal
    [Arguments]    ${amount}
    Click    ${WITHDRAW_BTN}
    Fill Text    ${AMOUNT_INPUT}    ${amount}
    Click    ${CONFIRM_BTN}
```

### Adding a New Locator

If a UI element is not yet mapped:

1. Open the relevant locators file in `resources/locators/` (e.g., `transactions_locators.resource`).
2. Add the locator as a variable.

```robotframework
*** Variables ***
${WITHDRAW_BTN}     css=button[data-testid="withdraw"]
${AMOUNT_INPUT}     css=input[name="amount"]
${CONFIRM_BTN}      css=button[type="submit"]
```

Always use `data-testid` attributes when available — they are more stable than class names or text.

---

## 5. Running Tests Locally

Always run with `-V` pointing to the bank config file and `-d` for output directory.

```bash
# Single module for one bank
robot -V resources/variables/banco-abucay.yaml \
      -d results/banco-abucay \
      tests/transactions/

# Smoke tests only for one bank
robot -V resources/variables/rural-bank-hermosa.yaml \
      -d results/rural-bank-hermosa \
      --include smoke tests/

# Full suite for all banks
bash run_all.sh

# Smoke tests for all banks
bash run_all.sh smoke
```

Reports are saved under `results/` and are gitignored. Open `results/<bank>/log.html` in your browser for the detailed test log.

---

## 6. What NOT to Commit

The `.gitignore` already covers most of these, but be aware:

| Item | Reason |
|------|--------|
| `results/` | Auto-generated, changes every run |
| `venv/` | Machine-specific, each dev creates their own |
| `*.yaml` credentials | Do not commit real passwords — use placeholders |
| `output.xml`, `log.html`, `report.html` | Robot output files, gitignored |
| `.DS_Store`, `Thumbs.db` | OS junk files |

**Sensitive credentials** (`TELLER_EMAIL`, `TELLER_PASSWORD` in the `.yaml` files) should never be committed with real values. Keep real credentials local only.

---

## 7. Workflow Diagram

```
  main (protected)
    │
    ├── Pull latest
    │     git checkout main
    │     git pull origin main
    │
    ├── Create your branch
    │     git checkout -b feature/your-branch-name
    │
    ├── Do your work
    │     - Write/edit tests in tests/
    │     - Write/edit keywords in resources/keywords/
    │     - Write/edit locators in resources/locators/
    │
    ├── Commit frequently
    │     git add <specific-files>
    │     git commit -m "feat: add loan approval test"
    │
    ├── Push your branch
    │     git push -u origin feature/your-branch-name
    │
    ├── Open a Pull Request on GitHub
    │     - Assign a reviewer
    │     - Wait for approval before merging
    │
    └── After merge → delete branch, pull main, repeat
          git checkout main
          git pull origin main
          git branch -d feature/your-branch-name
```

---

> Questions? Check the README for setup and test execution details, or ask the team.
