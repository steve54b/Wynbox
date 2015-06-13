class DocumentsController < ApplicationController
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
      scope: 'https://www.googleapis.com/auth/drive',
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

    redirect_to url_for(:action => :docs)
  end

  def docs
    google_api_client = Google::APIClient.new({
      application_name: 'Wynbox',
      application_version: '1.0.0'
    })

    google_api_client.authorization = Signet::OAuth2::Client.new({
      client_id: ENV.fetch('GOOGLE_KEY'),
      client_secret: ENV.fetch('GOOGLE_SECRET'),
      access_token: session[:access_token]
    })

    google_drive_api = google_api_client.discovered_api('drive', 'v2')

    response = google_api_client.execute({
      api_method: google_drive_api.files.list,
      parameters: {}
    })

    # @documents = []
    # @documents << response.data["items"]

    # @documents[0].each do |time|
    #   puts ""
    #   puts time["title"]
    #   puts time[""]
    # end

    redirect_to documents_index_path
  end
end
