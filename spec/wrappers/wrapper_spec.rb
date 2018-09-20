describe 'wrapper' do
  describe 'forwarding class methods to instance' do
    context 'calling forwarded method' do
      it 'calls instance method' do
        stub_class 'DummyClient' do
          def request(*)
          end
        end

        stub_class 'DummyWrapper', parent: ApplicationWrapper do
          client_class DummyClient

          forward :the_method

          def the_method(parameter, foo: 0)
            client.request(foo * 3, parameter * 2)
          end
        end

        client_instance = instance_double('DummyClient')

        allow(DummyClient).to receive(:new).and_return(client_instance)
        allow(client_instance).to receive(:request)

        DummyWrapper.the_method(3, foo: 8)

        expect(client_instance).to have_received(:request).with(24, 6)
      end
    end

    context 'calling not-forwarded method' do
      it 'raises error' do
        stub_class 'DummyClient' do
          def request(*)
          end
        end

        stub_class 'DummyWrapper', parent: ApplicationWrapper do
          client_class DummyClient

          forward :the_method

          def the_method(*)
          end

          def not_a_good_method
          end
        end

        client_instance = instance_double('DummyClient')
        allow(DummyClient).to receive(:new).and_return(client_instance)

        DummyWrapper.the_method(3, foo: 8)

        expect {
          DummyWrapper.not_a_good_method(90)
        }.to raise_error(
          NoMethodError, 'undefined method `not_a_good_method\' for DummyWrapper:Class'
        )
      end
    end
  end
end
