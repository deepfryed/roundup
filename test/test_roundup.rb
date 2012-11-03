require 'helper'
require 'date'

describe 'Roundup' do
  before do
    @files   = 10000.times.map {|n| (Time.now - (1800 * n)).strftime('snapshot-%Y%m%d%H%M%S.gz')}
    @scanner = Roundup::Scanner.custom {|file| DateTime.strptime(file, 'snapshot-%Y%m%d%H%M%S').to_time}
  end

  it 'should keep hourlies' do
    Dir.stub(:[], @files) do
      roundup = Roundup.new('/tmp', policy: {hourly: 24}, scanner: @scanner)
      roundup.files_to_keep.must_equal @files.select.with_index {|n, i| i.even? && i < 48}
    end
  end

  it 'should keep dailies' do
    Dir.stub(:[], @files) do
      roundup = Roundup.new('/tmp', policy: {daily: 7}, scanner: @scanner)
      roundup.files_to_keep.must_equal @files.select.with_index {|n, i| i % 48 == 0}.take(7)
    end
  end

  it 'should keep monthlies' do
    files = %w(
      snapshot-20121103000000.gz
      snapshot-20121102000000.gz
      snapshot-20121101000000.gz
      snapshot-20121003000000.gz
      snapshot-20121004000000.gz
      snapshot-20121002000000.gz
      snapshot-20120903000000.gz
      snapshot-20120902000000.gz
      snapshot-20120901000000.gz
      snapshot-20120803000000.gz
      snapshot-20120802000000.gz
      snapshot-20120801000000.gz
      snapshot-20120701000000.gz
      snapshot-20120723000000.gz
      snapshot-20120725000000.gz
    )

    Dir.stub(:[], files) do
      roundup = Roundup.new('/tmp', policy: {monthly: 12}, scanner: @scanner)
      roundup.files_to_keep.must_equal files.select.with_index {|n, i| i % 3 == 0}
    end
  end
end
