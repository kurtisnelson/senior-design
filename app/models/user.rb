class User < ActiveRecord::Base
  has_many :players, dependent: :delete_all
  has_many :stats
  has_many :teams, through: :players

  devise :database_authenticatable, :registerable, :omniauthable,
    :recoverable, :rememberable, :trackable, :omniauth_providers => [:google_oauth2]
  validates :name, :email, presence: true

  enumerate :role do
    value id: 0, name: "Player"
    value id: 1, name: "Statistician"
    value id: 2, name: "Coach"
  end

  def self.find_for_google_oauth2(auth)
    data = auth.info
    user = User.where(:email => data["email"]).first

    unless user
      user = User.create(name: data["name"],
                         email: data["email"],
                         password: Devise.friendly_token[0,20]
                        )
    end
    user
  end
end
