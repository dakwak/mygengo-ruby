# encoding: UTF-8
require 'mygengo'

# Delete a job previously sent to myGengo and
# print out response JSON.

mygengo = MyGengo::API.new({
	:public_key => 'your_public_key',
	:private_key => 'your_private_key',
	:sandbox => true,
})

puts mygengo.deleteTranslationJob({:id => 42})
