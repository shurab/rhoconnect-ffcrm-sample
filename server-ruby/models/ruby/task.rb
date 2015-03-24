require_relative "helper"

class Task < Rhoconnect::Model::Base
  include Helper

  def initialize(source)
    @base =  "http://rho-fat-free.herokuapp.com/tasks"
    #@base =  "http://localhost:3000/tasks"
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

    # Tasks grouped by due time:
    # { "overdue" =>  ["task" => {...}, ..., "task" => {...}],
    #   "due_asap"=>  [...],
    #   "due_today"=> [...],
    #   "due_tomorrow"=> [...],
    #   "due_this_week"=>[...],
    #   "due_next_week"=>[...],
    #   "due_later"=>  [...] }
    @result = {}
    parsed.each do |due, tasks|
      tasks.each do |item|
        @result[item["task"]["id"].to_s] = item["task"] if item["task"]
      end
    end if parsed
  end

  def create(create_hash)
    # Get cookies for current user
    cookies(current_user.login)

    res = RestClient.post(@base,
      {:contact => create_hash}, {:cookies => @cookies})
    # After create we are redirected to the new record.
    # We need to get the id of that record and return it as part of create so rhoconnect can establish a link
    # from its temporary object on the client to this newly created object on the server
    JSON.parse(RestClient.get("#{res.headers[:location]}.json", {:cookies => @cookies}).body)["task"]["id"]
  end

  def update(update_hash)
    # Get cookies for current user
    cookies(current_user.login)

    obj_id = update_hash['id']
    update_hash.delete('id')
    RestClient.put("#{@base}/#{obj_id}",
      {:contact => update_hash}, {:cookies => @cookies})
  end

  def delete(delete_hash)
    # Get cookies for current user
    cookies(current_user.login)

    RestClient.delete("#{@base}/#{delete_hash['id']}", {:cookies => @cookies})
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