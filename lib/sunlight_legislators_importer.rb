require 'csv'
require_relative '../db/config'

class SunlightLegislatorsImporter
  def self.import(filename)
    csv = CSV.new(File.open(filename), :headers => true, :header_converters => :symbol)
    csv.each do |row|
      legislator = {title: row[:title],
                    name:  (row[:firstname] + " " + row[:lastname]),
                    birthday: row[:birthdate],
                    party: row[:party],
                    state: row[:state],
                    district: row[:district],
                    gender: row[:gender],
                    phone: row[:phone],
                    website: row[:website],
                    in_office: row[:in_office]}
      Legislator.create!(legislator)
    end
  end

  def self.import_birthday(filename)
    csv = CSV.new(File.open(filename), :headers => true, :header_converters => :symbol)
    id = 0
    csv.each do |row|
      id += 1
      fixed_date = Date.strptime(row[:birthdate], '%m/%d/%Y')
      Legislator.update(id, :birthday => fixed_date)
    end
  end

end

# IF YOU WANT TO HAVE THIS FILE RUN ON ITS OWN AND NOT BE IN THE RAKEFILE, UNCOMMENT THE BELOW
# AND RUN THIS FILE FROM THE COMMAND LINE WITH THE PROPER ARGUMENT.
# begin
#   raise ArgumentError, "you must supply a filename argument" unless ARGV.length == 1
#   SunlightLegislatorsImporter.import(ARGV[0])
# rescue ArgumentError => e
#   $stderr.puts "Usage: ruby sunlight_legislators_importer.rb <filename>"
# rescue NotImplementedError => e
#   $stderr.puts "You shouldn't be running this until you've modified it with your implementation!"
# end


# ruby sunlight_legislators_importer.rb legislators.csv
