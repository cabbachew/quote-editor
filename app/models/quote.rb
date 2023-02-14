class Quote < ApplicationRecord
  has_many :line_item_dates, dependent: :destroy
  has_many :line_items, through: :line_item_dates

  belongs_to :company

  validates :name, presence: true

  scope :ordered, -> { order(id: :desc) }
  
  # after_create_commit -> { broadcast_prepend_to "quotes",
  #                          partial: "quotes/quote",
  #                          locals: { quote: self },
  #                          target: "quotes" }

  # Default target == model_name.plural
  # Default partial == model_instance.to_partial_path // i.e. "quotes/quote"
  # Default locals == { model_name.element.to_sym => self }
  after_create_commit ->(quote) { broadcast_prepend_later_to quote.company, "quotes" }
  after_update_commit ->(quote) { broadcast_replace_later_to quote.company, "quotes" }
  after_destroy_commit ->(quote) { broadcast_remove_to quote.company, "quotes" } # No asynchronous equivalent
  # Combine the three callbacks above into a single method:
  # broadcasts_to ->(quote) { [quote.company, "quotes"] }, inserts_by: prepend

  def total_price
    line_items.sum(&:total_price)
  end
end
