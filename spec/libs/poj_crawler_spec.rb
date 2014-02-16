require 'spec_helper'
require 'poj_crawler'

describe PojCrawler do
  let(:crawler) { PojCrawler.new }
  let(:top) { 100_000_000 }

  describe '#crawl' do
    let(:params) { { size: 10, top: top } }

    it 'works' do
      VCR.use_cassette('poj/0') do
        expect do
          expect(crawler.crawl(params)).not_to be_nil
        end.to change { PojSubmission.count }.by(10)
        expect(StandingCache.count).to eq(9)
        PojSubmission.all.pluck(:id).each do |id|
          expect(last_log('poj_import')[:submissions].map { |h| h['id'] }).to include(id)
        end
      end

      VCR.use_cassette('poj/0') do
        expect(crawler.crawl(params)).to be_nil
      end
    end
  end

  describe '#run' do
    it 'works' do
      VCR.use_cassette('poj/run1') do
        expect do
          crawler.run(count: 2, size: 10)
        end.to change { PojSubmission.count }.by(19)
      end
      expect(StandingCache.count).to eq(16)
      expect(last_log('poj_import_error')).to be_nil
      logger.queue.clear

      VCR.use_cassette('poj/run2') do
        expect do
          crawler.run(count: 2, size: 10)
        end.to change { PojSubmission.count }.by(8)
      end
      expect(StandingCache.count).to eq(21)
      expect(last_log('poj_import_error')).to be_nil
    end
  end
end
