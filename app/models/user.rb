class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  # devise :ldap_authenticatable, :registerable,
  #        :recoverable, :rememberable, :trackable, :validatable

  devise :ldap_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

         validates :username, presence: true, uniqueness: true 

      before_validation :get_ldap_email
      def get_ldap_email
      self.email = Devise::LDAP::Adapter.get_ldap_param(self.username,"mail").first.split(",").first 

      end
end
