class Services::GettingProductDistributer::Swg

  def self.call
    puts '=====>>>> СТАРТ SWG SCV '+Time.now.to_s

    # Product.where(distributor: "Swg").each {|tov| tov.update(quantity: 0, check: false)}

    uri = "https://swgshop.ru/upload/swgshop_export_full.csv"

    File.open("#{Rails.root.join('public', 'swg.csv')}", 'w') {|f|
      block = proc { |response|
        body = response.body.gsub!("\r", '').force_encoding('UTF-8').gsub(/\b;/, " --- ")
        f.write body
      }
      RestClient::Request.new(method: :get, url: uri, block_response: block).execute
    }

    rows = CSV.read("#{Rails.root.join('public', 'swg.csv')}", headers: true, col_sep: ';', :quote_char => "\x00").map do |row|
      row.to_hash
    end

    param_name = Services::CompareParams.new("SWG")
    # arr_exclude = [
    #   "\"Длинное наименование [OLD_NAME]\"", " \"Внешний код\"", "\"Цена \"\"Розничная цена\"\"\"",
    #   "\"Количество на складе \"\"Основной склад (с. Дмитровское)\"\"\"", "\"Видео обзор (ссылка на YouTube)\"",
    #   "\"Заголовок окна браузера [TITLE]\"", "\"Мета-описание [META_DESCRIPTION]\"", "\"Уникальное наименование в детальной карточке товара [H1_DETAIL]\"",
    #   "\"Детальная картинка (путь)\"", "\"Фотографии галереи [MORE_PHOTO]\""
    # ]
    arr_exclude = []
    rows.each do |row|
      params = []
      row.each do |key, value|

        if value.present? && !arr_exclude.include?(key)
          name = param_name.compare(key)
          value = value.gsub(/"/, "")

          if name == "Вес нетто, кг"
            value = value.to_f / 1000
          end
          params << "#{name}: #{value}" if name.present? && value.present?
        end
      end
      p params

      photos = []
      # (1..8).each do |num|
      #   photo = row["Фото#{num}"]
      #   if photo&.match(/onec-dev.s3/)
      #     p photo = get_image_aws(photo)
      #   end
      #   photos << photo unless photo.nil?
      # end

      # data = {
      #   fid: row["vendorCode"] + "__Maytoni",
      #   title: row["name"],
      #   url: row["url"],
      #   sku: row["vendorCode"],
      #   distributor: "Maytoni",
      #   image: photos.join(" "),
      #   cat: "Maytoni",
      #   cat1: row["Категория"],
      #   barcode: row["barcode"],
      #   price: row["price"].present? ? row["price"] : 0,
      #   quantity: row["Stock"],
      #   p1: params.join(" --- "),
      #   check: true
      # }
      #
      # product = Product.find_by(fid: data[:fid])
      # product ? product.update(data) : Product.create(data)
    end
    puts '=====>>>> FINISH SWG CSV '+Time.now.to_s
  end

  # def self.get_image_aws(url)
  #   filename = url.split('/').last.gsub(/.jpeg$/, ".jpg")
  #   File.open("#{Rails.root.join('public', 'aws', filename)}", 'w') {|f|
  #     block = proc { |response|
  #       f.write response.body.force_encoding('UTF-8')
  #     }
  #     RestClient::Request.new(method: :get, url: url, block_response: block).execute
  #   }
  #   "http://164.92.252.76/aws/#{(filename)}"
  # end
end
