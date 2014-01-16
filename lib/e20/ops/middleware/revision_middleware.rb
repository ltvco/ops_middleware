module E20
  module Ops
    module Middleware
      class RevisionMiddleware
        
        CURRENT_REVISION = Revision.new.to_s
        
        def initialize(app, options = {})
          @app = app
          @options = options
        end

        def call(env)
          
          response = if env["PATH_INFO"] == "/system/revision"
            body = "#{CURRENT_REVISION}\n"
            [200, { "Content-Type" => "text/plain", "Content-Length" => body.size.to_s }, [body]]
          else
            status, headers, body = @app.call(env)
            headers["X-Revision"] = CURRENT_REVISION
            [status, headers, body]
          end
          
          if (logger = @options[:logger])
            logger.info "[#{self.class.name}] Running: #{CURRENT_REVISION}"
          end
          
          response
        end

      end
    end
  end
end
