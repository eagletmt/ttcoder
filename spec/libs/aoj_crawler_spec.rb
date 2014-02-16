require 'spec_helper'
require 'aoj_crawler'

describe AojCrawler do
  let(:crawler) { AojCrawler.new }

  describe '#crawl' do
    it 'works' do
      VCR.use_cassette('aoj/0') do
        expect do
          expect(crawler.crawl(start: 0, limit: 10)).to be(true)
        end.to change { AojSubmission.count }.by(10)
        expect(StandingCache.count).to eq(8)
        AojSubmission.all.pluck(:run_id).each do |run_id|
          expect(last_log('aoj_import')[:submissions].map { |h| h['run_id'] }).to include(run_id)
        end
      end

      VCR.use_cassette('aoj/0') do
        expect(crawler.crawl(start: 0, limit: 10)).to be(false)
      end
    end
  end

  describe '#run' do
    it 'works' do
      VCR.use_cassette('aoj/run1') do
        expect do
          crawler.run(count: 2, limit: 10)
        end.to change { AojSubmission.count }.by(20)
        expect(StandingCache.count).to eq(14)
      end

      VCR.use_cassette('aoj/run2') do
        expect do
          crawler.run(count: 2, limit: 10)
        end.to change { AojSubmission.count }.by(2)
        expect(StandingCache.count).to eq(16)
      end
    end
  end
end
