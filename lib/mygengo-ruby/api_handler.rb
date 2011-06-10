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
			
			# This will be faster, but is more work for an end user to maintain. :(
			#OpenSSL::HMAC.digest(OpenSSL::Digest::Digest.new('sha1'), @opts[:private_key], params)
			HMAC::SHA1.hexdigest @opts[:private_key], params
		end

		# The "GET" method; handles requesting basic data sets from myGengo and converting
		# the response to a Ruby hash/object.
		#
		# Options:
		# <tt>endpoint</tt> - String/URL to request data from.
		# <tt>params</tt> - Data necessary for request (keys, etc). Generally taken care of by the requesting instance.
		def get_from_mygengo(endpoint, params = {})
			# The first part of the object we're going to encode and use in our request to myGengo. The signing process
			# is a little annoying at the moment, so bear with us...
			query = {}
			query["api_key"] = @opts[:public_key]
			query["data"] = params.to_json if !params.empty?
			query["ts"] = Time.now.gmtime.to_i.to_s

			query.merge!("api_sig" => signature_of(query))
			
			endpoint << '?' + query.map { |k, v| "#{k}=#{CGI::escape(v)}" }.join('&')	
			api_url = URI.parse(@api_host + endpoint);

			resp = Net::HTTP.start(api_url.host, api_url.port) do |http|
			puts api_url.request_uri
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
			data = {}

			# ...strip out job data as we need it.
			if !params[:job].nil?
				data[:job] = {:job => params[:job]}
			elsif !params[:jobs].nil?
				data[:jobs] = {:jobs => params[:jobs]}
				data[:process] = params[:process] if !params[:process].nil?
				data[:as_group] = params[:as_group] if !params[:as_group].nil?
			elsif !params[:comment].nil?
				data[:comment] = params[:comment]
			elsif !params[:update].nil?
				# Less confusing for people. ;P
				data[:update] = params[:action]
			end

			# The first part of the object we're going to encode and use in our request to myGengo. The signing process
			# is a little annoying at the moment, so bear with us...
			query = {
				"api_key" => @opts[:public_key],
				"ts" => Time.now.gmtime.to_i.to_s
			}
			query["data"] = data if !data.empty?
			query.merge!('api_sig' => signature_of(query.to_json))
			
			api_url = URI.parse(@api_host + endpoint);

			resp = Net::HTTP.start(api_url.host, api_url.port) do |http|
				req = Net::HTTP::Post.new(api_url.request_uri, {
					'Accept' => 'application/json', 
					'User-Agent' => @opts[:user_agent]
				})
				req.set_form_data query
				http.request(req)
			end
			
			json = JSON.parse(resp.body)

			if json['opstat'] != 'ok'
				raise MyGengo::Exception.new(json['opstat'], json['err']['code'].to_i, json['err']['msg'])
			end

			# Return it if there are no problems, nice...
			json
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

		# Posts a translation job over to myGengo, returns a response indicating whether the submission was
		# successful or not. Param list is quite expansive here, pay attention...
		#
		# Options:
		# <tt>job</tt> - A job is a hash of data describing what you want translated. See the examples included for
		# more information on what this should be. (type/slug/body_src/lc_src/lc_tgt/tier/auto_approve/comment/callback_url/custom_data)
		def postTranslationJob(params = {})
			self.send_to_mygengo('translate/job', params)
		end

		# Much like the above, but takes a hash titled "jobs" that is multiple jobs, each with their own unique key.
		#
		# Options:
		# <tt>jobs</tt> - "Jobs" is a hash containing further hashes; each further hash is a job. This is best seen in the example code.
		def postTranslationJobs(params = {})
			self.send_to_mygengo('translate/jobs', params)
		end

		# Updates an already submitted job.
		#
		# Options:
		# <tt>id</tt> - The ID of a job to update.
		# <tt>action</tt> - A hash describing the update to this job. See the examples for further documentation.
		def updateTranslationJob(params = {})		
			self.send_to_mygengo('translate/job/:id'.gsub(':id', params.delete(:id)), params)
		end

		# Given an ID, pulls down information concerning that job from myGengo.
		#
		# <tt>id</tt> - The ID of a job to check.
		# <tt>pre_mt</tt> - Optional, get a machine translation if the human translation is not done.
		def getTranslationJob(params = {})
			self.get_from_mygengo('translate/job/:id'.gsub(':id', params.delete(:id)), params)
		end

		# Pulls down a list of recently submitted jobs, allows some filters.
		#
		# <tt>status</tt> - Optional. "unpaid", "available", "pending", "reviewable", "approved", "rejected", or "canceled".
		# <tt>timestamp_after</tt> - Optional. Epoch timestamp from which to filter submitted jobs.
		# <tt>count</tt> - Optional. Defaults to 10.
		def getTranslationJobs(params = {})
			self.get_from_mygengo('translate/jobs', params)
		end

		# Pulls a group of jobs that were previously submitted together.
		#
		# <tt>id</tt> - Required, the ID of a job that you want the batch/group of.
		def getTranslationJobBatch(params = {})
			self.get_from_mygengo('translate/jobs/:id'.gsub(':id', params.delete(:id)), params)
		end
	
		# Mirrors the bulk Translation call, but just returns an estimated cost.
		def determineTranslationCost(params = {})
			self.send_to_mygengo('translate/service/quote', params)
		end

		# Post a comment for a translator or myGengo on a job.
		#
		# Options:
		# <tt>id</tt> - The ID of the job you're commenting on.
		# <tt>comment</tt> - The comment to put on the job.
		def postTranslationJobComment(params = {})
			self.send_to_mygengo('translate/job/:id/comment'.gsub(':id', params.delete(:id)), params)
		end

		# Get all comments (the history) from a given job.
		#
		# Options:
		# <tt>id</tt> - The ID of the job to get comments for.
		def getTranslationJobComments(params = {})
			self.get_from_mygengo('translate/job/:id/comments'.gsub(':id', params.delete(:id)), params)
		end

		# Returns the feedback you've submitted for a given job.
		#
		# Options:
		# <tt>id</tt> - The ID of the translation job you're retrieving comments from.
		def getTranslationJobFeedback(params = {})
			self.get_from_mygengo('translate/job/:id/feedback'.gsub(':id', params.delete(:id)), params)
		end

		# Gets a list of the revision resources for a job. Revisions are created each time a translator updates the text.
		#
		# Options:
		# <tt>id</tt> - The ID of the translation job you're getting revisions from.
		def getTranslationJobRevisions(params = {})
			self.get_from_mygengo('translate/job/:id/revisions'.gsub(':id', params.delete(:id)), params)
		end

		# Get a specific revision to a job.
		# 
		# Options:
		# <tt>id</tt> - The ID of the translation job you're getting revisions from.
		# <tt>rev_id</tt> - The ID of the revision you're looking up.
		def getTranslationJobRevision(params = {})
			self.get_from_mygengo('translate/job/:id/revisions/:revision_id'.gsub(':id', params.delete(:id)).gsub(':rev_id', params.delete(:rev_id)), params)
		end

		# Returns a preview image for a job.
		#
		# Options:
		# <tt>id</tt> - The ID of the job you want a preview image of.
		def getTranslationJobPreviewImage(params = {})
			self.get_from_mygengo('translate/job/:id/preview'.gsub(':id', params.delete(:id)), params)
		end

		# Deletes a job.
		#
		# Options:
		# <tt>id</tt> - The ID of the job you want to delete.
		def deleteTranslationJob(params = {})
			self.send_to_mygengo('translate/job/:id'.gsub(':id', params.delete(:id)), params)
		end

		# Gets information about currently supported language pairs.
		#
		# Options:
		# <tt>lc_src</tt> - Optional language code to filter on.
		def getServiceLanguagePairs(params = {})
			self.get_from_mygengo('translate/service/language_pairs', params)
		end

		# Pulls down currently supported languages.
		def getServiceLanguages(params = {})
			self.get_from_mygengo('translate/service/languages', params)
		end
	end

end
