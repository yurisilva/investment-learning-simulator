class InvestmentCategory < ApplicationRecord
  # Associations
  has_many :investment_types, dependent: :destroy

  # Validations
  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true

  # Callbacks
  before_validation :generate_slug, if: -> { slug.blank? && name.present? }

  # Translated attributes
  def translated_name
    I18n.t("categories.#{slug}.name", default: name)
  end

  def translated_description
    I18n.t("categories.#{slug}.description", default: description)
  end

  private

  def generate_slug
    self.slug = name.parameterize
  end
end
