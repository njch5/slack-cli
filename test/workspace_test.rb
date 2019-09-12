require_relative "test_helper"

describe "User.list method" do
  before do
    VCR.use_cassette("users_list") do
      @user_array = Slack::User.list
      @workspace = Slack::Workspace.new
    end
  end

  it "users is list of type User" do
    expect(@workspace.users.all? { |user| user.is_a?(Slack::User) }).must_equal true
  end

  it "will select a user by name" do
    @workspace.select_user("slackbot")
    expect(@workspace.selected.is_a?(Slack::User)).must_equal true
  end

  it "will select a user by slack_id" do
    @workspace.select_user("USLACKBOT")
    expect(@workspace.selected.is_a?(Slack::User)).must_equal true
  end
end

describe "Channel.list method" do
  before do
    VCR.use_cassette("channels_list") do
      @channel_array = Slack::Channel.list
      @workspace = Slack::Workspace.new
    end
  end

  it "channels is a list of type Channel" do
    expect(@workspace.channels.all? { |channel| channel.is_a?(Slack::Channel) }).must_equal true
  end

  it "will select a channel by name" do
    @workspace.select_channel("fuzzy_bunnies")
    expect(@workspace.selected.is_a?(Slack::Channel)).must_equal true
  end

  it "will select a channel by slack_id" do
    @workspace.select_channel("CN759T0MA")
    expect(@workspace.selected.is_a?(Slack::Channel)).must_equal true
  end
end

describe "show_details method" do
  before do
    VCR.use_cassette("channels_list") do
      @channel_array = Slack::Channel.list
      @workspace = Slack::Workspace.new
    end
  end

  it "returns the selected channel's details" do
    # p @workspace.select_channel("fuzzy_bunnies").inspect
    @workspace.select_channel("fuzzy_bunnies")
    expect(@workspace.show_details).must_be_kind_of String
  end

  it "returns the selected user's details" do
    @workspace.select_user("idhallie")
    expect(@workspace.show_details).must_be_kind_of String
  end
end

describe "send_message method" do
  it "sends a message to the chosen channel" do
    VCR.use_cassette("channels_list") do
      @channel_array = Slack::Channel.list
      @workspace = Slack::Workspace.new
      body = {
        token: ENV["SLACK_TOKEN"],
        channel: "fuzzy_bunnies",
        text: "hello from the other side",
      }

      @response = HTTParty.post(MESSAGE_URL, body: body)
    end

    expect(@response).must_be_kind_of HTTParty::Response
  end

  it "sends a message to the chosen user" do
    VCR.use_cassette("users_list") do
      @user_array = Slack::User.list
      @workspace = Slack::Workspace.new
      body = {
        token: ENV["SLACK_TOKEN"],
        channel: "UN69TR3N1",
        text: "hello from the other side",
      }

      @response = HTTParty.post(MESSAGE_URL, body: body)
    end

    expect(@response).must_be_kind_of HTTParty::Response
  end

  it "returns the selected channel" do
    VCR.use_cassette("message_post") do
      body = {
        token: ENV["SLACK_TOKEN"],
        channel: "apis",
        text: "hello from the other side",
      }
      @workspace = Slack::Workspace.new
      @selected_channel = @workspace.select_channel("apis")
      response = @workspace.send_message("APIs! Amiright?")

      expect(response["ok"]).must_equal true
    end

    expect(@response).must_equal true
  end
end
