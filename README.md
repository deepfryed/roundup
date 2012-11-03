# Roundup

* http://github.com/deepfryed/roundup

## Description

A simple snapshot cleaner to keep the right number of historical data backups.

## Synopsis

```ruby
require 'roundup'

Roundup.new(path: '/path/to/snapshots/**/*.gz', dryrun: false).clean!
Roundup.new(path: '/path/to/snapshots/**/*.gz').files_to_keep   #=> [Array]
Roundup.new(path: '/path/to/snapshots/**/*.gz').files_to_remove #=> [Array]
Roundup.new(path: '/path/to/snapshots/**/*.gz', policy: {hourly: 24, daily: 30, monthly: 12}).clean!
```

## License

BSD
