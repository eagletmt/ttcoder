require 'spec_helper'

RSpec.describe AlertMailer, type: :mailer do
  describe 'controller_exception' do
    class SomethingWentWrong < StandardError
    end

    let(:exception) { begin; raise SomethingWentWrong.new('どうしたらいいのか全くわからない'); rescue => e; e; end }
    let(:mail) { described_class.controller_exception(exception) }

    it 'sends an alert mail' do
      expect(mail.subject).to eq('[ALERT][ttc.wanko.cc] Controller Exception')
      expect(mail.body).to include('SomethingWentWrong')
      expect(mail.body).to include('どうしたらいいのか全くわからない')
    end
  end

  describe 'crawler_error' do
    require 'poj_crawler'

    class ServerError < StandardError
    end

    let(:exception) { begin; raise ServerError.new('サーバ重い'); rescue => e; e; end }
    let(:crawler) { PojCrawler }
    let(:mail) { described_class.crawler_error(crawler, exception) }

    it 'sends an alert mail' do
      expect(mail.subject).to eq('[ALERT][ttc.wanko.cc] Crawler Exception')
      expect(mail.body).to include('PojCrawler')
      expect(mail.body).to include('ServerError')
      expect(mail.body).to include('サーバ重い')
    end
  end
end
