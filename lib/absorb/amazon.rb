module Amazon

  def self.startup
    return if @started_up

    start_aws_from Absorb.settings
    start_dynamodb_from Absorb.settings

    @started_up = true
  end

  def self.start_aws_from settings
    AWS.config(access_key_id:       settings[:access_key_id],
               secret_access_key:   settings[:secret_access_key],
               dynamo_db_endpoint:  settings[:dynamo_db_endpoint])
  end

  def self.start_dynamodb_from settings
    Dynamoid.configure do |config|
      config.adapter        = 'aws_sdk'
      config.namespace      = settings[:dynamodb_upload]
      config.warn_on_scan   = true
      config.partitioning   = true
      config.partition_size = 200
      config.read_capacity  = 100
      config.write_capacity = 20
    end
  end

end
