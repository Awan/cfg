#!/usr/bin/env python

from datetime import datetime
from dateutil.relativedelta import relativedelta

# Provided date
provided_date = datetime(2023, 11, 26, 8, 00, 8)  # Replace with your date

# Current date
current_date = datetime.now()

# Calculate the difference using relativedelta
delta = relativedelta(current_date, provided_date)

# Print the result
print(f"{delta.years} years, {delta.months} months, {delta.days} days have passed.")

