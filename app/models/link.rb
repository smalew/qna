class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true

  validates_format_of :url, with: URI.regexp
end
