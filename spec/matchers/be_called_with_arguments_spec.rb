require 'English'
require 'rspec/shell/expectations'

# TODO - the below specs test implementation, until the goofy wiring of StubbedCommand => StubbedCall => CallLog is sorted out

describe 'be_called_with_arguments' do
  include Rspec::Shell::Expectations
  let(:stubbed_env) { create_stubbed_env }

  context 'with a command' do
    context 'and no chain calls' do
      before(:each) do
        @command = stubbed_env.stub_command('command')
        expect(@command).to receive(:called_with_args?).with('first_argument', 'second_argument', anything).and_return(true)
        @actual_stdout, @actual_stderr, @actual_status = stubbed_env.execute(<<-multiline_script
          command first_argument second_argument
        multiline_script
        )
      end
      it 'passes the check to the StubCommand\'s #called_with_args? method' do
        expect(@command).to be_called_with_arguments('first_argument', 'second_argument')
      end
    end
    context 'and the at_position chain call' do
      before(:each) do
        @command = stubbed_env.stub_command('command')
        expect(@command).to receive(:called_with_args?).with('first_argument', 'second_argument', position: 0).and_return(true)
        @actual_stdout, @actual_stderr, @actual_status = stubbed_env.execute(<<-multiline_script
          command first_argument second_argument
        multiline_script
        )
      end
      it 'passes the check to the StubCommand\'s #called_with_args? method' do
        expect(@command).to be_called_with_arguments('first_argument', 'second_argument').at_position(0)
      end
    end
  end
  context 'with a sub-command' do
    context 'and no chain calls' do
      before(:each) do
        @command = stubbed_env.stub_command('command')
        @sub_command = @command.with_args('sub_command')

        expect(@sub_command).to receive(:called_with_args?).with('first_argument', 'second_argument', anything).and_return(true)
        @actual_stdout, @actual_stderr, @actual_status = stubbed_env.execute(<<-multiline_script
          command sub_command first_argument second_argument
        multiline_script
        )
      end
      it 'passes the check to the StubCall\'s #called_with_args? method' do
        expect(@sub_command).to be_called_with_arguments('first_argument', 'second_argument')
      end
    end
    context 'and the at_position chain call' do
      before(:each) do
        @command = stubbed_env.stub_command('command')
        @sub_command = @command.with_args('sub_command')

        expect(@sub_command).to receive(:called_with_args?).with('first_argument', 'second_argument', position: 0).and_return(true)
        @actual_stdout, @actual_stderr, @actual_status = stubbed_env.execute(<<-multiline_script
          command sub_command first_argument second_argument
        multiline_script
        )
      end
      it 'passes the check to the StubCall\'s #called_with_args? method' do
        expect(@sub_command).to be_called_with_arguments('first_argument', 'second_argument').at_position(0)
      end
    end
  end
end