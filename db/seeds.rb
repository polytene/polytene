# Admin Role
admin_role = Role.create!(:abbr => 'admin', :name => 'Admin')

# Admin User
admin_user = User.create!({ :email => 'admin@example.com', :password => 'AlaMaKota2!', :password_confirmation => 'AlaMaKota2!'})
admin_user.user_roles.create!(:role_id => admin_role.id)
