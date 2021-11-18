class Services::GettingProductDistributer::Maytoni

  def self.call
    puts '=====>>>> СТАРТ Maytoni SCV '+Time.now.to_s

    Product.where(distributor: "Maytoni").each {|tov| tov.update(quantity: 0, check: false)}

    uri = "https://onec-dev.s3.amazonaws.com/upload/public/documents/all.csv"

    FileUtils.rm_rf(Dir.glob('public/maytoni.csv'))
    FileUtils.rm_rf(Dir.glob('tmp/image_aws/*.*'))

    File.open("#{Rails.root.join('public', 'maytoni.csv')}", 'w') {|f|
      block = proc { |response|
        f.write response.body.force_encoding('UTF-8')
      }
      RestClient::Request.new(method: :get, url: uri, block_response: block).execute
    }

    rows = CSV.read("#{Rails.root.join('public', 'maytoni.csv')}", headers: true, col_sep: ';').map do |row|
      row.to_hash
    end

    param_name = Services::CompareParams.new("Maytoni")
    arr_exclude = [
      "name", "vendorCode", "price", "currencyId", "Stock", "style_name", "Гарантия", "barcode", "КодТНВЭД",
      "ТипМонтажаВстраиваемогоСветильника", "Типы помещении", "ТипПотолочногоКрепления", "ФормаМонтажногоОтверстияВстраиваемогоСветильника",
      "ДиаметрМонтажногоОтверстияВстраиваемогоСветильника", "ГлубинаМонтажногоОтверстияВстраиваемогоСветильника", "ШиринаМонтажногоОтверстияВстраиваемогоСветильника",
      "ДлинаМонтажногоОтверстияВстраиваемогоСветильника", "Цепь", "ДлинаЦепи", "ЛампыВКомплекте", "Цоколь", "КоличествоЛамп", "СветовойПоток", "УголРассеивания",
      "ИндексЦветопередачи", "ЦветоваяТемпература", "АналогЛампыНакаливания", "Класс Электрозащиты", "ingress_protection_rating", "Чаша крепления", "Напряжение",
      "Мощность", "ВесНетто", "ВесБрутто"
    ]
    rows.each do |row|
      params = []
      row.each do |key, value|
        if value.present? && !arr_exclude.include?(key)
          name = param_name.compare(key)

          if name == "Тип лампы"
            if value == "Да"
              value = "LED"
            else
              next
            end
          end

          params << "#{name}: #{value}" unless name.nil?
        end
      end

      photos = []
      (1..8).each do |num|
        photo = row["Фото#{num}"]
        if photo&.match(/onec-dev.s3/)
          p photo = get_image_aws(photo)
        end
        photos << photo unless photo.nil?
      end

      data = {
        fid: row["vendorCode"],
        title: row["name"],
        url: row["url"],
        sku: row["vendorCode"],
        distributor: "Maytoni",
        image: photos.join(" "),
        cat: "Maytoni",
        cat1: row["Категория"],
        price: row["price"],
        quantity: row["Stock"],
        p1: params.join(" --- "),
        check: true
      }

      product = Product.find_by(fid: data[:fid])
      product ? product.update(data) : Product.create(data)
    end
    puts '=====>>>> FINISH Maytoni CSV '+Time.now.to_s
  end

  def self.get_image_aws(url)
    filename = url.split('/').last.gsub(/.jpeg$/, ".jpg")
    File.open("#{Rails.root.join('tmp', 'image_aws', filename)}", 'w') {|f|
      block = proc { |response|
        f.write response.body.force_encoding('UTF-8')
      }
      RestClient::Request.new(method: :get, url: url, block_response: block).execute
    }
    Rails.root.join('tmp', 'image_aws', filename).to_s
  end
end
