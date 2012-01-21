class RegistrationController < ApplicationController
  #before_filter :authenticate_user!

  def sign_up
    if request.post?
      if (current_user)
        current_user.update_without_password(params['user'])
      else #TODO: VALIDATION! (passwords match, etc.)
        User.create!(params['user'])
      end
      #Rails::logger.info "form posted: #{Time.now}"
      #TODO: Send email (take a look at Devise's RegistrationController)
      #TODO: (nice to have) Log the user in automatically
      redirect_to :action => :thank_you #maybe: render :template=>:thank_you
    else
      @hide_auth = true
      @title = ""
      @name = ""
      @email = ""

      if current_user
        work = current_user["work"]
        @name = current_user.name
        @email = current_user.email
      end

      if work && work.length > 0
        @title = work[0]["position"] && work[0]["position"]["name"]
      end
    end
  end

  def thank_you
  end

  def shared
    if request.post?
      user = current_user
      render :nothing => true
    else
      user = User.find(params[:id])
      redirect_to "/"
    end

    user.shares += 1
    user.save!
  end
end
