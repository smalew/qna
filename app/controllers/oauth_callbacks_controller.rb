class OauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_action :verify_authenticity_token, only: :github

  def github
    if user&.persisted?
      authorize_user_by('GitHUb')
    else
      redirect_to root_path
    end
  end

  def twitter
    if user.present?
      authorize_user_by('Twitter')
    else
      session['omniauth.auth'] = oauth_params
      redirect_to new_user_confirmation_path
    end
  end

  def failure
    set_flash_message!(
      :alert,
      :failure,
      kind: OmniAuth::Utils.camelize(failed_strategy.name),
      reason: 'Error'
    )
    redirect_to root_path
  end

  private

    def authorize_user_by(provider)
      sign_in_and_redirect user, event: :authentication
      set_flash_message(:notice, :success, kind: provider) if is_navigational_format?
    end

    def user
      @user ||= User.find_for_oauth(oauth_params)
    end

    def oauth_params
      request.env['omniauth.auth']
    end
end
