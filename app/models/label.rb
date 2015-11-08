class Label < ActiveRecord::Base
  has_many :labelings
  belongs_to :labelable, polymorphic: true
  has_many :topics, through: :labelings, source: :labelable, source_type: :Topic
  has_many :posts, through: :labelings, source: :labelable, source_type: :Post

  def self.update_labels(label_string)
    new_labels = []

    unless label_string.nil? || label_string.empty?
      label_string.split(',').each do |label|
        label_name = label.strip
        new_label = Label.find_or_create_by(name: label_name)
        new_labels << new_label
      end
    end

    new_labels
  end
end
