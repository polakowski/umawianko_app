describe 'wrapper' do
  describe 'forwarding class methods to instance' do
    context 'calling forwarded method' do
      it 'calls instance method' do
        define_const 'DummyClient' do
          def request(*)
          end
        end

        define_const 'DummyWrapper', parent: ApplicationWrapper do
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
        define_const 'DummyClient' do
          def request(*)
          end
        end

        define_const 'DummyWrapper', parent: ApplicationWrapper do
          client_class DummyClient

          forward :the_method

          def the_method(*)
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

def define_const(name, parent: nil, &block)
  if parent.nil?
    stub_const(name, Class.new(&block))
  else
    stub_const(name, Class.new(parent, &block))
  end
end
