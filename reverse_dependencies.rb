#!/usr/bin/env ruby

# Run this script to output gems which depend on specified gem
#
# Very slow. Do not use on popular libraries like sprockets or rails.
#
# e.g.
# ruby reverse_dependencies.rb shoulda
# [
#  "jeweler",
#  "rubigen",
#  "verhoeff",
#  "vanilla",
#  "soup",
#  ...
# ]
#
require 'rubygems'
require 'gems'

results = Gems.reverse_dependencies ARGV[0]

weighted_results = {}
results.each do |name|
  download_hash = Gems.total_downloads name
  if download_hash.is_a? Hash
    weighted_results[name] = download_hash[:total_downloads]
  else
    puts "#{name}: #{download_hash}"
  end
end

weighted_results.sort {|(k1, v1), (k2, v2)| v2 <=> v1 }.first(50).each_with_index do |(k, v), i|
  puts "#{i}) #{k}: #{v}"
end

