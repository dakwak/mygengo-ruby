# encoding: UTF-8
require 'mygengo'

# Updates a job with a given set of actions
# and relevant data.

mygengo = MyGengo::API.new({
	:public_key => 'your_public_key',
	:private_key => 'your_private_key',
	:sandbox => true,
})

# Reject all the following jobs.
mygengo.updateTranslationJob({
	:jobs => [42, 43, 44, 45],
	:action => "reject",
	:reason => "quality",
	:comment => "My Grandmother does better.",
	:captcha => "bert"
})
