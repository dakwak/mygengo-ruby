require 'rake'

Gem::Specification.new do |gs|
	gs.name = "mygengo-ruby"
	gs.version = "1.1"
	gs.authors = [
		"Ryan McGrath <ryan@mygengo.com>",
		"Matthew Romaine <matt@mygengo.com>",
		"Kim Ahlstrom",
	]
	gs.date = "2011-05-10"
	gs.summary = "A library for interfacing with the myGengo API."
	gs.description = "myGengo is a service that offers various translation API, both machine and high quality human-sourced translation based. ruby-mygengo lets you interface with the myGengo REST API (http://mygengo.com/services/api/dev-docs/)."
	gs.email = "ryan@mygengo.com"
	gs.homepage = "http://mygengo.com/services/api/dev-docs/"
	gs.files = FileList['lib/**/*.rb', 'licenses/*', 'bin/*', '[A-Z]*', 'test/**/*'].to_a
	gs.has_rdoc = true
end
