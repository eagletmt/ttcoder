require 'spec_helper'

describe 'Ruby files' do
  let(:ruby_files) { find_files(Rails.root, '.rb') }
  let(:stderr) { StringIO.new }

  around do |example|
    verbose = $VERBOSE
    $VERBOSE = true
    err = $stderr
    $stderr = stderr
    example.run
    $stderr = err
    $VERBOSE = verbose
  end

  it 'has no syntax errors or warnings' do
    ruby_files.each do |ruby_file|
      RubyVM::InstructionSequence.compile_file(ruby_file)
    end
    expect(stderr.string).to eq('')
  end
end
