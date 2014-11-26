class CreatePlaces < ActiveRecord::Migration
  def up

    ## Countries
    create_table(:countries, :primary_key => 'country_pk') do |t|
      t.integer :country_pk,                        null: false
      t.string  :name,                  limit: 50,  null: false
      t.string  :fips104,               limit: 2,   null: false
      t.string  :iso2,                  limit: 2,   null: false
      t.string  :iso3,                  limit: 3,   null: false
      t.string  :ison,                  limit: 4,   null: false
      t.string  :internet,              limit: 2,   null: false
      t.string  :capital,               limit: 25
      t.string  :map_reference,         limit: 50
      t.string  :nationality_singular,  limit: 35
      t.string  :nationaiity_plural,    limit: 35
      t.string  :currency,              limit: 30
      t.string  :currency_code,         limit: 3
      t.integer :population
      t.string  :title,                 limit: 50
      t.string  :comment,               limit: 255

      t.integer :users_count,           null: false, default: 0

      t.timestamps
    end

    [
      :name,
      :fips104,
      :iso2,
      :iso3,
      :ison,
      :internet,
      :currency_code,
      :population,
      :users_count,
      :created_at,
      :updated_at
    ].each do |k|
      add_index(:countries, k)
    end

    ## Regions
    create_table(:regions, :primary_key => 'region_pk') do |t|
      t.integer     :region_pk,  null: false
      t.integer     :country_pk, null: false

      t.string      :name,      limit: 45,  null: false
      t.string      :code,      limit: 8,   null: false
      t.string      :adm1code,  limit: 4,   null: false

      t.integer     :users_count,           null: false, default: 0

      t.timestamps
    end

    [
      :country_pk,
      :name,
      :code,
      :adm1code,
      :users_count,
      :created_at,
      :updated_at
    ].each do |k|
      add_index(:regions, k)
    end
    # add_foreign_key(:regions, :countries, dependent: :delete)

    ## Cities
    create_table(:cities, :primary_key => 'city_pk') do |t|
      t.integer    :city_pk,      null: false
      t.integer    :country_pk,   null: false
      t.integer    :region_pk,    null: false

      t.string      :name,        limit: 45,    null: false
=begin
      t.float       :latitude,                  null: false
      t.float       :longitude,                 null: false
      t.string      :timezone,    limit: 10,    null: false
      t.integer     :dma_id
      t.string      :county,      limit: 25
      t.string      :code,        limit: 4
=end
      t.text        :full_name,   null: false, default: ''
      t.integer     :users_count, null: false, default: 0



      t.timestamps
    end

    [
      :country_pk,
      :region_pk,
      :name, 
      :created_at,
      :updated_at
    ].each do |k|
      add_index(:cities, k)
    end
    # add_foreign_key(:cities, :countries,  dependent: :delete)
    # add_foreign_key(:cities, :regions,    dependent: :delete)

    ## SQL Query generation (so that we can use it from workbench or something)
    root = ::Rails.root.join('data', 'geo', 'GeoWorldMap').to_s

    sql = []
    ['countries', 'regions', 'cities'].each do |table|
      path = File.join(root, "#{table.titleize}.txt")
      target = File.join(Dir.tmpdir, "#{table.titleize}.txt")

      FileUtils.rm_f(target)
      FileUtils.cp(path, target)
      FileUtils.chmod(0666, target)

      sql << "LOAD DATA LOCAL INFILE '#{target}' INTO TABLE #{table} CHARACTER SET utf8 FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\\\"' LINES TERMINATED BY '\\r\\n' IGNORE 1 LINES;"
      sql << "UPDATE #{table} SET created_at = UTC_TIMESTAMP(), updated_at = UTC_TIMESTAMP();"
    end

    sql << <<-eos
    UPDATE cities
      INNER JOIN regions ON regions.id = region_id
      INNER JOIN countries ON countries.id = cities.country_id
    SET
      full_name = CONCAT_WS(', ', cities.name, regions.name, countries.name);

    UPDATE cities
      INNER JOIN regions ON regions.id = region_id
      INNER JOIN countries ON countries.id = cities.country_id
    SET
      cities.name = CONCAT_WS(', ', regions.name, countries.name)
    WHERE length(cities.name) = 0;
    eos

    puts
    puts
    puts
    puts "Execute (in steps) the following SQL to populate the places database:"
    puts

    sql.each_with_index do |command, index|
      puts "#{index + 1}: #{command}"
    end


    puts
    puts
    puts
  end

  def down
    drop_table(:cities)
    drop_table(:regions)
    drop_table(:countries)
  end
end
