# frozen_string_literal: true

class Representative < ApplicationRecord
  has_many :news_items, dependent: :delete_all

  def self.civic_api_to_representative_params(rep_info)
    reps = []

    rep_info.officials.each_with_index do |official, index|
      title, ocdid = find_title_and_ocdid(rep_info, index)

      rep_attributes = create_rep_attributes(official, title, ocdid)
      existing = Representative.find_by({ name: official.name })
      if existing.nil?
        rep = Representative.create!(rep_attributes)
        reps.push(rep)
      else
        existing.update(rep_attributes)
        reps.push(existing)
      end
    end
    reps
  end

  def self.find_title_and_ocdid(rep_info, index)
    ocdid_temp = ''
    title_temp = ''

    rep_info.offices.each do |office|
      if office.official_indices.include? index
        title_temp = office.name
        ocdid_temp = office.division_id
      end
    end
    [title_temp, ocdid_temp]
  end

  def self.create_rep_attributes(official, title, ocdid)
    address = official.address&.first
    {
      name:      official.name,
      ocdid:     ocdid,
      title:     title,
      line1:     address&.line1,
      city:      address&.city,
      state:     address&.state,
      zip:       address&.zip,
      party:     official.party,
      photo_url: official.photo_url
    }
  end
end
