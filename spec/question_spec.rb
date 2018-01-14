# rubocop:disable Metrics/BlockLength
# frozen_string_literal: true

ENV['ENV'] = 'test'

load './question'

RSpec.describe '#salutation' do
  context 'with a name option' do
    it 'returns a salutation' do
      expect(salutation('Test')).to include 'Test'
    end
  end
end

RSpec.describe '#parse_options!' do
  context 'without options' do
    it 'sets :name to nil' do
      expect(parse_options![:name]).to be_nil
    end
  end

  context 'with options' do
    let(:name) { 'Bob' }
    let(:question) { 'some question text' }
    let(:options) { ['-n', name, '--'] << question.split(' ') }
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

    it 'sets the :name' do
      expect(parse_options![:name]).to eq name
    end

    it 'sets the question text to the argument following --' do
      parse_options!
      expect(question_text).to eq question
    end
  end
end
# rubocop:enable Metrics/BlockLength
