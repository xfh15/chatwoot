# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Channel::WebWidget do
  context 'when web widget channel' do
    let!(:channel_widget) { create(:channel_widget) }

    it 'pre chat options' do
      expect(channel_widget.pre_chat_form_options['pre_chat_message']).to eq 'Share your queries or comments here.'
      expect(channel_widget.pre_chat_form_options['pre_chat_fields'].length).to eq 3
    end

    it 'builds a public chat url from FRONTEND_URL' do
      ClimateControl.modify FRONTEND_URL: 'https://chatbot.z-soft.jp/' do
        expect(channel_widget.public_chat_url).to eq("https://chatbot.z-soft.jp/widget?website_token=#{channel_widget.website_token}")
      end
    end
  end
end
