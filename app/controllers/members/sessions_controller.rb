class Members::SessionsController < Devise::SessionsController
  def guest_sign_in
    member = Member.guest
    sign_in member
    redirect_to root_path, success: 'guestmemberでログインしました'
  end
end