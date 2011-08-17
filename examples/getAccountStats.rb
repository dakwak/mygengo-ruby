# encoding: UTF-8
require 'mygengo'

mygengo = MyGengo::API.new({
	:public_key => 'your_public_key',
	:private_key => 'your_private_key',
	:sandbox => true,
})

# Return some statistics about your account.
puts mygengo.getAccountStats()
