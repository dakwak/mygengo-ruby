myGengo Ruby Library (for the [myGengo API](http://mygengo.com/))
========================================================================================================
Translating your tools and products helps people all over the world access them; this is, of course, a
somewhat tricky problem to solve. **[myGengo](http://mygengo.com/)** is a service that offers human-translation
(which is often a higher quality than machine translation), and an API to manage sending in work and watching
jobs. This is a ruby interface to make using the API simpler (some would say incredibly easy). 


Installation & Requirements
-------------------------------------------------------------------------------------------------------
Installing myGengo is fairly simple:

    gem install mygengo


Tests - Running Them, etc
------------------------------------------------------------------------------------------------------
myGengo has a full suite of tests, however they're not currently automated. Each script in the _examples_
directory tests a different myGengo API endpoint; run against those if you wish to test for now.

Question, Comments, Complaints, Praise?
------------------------------------------------------------------------------------------------------
If you have questions or comments and would like to reach us directly, please feel free to do
so at the following outlets. We love hearing from developers!

Email: api [at] mygengo dot com  
Twitter: **[@mygengo_dev](http://twitter.com/mygengo_dev)**  

If you come across any issues, please file them on the **[Github project issue tracker](https://github.com/myGengo/mygengo-ruby/issues)**. Thanks!


Documentation
------------------------------------------------------------------------------------------------------
The usage of the API is very simple - the most important part is getting authenticated. To do this is just
a few lines of code:

``` ruby
require 'mygengo'

mygengo = MyGengo::API.new({
	:public_key => 'your_public_key',
	:private_key => 'your_private_key',
	:sandbox => true, # Or false, depending on your work
})

# Get some information
puts mygengo.getAccountBalance()
```

With that, you can call any number of methods supported by this library. The entire library is rdoc supported,
so you can look at more method information there - there's also a full suite of test code/examples, located in the 'examples'
directory. Good luck!
