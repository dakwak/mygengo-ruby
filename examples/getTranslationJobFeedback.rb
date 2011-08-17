# encoding: UTF-8
require 'mygengo'

# Get all feedback on a job.

mygengo = MyGengo::API.new({
	:public_key => 'your_public_key',
	:private_key => 'your_private_key',
	:sandbox => true,
})

puts mygengo.getTranslationJobFeedback({:id => 42})
