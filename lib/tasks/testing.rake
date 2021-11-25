namespace :p do
  task t: :environment do
    func_compare = Services::CompareParams.new("Maytoni")
    func_compare.compare("ТипПотолочногоКрепления")
    func_compare.compare("ingress_protection_rating")
  end

  task maytoni: :environment do
    Services::GettingProductDistributer::Maytoni.call
  end

  task swg: :environment do
    Services::GettingProductDistributer::Swg.call
  end

  task swg2: :environment do
    Services::GettingProductDistributer::Swg2.call
  end


  task a: :environment do
    FileUtils.rm_rf(Dir.glob('public/swg.csv'))
    FileUtils.rm_rf(Dir.glob('public/test.csv'))

    url = "https://swgshop.ru/upload/swgshop_export_full_price_qty.csv"
    download = RestClient::Request.execute(method: :get, url: url, raw_response: true, verify_ssl: false )
    download_path = Rails.public_path.to_s + '/swg.csv'
    IO.copy_stream(download.file.path, download_path)

    content = File.read(download_path)
    detection = CharlockHolmes::EncodingDetector.detect(content)
    p utf8_encoded_content = CharlockHolmes::Converter.convert(content, detection[:encoding], 'UTF-8')

    # url = "https://swgshop.ru/upload/swgshop_export_full.csv"
    # url = "https://swgshop.ru/upload/swgshop_export_full_price_qty.csv"

    # File.open("#{Rails.root.join('public', 'swg.csv')}", 'w') {|f|
    #   block = proc { |response|
    #     body = response.body
    #     # body = response.body.gsub!("\r", '').force_encoding('UTF-8').gsub(/\b;/, "##").gsub(/\);/, ")##")
    #     f.write body
    #   }
    #   RestClient::Request.new(method: :get, url: uri, block_response: block).execute
    # }

    # tmpfile = Tempfile.new("#{Rails.root.join('public', 'swg.csv')}", encoding: 'utf-8')
    # tmpfile.write(File.read("#{Rails.root.join('public', 'swg.csv')}").gsub!("\r", ''))
    # tmpfile.rewind
    # # file_path = File.read("#{Rails.root.join('public', 'swg.csv')}")
    # spreadsheet = Roo::CSV.new("#{Rails.root.join('public', 'swg.csv')}", csv_options: {col_sep: ";", quote_char: "\x00"})
#
# spreadsheet.each_with_pagename do |name, sheet|
#   # # last = sheet.last_row
#   # sheet.parse(headers: true).each do |row|
#   #   pp row["\"Длинное наименование [OLD_NAME]\""] if row["﻿\"Внешний код\""] == "\"00-00000874\""
#   # end
#   # p sheet.row(1)
# end


    # download_link = "https://swgshop.ru/upload/swgshop_export_full.csv"
    # download_path = "#{Rails.public_path}"+"swg.csv"
    # download_response = open(download_link).read()
    # IO.copy_stream(download_response, download_path)

    # url = "https://swgshop.ru/upload/swgshop_export_full.csv"
    # download_path = "#{Rails.public_path}"+"/swg.csv"
    # download_response = open(url).read().gsub!("\r", '').force_encoding("UTF-8")
    # IO.copy_stream(download_response, download_path)

    # uri = "https://swgshop.ru/upload/swgshop_export_full.csv"

    # File.open("#{Rails.root.join('public', 'swg.csv')}", 'w') {|f|
    #   block = proc { |response|
    #     body = response.body
    #     f.write body
    #   }
    #   RestClient::Request.new(method: :get, url: uri, block_response: block).execute
    # }
    #
    # rows = CSV.read("#{Rails.root.join('public', 'swg.csv')}", headers: true, col_sep: ';', :quote_char => "\x00").map do |row|
    #   row.to_hash
    # end
    # pp rows


#     headers = rows[0]
# i = 0
#
#     CSV.read("#{Rails.root.join('public', 'swg.csv')}", headers: true, col_sep: ';', :quote_char => "\x00").map do |row|
#       pp row["\"Заголовок окна браузера [TITLE]\""].gsub(/"/, "")
#       # p "-----------------------------------"
#       # headers.each do |header|
#       #   p '================='
#       #   pp "#{header} --- #{row[header]}"
#       #   p '+++++++++++++++++'
#       # end
#       break if i == 2
#       i += 1
#     end
    # rows = CSV.read("#{Rails.root.join('public', 'swg.csv')}", headers: true, col_sep: ';', :quote_char => "\x00").map do |row|
    #   # p row["\"Фотографии галереи [MORE_PHOTO]\""]
    #   # p row["Фотографии галереи [MORE_PHOTO]"]
    #   row.to_hash
    # end
    # pp rows[0]

    # url = "https://swgshop.ru/upload/swgshop_export_full.csv"
    # rows = CSV.read(open(url), headers: true, col_sep: ';', :quote_char => "\x00").map do |row|
    #   p row.to_hash
    # end
    # pp rows
  # end




    # File.open("#{Rails.root.join('public', 'proba.csv')}", 'w') {|f|
    #   block = proc { |response|
    #     f.write response.body.force_encoding('UTF-8')
    #     # response.read_body do |chunk|
    #     #   puts "Working on response"
    #     #   f.write chunk.force_encoding('UTF-8')
    #     # end
    #   }
    #   RestClient::Request.new(method: :get, url: 'https://onec-dev.s3.amazonaws.com/upload/public/documents/all.csv', block_response: block).execute
    # }
    #
    # rows = CSV.read("#{Rails.root.join('public', 'proba.csv')}", headers: true, col_sep: ';').map do |row|
    #   row.to_hash
    # end
    # p rows[1]["﻿id"]

    # File.open(Rails.root.join('public', 'proba.csv'), 'wb') do |file|
    #   file.write(response.body)
    # end

    # csv = CSV.parse("#{Rails.root.join('public', 'map_params.csv')}", headers: true, col_sep: ";")
    # csv = CSV.parse("#{Rails.root.join('public', 'map_params.csv')}", headers: true, col_sep: ";")
    # p csv
    # csv.each do |row|
    #   # p "------------"
    #   # row.each do |r|
    #   # p "- - - - -"
    #   #   puts r
    #   # end
    #   puts row[0]
    # end
    # Services::GettingProductDistributer::Maytoni.call
  end
end
