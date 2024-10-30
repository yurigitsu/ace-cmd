# frozen_string_literal: true

# NOTE: helper names follow convention 'support_<module_name>_<helper_name>'

module Dummy
  def support_dummy_calle(name)
    stub_const(name, Class.new do
      include AceCallee

      def call(rez)
        rez
      end
    end)
  end

  def support_dummy_base_command(name)
    stub_const(name, Class.new do
      include AceCommand

      command do
        fail_fast "Base Fail Fast Message"
      end
    end)
  end

  def support_dummy_error(name)
    stub_const(name, Class.new(StandardError))
  end
end
