class Member < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # deviseのupdate_without_passwordは本来パスワードは変更できない
  # 管理者しかこの関数を呼ばない前提で、パスワードがなくてもパスワードを変更できるようにオーバーライドする

  # update_with_password関数を参考にする
  def update_without_password(params, *options)
    # current_password = params.delete(:current_password)

    if params[:password].blank?
      params.delete(:password)
      params.delete(:password_confirmation) if params[:password_confirmation].blank?
    end

    # result = if valid_password?(current_password)
    #   update_attributes(params, *options)
    # else
    #   self.assign_attributes(params, *options)
    #   self.valid?
    #   self.errors.add(:current_password, current_password.blank? ? :blank : :invalid)
    #   false
    # end

    update_attributes(params, *options)

    clean_up_passwords
    result
  end
end
