# encoding: UTF-8
require 'mygengo'

mygengo = MyGengo::API.new({
	:public_key => '',
	:private_key => '',
	:sandbox => true,
})

# Return the number of credits left on your account.
puts mygengo.getAccountBalance()
