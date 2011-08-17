# encoding: UTF-8
require 'mygengo'

mygengo = MyGengo::API.new({
	:public_key => 'your_public_key',
	:private_key => 'your_private_key',
	:sandbox => true,
})

# Think of this as a "search my jobs" method and it
# becomes very self explanatory.
puts mygengo.getTranslationJobs({:status => "unpaid", :count => 15})
