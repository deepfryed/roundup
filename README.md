# Roundup

* http://github.com/deepfryed/roundup

## Description

A simple snapshot cleaner to keep the right number of historical data backups.

## Synopsis

```ruby
  require 'roundup'

  Roundup.new(path: '/path/to/snapshots/**/*.gz').clean!
  Roundup.new(path: '/path/to/snapshots/**/*.gz').files_to_keep
  Roundup.new(path: '/path/to/snapshots/**/*.gz').files_to_remove
  Roundup.new(path: '/path/to/snapshots/**/*.gz', policy: {hourly: 24, daily: 30, monthly: 12}).clean!
```

## License

BSD
