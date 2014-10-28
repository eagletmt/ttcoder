#!/usr/bin/env ruby
require 'open-uri'
require 'set'

aoj_user = ENV['AOJ_USER']
unless aoj_user
  abort "AOJ_USER is'nt set"
end

xml = open("http://judge.u-aizu.ac.jp/onlinejudge/webservice/user?id=#{aoj_user}&mode=solution").read
doc = Nokogiri::XML.parse(xml)
actual_solved_ids = doc.xpath('/user/solved_list/problem').map do |problem|
  problem.at_xpath('id').text.strip
end.to_set

solved_ids = AojSubmission.user(user_id: aoj_user).accepts.distinct(:problem_id).pluck(:problem_id).to_set

puts "Actual solved: #{actual_solved_ids.size}. Solved #{solved_ids.size}."
puts "actual_solved_ids - solved_ids: #{actual_solved_ids - solved_ids}"
puts "solved_ids - actual_solved_ids: #{solved_ids - actual_solved_ids}"
