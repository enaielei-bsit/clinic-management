class ApplicationController < ActionController::Base
    USERS = [
        "student", "administrator"
    ]

    before_action(only: [:index]) do |ctrl|
        signed_in = Administrator.signed_in() || Student.signed_in()
        if !signed_in
            redirect_to(new_user_url())
        end
    end

    def index()
    end
end
