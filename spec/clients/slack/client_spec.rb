describe Slack::Client do
  describe '#get_user_info' do
    it 'performs request and narrows the response' do
      stub_env('SLACK_APP_ACCESS_TOKEN', '123')
      stub_request(
        :get,
        'https://slack.com/api/users.info?token=123&user=ABC'
      ).with(
        headers: {
          'Content-Type' => 'application/x-www-form-urlencoded, charset=utf-8'
        }
      ).to_return(
        status: 200,
        body: '{ "user": { "id": "ABC", "email": "user@info.net" } }'
      )

      response = Slack::Client.new.get_user_info('ABC')

      expect(response).to eq(
        id: 'ABC',
        email: 'user@info.net'
      )
    end
  end

  describe '#send_dialog_open_request' do
    it 'performs request' do
      stub_env('SLACK_APP_ACCESS_TOKEN', '123')
      stub_request(
        :get,
        'https://slack.com/api/dialog.open?token=123&trigger_id=XYZ&dialog='\
          '{"foo":"bar","baz":"xyz"}'
      ).with(
        headers: {
          'Content-Type' => 'application/x-www-form-urlencoded, charset=utf-8'
        }
      ).to_return(
        status: 200,
        body: '{ "ok": true }'
      )

      response = Slack::Client.new.send_dialog_open_request('XYZ', foo: 'bar', baz: 'xyz')

      expect(response).to eq(
        ok: true
      )
    end
  end
end
