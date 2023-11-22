# frozen_string_literal: true

class Representative < ApplicationRecord
  has_many :news_items, dependent: :delete_all

  def self.civic_api_to_representative_params(rep_info)
    reps = []

    rep_info.officials.each_with_index do |official, index|
      ocdid_temp = ''
      title_temp = ''
      street = ''
      city = ''
      state = ''
      zip = ''
      political_party = ''
      photo = ''

      rep_info.offices.each do |office|
        if office.official_indices.include? index
          title_temp = office.name
          ocdid_temp = office.division_id
          unless official.address.nil?
            address = official.address[0]
            street = address.line1
            city = address.city
            state = address.state
            zip = address.zip
          end
          photo = official.photo_url
        end
        political_party = official.party if official.party
      end
      
      next if Representative.exists?(name: official.name, ocdid: ocdid_temp)

      rep = Representative.create!(
                                     name:            official.name,
                                     ocdid:           ocdid_temp,
                                     title:           title_temp,
                                     street:          street,
                                     city:            city,
                                     state:           state,
                                     zip:             zip,
                                     political_party: political_party,
                                     photo: photo
                                   )
      reps.push(rep)
    end
    reps
  end
end