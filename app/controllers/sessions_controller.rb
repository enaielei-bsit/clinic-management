class SessionsController < ApplicationController
  before_action() do |ctrl|
      # signed_in = signed_in()
      # if !signed_in
      #     redirect_to(new_user_url())
      # end
  end

  def new()
    @session = params[:session] || {
      email: "",
      password: "",
      remembered: false
    }
  end

  def create()
      @session = params[:session] || {
        email: "",
        password: "",
        remembered: false
      }

      if type == "student"
        @user = Student.find_by(email: @session[:email])
      elsif type == "administrator"
        @user = Administrator.find_by(email: @session[:email])
      end

      if @user
        if @user.authenticate(@session[:password])
          remembered = session[:remembered] == "1" : true : false
          @user.sign_in(remembered)
          Utils.add_messages(
            flash,
            {
              type: "success",
              subtitles: "User logged in!",
            }
          )
          return redirect_to(root_url())
        else
          Utils.add_messages(
              flash.now,
              {
                type: "error",
                subtitles: @user.errors.full_messages(),
              }
          )
        end
      else
        Utils.add_messages(
            flash.now,
            {
              type: "error",
              subtitles: "User does not exist!",
            }
        )
      end
      render(:new, status: :unprocessable_entity)
  end

  def destroy()
    Administrator.sign_out()
    Student.sign_out()
    redirect_to(root_url())
  end

  def type()
      t = params[:type]
      if USERS.include?(t)
        return t
      end
      return USERS.first
  end

  private

  def get_params()
      params = self.params.require(:session)
      if type == "student"
        return params.permi(
          :email, :password, :remembered
        )
      elsif type == "administrator"
        return params.permit(
          :email, :password, :remembered
        )
      end
  end
end
