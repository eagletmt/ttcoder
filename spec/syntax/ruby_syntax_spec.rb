require 'spec_helper'
require 'open3'

describe 'Ruby files' do
  let(:ruby_files) { find_files(Rails.root, '.rb') }

  it 'has no syntax errors or warnings' do
    ruby_files.each do |ruby_file|
      check_output, status = Open3.capture2e('ruby', '-wc', ruby_file)
      expect(check_output.chomp).to eq('Syntax OK')
      expect(status.exitstatus).to eq(0)
    end
  end
end
