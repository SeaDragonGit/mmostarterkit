require 'rails_admin/extensions/history/auditing_adapter'

RailsAdmin.add_extension(:history, MmoStarterKit::Extensions::History,
                         auditing: true
)
