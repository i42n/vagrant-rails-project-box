class Podcast < ActiveRecord::Base
	before_destroy :ensure_save_destroy
	before_destroy :remove_thumbs

	has_many :episodes, :dependent => :destroy

	acts_as_taggable_on :tags, :category

	validates :feed, presence: true
	validates :title, presence: true
	validates :logo_url, presence: true
	validates :website, presence: true

	mount_uploader :coverart, CoverArtUploader

	private
		def ensure_save_destroy
			# ensure that non of the episodes of this podcast is in danger zone
			self.episodes.each do |episode|
				episode.playlist_entries.each do |entry|
					return false if entry.isInDangerZone?
				end
			end
		end

		def remove_thumbs
			self.remove_coverart!
			self.save
		end
end
