UserSessionsController.class_eval do

  def merge
    # now sign in from the login form
    authenticate_user!

    if not current_user
      flash[:error] = I18n.t("devise.failure.invalid")
      @user = User.find(params['user']['id'])
      return render(:template => 'users/merge')
    end

    # prep for all the shifting and do it
    user = User.find(current_user.id)
    user.user_authentications << UserAuthentication.find(params[:user_authentication])
    user.save!

    if current_order
      current_order.associate_user!(user)
      session[:guest_token] = nil
    end
    # trash the old anonymous that was created
    User.destroy(params[:user][:id])

    # tell the truth now
    flash[:alert] = "Succesfully linked your accounts"
    sign_in_and_redirect(user, :event => :authentication)
  end

end
