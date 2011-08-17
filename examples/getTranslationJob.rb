# encoding: UTF-8
require 'mygengo'

# Get a previously submitted job.

mygengo = MyGengo::API.new({
	:public_key => 'your_public_key',
	:private_key => 'your_private_key',
	:sandbox => true,
})

puts mygengo.getTranslationJob({:id => 42})
