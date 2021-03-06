module OrigenTesters
  module Test
    class CustomTestInterface
      include OrigenTesters::ProgramGenerators

      def initialize(options = {})
        add_custom_til if tester.try(:igxl_based?)
        add_custom_tml if tester.v93k?
      end

      def custom(name, options = {})
        name = "custom_#{name}".to_sym
        if tester.try(:igxl_based?)
          ti = test_instances.mylib.test_a(name)
          ti.my_arg0 = 'arg0_set'
          ti.my_arg2_alias = 'curr'
          ti.set_my_arg4('arg4_set_from_method')

        elsif tester.v93k?
          ti = test_methods.my_tml.test_a
          ti.my_arg0 = 'arg0_set'
          ti.my_arg2_alias = 'CURR'
          ti.set_my_arg4('arg4_set_from_method')

        end
      end

      private

      def add_custom_tml
        add_tml :my_tml,
                test_a: {
                  # Parameters can be defined with an underscored symbol as the name, this can be used
                  # if the C++ implementation follows the standard V93K convention of calling the attribute
                  # the camel cased version, starting with a lower-cased letter, i.e. 'testerState' in this
                  # first example.
                  # The attribute definition has two required parameters, the type and the default value.
                  # The type can be :string, :current, :voltage, :time, :frequency, or :integer
                  # An optional 3rd parameter can be supplied to give an array of allowed values. If supplied,
                  # Origen will raise an error upon an attempt to set it to an unlisted value.
                  tester_state: [:string, 'CONNECTED', %w(CONNECTED UNCHANGED)],
                  test_name: [:string, 'Functional'],
                  my_arg0: [:string, ''],
                  my_arg1: [:string, 'a_default_value'],
                  my_arg2: [:string, 'VOLT', %w(VOLT CURR)],
                  my_arg3: [:string, ''],
                  my_arg4: [:string, ''],
                  # In cases where the C++ library has deviated from standard attribute naming conventions
                  # (camel-cased with lower cased first character), the absolute attribute name can be given
                  # as a string.
                  # The Ruby/Origen accessor for these will be the underscored version, with '.' characters
                  # converted to underscores, e.g. tm.bad_practice, tm.really_bad_practice, etc.
                  'BadPractice' => [:string, 'NO', %w(NO YES)],
                  'Really.BadPractice' => [:string, ''],
                  # Attribute aliases can be defined like this:
                  aliases: {
                    my_arg2_alias: :my_arg2
                  },
                  # Define any methods you want the test method to have
                  methods: {
                    # An optional finalize function can be supplied to do any final test instance configuration, this
                    # function will be called immediately before the test method is finally rendered. The test method
                    # object itself will be passed in as an argument.
                    finalize:    lambda  do |tm|
                      tm.my_arg3 = 'arg3_set_from_finalize'
                    end,
                    # Example of a custom method.
                    # In all cases the test method object will be passed in as the first argument.
                    set_my_arg4: lambda  do |tm, val|
                      tm.my_arg4 = val
                    end
                  }
                }
      end

      def add_custom_til
        add_til :mylib,
                test_a: {
                  # Basic arg
                  my_arg0: :arg0,
                  # Basic arg with default value
                  my_arg1: [:arg1, 'a_default_value'],
                  # Basic arg with default value and possible values
                  my_arg2: [:arg2, 'volt', %w(volt curr)],
                  my_arg3: :arg3,
                  my_arg4: :arg4,
                  # Attribute aliases can be defined like this:
                  aliases: {
                    my_arg_alias:  :my_arg,
                    my_arg1_alias: :my_arg1,
                    my_arg2_alias: :my_arg2
                  },
                  # Define any methods you want the test method to have
                  methods: {
                    # An optional finalize function can be supplied to do any final test instance configuration, this
                    # function will be called immediately before the test instance is finally rendered. The test instance
                    # object itself will be passed in as an argument.
                    finalize:    lambda  do |ti|
                      ti.my_arg3 = 'arg3_set_from_finalize'
                    end,
                    # Example of a custom method.
                    # In all cases the test method object will be passed in as the first argument.
                    set_my_arg4: lambda  do |ti, val|
                      ti.my_arg4 = val
                    end
                  }
                }
      end
    end
  end
end
