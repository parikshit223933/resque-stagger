## 0.2.1

### Added

* Staggering functionality

## 0.3.0

### Added

* Queue name can be given on runtime

## 1.0.2

### Fixed

* Improper way of prepending module

### Added

* Functionality to enqueue single job in a non-unit time range.
  For example, earlier "n" jobs could have been scheduled per unit time,
  i.e. in 1 second, but now it can be done both ways i.e. 1 job can be
  scheduled to be enqueued per 5 seconds as well as 5 jobs can be
  scheduled to be enqueued in 1 second.

