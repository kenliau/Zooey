class User < ActiveRecord::Base
  has_many :videos

  # devise :validatable handles password length and regex
  # configurable in config/initializers/devise.rb
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :email, :password, :password_confirmation, :remember_me,
    :first_name, :last_name, :is_admin, :membership

  validates :first_name, :last_name, :email, :membership, :password,
    :presence => { message: "is a required field" }

  validates :membership,
    :numericality => {
      :only_integer => true,
      :less_than => 3,
      :greater_than_or_equal_to => 0
    }
  validates :email,
    :uniqueness => {
      :message => "matches an email address that's already registers"
    }

  # on creation of a new model
  before_create :capitalize_names, :initialize_is_admin

  def capitalize_names
    self.first_name.capitalize!
    self.last_name.capitalize!
  end

  def initialize_is_admin
    self.is_admin ||= false;
    # BEFORE_CREATES CAN NEVER RETURN FALSE
    true
  end

  def admin?
    self.is_admin
  end
end
