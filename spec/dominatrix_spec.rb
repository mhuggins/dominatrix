# encoding: UTF-8
require 'spec_helper'

RSpec.describe Dominatrix do
  subject { described_class }

  describe '.parse' do
    shared_examples_for 'a valid URL' do |domain|
      it 'returns the domain when given a string' do
        expect(subject.parse(url)).to eq domain
      end

      it 'returns the domain when given a URI' do
        uri = URI.parse(url)
        expect(subject.parse(uri)).to eq domain
      end
    end

    describe 'for a valid LTR URI' do
      let(:url) { 'http://www.example.com/foo?x=y&y=z' }
      it_behaves_like 'a valid URL', 'example.com'
    end

    describe 'for a valid RTL URI', skip: 'RTL extensions not working' do
      let(:url) { 'http://مليسيا.مليسيا.مليسيا' }
      it_behaves_like 'a valid URL', 'مليسيا.مليسيا'
    end

    describe 'for an invalid URI' do
      it 'raises an error' do
        url = 42
        expect { subject.parse(url) }.to raise_error ArgumentError
      end
    end

    describe 'for an unparseable URI' do
      it 'raises an error' do
        url = ':'
        expect { subject.parse(url) }.to raise_error URI::InvalidURIError
      end
    end

    describe 'for an nonexistent domain' do
      it 'raises an error' do
        url = 'http://www.example.foo'
        expect { subject.parse(url) }.to raise_error Dominatrix::NotFoundError
      end
    end

    describe 'when given a custom list of extensions' do
      let(:extensions) { %w[.uk .co.uk].to_set }

      it 'returns the domain for a valid URI' do
        expect(subject.parse('http://www.example.co.uk', extensions)).to eq 'example.co.uk'
      end

      it 'raises an error for an invalid URI' do
        expect { subject.parse('http://www.example.com', extensions) }.to raise_error Dominatrix::NotFoundError
      end
    end
  end

  describe '.default_extensions' do
    it 'returns a set' do
      expect(subject.default_extensions).to be_a Set
    end

    it 'prefixes each extension with a dot', skip: 'RTL extensions not working' do
      expect(subject.default_extensions).to all start_with('.')
    end
  end
end
