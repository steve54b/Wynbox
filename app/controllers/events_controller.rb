class EventsController < ApplicationController
  def index
    
  end

  def redirect
    google_api_client = Google::APIClient.new({
      application_name: 'Wynbox',
      application_version: '1.0.0'
    })

    google_api_client.authorization = Signet::OAuth2::Client.new({
      client_id: ENV.fetch('GOOGLE_KEY'),
      client_secret: ENV.fetch('GOOGLE_SECRET'),
      authorization_uri: 'https://accounts.google.com/o/oauth2/auth',
      scope: 'https://www.googleapis.com/auth/calendar.readonly',
      #redirect_uri: 'http://localhost:3000/auth/google_oauth2/callback'
      redirect_uri: url_for(:action => :callback)
    })

    authorization_uri = google_api_client.authorization.authorization_uri

    redirect_to authorization_uri.to_s
  end

  def callback
    google_api_client = Google::APIClient.new({
      application_name: 'Wynbox',
      application_version: '1.0.0'
    })

    google_api_client.authorization = Signet::OAuth2::Client.new({
      client_id: ENV.fetch('GOOGLE_KEY'),
      client_secret: ENV.fetch('GOOGLE_SECRET'),
      token_credential_uri: 'https://accounts.google.com/o/oauth2/token',
      redirect_uri: url_for(:action => :callback),
      code: params[:code]
    })

    response = google_api_client.authorization.fetch_access_token!

    session[:access_token] = response['access_token']

    redirect_to url_for(:action => :calendars)
  end

  def calendars
    google_api_client = Google::APIClient.new({
      application_name: 'Wynbox',
      application_version: '1.0.0'
    })

    google_api_client.authorization = Signet::OAuth2::Client.new({
      client_id: ENV.fetch('GOOGLE_KEY'),
      client_secret: ENV.fetch('GOOGLE_SECRET'),
      access_token: session[:access_token]
    })

    google_calendar_api = google_api_client.discovered_api('calendar', 'v3')

    response = google_api_client.execute({
      api_method: google_calendar_api.events.list,
      parameters: {
        calendarId: "wyncode.co_qiqsohd35u10emguaedl9uqjpc@group.calendar.google.com"
      }
    })

    responseta = google_api_client.execute({
      api_method: google_calendar_api.events.list,
      parameters: {
        calendarId: "wyncode.co_uihuufg7hd8qr6f8cfu7afbo3k@group.calendar.google.com"
      }
    })

    @times = []
    @times << responseta.data.items.to_json

    @tatimes = JSON.parse @times[0]
    @tatimes.each do |time| 
      puts ""
      puts time["summary"]
      puts time["start"]
      puts time["end"]
    end

    @items = []
    @items << response.data.items.to_json
 
    @hash = JSON.parse @items[0]
    @hash.each do |lesson|
      puts ""
      puts lesson["summary"]
      puts lesson["start"]
      puts lesson["end"]
    end
  
    redirect_to events_index_path
  end

end
