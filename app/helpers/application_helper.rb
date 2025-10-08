module ApplicationHelper
  def locale_switcher
    content_tag(:div, class: "flex items-center space-x-2") do
      locales = [
        { code: :en, flag: "🇺🇸" },
        { code: :pt, flag: "🇧🇷" }
      ]

      locales.map do |locale_info|
        link_to root_path(locale: locale_info[:code]),
                class: "flex items-center px-3 py-2 rounded-lg font-medium transition duration-200 #{current_locale?(locale_info[:code]) ? 'bg-indigo-100 text-indigo-700' : 'text-gray-600 hover:bg-gray-100'}",
                title: t("locales.#{locale_info[:code]}") do
          content_tag(:span, locale_info[:flag], class: "text-xl")
        end
      end.join.html_safe
    end
  end

  def current_locale?(locale)
    I18n.locale.to_sym == locale.to_sym
  end
end
