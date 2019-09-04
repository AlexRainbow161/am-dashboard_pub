namespace :db do
  desc "Import files from csv data"
  task import_csv: :environment do
    require 'csv'
    CSV.foreach(Rails.root.join('data', 'stores.csv'), headers: true, encoding: "bom|utf8", header_converters: :symbol, col_sep: ';') do |row|
      Store.create!(row.to_h)
    end
  end

  def load_sql
    File.read(Rails.root.join('sql_queries', 'sand_query.sql'))
  end
  def downcase_row(row)
    downcaserow = {}
    row.each do |key, value|
      downcaserow.merge!("#{key.downcase}": value)
    end
    downcaserow
  end
  task sync_sandbox: :environment do
    Store.all.destroy_all
    query = load_sql
    require 'tiny_tds'
    client = TinyTds::Client.new username: "SDUserRead", password: "SDUserRead", dataserver: "REKS:49768", database: "referen"
    results = client.execute(query)
    results.each do |row|
      Store.create!(downcase_row(row))
    end
  end
end
