# encoding: UTF-8
require 'mygengo'

mygengo = MyGengo::API.new({
	:public_key => 'x4n7^jxvy)Pgp17hX5p[2x76A(0Yhk{76Lz2)bJ]8s5X)ShtW2hXyRZ^(#9}SKLh',
	:private_key => 'JimAgf8tkM^I}_|{jue5umYeqN$HHmL0LtXpZt8)aGf7itvzF2^zDtHgR_0MG754',
	:sandbox => true,
})

#mygengo = MyGengo::API.new({
#	:public_key => 'x4n7^jxvy)Pgp17hX5p[2x76A(0Yhk{76Lz2)bJ]8s5X)ShtW2hXyRZ^(#9}SKLh',
#	:private_key => '',
#	:sandbox => true,
#})

# Return the number of credits left on your account.
puts mygengo.getAccountBalance()
