class Services::CompareParams
  attr_reader :file_path_prep, :name_provider

  def initialize(name_provider)
    @name_provider = name_provider
    @file_path_prep = "#{Rails.root.join("public", "map_params.csv")}"
  end

  def compare(param)
      # p "param --> #{param.gsub(/"{2}/, '"').gsub(/^"|"$/, "").gsub(/\\/, "")}"
    @map_params ||= get_map_params
    result = @map_params.find do |hash|
      # p hash[:name_provider]
      hash[:name_provider] == param.gsub(/"{2}/, '"').gsub(/^"|"$/, "").gsub(/\\/, "")
    end
    result.present? ? result[:name_param] : param
  end

  private

  def get_map_params
    @map_params = CSV.read(file_path_prep, headers: true).map do |row|
      hash = row.to_hash
      {
        name_param: hash["Название"],
        name_provider: hash[name_provider]
      }
    end
  end
end
