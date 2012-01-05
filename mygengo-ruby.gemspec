require 'rake'

Gem::Specification.new do |gs|
	gs.name = "mygengo"
	gs.version = "1.7"
	gs.authors = [
		"Ryan McGrath <ryan@mygengo.com>",
		"Matthew Romaine",
		"Kim Alhstrom",
		"Lloyd Chan"
    ]
	gs.date = "2012-01-05"
	gs.summary = "A library for interfacing with the myGengo Translation API."
	gs.description = "myGengo is a service that offers various translation APIs, both machine and high quality human-sourced. The mygengo gem lets you interface with the myGengo REST API (http://mygengo.com/services/api/dev-docs/)."
	gs.email = "ryan@mygengo.com"
	gs.homepage = "http://mygengo.com/services/api/dev-docs/"
	gs.files = FileList['lib/**/*.rb', 'licenses/*', 'bin/*', '[A-Z]*', 'test/**/*'].to_a
	gs.has_rdoc = true
end
