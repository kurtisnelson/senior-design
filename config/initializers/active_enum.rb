# Form helper integration
require 'active_enum/form_helpers/simple_form'

ActiveEnum.setup do |config|

  # Extend classes to add enumerate method
  # config.extend_classes = [ ActiveRecord::Base ]

  # Return name string as value for attribute method
  # config.use_name_as_value = false

  # Storage of values
  # config.storage = :memory

end
