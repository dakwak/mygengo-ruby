# encoding: UTF-8
require 'mygengo'

# Post a single job over to myGengo and print out the
# response JSON.

mygengo = MyGengo::API.new({
	:public_key => 'your_public_key',
	:private_key => 'your_private_key',
	:sandbox => true,
})

puts mygengo.postTranslationJob({
	:job => {
		:type => "text",
		:slug => "Hallo",
		:body_src => "Hallo zusammen",
		:lc_src => "de",
		:lc_tgt => "en",
		:tier => "standard"
	}
})
