class User < Utils::SessionUser
    validates(
        :password,
        presence: true,
        allow_nil: true,
        confirmation: true,
        length: {minimum: 6}
    )

    has_secure_password()
end