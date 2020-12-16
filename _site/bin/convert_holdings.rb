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

raw_data = "date,account,ticker,cusip,name,shares,price,value,weighting,assets,shares_outstanding,units,flag\n" << ARGF.read.tr("\r",'')

csv = CSV.new(raw_data, :headers => true, :header_converters => :symbol, :converters => [:format_prices])
csv = csv.to_a.map {|row| row.to_hash }

outfile = {}

csv.drop(1).each do |row|
  outfile[row[:ticker]] = {
    "ticker" => row[:ticker],
    "date" => row[:date],
    "account" => row[:account],
    "cusip" => row[:cusip],
    "name" => row[:name],
    "shares" => row[:shares].sub(/\.?0+$/, ''),
    "price" => row[:price],
    "value" => row[:value],
    "weighting" => row[:weighting],
    "assets" => row[:assets],
    "shares_outstanding" => row[:shares_outstanding].sub(/\.?0+$/, ''),
    "units" => row[:units],
    "flag" => row[:flag]
    }
end

puts outfile.to_yaml