# Filename is prefixed with zero so that it runs first and other initializers can depend on it
APP_CONFIG = YAML.load_file("#{Rails.root.to_s}/config/nedb_config.yml")[Rails.env]
