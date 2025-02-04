require "httparty"
require "dotenv"
require "awesome_print"

Dotenv.load

require_relative "recipient"

module Slack
  class Channel < Recipient
    attr_reader :topic, :member_count

    def initialize(name:, slack_id:, topic:, member_count:)
      super(name: name, slack_id: slack_id)
      @topic = topic
      @member_count = member_count
    end

    def self.list
      url = "https://slack.com/api/channels.list"
      query_parameters = {
        token: ENV["SLACK_TOKEN"],
      }
      response = Channel.get(url, query: query_parameters)
      channels_array = []

      response["channels"].each do |channel|
        channel_hash = { "name" => channel["name"], "slack id" => channel["id"], "topic" => channel["topic"]["value"], "member count" => channel["members"].length }
        channels_array << channel_hash
      end
      return channels_array
    end

    def details
      return "\nname: #{name}, slack_id: #{slack_id}, topic: #{topic}, member count: #{member_count}"
    end
  end
end
