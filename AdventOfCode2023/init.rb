require_relative "./lib.rb"
require "thor/group"

class Init < Thor::Group
  include Thor::Actions

  YEAR = 2023

  desc <<~DOC
    This INIT tool is meant to be used as follows :
    ruby init.rb 4 my_solution # will create day4 folder with my_solution.rb and puzzle inputs
    ruby init.rb 4 # will create day4 folder and use puzzle name for the filename
    ruby init.rb # will download current day puzzle and use puzzle name for the filename
  DOC

  argument :day_num, type: :numeric, required: false, desc: "Number of the day in the month of the puzzle you want"
  argument :filename, type: :string, required: false, desc: "Snakecase version of the name you want, we will create filename.rb"
  class_option :commit, type: :boolean, default: true, desc: "Commit after generation"

  attr_accessor :example, :example_solution, :day_name

  def self.exit_on_failure?
    true
  end

  def self.source_root
    File.dirname(__FILE__)
  end

  def setup
    self.day_num = Date.current.day if day_num.nil?
    self.day_name = "day%02d" % day_num
    self.filename = downloader.parse_puzzle_name.tr(" ", "_").underscore if filename.nil?
    self.example = downloader.parse_example
    self.example_solution = downloader.parse_example_solution
  end

  def create_solver_files
    template("solver.rb.tt", "#{day_name}/#{filename}.rb")
    template("solver_spec.rb.tt", "#{day_name}/#{filename}_spec.rb")
  end

  def create_puzzle_files
    create_file("#{day_name}/example") { example }
    create_file("#{day_name}/puzzle") { downloader.download_puzzle }
  end

  def commit_result
    return unless @options["commit"]

    if check_solver_files
      Git.commit "[#{YEAR}-#{day_name}] Add solution scaffold"
    else
      puts "ERROR : no commit made because ruby generated files have an issue"
    end
  end

  private

  def downloader
    @downloader ||= AocDownloader.new(YEAR, day_num)
  end

  def check_solver_files
    `ruby #{day_name}/#{filename}.rb`
    return false unless $?.success?

    rspec_error_indicator = "error occurred outside of examples"
    !(rspec_error_indicator.in? `rspec #{day_name}/#{filename}_spec.rb`)
  end
end

Init.start
