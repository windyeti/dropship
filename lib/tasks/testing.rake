namespace :p do
  task t: :environment do
    func_compare = Services::CompareParams.new("Maytoni")
    func_compare.compare("ТипПотолочногоКрепления")
    func_compare.compare("ingress_protection_rating")
  end

  task w: :environment do
    Services::GettingProductDistributer::Maytoni.call
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
