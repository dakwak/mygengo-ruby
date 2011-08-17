# encoding: UTF-8
require 'mygengo'

# Updates a job with a given set of actions
# and relevant data.

mygengo = MyGengo::API.new({
	:public_key => 'your_public_key',
	:private_key => 'your_private_key',
	:sandbox => true,
})

mygengo.updateTranslationJob({:id => 42, :action => {
	:action => "reject",
	:reason => "quality",
	:comment => "My Grandmother does better.",
	:captcha => "bert"
})
