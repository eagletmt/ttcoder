require 'spec_helper'
require 'codeforces_crawler'

RSpec.describe CodeforcesCrawler do
  let(:crawler) { CodeforcesCrawler.new }

  describe '#crawl' do
    it 'works' do
      VCR.use_cassette('codeforces/0') do
        expect do
          expect(crawler.crawl(count: 10)).to be(true)
        end.to change { CodeforcesSubmission.count }.by(9)
        expect(StandingCache.count).to eq(9)
        CodeforcesSubmission.all.pluck(:id).each do |id|
          expect(last_log('codeforces_import')[:submissions].map { |h| h['id'] }).to include(id)
        end
      end
    end
  end

  describe '#run' do
    it 'works' do
      VCR.use_cassette('codeforces/run1') do
        expect do
          crawler.run(count: 10)
        end.to change { CodeforcesSubmission.count }.by(9)
        expect(StandingCache.count).to eq(9)
      end

      VCR.use_cassette('codeforces/run2') do
        expect do
          crawler.run(count: 10)
        end.to change { CodeforcesSubmission.count }.by(10)
        expect(StandingCache.count).to eq(18)
      end
    end
  end
end
