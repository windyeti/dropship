namespace :p do
  task t: :environment do
    func_compare = Services::CompareParams.new("Maytoni")
    func_compare.compare("ТипПотолочногоКрепления")
    func_compare.compare("ingress_protection_rating")
  end

  task w: :environment do
    Services::GettingProductDistributer::Maytoni.call
    # Services::GettingProductDistributer::Swg.call
  end


  task a: :environment do
    FileUtils.rm_rf(Dir.glob('public/swg.csv'))

    # download_link = "https://swgshop.ru/upload/swgshop_export_full.csv"
    # download_path = "#{Rails.public_path}"+"swg.csv"
    # download_response = open(download_link).read()
    # IO.copy_stream(download_response, download_path)

    # url = "https://swgshop.ru/upload/swgshop_export_full.csv"
    # p url_data = open(url).read()

    uri = "https://swgshop.ru/upload/swgshop_export_full.csv"

    File.open("#{Rails.root.join('public', 'swg.csv')}", 'w') {|f|
      block = proc { |response|
        # p body = response.body.gsub!("\r", '').force_encoding("UTF-8")
        body = response.body.gsub!("\r", '').force_encoding('UTF-8').gsub(/\b;/, " --- ")
        # p body = response.body.gsub!("\r", '').force_encoding('UTF-8').gsub(/.jpg;/, ".jpg ").gsub(/.png;/, ".png ")
        f.write body
      }
      RestClient::Request.new(method: :get, url: uri, block_response: block).execute
    }

    rows = CSV.read("#{Rails.root.join('public', 'swg.csv')}", headers: true, col_sep: ';', :quote_char => "\x00").map do |row|
      row.to_hash
    end
    pp rows


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
  end


  task q: :environment do
    # uri = "https://onec-dev.s3.amazonaws.com/upload/public/documents/all.csv"
    # response = open(uri)
    # IO.copy_stream(response, "#{Rails.root.join('public', 'proba.csv')}")
    #
    # rows = CSV.read("#{Rails.root.join('public', 'proba.csv')}", headers: true, col_sep: ';').map do |row|
    #   row.to_hash
    # end
    # p rows[1]["﻿id"]


    File.open("#{Rails.root.join('public', 'proba.csv')}", 'w') {|f|
      block = proc { |response|
        f.write response.body.force_encoding('UTF-8')
        # response.read_body do |chunk|
        #   puts "Working on response"
        #   f.write chunk.force_encoding('UTF-8')
        # end
      }
      RestClient::Request.new(method: :get, url: 'https://onec-dev.s3.amazonaws.com/upload/public/documents/all.csv', block_response: block).execute
    }

    rows = CSV.read("#{Rails.root.join('public', 'proba.csv')}", headers: true, col_sep: ';').map do |row|
      row.to_hash
    end
    p rows[1]["﻿id"]

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
