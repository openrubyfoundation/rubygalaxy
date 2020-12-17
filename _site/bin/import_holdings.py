#! /usr/bin/env python3

import csv
import operator
import pathlib
import shutil

path = pathlib.Path(__file__).resolve().parent.parent
f_in = path.joinpath('incoming', 'UFO_Holdings.csv')
f_cp = path.joinpath('src','media', 'data', 'UFO_Holdings.csv')
f_out = path.joinpath('src', '_data', 'holdings.csv')
shutil.copyfile(f_in, f_cp)

with open(f_in, 'r') as csv_input:
  csv_reader = csv.reader(csv_input, delimiter=',')
  next(csv_reader, None)

  rank = 1
  data = sorted(csv_reader, key=lambda row:float(row[7]), reverse= True)
  rows = [row for row in data if row[2] != "Cash&Other"]

  with open(f_out, 'w') as csv_output: 
    csvwriter = csv.writer(csv_output) 
    headers = ['date', 'rank', 'name', 'weighting', 'ticker', 'shares', 'value']
    csvwriter.writerow(headers)
    
    for row in rows:
      date, account, ticker, cusip, name, shares, price, value, weighting, assets, shares_outstanding, units, flag = row
      shares = int(float(shares))
      value = float(value)
      csvwriter.writerow([date]+[rank]+[name]+[weighting]+[ticker]+['{:,}'.format(shares)]+["$" + '{:,.2f}'.format(value)])
      rank += 1