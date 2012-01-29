OmniAuth Fellowship One Strategey
===========================================

Introduction
---
This library is an implementation of the OmniAuth Fellowship One 3rdparty
Authentication Strategy.

This library has only been tested with Devise and OmniAuth, but there is no reason
it cannot work without Devise.

Example Usage
---

The following example demonstrates what is required to use Devise and OmniAuth
in Rails 3.x with the Fellowship One Strategy to implement a sign in that authenticates
against Fellowship One.

Add the gem to the Gemfile:

    gem 'omniauth-fellowshipone'

Example Devise initializer configuration (config/initializers/devise.rb):
---

    config.omniauth :fellowship_one,
                    # FellowshipOne 3rdparty Consumer Key
                    '123',
                    # FellowshipOne 3rdparty Consumer Secret
                    '01234567-89ab-cdef-0123-4567890afbcd',
                    # FellowshipOne API Endpoint with %CC in place of
                    :site => 'https://%CC.fellowshiponeapi.com'.freeze

Example Devise route configuration (config/routes.rb):
---

  devise_for :users, :controllers => {:omniauth_callbacks => 'users/omniauth_callbacks'} do
    get 'sign_in', :to => 'users/sessions#new', :as => :new_user_session
    delete 'sign_out', :to => 'users/sessions#destroy', :as => :destroy_user_session
    get '/users/auth/:provider' => 'users/omniauth_callbacks#passthru'
  end

  unauthenticated do
    root :to => 'users/sessions#new'
  end

Example Application Controller (app/controllers/users/application_controller.rb):
---

  class ApplicationController < ActionController::Base
    before_filter :authenticate_user!
  end

Example Users Controller (app/controllers/users/sessions_controller.rb):
---

  class Users::SessionsController < ApplicationController
    skip_before_filter :authenticate_user!

    def new
      # sign_in is called in the callbacks controller
    end

    def destroy
      sign_out
      redirect_to new_user_session_path
    end
  end

Example OmniAuth Callbacks Controller (app/controllers/users/omniauth_callbacks_controller.rb):
---

  class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

    def fellowship_one
      @user = User.find_for_fellowship_one(env["omniauth.auth"], current_user)

      if @user.persisted?
        flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "FellowshipOne"
        sign_in_and_redirect @user, :event => :authentication
      else
        session["devise.fellowship_one_data"] = env["omniauth.auth"]
        redirect_to new_user_registration_url
      end
    end

    def passthru
      render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
    end

  end

Example User model (app/models/user.rb):
---

  class User < ActiveRecord::Base
    devise :omniauthable

    attr_accessible :uid, :church_code, :secret, :token, :first, :last,

    def self.find_for_fellowship_one(access_token, signed_in_resource=nil)
      uid = access_token['uid']
      church_code = access_token['info']['church_code']
      token = access_token['credentials']['token']
      secret = access_token['credentials']['secret']
      last = access_token['info']['last']
      first = access_token['info']['first']
      icode = access_token['extra']['raw_info']['@iCode']

      if user = User.find_by_uid(uid)
        user.update_attributes!(:token => token,
                                :secret => secret)
      else
        user = User.create!(:uid => uid,
                            :church_code => church_code,
                            :first => first,
                            :last => last,
                            :token => token,
                            :secret => secret)
      end

      user
    end
  end

Example New User Html (app/views/users/sessions/new.html.erb):
---

    <%= form_tag(user_omniauth_authorize_path(:fellowship_one)) do %>
    <input type="text" id="church_code"/>
    ...
    <% end %>

    <script type="text/javascript">
    $(document).ready(function() {
      $("form").submit(function() {
        var $church_code = $("#church_code");
        /* validate church code */
        $(this).attr('action', $(this).attr('action') + "?church_code=" + escape($church_code.val()));
      });
    });
    </script>
