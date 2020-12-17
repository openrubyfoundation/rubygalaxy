#!/usr/bin/env ruby

require 'csv'
require 'yaml'

::CSV::Converters[:blank_to_nil] = lambda do |field|
  field && field.empty? ? nil : field
end
::CSV::Converters[:format_prices] = lambda do |field|
  val = nil
  begin
    val = sprintf("%2.2f", Float(field).to_s ).gsub(/(\d)(?=\d{3}+\.)/, '\1,')
  rescue
    val = field
  end
  val.to_s
end

raw_data = "name,ticker,cusip,assets,shares,nav,nav_change,nav_change2,price,price_change,price_change2,discount,date,median_30\n" << ARGF.read.tr("\r",'')

csv = CSV.new(raw_data, :headers => true, :header_converters => :symbol, :converters => [:format_prices])
csv = csv.to_a.map {|row| row.to_hash }

outfile = {}

csv.drop(1).each do |row|
  outfile[row[:ticker]] = {
    "name" => row[:name],
    "ticker" => row[:ticker],
    "cusip" => row[:cusip],
    "assets" => row[:assets],
    "shares" => row[:shares].sub(/\.?0+$/, ''),
    "nav" => row[:nav],
    "nav_change" => row[:nav_change],
    "nav_change2" => row[:nav_change2],
    "price" => row[:price],
    "price_change" => row[:price_change],
    "price_change2" => row[:price_change2],
    "discount" => row[:discount],
    "date" => row[:date],
    "median_30" => row[:median_30]
    }
end

puts outfile.to_yaml
