class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :set_locale

  def set_locale
    locale = params[:locale] || session[:locale] || I18n.default_locale
    I18n.locale = session[:locale] = locale.to_sym
  end

  def default_url_options
    { locale: I18n.locale }
  end
end
