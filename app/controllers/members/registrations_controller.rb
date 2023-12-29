# frozen_string_literal: true

class Members::RegistrationsController < Devise::RegistrationsController
  ## ログイン中の:new, :createへのアクセスを許可
  ## prepend_before_action :require_no_authentication, only: [:new, :create, :cancel]→
  prepend_before_action :require_no_authentication, only: [:cancel]
  prepend_before_action :authenticate_scope!, only: [:update, :destroy]

  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]


  ## 新規登録権限があるか
  before_action :creatable?, only: [:new, :create]
  before_action :editable?, only: [:edit, :update]
  # GET /resource/sign_up
  # def new
  #   super
  # end


  ##  新規登録権限の判定(権限者としてログインしているか)
  def creatable?
    ## raise -> エラーを出力する
    ## ログインしていない->CanCan::AccessDeniedクラスにエラー
    raise CanCan::AccessDenied unless member_signed_in?
    ## 権限者としてログインしていない->CanCan::AccessDeniedクラスにエラー
    if !current_member_is_admin?
      raise CanCan::AccessDenied
    end
  end
  
  ##  編集権限の判定(権限者としてログインしているか)
  def editable?
    raise CanCan::AccessDenied unless user_signed_in?

    if !current_user_is_admin?
      raise CanCan::AccessDenied
    end
  end

  # POST /resource
  # def create
  #   super
  # end

  # GET /resource/edit
  def edit
    if by_admin_member?(params)
      self.resource = resource_class.to_adapter.get!(params[:id])
    else
      authenticate_scope!
      super
    end
  end

  # PUT /resource
  def update
    if by_admin_user?(params)
      self.resource = resource_class.to_adapter.get!(params[:id])
    else
      self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    end

    if by_admin_user?(params)
      resource_updated = update_resource_without_password(resource, account_update_params)
    else
      resource_updated = update_resource(resource, account_update_params)
    end
  end

  def by_admin_user?(params)
    params[:id].present? && current_user_is_admin?
  end

  def update_resource_without_password(resource, params)
    resource.update_without_password(params)
  end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the member wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  ##
  protected

  ## 権限者としてログインしているか判別
  def current_member_is_admin?
    member_signed_in? && current_member.has_role?(:admin)
  end





  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end


  ## 権限者としてログイン中でなければsign_up後にsign_in
  def sign_up(resouece_name, resouece)
    if !current_member_is_admin?
      sign_in(resource_name, resource)
    end
  end
end