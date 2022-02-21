require 'googleauth'
require 'google/apis/drive_v3'
require "google/apis/drive_v3"
class ArticlesController < ApplicationController
  Drive = ::Google::Apis::DriveV3
  def home
    redirect_to new_article_path
  end

  def index
    @articles = Article.new
  end

  def new
    @article=Article.new
  end

  def create
    scope = 'https://www.googleapis.com/auth/drive'
    authorizer = Google::Auth::ServiceAccountCredentials.make_creds(
      json_key_io: File.open('./config/client_secret.json'),
      scope: scope)

    authorizer.fetch_access_token!
    drive = Drive::DriveService.new
    drive.authorization = authorizer
    folder_id="1CmMzgzy7kySuh7bDZSs9RxjLSHe0zbUa"
    metadata = {
        name: 'test.txt',
        parents: [folder_id]
    }
    metadata = drive.create_file(metadata, fields: 'id', upload_source: 'test.txt', content_type: 'text/plain')
    list_files = drive.list_files()
    list_files.files.each do |file|
        puts "#{file.name} (#{file.id})"
    end
  end
end
