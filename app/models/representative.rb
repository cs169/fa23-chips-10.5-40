# frozen_string_literal: true

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
    office_info = find_office_info(rep_info, official)
    address = official.address&.first

    Representative.find_or_initialize_by(name: official.name, ocdid: office_info[:ocdid]).tap do |rep|
      rep.assign_attributes(
        title:           office_info[:title],
        street:          address&.line1,
        city:            address&.city,
        state:           address&.state,
        zip:             address&.zip,
        political_party: official.party || '',
        photo:           official.photo_url || ''
      )
    end
  end

  def self.find_office_info(rep_info, official)
    rep_info.offices.each do |office|
      if office.official_indices.include?(rep_info.officials.index(official))
        return {
          title: office.name,
          ocdid: office.division_id
        }
      end
    end
    { title: '', ocdid: '' }
  end
end
