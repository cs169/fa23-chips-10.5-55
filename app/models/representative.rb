# frozen_string_literal: true

class Representative < ApplicationRecord
  has_many :news_items, dependent: :delete_all

  def self.civic_api_to_representative_params(rep_info)
    reps = []

    rep_info.officials.each_with_index do |official, index|
      ocdid_temp = ''
      title_temp = ''
      address_temp = ''

      rep_info.offices.each do |office|
        if office.official_indices.include? index
          title_temp = office.name
          ocdid_temp = office.division_id
        end
      end
      rep_attributes = {
        name: official.name,
        ocdid: ocdid_temp,
        title: title_temp,
        "line1": official.address&.first&.line1,
        # "line2": official.address&.first&.line2,
        # "line3": official.address&.first&.line3,
        "city": official.address&.first&.city,
        "state": official.address&.first&.state,
        "zip": official.address&.first&.zip,
        party: official.party,
        photo_url: official.photoUrl,
      }
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
end
