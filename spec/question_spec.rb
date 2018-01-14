# rubocop:disable Metrics/BlockLength
# frozen_string_literal: true

ENV['ENV'] = 'test'

load './question'

RSpec.context 'with options' do
  let(:name) { 'Bob' }
  let(:question) { 'some question text' }
  let(:options) { ['-n', name, '--'] << question.split(' ') }
  let(:parsed_options) { { name: name } }
  let!(:warn_level) { $VERBOSE }
  let!(:orig_ARGV) { ARGV }

  # Suppress warnings about reassigning ARGV
  before(:each) do
    $VERBOSE = nil
    ARGV = options
  end

  after(:each) do
    ARGV = orig_ARGV
    $VERBOSE = warn_level
  end

  describe '#parse_options!' do
    it 'sets the :name' do
      expect(parse_options![:name]).to eq name
    end

    it 'sets the question text to the argument following --' do
      parse_options!
      expect(question_text).to eq question
    end
  end

  describe '#salutation' do
    context 'with a name option' do
      it 'returns a salutation' do
        expect(salutation('Test')).to include 'Test'
      end
    end
  end

  describe '#format_output' do
    it 'includes the name' do
      expect(format_output(parsed_options)).to include name
    end

    it 'ends with a period' do
      expect(format_output(parsed_options)).to match(/.\z/)
    end

    it 'includes the question text' do
      expect(format_output(parsed_options)).to include question
    end
  end
end

RSpec.context 'without options' do
  let(:options) { {} }
  describe '#parse_options!' do
    it 'sets :name to nil' do
      expect(parse_options![:name]).to be_nil
    end
  end

  describe '#format_output' do
    it 'ends with a period' do
      expect(format_output(options)).to match(/.\z/)
    end
  end

  describe '#outro' do
    it 'does emdashes correctly' do
      expect(outro).not_to match(/-- /)
    end
  end
end
# rubocop:enable Metrics/BlockLength
