require 'contracts'
require 'openssl'
require 'rakuna/data/redis'
require 'securerandom'

module Rakuna
  module Session
    # Redis-backed sessions
    module Redis
      include Contracts
      include Rakuna::Data::Redis

      # A session backed by redis.
      class Session
        include Contracts

        Contract ::Redis, String, Maybe[Hash] => Any
        def initialize(redis, session_id, options = {})
          @redis = redis
          @session_id = session_id
          @namespace = options.fetch 'namespace', '_'
        end

        Contract String, String => Bool
        def set(key, value)
          @redis.hset session, key, value
        end

        Contract String => Any
        def get(key)
          @redis.hget session, key
        end

        Contract None => Bool
        def active?
          @redis.exists "#{session}:active"
        end

        Contract Maybe[Num] => 'OK'
        def renew(duration = 300)
          @redis.set "#{session}:active", true, ex: duration
        end

        private

        Contract None => String
        def reseed
          SecureRandom.uuid.tap { |uuid| @redis.set "#{@namespace}:seed", uuid }
        end

        Contract None => String
        def seed
          @seed ||= @redis.get("#{@namespace}:seed") || reseed
        end

        Contract None => String
        def id
          OpenSSL::HMAC.hexdigest OpenSSL::Digest::SHA256.new, seed, @session_id
        end

        Contract None => String
        def session
          @session ||= "#{@namespace}:#{id}"
        end
      end

      Contract None => Rakuna::Session::Redis::Session
      def session
        @session || Session.new(redis, session_id)
      end
    end
  end
end
