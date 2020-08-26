# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

    def new
      @user = User.new
    end

    def create
      @user = User.new(sign_up_params)
      unless @user.valid?
        flash.now[:alert] = @user.errors.full_messages
        render :new and return
      end
      session["devise.regist_data"] = {user: @user.attributes}
      session["devise.regist_data"][:user]["password"] = params[:user][:password]
      @profile = @user.build_profile
      render :new_profile
    end

    def create_profile
      @user = User.new(session["devise.regist_data"]["user"])
      @profile = Profile.new(profile_params)

      unless @profile.valid?
        flash.now[:alert] = @profile.errors.full_messages
        render :new_profile and return
      end
      session["devise.regist_data"].merge!(profile: @user.build_profile(@profile.attributes).attributes)
      @address = @user.addresses.build
      render :new_address
    end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:nickname])
  end

  def profile_params
    params.require(:profile).permit(:family_name, :family_name_kana, :first_name, :first_name_kana, :birthday)
  end

  def address_params
    params.require(:address).permit(:post_family_name, :post_family_name_kana, :post_first_name, :post_first_name_kana, :postal_code, :prefecture_id, :city, :address, :building, :phone_number)
  end

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
end