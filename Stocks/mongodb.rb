require 'active_support/core_ext/object/blank'
require 'mongo'

module Stock
  class MongoDB
      
    def initialize(server = '127.0.0.1:27017')
      @database = 'stocks'
      @server = server

      @db_client = Mongo::Client.new([@server], database: @database)
    end
      
    # Example: {"ticker"=>"twtr", "tag"=>"IT", "desc"=>"}
    def insert_kseries(data, length)
      return nil if data.nil?

      puts data

      collection = @db_client[:us]
      docs.each { |doc|
        collection.update_one({ ticker: data[:ticker] } ,
                              { "$set": data },
                              { upsert: true });
      }
    end
  end
end