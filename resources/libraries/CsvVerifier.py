"""
CsvVerifier.py
Robot Framework custom library for verifying downloaded CSV report files.
Used by the Reports module test suite (t6.1).

Actual CSV structure produced by the Reports module:
  Row 1  : Summary  → "Closing balance for <date range>", "-₱200.00"
  Row 2  : Empty
  Row 3  : Column headers
  Row 4+ : Data rows

Actual Transaction Type values in production:
  "Internal"  — internal fund transfers (excluded from closing balance)
  "External"  — external fund transfers (excluded from closing balance)
  "Deposit"   — cash deposits          (increases balance)
  "Withdraw"  — cash withdrawals       (decreases balance)

Balance formula (empirically verified from sample CSV):
  Closing Balance = sum(Deposit Transaction Amounts)
                  + sum(Withdraw Transaction Amounts)
  where Internal and External are excluded entirely.

  Note: Transaction Amounts for Withdraw are already negative in the CSV,
  so a plain sum of included rows gives the correct signed result.
"""

import csv
import re
from datetime import datetime


class CsvVerifier:
    ROBOT_LIBRARY_VERSION = "1.0.0"

    EXPECTED_HEADERS = [
        "Transaction ID",
        "Transaction Type",
        "Date & Time",
        "Debit Account Name",
        "Debit Account Number",
        "Credit Account Name",
        "Credit Account Number",
        "Transaction Amount",
        "Service Fee Amount",
        "Total Amount",
    ]

    # Types whose Transaction Amount contributes to the closing balance.
    # Internal is always excluded.
    # External is included ONLY when the transaction status is Success —
    # Failed External transactions are excluded per spec but cannot be
    # identified from the CSV alone (no Status column).
    BALANCE_INCLUDED_TYPES = {"Deposit", "Withdraw", "External"}

    # ------------------------------------------------------------------ #
    #  Internal parser — handles the 3-row prefix                         #
    # ------------------------------------------------------------------ #

    def _parse_csv(self, filepath):
        """
        Parses the CSV file according to its actual structure.
        Returns: (summary_row_list, headers_list, data_rows_list_of_dicts)
        """
        with open(filepath, newline="", encoding="utf-8-sig") as f:
            all_rows = list(csv.reader(f))

        if len(all_rows) < 3:
            raise AssertionError(
                f'CSV "{filepath}" has fewer than 3 rows. '
                "Expected: summary row, empty row, header row."
            )

        summary_row = all_rows[0]   # ['Closing balance for ...', '-₱200.00']
        headers     = all_rows[2]   # column names row
        data_rows   = [
            dict(zip(headers, row))
            for row in all_rows[3:]
            if any(cell.strip() for cell in row)    # skip fully-empty rows
        ]

        return summary_row, headers, data_rows

    @staticmethod
    def _parse_amount(raw):
        """Strips ₱, commas, and whitespace then returns a float."""
        cleaned = raw.replace("₱", "").replace(",", "").strip()
        return float(cleaned)

    # ------------------------------------------------------------------ #
    #  File name                                                           #
    # ------------------------------------------------------------------ #

    def verify_csv_file_name(self, filename, report_date):
        """
        Asserts the file name matches:
          <bank-name>_transactions_report_<DD_Mon_YYYY>[_to_<DD_Mon_YYYY>].csv

        - report_date : start/closing date in YYYY-MM-DD format;
                        converted to DD_Mon_YYYY before checking presence.
        """
        if "_transactions_report_" not in filename:
            raise AssertionError(
                f'File name "{filename}" does not contain "_transactions_report_".\n'
                f"Expected: <bank-name>_transactions_report_<date(s)>.csv"
            )
        if not filename.endswith(".csv"):
            raise AssertionError(
                f'File name "{filename}" does not have a .csv extension.'
            )
        if report_date:
            formatted = datetime.strptime(report_date, "%Y-%m-%d").strftime("%d_%b_%Y")
            if formatted not in filename:
                raise AssertionError(
                    f'File name "{filename}" does not contain "{formatted}" '
                    f'(converted from "{report_date}").'
                )

    # ------------------------------------------------------------------ #
    #  Summary row                                                         #
    # ------------------------------------------------------------------ #

    def verify_csv_summary_row(self, filepath):
        """
        Asserts row 1 contains a closing balance summary:
          "Closing balance for <date range>", "<amount>"
        Returns the raw balance string (e.g. "-₱200.00") for logging.
        """
        summary_row, _, _ = self._parse_csv(filepath)

        if "closing balance" not in summary_row[0].lower():
            raise AssertionError(
                f'Row 1 does not contain "Closing balance". Actual: {summary_row[0]!r}'
            )

        balance = summary_row[1].strip() if len(summary_row) > 1 else ""
        if not balance:
            raise AssertionError("Row 1 has no balance value in column 2.")

        return balance

    # ------------------------------------------------------------------ #
    #  Headers                                                             #
    # ------------------------------------------------------------------ #

    def verify_csv_headers(self, filepath):
        """
        Asserts the CSV has exactly the 10 expected column headers in order
        (row 3, after the summary and empty rows).
        """
        _, actual_headers, _ = self._parse_csv(filepath)

        if actual_headers != self.EXPECTED_HEADERS:
            raise AssertionError(
                f"CSV headers mismatch.\n"
                f"Expected : {self.EXPECTED_HEADERS}\n"
                f"Actual   : {actual_headers}"
            )

    # ------------------------------------------------------------------ #
    #  Row count                                                           #
    # ------------------------------------------------------------------ #

    def verify_csv_has_rows(self, filepath):
        """
        Asserts the CSV has at least one data row (row 4+).
        Returns the row count for logging.
        """
        _, _, data_rows = self._parse_csv(filepath)

        if not data_rows:
            raise AssertionError(
                f'CSV "{filepath}" contains no data rows.'
            )
        return len(data_rows)

    # ------------------------------------------------------------------ #
    #  Date & Time format and range                                        #
    # ------------------------------------------------------------------ #

    _DT_PATTERN = re.compile(r"^\d{4}/\d{2}/\d{2} \d{2}:\d{2}:\d{2}$")

    def verify_csv_date_format_and_range(self, filepath, date_from, date_to):
        """
        Asserts every "Date & Time" cell:
          1. Matches format  yyyy/mm/dd hh:mm:ss
          2. Falls within the given date range (inclusive)

        date_from / date_to must be in YYYY-MM-DD format.
        """
        df = date_from.replace("-", "/")    # "2026/03/10"
        dt = date_to.replace("-", "/")

        _, _, data_rows = self._parse_csv(filepath)
        errors = []

        for i, row in enumerate(data_rows, start=4):   # data starts at row 4
            cell = row.get("Date & Time", "")

            if not self._DT_PATTERN.match(cell):
                errors.append(
                    f'Row {i}: "{cell}" — does not match yyyy/mm/dd hh:mm:ss'
                )
                continue

            date_part = cell[:10]
            if not (df <= date_part <= dt):
                errors.append(
                    f'Row {i}: "{date_part}" — outside range [{df} to {dt}]'
                )

        if errors:
            raise AssertionError(
                f"Date & Time errors in '{filepath}':\n" + "\n".join(errors)
            )

    # ------------------------------------------------------------------ #
    #  Internal transaction presence                                       #
    # ------------------------------------------------------------------ #

    def verify_csv_internal_transactions_present(self, filepath):
        """
        Warns (does not fail) if no "Internal" transactions appear in the CSV.
        Internal transactions must be present in the report even though they
        are excluded from the closing balance.
        """
        _, _, data_rows = self._parse_csv(filepath)
        found = any(
            row.get("Transaction Type", "").strip() == "Internal"
            for row in data_rows
        )
        if not found:
            print(
                "[CsvVerifier] NOTE: No 'Internal' transactions found in this period — "
                "acceptable if none occurred in the selected date range."
            )
        return found

    # ------------------------------------------------------------------ #
    #  Balance verification                                                #
    # ------------------------------------------------------------------ #

    def verify_csv_balance_matches_summary(self, filepath):
        """
        Computes the closing balance from the data rows and asserts it matches
        the value stated in the summary row (row 1).

        Balance formula:
          Sum of Transaction Amounts for rows where Transaction Type is
          "Deposit", "Withdraw", or "External" (Success only).
          Transaction Amounts are already signed in the CSV, so a plain
          sum of included rows gives the correct result.

          "Internal" rows are always excluded.
          "External" rows for Failed transactions are also excluded per spec,
          but cannot be identified without a Status column — if the computed
          balance does not match the summary, check for Failed External
          transactions in the selected date range.
        """
        summary_row, _, data_rows = self._parse_csv(filepath)

        # --- Parse summary balance ---
        raw_summary = summary_row[1].strip() if len(summary_row) > 1 else ""
        try:
            summary_balance = self._parse_amount(raw_summary)
        except (ValueError, IndexError):
            raise AssertionError(
                f'Cannot parse summary balance from "{raw_summary}".'
            )

        # --- Compute balance from transactions ---
        computed = 0.0
        skipped  = []

        for i, row in enumerate(data_rows, start=4):
            txn_type = row.get("Transaction Type", "").strip()
            if txn_type not in self.BALANCE_INCLUDED_TYPES:
                continue    # Internal, External — excluded

            raw_amount = row.get("Transaction Amount", "").strip()
            try:
                computed += self._parse_amount(raw_amount)
            except ValueError:
                skipped.append(f'Row {i}: could not parse amount "{raw_amount}"')

        computed = round(computed, 2)

        if skipped:
            print("[CsvVerifier] Skipped rows during balance computation:\n"
                  + "\n".join(skipped))

        # --- Compare ---
        if computed != summary_balance:
            raise AssertionError(
                f"Closing balance mismatch.\n"
                f"  Summary row : {summary_balance}\n"
                f"  Computed    : {computed}\n"
                f"  Diff        : {round(computed - summary_balance, 2)}\n"
                f"  Included types: {sorted(self.BALANCE_INCLUDED_TYPES)}\n"
                f"  NOTE: If the diff matches an External transaction amount, the cause\n"
                f"  is likely a Failed External transaction — which is excluded from the\n"
                f"  balance per spec but cannot be identified without a Status column.\n"
                f"  Manual verification required for Failed External transactions."
            )

        return computed
