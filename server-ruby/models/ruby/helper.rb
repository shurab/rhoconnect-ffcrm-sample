module Helper
  # Read for current 'user' cookies stored in redis and return them as a hash
  # { 'user_credentials' => '...', '_session_id' => '...' }
  def cookies(user)
    @cookies = {}
    @cookies['user_credentials'] = Store.get_value("user:#{current_user.login}:user_credentials")
    @cookies['_session_id'] = Store.get_value("user:#{current_user.login}:_session_id")
  end

end