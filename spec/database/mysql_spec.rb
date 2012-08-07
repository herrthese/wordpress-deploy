require 'spec_helper'

include WordpressDeploy::Database

describe MySql do
  it { should respond_to :run }
  it { should respond_to :utility }
  it { should respond_to :command_name }

  context "find commands" do
    it "should raise Errors::Cli::UtilityNotFoundError if no command given" do
      expect{subject.utility ""}.to raise_error(WordpressDeploy::Errors::Cli::UtilityNotFoundError)
    end
    it "should raise Errors::Cli::UtilityNotFoundError if command not found" do
      expect{subject.utility "missing_system_command"}.to raise_error(WordpressDeploy::Errors::Cli::UtilityNotFoundError)
    end
    it "mysql" do
      stdin    = Object.new
      stdin.stub(:close)

      stdout   = Object.new.stub(:read).and_return("")
      stdout.stub(:read).and_return("/path/to/mysql")

      stderr   = Object.new.stub(:read).and_return("")
      stderr.stub(:read).and_return("")

      wait_thr = Object.new
      wait_thr.stub(:value).and_return($?)

      Open3.should_receive(:popen3).exactly(1).times.and_yield(stdin, stdout, stderr, wait_thr)

      subject.utility("mysql").should eq "/path/to/mysql"
      WordpressDeploy::Database::MySql::UTILITY["mysql"].should eq "/path/to/mysql"
    end
  end
end