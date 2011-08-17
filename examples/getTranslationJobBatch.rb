# encoding: UTF-8
require 'mygengo'

# Get a group of jobs previously submitted, given
# one job ID.

mygengo = MyGengo::API.new({
	:public_key => 'your_public_key',
	:private_key => 'your_private_key',
	:sandbox => true,
})

puts mygengo.getTranslationJobBatch({:id => 42})
