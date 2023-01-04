class Quote < ApplicationRecord
  validates :name, presence: true

  scope :ordered, -> { order(id: :desc) }
  
  # after_create_commit -> { broadcast_prepend_to "quotes",
  #                          partial: "quotes/quote",
  #                          locals: { quote: self },
  #                          target: "quotes" }

  # Default target == model_name.plural
  # Default partial == model_instance.to_partial_path // i.e. "quotes/quote"
  # Default locals == { model_name.element.to_sym => self }
  after_create_commit -> { broadcast_prepend_later_to "quotes" }
  after_update_commit -> { broadcast_replace_later_to "quotes" }
  after_destroy_commit -> { broadcast_remove_to "quotes" } # No asynchronous equivalent
  # Combine the three callbacks above into a single method:
  # broadcasts_to ->(quote) { "quotes" }, inserts_by: prepend
end
