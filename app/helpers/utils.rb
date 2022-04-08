module Utils
    class SessionUser < ApplicationRecord
        @@session_digest_name = "session_digest"
        @@session_id_name = "user_id"
        @@session_request_name = "request"

        def sign_in(remembered=false)
            id = @@session_id_name.to_sym
            req = @@session_request_name.to_sym

            if !remembered
                session[id] = self.id
            else
                cookies.permanent.signed[id] = self.id
                request = Utils.random()
                cookies.permanent[req] = request
                user.update(@@session_digest_name => Utils.tokenize(request))
            end
        end
    
        def self.signed_in(user=nil)
            id_ = @@session_id_name.to_sym
            req = @@session_request_name.to_sym

            if user != nil
                return signed_in() == user
            else
                id = session[id_]
                request = nil
                if !id
                    id = cookies.signed[id_]
                    request = cookies[req]
                end
    
                return nil if !id
                user = self.find_by(id: id)
    
                if user && request
                    return user if Utils.compare(user[@@session_digest_name], request)
                end
    
                return user
            end
        end
    
        def self.sign_out(user=nil)
            id = @@session_id_name.to_sym
            req = @@session_request_name.to_sym

            if user == nil || (user && signed_in(user))
                session[id] = nil
                cookies.permanent.signed[id] = nil
                cookies.permanent[req] = nil
                user.update(digest_name => nil)
            end
        end
    end

    def self.generate_message(title, subtitles=nil, type=nil)
        return {
            "title" => title,
            "subtitles" => !subtitles ? [] : (
                !subtitles.is_a?(Array) ? [subtitles] : subtitles
            ),
            "type" => type || "positive",
        }
    end
    
    def self.add_messages(container, *messages)
        first = messages.first
        if first
            container[:messages] = [] if !container[:messages]

            if first.is_a?(Array)
                container[:messages] << generate_message(
                    first[0],
                    first[1],
                    first[2],
                )
            else
                if first.is_a?(Hash)
                    for message in messages
                        container[:messages] << generate_message(
                            message[:title] || message["title"],
                            message[:subtitles] || message["subtitles"],
                            message[:type] || message["type"],
                        )
                    end
                else
                    container[:messages] << generate_message(*messages)
                end
            end

            return container
        end
    end

    def self.random(size=10)
        return SecureRandom.urlsafe_base64(size)
    end

    def self.tokenize(value)
        return BCrypt::Password.create(value)
    end

    def self.compare(token, random)
        begin
            return BCrypt::Password.new(token) == random
        rescue
        ensure
        end
        
        return false
    end
end