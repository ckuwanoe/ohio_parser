namespace :csv do
  desc "Parse a standard csv file"
  task :parse_standard, [:file] => :environment do |task, args|
    Voter.parse_csv(args[:file])
  end

  desc "Parse all uploaded csv files"
  task :parse_all_files => :environment do
    Voter.parse_all_files
  end

  desc "Export to csv"
  task :export => :environment do
    Voter.to_csv
  end

  desc "Import all files then export"
  task :import_then_export => :environment do
    Voter.parse_all_files
    Voter.to_csv
  end

  desc "Test sudo"
  task :sudo => :environment do
    puts ENV['sudo_password']
  end
end