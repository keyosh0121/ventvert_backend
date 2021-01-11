# frozen_string_literal: true
require 'net/http'
require 'uri'
require 'json'
require 'logger'

class Report < ApplicationRecord
  belongs_to :user

  def create_github_issue

    file = File.open("#{Rails.root}/log/github_send_issue.log", File::WRONLY | File::APPEND | File::CREAT)
    logger = Logger.new(file)
    uri = URI.parse("https://api.github.com/repos/keyosh0121/ventvert_backend/issues")
    
    title = "【#{self.category}】#{self.title}"
    content = self.content
    token = Rails.application.credentials.github[:access_token]
    headers = {Authorization: "token #{token}"}
    
    data = {title: title, body: content}
    
    begin
      
      https = Net::HTTP.new(uri.host,uri.port)
      https.use_ssl = true
      https.read_timeout = 10

      ## Send Create(POST) Issue request to Github
      req = Net::HTTP::Post.new(uri.path, headers)
      req.body = data.to_json

      res = https.request(req)
      puts res.body

      case res
      when Net::HTTPSuccess
        logger.info(JSON.parse(res.body))
      else
        logger.error("HTTP ERROR: code: #{res.code} message: #{res.message}")
      end
        
    rescue IOError => e
      logger.error(e.message)
    rescue Timeout::Error => e
      logger.error(e.message)
    rescue JSON::ParserError => e
      logger.error(e.message)
    rescue => e
      logger.error(e.message)
    end

  end
end
