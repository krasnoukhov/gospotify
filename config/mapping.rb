coercer = Lotus::Model::Adapters::Dynamodb::Coercer
mapper = Lotus::Model::Mapper.new(coercer) do
  collection :users do
    entity User

    attribute :id,          String
    attribute :email,       String
  end

  collection :auths do
    entity Auth

    attribute :id,          String
    attribute :user_id,     String
    attribute :provider,    String
    attribute :external_id, String
    attribute :email,       String
    attribute :token,       String
    attribute :secret,      String
  end
end.load!
adapter = Lotus::Model::Adapters::DynamodbAdapter.new(mapper)

AuthRepository.adapter = adapter
UserRepository.adapter = adapter
