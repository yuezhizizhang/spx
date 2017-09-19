require 'active_support/core_ext/object/blank'
require 'mongo'

module Quant
  class MongoDB
    include QuantUtil

    def initialize(database, server = '127.0.0.1:27017')
      @database = database
      @server = server

      @db_client = Mongo::Client.new([@server], database: @database)
    end

    # = param data
    #
    # Example: {"t"=>[1451952000, 1452038400], "c"=>[2011.75, 1986], "o"=>[2009, 2010.75], "h"=>[2017, 2013.25], "l"=>[1992.25, 1970.5], "v"=>["n/a", "n/a"], "vo"=>["n/a", "n/a"], "s"=>"ok"}
    def insert_kseries(data, length)
      return nil unless data['s'] == 'ok'

      docs = format(data, length)
      puts docs

      collection = @db_client[:kseries]
      docs.each { |doc|
        collection.update_one({ t: doc[:t] } ,
                              { "$set": doc },
                              { upsert: true });
      }
    end

    def update_kseries(date, params)
      collection = @db_client[:kseries]

      timestamp = to_timestamp(date, '%m/%d/%Y')
      collection.update_one({ t: timestamp } , { "$set": params });
    end

    def drop_kseries
      collection = @db_client[:kseries]
      collection.drop
    end

    def query_kseries(from, to)
      start = to_timestamp(from, '%Y-%m-%d')
      stop = to_timestamp(to, '%Y-%m-%d')

      collection = @db_client[:kseries]
      results = collection.find({"$and": [
                                  {"t": {"$gte": start}},
                                  {"t": {"$lte": stop}}
                                ]})
      results
    end

    def query_kseries_all
      collection = @db_client[:kseries]
      results = collection.find({})
      results
    end

    def format(data, length)
      docs = []

      timestamps = data['t']
      opens = data['o']
      closes = data['c']
      highs = data['h']
      lows = data['l']

      return docs unless (timestamps.length == opens.length &&
                          opens.length == closes.length &&
                          closes.length == highs.length &&
                          highs.length == lows.length)
      
      timestamps.each_with_index { |t, i|
        break if i >= length
        docs << {t: t, o: "#{opens[i]}", c: "#{closes[i]}", h: "#{highs[i]}", l: "#{lows[i]}"}
      }

      docs
    end
  end
end