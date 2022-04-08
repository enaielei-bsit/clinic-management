class Administrator < User
    validates(
        :email,
        presence: true,
        uniqueness: true,
        length: {maximum: 50}
    )
    validates(
        :given_name,
        presence: true,
        length: {maximum: 50}
    )
    validates(
        :middle_name,
        length: {maximum: 50}
    )
    validates(
        :family_name,
        presence: true,
        length: {maximum: 50}
    )
end
