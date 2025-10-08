class GlossaryTerm < ApplicationRecord
  # Validations
  validates :term, presence: true, uniqueness: true
  validates :definition, presence: true

  # Scopes
  scope :alphabetical, -> { order(:term) }
  scope :by_category, ->(category) { where("? = ANY(related_categories)", category) }

  # Translated attributes
  def translated_term
    I18n.t("glossary_terms.#{term.parameterize.underscore}.term", default: term)
  end

  def translated_definition
    I18n.t("glossary_terms.#{term.parameterize.underscore}.definition", default: definition)
  end
end
