require 'bcrypt'

class User < ActiveRecord::Base
  validates_length_of :login, within: 2..16
  validates_presence_of :password
  validates_format_of :email, with: /\A[^@]+@\S+\z/

  has_many :posts

  def password=(original_password)

	#we started off doing this:
       	#salt = BCrypt::Engine.generate_salt
	#encrypted = BCrypt::Engine.hash_secret(original_password, salt)
	#but are changing now to instead use BCrypt::Password
	encrypted = BCrypt::Password.create(original_password) #this returns a BCrypt::Password object

	# har har har wouldn't it be funny if we did this (infinitely recurses on itself):
	# self.password = encrypted

	super(encrypted.to_s) #and we need to convert that BCrypt::Password object to a string.
	#which actually is just going to do this but is a more consistent way of expressing it:
	#self.write_attribute(:password, encrypted)

  end

  def self.authenticate(login, plaintext)
	# look up the user with that login
	# check that the passwords match
	# return the User if so, or nil if not.
	user = User.where(login: login).first
	if user   # because if we found the user, this is not nil, otherwise it is nil and will evaluate to false
		encrypted = BCrypt::Password.new(user.password)
		if encrypted == plaintext # well that is an odd thing to write but it should work
			user 	# returns this since it's the last value in the routine. 
			# you can use 'return' if you  really want
#		else				saying 'else nil' is not necessary but you can if you want.
#			nil			The if statement will return nil if the condition evals false.
		end
	end
  end

end

# @user.password = "pie"

# "pie" + "dqw7ad7" = "piedqw7ad7"
# dqw7ad7dwhii7ddh7is7isef7ihhis7e
