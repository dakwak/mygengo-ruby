# encoding: UTF-8
require 'mygengo'

# Delete a job previously sent to myGengo and
# print out response JSON.

mygengo = MyGengo::API.new({
    :public_key => 'Kqw3@uQ=UYejce5U3u-P6s6-A}i#UELr8-g4oaA~eRSfjFu{HS@j@{4=]}rmoaOR',
    :private_key => 'WHOWYPoPn7oCoZ@wn~76V=DWLOue{8{pkNS$ym#[e3t2qY|SEN7erfJS3cqcdngv',
    :sandbox => true
})

puts mygengo.deleteTranslationJob({:id => 64462})
