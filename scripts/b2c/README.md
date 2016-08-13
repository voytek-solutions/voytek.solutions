# Barclays to Crunch

In browser statement update to add the "balance" column required by Crunch.

Extra features
* warn if the last entires are from today or in the future - with an option to
  remove entries.
* option to remove first entries - in case when part of your statement is
  already imported to your Crunch account.

## The Process

* drop your Barclays CSV statement


-> Handle drop even
-> call statementProcessor()
-> get warnings and display if any
-> show first entry and give option to remove or put balance.
-> download
