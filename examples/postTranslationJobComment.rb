# encoding: UTF-8
require 'mygengo'

mygengo = MyGengo::API.new({
	:public_key => 'your_public_key',
	:private_key => 'your_private_key',
	:sandbox => true,
})

# Posts a comment to job #42.
puts mygengo.postTranslationJob({:id => 42, :comment => {
	:body => "I love lamp!"
})
