class ApplicationController < ActionController::Base
  # before_action :authenticate_user!
before_action :set_breadcrumbs

def add_breadcrumb(label, path, current = false)
  @breadcrumbs << {
    label: label,
    path: path,
    current: current
  }
end

def set_breadcrumbs
  @breadcrumbs = []
end

def default_url_options
  { host: ENV["DOMAIN"] || "localhost:3000" }
end

end
