module MyGengo
	# Base Exception class and such.
	class MyGengo::Exception < ::StandardError
		attr_accessor :opstat, :code, :msg

		# Pretty self explanatory stuff here...
		def initialize(opstat, code, msg)
			@opstat = opstat
			@code = code
			@msg = msg

			puts msg
		end
	end
end
