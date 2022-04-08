class UsersController < ApplicationController
    before_action() do |controller|
        # signed_in = signed_in()
        # if !signed_in
        #     redirect_to(new_user_url())
        # end
    end

    def new()
        if type == "student"
            @user = Student.new()
        elsif type == "administrator"
            @user = Administrator.new()
        end
    end

    def create()
        if type == "student"
            @user = Student.new(get_params())
        elsif type == "administrator"
            @user = Administrator.new(get_params())
        end

        if @user.save()
            Utils.add_messages(
                flash,
                {
                    type: "success",
                    subtitles: "User created!",
                }
            )
            redirect_to(new_user_url())
        else
            Utils.add_messages(
                flash.now,
                {
                    type: "error",
                    subtitles: @user.errors.full_messages(),
                }
            )
            render(:new, status: :unprocessable_entity)
        end
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
        params = self.params.require(:user)
        if type == "student"
            return params.permit(
                :email, :given_name, :middle_name, :family_name,
                :password, :password_confirmation
            )
        elsif type == "administrator"
            return params.permit(
                :email, :given_name, :middle_name, :family_name,
                :password, :password_confirmation
            )
        end
    end
end
