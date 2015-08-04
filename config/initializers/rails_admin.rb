RailsAdmin.config do |config|

  ### Popular gems integration

  # == Devise ==
  config.authenticate_with do
    warden.authenticate! scope: :user
  end
  config.current_user_method(&:current_user)

  # == Cancan ==
  config.authorize_with :cancan

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration

  # config.model Book do
  #   edit do
  #     field :description, :wysihtml5
  #   end
  # end

  config.actions do
    dashboard # mandatory
    index # mandatory
    new do
      except ['Order', 'OrderItem', 'Address', 'Rating']
    end
    #export
    #bulk_delete
    show
    edit
    #delete
    show_in_app
    state

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end

  config.excluded_models = [
      "CreditCard",
  ]
end
