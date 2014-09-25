namespace :parse_csv do
  desc "Parse a standard csv file"
  task :standard, [:file] => :environment do |task, args|
    Voter.parse_csv(file)
  end
end