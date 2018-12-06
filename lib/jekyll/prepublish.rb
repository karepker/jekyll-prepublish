require 'jekyll/prepublish/validator/validator_instances'
require 'jekyll/prepublish/version'
require 'nokogiri'

# Command definition.
#
# Run with:
# $ bundler exec jekyll prepublish -p <post location relative to jekyll root>
module JekyllPrepublish
  class Prepublish < Jekyll::Command
    class << self

      def init_with_program(prog)
        prog.command(:prepublish) do |c|
          c.syntax 'prepublish'
          c.description 'Validate various aspects of a page.'
          c.option 'path', '-p PATH', '--path PATH', 'Path to post to check.
              Specify the path from the website root.'

          c.action do |args, options|
            Jekyll.logger.debug('Running prepublish ...')
            configuration = configuration_from_options(options)

            Jekyll.logger.debug('Reading site.')
            site = Jekyll::Site.new(configuration)
            site.read

            Jekyll.logger.debug('Getting post to check.')
            path = configuration.fetch("path")
            post = site.posts.docs.find { |post| post.relative_path == path }
            if post.nil?
              Jekyll.logger.info(
                "No post with path \"#{path}\" could be found, exiting.")
              exit 0
            end
            Jekyll.logger.info("Running prepublish on post #{post.path}.")

            Jekyll.logger.debug('Rendering and parsing post HTML.')
            post.output = Jekyll::Renderer.new(site, post).run
            document = Nokogiri::HTML(post.output)

            Jekyll.logger.debug('Running validation.')
            registry = JekyllPrepublish::ValidatorRegistry.new
            validator_errors = 0
            jekyll_prepublish_configuration = configuration.fetch(
              "jekyll-prepublish", Hash.new)
            validators_configuration = jekyll_prepublish_configuration.fetch(
              'validators', Hash.new)
            registry.each_validator(
                validators_configuration) do |key, validator|
              Jekyll.logger.debug(
                  "Running #{key} validator: #{validator.describe_validation}")
              validation_text = validator.validate(post, document, site)
              next if validation_text.nil?
              validator_errors += 1
              $stderr.puts validation_text
            end

            exit validator_errors
          end
        end
      end
    end
  end
end
