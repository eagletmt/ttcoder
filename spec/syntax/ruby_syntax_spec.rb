require 'spec_helper'
require 'ripper'

class WarningParser < Ripper
  attr_reader :messages

  def initialize(*)
    super
    @messages = []
  end

  private

  def warn(fmt, *args)
    log(:warn, fmt, *args)
    super
  end

  def warning(fmt, *args)
    log(:warning, fmt, *args)
    super
  end

  def compile_error(fmt, *args)
    log(:compile_error, fmt, *args)
    super
  end

  def log(tag, fmt, *args)
    @messages << sprintf("%s:%d:%d: %s: #{fmt}", filename, lineno, column, tag, *args)
  end
end

describe 'Ruby files' do
  let(:ruby_files) { find_files(Rails.root, '.rb') }

  around do |example|
    verbose = $VERBOSE
    $VERBOSE = true
    example.run
    $VERBOSE = verbose
  end

  it 'has no syntax errors or warnings' do
    ruby_files.each do |ruby_file|
      File.open(ruby_file) do |f|
        parser = WarningParser.new(f, ruby_file)
        parser.parse
        expect(parser.messages).to eq([])
      end
    end
  end
end
