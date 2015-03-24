require_relative "helper"

class Contact < Rhoconnect::Model::Base
  include Helper

  def initialize(source)
    @base =  "http://rho-fat-free.herokuapp.com/contacts"
    #@base =  "http://localhost:3000/contacts"
    super(source)
  end

  def login
    # TODO: Login to your data source here if necessary
  end

  def query(params=nil)
    # Get cookies for current user
    cookies(current_user.login)

    rest_result = RestClient.get("#{@base}.json", {:cookies => @cookies}).body
    if rest_result.code != 200
      raise Rhoconnect::Model::Exception.new("Error connecting to fat_free_crm server!")
    end
    parsed = JSON.parse(rest_result)

    @result={}
    parsed.each do |item|
      @result[item["contact"]["id"].to_s] = item["contact"]
    end if parsed

    # TODO: Query your backend data source and assign the records
    # to a nested hash structure called @result. For example:
    # @result = {
    #   "1"=>{"name"=>"Acme", "industry"=>"Electronics"},
    #   "2"=>{"name"=>"Best", "industry"=>"Software"}
    # }
    # raise Rhoconnect::Model::Exception.new("Please provide some code to read records from the backend data source")
  end

  def create(create_hash)
    # Get cookies for current user
    cookies(current_user.login)

    #TODO: Handle properly account for new contact (now is nil)
    res = RestClient.post(@base,
      {:contact => create_hash, :account => { :id => "", :name => ""}}, {:cookies => @cookies})
    # After create we are redirected to the new record.
    # We need to get the id of that record and return it as part of create so rhoconnect can establish a link
    # from its temporary object on the client to this newly created object on the server
    JSON.parse(RestClient.get("#{res.headers[:location]}.json", {:cookies => @cookies}).body)["contact"]["id"]

    # # TODO: Create a new record in your backend data source
    # raise "Please provide some code to create a single record in the backend data source using the create_hash"
  end

  def update(update_hash)
    # Get cookies for current user
    cookies(current_user.login)

    obj_id = update_hash['id']
    update_hash.delete('id')
    # TODO: get/set properly account for updated contact (now is nil)
    RestClient.put("#{@base}/#{obj_id}",
      {:contact => update_hash, :account => { :id => "", :name => ""}}, {:cookies => @cookies})

    # TODO: Update an existing record in your backend data source
    # raise "Please provide some code to update a single record in the backend data source using the update_hash"
  end

  def delete(delete_hash)
    # Get cookies for current user
    cookies(current_user.login)

    RestClient.delete("#{@base}/#{delete_hash['id']}", {:cookies => @cookies})
    # TODO: write some code here if applicable
    # be sure to have a hash key and value for "object"
    # for now, we'll say that its OK to not have a delete operation
    # raise "Please provide some code to delete a single object in the backend application using the object_id"
  end

  def logoff
    # TODO: Logout from the data source if necessary
  end

  def store_blob(object,field_name,blob)
    # TODO: Handle post requests for blobs here.
    # make sure you store the blob object somewhere permanently
    raise "Please provide some code to handle blobs if you are using them."
  end
end