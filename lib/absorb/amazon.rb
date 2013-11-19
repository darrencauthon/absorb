module Amazon

  def self.startup
    return if @started_up
    AWS.config(access_key_id:       Absorb.settings[:access_key_id],
               secret_access_key:   Absorb.settings[:secret_access_key],
               dynamo_db_endpoint: 'dynamodb.us-east-1.amazonaws.com')

    Dynamoid.configure do |config|
      config.adapter = 'aws_sdk' # This adapter establishes a connection to the DynamoDB servers using Amazon's own AWS gem.
      config.namespace = Absorb.settings[:dynamodb_upload] # To namespace tables created by Dynamoid from other tables you might have.
      config.warn_on_scan = true # Output a warning to the logger when you perform a scan rather than a query on a table.
      config.partitioning = true # Spread writes randomly across the database. See "partitioning" below for more.
      config.partition_size = 200  # Determine the key space size that writes are randomly spread across.
      config.read_capacity = 100 # Read capacity for your tables
      config.write_capacity = 20 # Write capacity for your tables
    end

    @started_up = true
  end

end
