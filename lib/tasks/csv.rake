namespace :csv do
  desc "Parse a standard csv file"
  task :parse_standard, [:file] => :environment do |task, args|
    Voter.parse_standard_csv(args[:file])
  end

  desc "Parse all uploaded csv files"
  task :parse_all_files => :environment do
    Voter.parse_all_files
  end

  desc "Export to csv"
  task :export => :environment do
    Voter.to_csv
  end
end