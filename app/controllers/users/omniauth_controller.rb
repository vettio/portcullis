class Users::OmniauthController < Devise::OmniauthCallbacksController
  private
  def omniauth_auth
    request.env['omniauth.auth']
  end

  private
  def omniauth_params
    request.env['omniauth.params']
  end

  private
  def is_omniauth_auth_malformed?
    return true if omniauth_auth.empty? or omniauth_auth.nil?
    ['provider', 'uid', 'info', 'credentials'].each do | key |
      unless omniauth_auth.keys.include? key
        Rails.logger.info "Exception! #{key} key is missing" 
        return true
      end
    end
    false
  end

  private
  def create_user_with_oauth(provider)
    info = omniauth_auth['info']
    return :error_user_exists unless User.find_by_email(info['email']).nil?

    @user = User.new email: info['email']
    @provider = @user.providers.build
    @provider.user = @user
    @provider.name = provider.to_sym
    @provider.token = omniauth_auth['credentials']['token'].to_s
    @provider.uid = omniauth_auth['uid'].to_s
    @provider.import_from_oauth omniauth_auth['info']
    @user.grant :attendee

    begin
      @user.save!
      @provider.save!
    rescue ActiveRecord::RecordInvalid
      return :error_user_is_malformed
    end
    :user_created
  end

  private
  def find_user_from_oauth(provider)
    email = omniauth_auth['info']['email']
    @user = User.find_by_email(email)
    return :error_not_found if @user.nil?
    return :user_found
  end

  private
  def validate_parameters!
    redirect_to new_user_session_path, error: t('auth.failure'), status: 500 and return false if omniauth_params.nil?

    @user = nil
    @task = omniauth_params['task'].to_s if omniauth_params.keys.include? 'task'
    no_good = (@task.nil? || omniauth_params.empty?)

    redirect_to new_user_registration_path, error: t('auth.failure'), status: 500 and return false if no_good
    redirect_to new_user_session_path, error: t('auth.failure'), status: 500 and return false if is_omniauth_auth_malformed?
    true
  end

  private 
  def do_the_deed(provider)
    return unless validate_parameters!

    case @task
    when 'new'
      case create_user_with_oauth(provider)
      when :error_user_is_malformed
        flash[:error] = 'A bit of a slip up trying to make your account. Try again?'
        redirect_to new_user_registration_path, status: :internal_server_error, 
          error: t('auth.create_failure') and return
      when :error_user_exists
        @user = User.find_by_email(omniauth_auth['info']['email'])
      end
    when 'find'
      case find_user_from_oauth(provider)
      when :error_not_found
        redirect_to new_user_session_path, status: :internal_server_error,
          error: t('auth.failure') and return
      when :user_found
        flash[:notice] = t('auth.welcome')
      end
    end

    return complete_the_deed
  end

  private
  def complete_the_deed
    flash[:notice] = "Welcome #{@user.profile.first_name}!"
    sign_in_and_redirect @user and return true unless @user.nil?
  end

  Settings.authentication.providers.each do | provider, _ |
    class_eval <<-METHODS, __FILE__, __LINE__+1
    public
    def #{provider}
      return do_the_deed('#{provider}')
    end
    METHODS
  end

  public
  def failure
    redirect_to new_user_session_path, status: 401, alert: t('auth.failure') and return
  end
end
