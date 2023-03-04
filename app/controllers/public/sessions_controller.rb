# frozen_string_literal: true

class Public::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  protected

  def after_sign_out_path_for(resource_or_scope)
     new_member_session_path
  end

  def reject_member
    @member = Member.find_by(email: params[:member][:email])
    if @member
      if @member.valid_password?(params[:member][:password]) && (@member.is_deleted == false)
        flash[:danger] = "退会済みです。再度ご登録ください"
        redirect_to new_member_registration_path
      else
        flash[:warning] = "項目を入力してください"
      end
    end
  end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
