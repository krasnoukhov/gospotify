namespace :db do
  desc "Drop test database"
  task drop: :environment do
    Net::HTTP.new("localhost", AWS.config.dynamo_db_port).delete("/")
  end

  desc "Create database tables"
  task create: :environment do
    DB = AWS::DynamoDB::Client.new(api_version: Lotus::Dynamodb::API_VERSION)

    DB.create_table(
      table_name: "users",
      attribute_definitions: [
        { attribute_name: "id",           attribute_type: "S" },
        { attribute_name: "email",        attribute_type: "S" },
      ],
      key_schema: [
        { attribute_name: "id",           key_type: "HASH" },
      ],
      global_secondary_indexes: [{
        index_name: "by_email",
        key_schema: [
          { attribute_name: "email",      key_type: "HASH" },
        ],
        projection: {
          projection_type: "ALL",
        },
        provisioned_throughput: {
          read_capacity_units: 10,
          write_capacity_units: 10,
        },
      }],
      provisioned_throughput: {
        read_capacity_units: 10,
        write_capacity_units: 10,
      },
    )

    DB.create_table(
      table_name: "auths",
      attribute_definitions: [
        { attribute_name: "user_id",      attribute_type: "S" },
        { attribute_name: "provider",     attribute_type: "S" },
        { attribute_name: "external_id",  attribute_type: "S" },
      ],
      key_schema: [
        { attribute_name: "user_id",      key_type: "HASH" },
        { attribute_name: "provider",     key_type: "RANGE" },
      ],
      global_secondary_indexes: [{
        index_name: "by_external",
        key_schema: [
          { attribute_name: "provider",   key_type: "HASH" },
          { attribute_name: "external_id",key_type: "RANGE" },
        ],
        projection: {
          projection_type: "ALL",
        },
        provisioned_throughput: {
          read_capacity_units: 10,
          write_capacity_units: 10,
        },
      }],
      provisioned_throughput: {
        read_capacity_units: 10,
        write_capacity_units: 10,
      },
    )
  end
end
