class ApplicationController < ActionController::Base
    USERS = [
        "student", "administrator"
    ]

    before_action(only: [:index]) do |ctrl|
        signed_in = signed_in()
        if !signed_in
            redirect_to(new_user_url())
        end
    end

    def index()
    end

    def sign_in(user, remembered=false)
        if !remembered
            session[:user_id] = user.id
        else
            cookies.permanent.signed[:user_id] = user.id
            request = Utils.random()
            cookies.permanent[:request] = request
            user.update(session_digest: Utils.tokenize(request))
        end
    end

    def sign_out(user=nil)
        if user == nil || (user && signed_in(user))
            session[:user_id] = nil
            cookies.permanent.signed[:user_id] = nil
            cookies.permanent[:request] = nil
            user.update(session_digest: nil)
        end
    end

    def signed_in(user=nil)
        if user != nil
            return signed_in() == user
        else
            id = session[:user_id]
            request = nil
            if !id
                id = cookies.signed[:user_id]
                request = cookies[:request]
            end

            return nil if !id
            user = User.find_by(id: id)

            if user && request
                return user if Utils.compare(user.session_digest, request)
            end

            return user
        end
    end
end
