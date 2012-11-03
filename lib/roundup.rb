require 'logger'
require 'fileutils'

class Roundup
  DEFAULT_POLICY = {:hourly => 48, :daily => 31, :monthly => 12}

  attr_reader :path, :policy, :scanner

  def initialize path, options = {}
    @path    = path
    @dryrun  = options.fetch(:dryrun,  true)
    @verbose = options.fetch(:verbose, false)
    @policy  = options.fetch(:policy,  DEFAULT_POLICY)
    @scanner = options.fetch(:scanner, Scanner).new(path)
  end

  def files_to_keep
    policy.map {|interval, n| scanner.find(interval).take(n)}.flatten.uniq
  end

  def files_to_remove
    files - files_to_keep
  end

  def clean!
    remove = files_to_remove

    info 'deleting %d files' % remove.count
    info remove.join($/) unless remove.empty?

    if dryrun?
      info 'dry run - so nothing deleted'
    else
      FileUtils.rm_f(remove)
      info 'cleaned!'
    end
  end

  private

  def verbose?
    !!@verbose
  end

  def logger
    @logger ||= Logger.new($stdout)
  end

  def info message
    logger.info(message) if verbose?
  end

  def dryrun?
    @dryrun == true
  end

  class Scanner
    DAYS = [nil, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

    attr_reader :path

    def self.custom &block
      Class.new(self).tap do |klass|
        klass.send(:define_method, :created_time, &block)
      end
    end

    def initialize path
      @path = path
    end

    def find interval
      send(interval)
    end

    private

    def timeslice
      time = nil
      files.sort_by(&method(:created_time)).reverse.each_with_object([]) do |file, keep|
        created_at = created_time(file)
        if time.nil? or yield(time, created_at)
          time  = created_at
          keep << file
        end
      end
    end

    def hourly
      timeslice {|a, b| (a - b) >= 3600}
    end

    def daily
      timeslice {|a, b| (a - b) >= 86400}
    end

    def monthly
      timeslice do |a, b|
        case
          when a < b
            b - DAYS[a.month] * 86400 >= a
          when a > b
            a - DAYS[b.month] * 86400 >= b
          else
            false
        end
      end
    end

    def files
      Dir[path]
    end

    def created_time file
      File.stat(file).ctime
    end
  end # Scanner
end # Roundup
