describe Slack::Wrapper do
  describe '.user_id_to_email' do
    it 'returns user email' do
      client    = instance_double('Slack::Client')
      user_data = { profile: { email: 'jane@doe.com' } }

      allow(Slack::Client).to receive(:new).and_return(client)
      allow(client).to receive(:get_user_info).with('123ABC').and_return(user_data)

      expect(Slack::Wrapper.user_id_to_email('123ABC')).to eq 'jane@doe.com'
    end
  end

  describe '.open_dialog' do
    it 'calls client send_dialog_open_request method' do
      client = instance_double('Slack::Client')
      dialog = {
        title: 'Foo',
        submit_label: 'Submit',
        elements: [
          {
            type: 'text'
          }
        ]
      }

      allow(Slack::Client).to receive(:new).and_return(client)
      allow(client).to receive(:send_dialog_open_request)

      Slack::Wrapper.open_dialog('f4c-8e1', dialog)

      expect(client).to have_received(:send_dialog_open_request).once.with(
        'f4c-8e1',
        hash_including(
          title: 'Foo',
          submit_label: 'Submit',
          elements: [
            include(
              type: 'text'
            )
          ]
        )
      )
    end
  end
end
