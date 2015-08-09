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

  config.model Book do
    list do
      configure :description do
        hide
      end
    end
    edit do
      # To configure the editor bar or the parser rules pass a hash of options:
      # For RailsAdmin >= 0.5.0
      configure :description, :wysihtml5 do
        config_options toolbar: { fa: true, image: false, link: false }, # use font-awesome instead of glyphicon
                       html: true, # enables html editor
                       parserRules: { tags: { p:1 } } # support for <p> in html mode
      end
      # field :description, :wysihtml5 do
      #   config_options toolbar: { fa: true, image: false, link: false }, # use font-awesome instead of glyphicon
      #                  html: true, # enables html editor
      #                  parserRules: { tags: { p:1 } } # support for <p> in html mode
      #
      # end
    end
  end


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
