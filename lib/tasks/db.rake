namespace :db do
  desc "Import files from csv data"
  task import_csv: :environment do
    require 'csv'
    CSV.foreach(Rails.root.join('data', 'stores.csv'), headers: true, encoding: "bom|utf8", header_converters: :symbol, col_sep: ';') do |row|
      Store.create!(row.to_h)
    end
  end

end
