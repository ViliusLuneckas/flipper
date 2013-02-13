module Flipper
  module Gates
    class Boolean < Gate
      TruthMap = {
        true    => true,
        'true'  => true,
        'TRUE'  => true,
        'True'  => true,
        't'     => true,
        'T'     => true,
        '1'     => true,
        'on'    => true,
        'ON'    => true,
        1       => true,
        1.0     => true,
        false   => false,
        'false' => false,
        'FALSE' => false,
        'False' => false,
        'f'     => false,
        'F'     => false,
        '0'     => false,
        'off'   => false,
        'OFF'   => false,
        0       => false,
        0.0     => false,
        nil     => false,
      }

      # Internal: The name of the gate. Used for instrumentation, etc.
      def name
        :boolean
      end

      # Internal: The piece of the adapter key that is unique to the gate class.
      def key
        :boolean
      end

      def enable(thing)
        adapter.write adapter_key, thing.value
        true
      end

      def disable(thing)
        feature.gates.each do |gate|
          gate.adapter.delete gate.adapter_key
        end
        true
      end

      def enabled?
        value
      end

      def value
        value = adapter.read(adapter_key)
        !!TruthMap[value]
      end

      # Internal: Checks if the gate is open for a thing.
      #
      # Returns true if gate open for thing, false if not.
      def open?(thing, value)
        instrument(:open?, thing) { |payload| value }
      end

      def protects?(thing)
        thing.is_a?(Flipper::Types::Boolean)
      end

      def description
        if enabled?
          'Enabled'
        else
          'Disabled'
        end
      end
    end
  end
end
