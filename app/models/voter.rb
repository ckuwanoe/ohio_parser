class Voter < ActiveRecord::Base
  require 'csv'

  STANDARD = {:county_voter_id => 6, :av_requested_date => 20, :av_sent_date => 13, :av_returned_date => 15, :ev_date => 15}
  EV = %w( INPERSON PERSON EARLY )

  def self.parse_standard_csv(file)
    file_array = file.split('/').last.split('-')
    county_name = file_array.first.downcase.titleize # get county name from file
    file_date = Date.parse(file_array[1])
    county_id = County.where(name: county_name).first.id

    CSV.parse(File.open(file))[1..-1].each do |row|
      # use the lookup table to get the state voter id
      state_voter_id = CountyVoter.where(county_name: county_name, county_voter_id: row[Voter::STANDARD[:county_voter_id]]).first.try(:state_voter_id)

      # check to see if we're doing early vote or absentee
      if Voter::EV.include?(row[16])
        ev_date = row[Voter::STANDARD[:ev_date]]
      else
        av_returned_date = row[Voter::STANDARD[:av_returned_date]]
      end

      # find the voter by county voter id, create if it doesn't exist
      voter = self.where(county_name: county_name, county_voter_id: row[Voter::STANDARD[:county_voter_id]]).first_or_initialize
      voter.state_voter_id = state_voter_id
      voter.county_id = county_id
      voter.county_voter_id = row[Voter::STANDARD[:county_voter_id]]
      voter.av_requested_date = row[Voter::STANDARD[:av_requested_date]]
      voter.av_sent_date = row[Voter::STANDARD[:av_sent_date]]
      voter.av_returned_date = av_returned_date
      voter.ev_date = ev_date
      voter.county_name = county_name.titleize
      voter.file_date = file_date
      voter.save
    end
    return true
  end
end
