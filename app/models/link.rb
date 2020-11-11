# == Schema Information
#
# Table name: links
#
#  id            :bigint           not null, primary key
#  name          :string
#  url           :string
#  linkable_type :string
#  linkable_id   :bigint
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true

  validates_format_of :url, with: URI.regexp

  def gist?
    URI.parse(url).host.include?('gist')
  end

  def load_gist
    client = Octokit::Client.new
    gist_id = URI.parse(url).path.split('/').last

    client.gist(gist_id)
  end
end
