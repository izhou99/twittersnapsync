require 'pp'
require 'twitter'

class SessionsController < ApplicationController
  def create
    credentials = request.env['omniauth.auth']['credentials']
    session[:access_token] = credentials['token']
    session[:access_token_secret] = credentials['secret']
    redirect_to show_path, notice: 'Signed in'
  end

  def show
    if session['access_token'] && session['access_token_secret']
      @user = client.user(include_entities: true)
      friends = get_friends
      friends.select! do |f|
        f[:description].downcase.include?("snap")
      end

      @friends = friends.map do |user|
        user[:description].gsub!(":", " ")
        user[:description].gsub!("@", " ")
        pieces = user[:description].split(" ")
        i = 0
        found = false
        snapchat = ""
        while i < pieces.length
          if pieces[i].downcase.include?("snap")
            found = true
            i += 1
            next
          end

          if found && (pieces[i] =~ /[a-zA-Z0-9]+[a-zA-Z0-9\.\-\_]+/) != nil
            if pieces[i].downcase.include?("insta") ||
              pieces[i].downcase == "chat" ||
              pieces[i].length < 5
              i += 1
              next 
            end
            snapchat = pieces[i]
            break
          end
          i += 1
        end
        {:name => user[:name], :snapchat => snapchat}
      end
    else
      redirect_to failure_path
    end
  end

  def get_friends
    cursor = -1
    friends = []
    begin
      f = client.friends(:cursor => cursor, :count => 200, include_entities: true)
      friends += f.attrs[:users]
      cursor = f.attrs[:next_cursor]
      pp cursor
    end while cursor > 0
    return friends
  end

  def error
    flash[:error] = 'Sign in with Twitter failed'
    redirect_to root_path
  end

  def destroy
    reset_session
    redirect_to root_path, notice: 'Signed out'
  end

end
