module Utils
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