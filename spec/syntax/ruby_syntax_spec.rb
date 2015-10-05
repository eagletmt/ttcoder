require 'spec_helper'
require 'open3'

RSpec.describe 'Ruby files' do
  let(:ruby_files) { find_files(Rails.root, '.rb') }
  let(:syntax_checker) { Rails.root.join('spec', 'tools', 'ruby_syntax_check.rb').to_s }
  let(:stderr) { StringIO.new }

  it 'has no syntax errors or warnings' do
    check_output, = Open3.capture2e(syntax_checker, *ruby_files)
    expect(check_output).to eq('')
  end
end
