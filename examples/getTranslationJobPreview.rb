# encoding: UTF-8
require 'mygengo'

# Returns an image preview of the job
# in question (.gif).

mygengo = MyGengo::API.new({
	:public_key => 'your_public_key',
	:private_key => 'your_private_key',
	:sandbox => true,
})

puts mygengo.getTranslationJobPreview({:id => 42})
