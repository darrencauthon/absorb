module Amazon

  def self.startup
    return if @started_up
    AWS.config(access_key_id:       Absorb.settings[:access_key_id],
               secret_access_key:   Absorb.settings[:secret_access_key],
               dynamo_db_endpoint: 'dynamodb.us-east-1.amazonaws.com')
    @started_up = true
  end

end
