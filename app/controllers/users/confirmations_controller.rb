# frozen_string_literal: true

module Users
  class ConfirmationsController < Devise::ConfirmationsController
    
    # GET /resource/confirmation/new
    # def new
    #   super
    # end

    # POST /resource/confirmation
    # def create
    #   super
    # end
    
    #メール認証後にそのままログインさせるための記述
    #これはメールアドレスを間違って登録してしまった時のため、セキュリティ上この設定になっている
    # GET /resource/confirmation?confirmation_token=abcdef
    def show
      super do
        sign_in(resource) if resource.errors.empty?
      end
    end
  
    def after_confirmation_path_for(resource_name, resource)
      after_sign_in_path_for(resource)
    end

    # protected

    # The path used after resending confirmation instructions.
    # def after_resending_confirmation_instructions_path_for(resource_name)
    #   super(resource_name)
    # end

    # The path used after confirmation.
    # def after_confirmation_path_for(resource_name, resource)
    #   super(resource_name, resource)
    # end
  end
end
