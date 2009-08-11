require 'rubygems'
require 'rack'
require 'json'
require 'haml'

class Narf
  attr_accessor :classes
  attr_accessor :templates
  attr_accessor :directories
  attr_accessor :options

  def initialize options = {}, &block
    self.classes = {}
    self.templates = {}
    self.directories = {}
    self.options = default_options.merge options
    self.instance_eval &block
  end

  def expose options
    raise ArgumentError.new("Argument isn't a hash") unless options.is_a? Hash

    if options[:directory]
      as = options[:as] || ("/" + File.basename(options[:directory]))
      self.directories[as] = options[:directory]
    elsif options[:class]
      as = options[:as] || ("/" + options[:class].name.downcase)
      self.classes[as] = options[:class]
    elsif options[:templates]
      as = options[:as] || ("/"+ File.basename(options[:templates]))
      self.templates[as] = options[:templates]
    else
      raise ArgumentError.new("Must specify either :directory, :class, or :templates")
    end
  end

  def start
    Rack::Handler::Mongrel.run build_rack, :Port => options[:port]
  end

  private

  def default_options
    { :port=>3000,
      :verbose=>false }
  end

  def build_rack
    classes = self.classes
    directories = self.directories
    templates = self.templates
    options = self.options

    Rack::Builder.new do
      if options[:verbose]
        use Rack::CommonLogger
        use Rack::ShowExceptions
      end

      use Narf::ContentLength

      directories.each do |as, dir|
        map as do
          run Rack::File.new(dir)
        end
      end

      classes.each do |as, cls|
        map as do
          run Narf::ClassAdapter.new(cls)
        end
      end

      templates.each do |as, cls|
        map as do
          run Narf::TemplateAdapter.new(cls)
        end
      end
    end
  end

  ##########################################################
  # For some reason, Safari doesn't like the Content-Length
  # header, requiring instead Content-length, hence this.
  ##########################################################
  class ContentLength
    def initialize app
      @app = app
    end

    def call env
      result = @app.call env
      result[1]['Content-length']=result[2].to_s.size.to_s
      result[1].delete 'Content-Length'
      result
    end
  end

  class TemplateAdapter
    def initialize dir
      @dir = dir
    end

    def call env
      req = Rack::Request.new(env)

      begin
        template_path = (req.path_info == '/' ? 'index' : req.path_info)
        template = File.join(@dir, template_path+".haml")
        return [404, {}, ""] unless File.exists? template

        result = Haml::Engine.new(File.read(template)).render(Object.new, req.params)
      rescue
        result = "<h1>#{$!.message}</h1>\n"+$!.backtrace.join("\n<br/>")
      end

      [200, {"Content-type"=>"text/html"}, result]
    end
  end

  class ClassAdapter
    def initialize klass
      @class = klass
    end

    def call env
      req = Rack::Request.new(env)

      begin
        parts = req.path_info.split('/')
        parts.shift # Leading / means the first element is always ""

        method_name = parts.shift.to_sym
        method = @class.new.method method_name

        args = parts
        args << req.params if method.arity.abs > parts.length

        result = method.call *args
      rescue
        result = {:error => $!.message, :stack=>$!.backtrace}
      end

      [200, {"Content-type"=>"application/javascript"}, result.to_json]
    end
  end
end
