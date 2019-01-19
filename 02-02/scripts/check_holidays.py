#!/usr/bin/env python

import datetime
from workalendar.europe import Russia

cal = Russia()
to_day = datetime.date.today()
cal.holidays(to_day.year)

print(int(cal.is_working_day(to_day)))
