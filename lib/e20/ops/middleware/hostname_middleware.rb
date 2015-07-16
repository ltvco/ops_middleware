module E20
  module Ops
    module Middleware
      class HostnameMiddleware

        def initialize(app, options = {})
          @app      = app
          @options  = options
          @hostname = options[:hostname] || Hostname.new
          @pid      = Process.pid
        end

        def call(env)
          status, headers, body = @app.call(env)
          headers["X-Served-By"] = "#{@hostname.to_s} (#{@pid})"
          if (logger = @options[:logger])
            logger.info "[#{self.class.name}] Running on: #{@hostname} (#{@pid})"
          end
          [status, headers, body]
        end

      end
    end
  end
end
