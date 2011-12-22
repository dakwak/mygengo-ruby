# encoding: UTF-8
require 'mygengo'

# Delete a job previously sent to myGengo and
# print out response JSON.

mygengo = MyGengo::API.new({
    :public_key => '',
    :private_key => '',
    :sandbox => true
})

puts mygengo.deleteTranslationJob({:id => 64462})
