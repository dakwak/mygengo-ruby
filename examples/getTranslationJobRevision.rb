# encoding: UTF-8
require 'mygengo'

# Returns a revision specified by number.

mygengo = MyGengo::API.new({
	:public_key => 'your_public_key',
	:private_key => 'your_private_key',
	:sandbox => true,
})

puts mygengo.getTranslationJobRevision({:id => 42, :rev_id => 1})
