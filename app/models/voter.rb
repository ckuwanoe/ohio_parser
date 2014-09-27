class Voter < ActiveRecord::Base
  require 'csv'

  STANDARD = {:county_voter_id => 6, :av_requested_date => 20, :av_sent_date => 13, :av_returned_date => 15, :ev_date => 15}
  STANDARD_WITH_PHONE = {:county_voter_id => 7, :av_requested_date => 21, :av_sent_date => 14, :av_returned_date => 16, :ev_date => 16}
  NON_STANDARD = {"Athens" => STANDARD_WITH_PHONE, "Highland" => STANDARD_WITH_PHONE, "Jackson" => STANDARD_WITH_PHONE,
    "Marion" => STANDARD_WITH_PHONE, "Monroe" => STANDARD_WITH_PHONE, "Perry" => STANDARD_WITH_PHONE, "Putnam" => STANDARD_WITH_PHONE,
    "Fulton" => STANDARD_WITH_PHONE, "Paulding" => STANDARD_WITH_PHONE, "Van Wert" => STANDARD_WITH_PHONE}
  EV = %w( INPERSON PERSON EARLY )

  def self.parse_csv(file)
    file_array = file.split('/').last.split('-')
    county_name = file_array.first.downcase.gsub(/_/, ' ').titleize # get county name from file
    file_date = Date.parse(file_array[1])
    county = County.where(name: county_name).first
    county.standard? ? hash = STANDARD : hash = NON_STANDARD[county.name]
    county_id = county.id

    CSV.parse(File.open(file))[1..-1].each do |row|
      # use the lookup table to get the state voter id
      state_voter_id = CountyVoter.where(county_name: county_name, county_voter_id: row[hash[:county_voter_id]]).first.try(:state_voter_id)

      # check to see if we're doing early vote or absentee
      if Voter::EV.include?(row[16])
        ev_date = row[hash[:ev_date]]
      else
        av_returned_date = row[hash[:av_returned_date]]
      end

      # find the voter by county voter id, create if it doesn't exist
      voter = self.where(county_name: county_name, county_voter_id: row[hash[:county_voter_id]]).first_or_initialize
      voter.state_voter_id = state_voter_id
      voter.county_id = county_id
      voter.county_voter_id = row[hash[:county_voter_id]]
      voter.av_requested_date = row[hash[:av_requested_date]]
      voter.av_sent_date = row[hash[:av_sent_date]]
      voter.av_returned_date = av_returned_date
      voter.ev_date = ev_date
      voter.county_name = county_name.titleize
      voter.file_date = file_date
      voter.save
    end
    return true
  end

  def self.to_csv
    file_part = "export-#{Time.now.to_i}"
    file_name = "#{file_part}.csv"
    file_path = "#{Rails.root}/public/downloads/#{file_name}"
    CSV.open(file_path, 'w+') do |csv|
      csv << ["state_voter_id", "county_name", "county_voter_id","av_requested_date","av_sent_date", "av_returned_date", "ev_date"]
      where("state_voter_id IS NOT NULL").each do |voter|
        csv << [voter.state_voter_id, voter.county_name, voter.county_voter_id, voter.av_requested_date, voter.av_sent_date, voter.av_returned_date, voter.ev_date]
      end
    end

    `cd #{Rails.root}/public/downloads/ && split -b20m -d #{file_name} #{file_part} && rm #{file_path}`
  end

  def self.parse_all_files
    base_dir = "#{Rails.root}/public/uploads"
    `echo #{ENV['sudo_password']} | sudo -S chmod -R 755 #{base_dir}/*`
    files = Dir.glob("#{base_dir}/*")
    files.each do |file|
      self.parse_csv(file)
      Rails.logger.io.info("parsed #{file}\n")
      `mv #{file} #{Rails.root}/public/archive/`
    end
  end
end
