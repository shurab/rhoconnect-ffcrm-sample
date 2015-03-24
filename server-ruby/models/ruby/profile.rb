require_relative "helper"

class Profile < Rhoconnect::Model::Base
  include Helper

  def initialize(source)
    @base =  "http://rho-fat-free.herokuapp.com"
    # @base =  "http://localhost:3000"
    super(source)
  end

  def login
    # TODO: Login to your data source here if necessary
  end

  def query(params=nil)
    # Get cookies for current user
    cookies(current_user.login)

    rest_result = RestClient.get("#{@base}/profile.json", {:cookies => @cookies}).body
    if rest_result.code != 200
      raise Rhoconnect::Model::Exception.new("Error connecting to fat_free_crm server!")
    end
    parsed = JSON.parse(rest_result)
    user = parsed['user']
    @result = {}
    @result[user['id'].to_s] = user
    # puts @result

    # TODO: Query your backend data source and assign the records
    # to a nested hash structure called @result. For example:
    # @result = {
    #   "1"=>{"name"=>"Acme", "industry"=>"Electronics"},
    #   "2"=>{"name"=>"Best", "industry"=>"Software"}
    # }
    # raise Rhoconnect::Model::Exception.new("Please provide some code to read records from the backend data source")
  end

  def create(create_hash)
    # TODO: Create a new record in your backend data source
    raise "Please provide some code to create a single record in the backend data source using the create_hash"
  end

  def update(update_hash)
    # Get cookies for current user
    cookies(current_user.login)

    obj_id = update_hash['id']
    update_hash.delete('id')
    rest_result = RestClient.put("#{@base}/users/#{obj_id}", { :user => update_hash }, { :cookies => @cookies })
    puts rest_result.code # => 204
  end

  def delete(delete_hash)
    # TODO: write some code here if applicable
    # be sure to have a hash key and value for "object"
    # for now, we'll say that its OK to not have a delete operation
    # raise "Please provide some code to delete a single object in the backend application using the object_id"
  end

  def logoff
    # TODO: Logout from the data source if necessary
  end

  # Calling super here returns rack tempfile path:
  # i.e. /var/folders/J4/J4wGJ-r6H7S313GEZ-Xx5E+++TI
  # Note: This tempfile is removed when server stops or crashes...
  # See http://rack.rubyforge.org/doc/Multipart.html for more info
  #
  # Uncomment this code and override it by creating a copy of the file somewhere
  # and returning the path to that file (then don't call super!):
  # i.e. /mnt/myimages/soccer.png
  #def store_blob(object,field_name,blob)
  #  super #=> returns blob[:tempfile]
  #end
end