# Encoding: UTF-8

require 'rubygems'
require 'net/http'
require 'uri'
require 'cgi'
require 'json'
require 'hmac-sha1'
require 'time'
require 'pp'

module MyGengo
	
	# The only real class that ever needs to be instantiated.
	class API
		attr_accessor :api_host
		attr_accessor :debug
		attr_accessor :client_info

		# Creates a new API handler to shuttle calls/jobs/etc over to the myGengo translation API.
		#
		# Options:
		# <tt>opts</tt> - A hash containing the api key, the api secret key, the API version (defaults to 1), whether to use
		# the sandbox API, and an optional custom user agent to send.
		def initialize(opts)
			# Consider this an example of the object you need to pass.
			@opts = {
				:public_key => '',
				:private_key => '',
				:api_version => '1',
				:sandbox => false,
				:user_agent => "myGengo Ruby Library v#{MyGengo::Config::VERSION}",
				:debug => false,
			}.merge(opts)

			# Let's go ahead and separate these out, for clarity...
			@debug = @opts[:debug]
			@api_host = (@opts[:sandbox] == true ? MyGengo::Config::SANDBOX_API_HOST : MyGengo::Config::API_HOST) + "v#{@opts[:api_version]}/"

			# More of a public "check this" kind of object.
			@client_info = {"VERSION" => MyGengo::Config::VERSION}
		end

		# Creates an HMAC::SHA1 signature, signing the request with the private key.
		def signature_of(params)
			if Hash === params
				sorted_keys = params.keys.sort
				params = sorted_keys.zip(params.values_at(*sorted_keys)).map do |k, v|
					"#{k}=#{CGI::escape(v)}"
				end * '&'
			end

			HMAC::SHA1.hexdigest @opts[:private_key], params
		end

		# The "GET" method; handles requesting basic data sets from myGengo and converting
		# the response to a Ruby hash/object.
		#
		# Options:
		# <tt>endpoint</tt> - String/URL to request data from.
		# <tt>params</tt> - Data necessary for request (keys, etc). Generally taken care of by the requesting instance.
		def get_from_mygengo(endpoint, params = nil)
			# The first part of the object we're going to encode and use in our request to myGengo. The signing process
			# is a little annoying at the moment, so bear with us...
			#
			# This Hash[] syntax is hilariously odd, yes, but it's actually the quickest way to do a key-sorted hash pre-Ruby1.9.
			# We'd like to TRY and be 1.8 compatible if possible, as there are still a great many 1.8 installations out there. :)
			query = {
				"api_key" => @opts[:public_key],
				"ts" => Time.now.gmtime.to_i.to_s
			}
			
			if !params.nil? 
				query["data"] = params.to_json
			end
			
			query.merge!('api_sig' => signature_of(query))
			
			endpoint << '?' + query.map { |k, v| "#{k}=#{CGI::escape(v)}" }.join('&')	
			api_url = URI.parse(@api_host + endpoint);

			resp = Net::HTTP.start(api_url.host, api_url.port) do |http|
				http.request(Net::HTTP::Get.new(api_url.request_uri, {
					'Accept' => 'application/json', 
					'User-Agent' => @opts[:user_agent]
				}))
			end
			
			json = JSON.parse(resp.body)

			if json['opstat'] != 'ok'
				raise MyGengo::Exception.new(json['opstat'], json['err']['code'].to_i, json['err']['msg'])
			end

			# Return it if there are no problems, nice...
			json
		end

		# The "POST" method; handles shuttling up encoded job data to myGengo
		# for translation and such. Somewhat similar to the above methods, but depending on the scenario
		# can get some strange exceptions, so we're gonna keep them fairly separate for the time being. Consider
		# for a merger down the road...
		#
		# Options:
		# <tt>endpoint</tt> - String/URL to post data to.
		# <tt>params</tt> - Data necessary for request (keys, etc). Generally taken care of by the requesting instance.
		def send_to_mygengo(endpoint, params = {})
		end

		# Returns a Ruby-hash of the stats for the current account. No arguments required!
		#
		# Options:
		# <tt>None</tt> - N/A
		def getAccountStats(params = {})
			self.get_from_mygengo('account/stats', params)
		end

		# Returns a Ruby-hash of the balance for the authenticated account. No args required!
		#
		# Options:
		# <tt>None</tt> - N/A
		def getAccountBalance(params = {})
			self.get_from_mygengo('account/balance', params)
		end
	end

end
