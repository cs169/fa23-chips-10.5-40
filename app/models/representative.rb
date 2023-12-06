class Representative < ApplicationRecord
  has_many :news_items, dependent: :delete_all

  def self.civic_api_to_representative_params(rep_info)
    rep_info.officials.map do |official|
      rep = build_representative(rep_info, official)
      rep.save! if rep.new_record? || rep.changed?
      rep
    end
  end

  def self.build_representative(rep_info, official)
    ocdid_temp, title_temp, street, city, state, zip, political_party, photo = '', '', '', '', '', '', '', ''

    rep_info.offices.each do |office|
      if office.official_indices.include?(rep_info.officials.index(official))
        title_temp = office.name
        ocdid_temp = office.division_id
        address = official.address&.first
        street, city, state, zip = address&.line1, address&.city, address&.state, address&.zip if address
        photo = official.photo_url if official.photo_url
      end
      political_party = official.party if official.party
    end

    Representative.find_or_initialize_by(name: official.name, ocdid: ocdid_temp).tap do |rep|
      rep.assign_attributes(
        title:           title_temp,
        street:          street,
        city:            city,
        state:           state,
        zip:             zip,
        political_party: political_party,
        photo:           photo
      )
    end
  end
end
