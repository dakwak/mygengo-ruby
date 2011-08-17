# encoding: UTF-8
require 'mygengo'

# Returns all revisions on a job.

mygengo = MyGengo::API.new({
	:public_key => 'your_public_key',
	:private_key => 'your_private_key',
	:sandbox => true,
})

puts mygengo.getTranslationJobRevisions({:id => 42})
