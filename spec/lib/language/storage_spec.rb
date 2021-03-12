require 'language/storage'
require 'json'

RSpec.describe Language::Storage do
  let(:path) { '/tmp/test/language' }
  let(:storage) { described_class.new path: path }
  let(:hash) { { id: 123, name: 'Sebastian' } }

  after(:all) {
    Dir.delete('/tmp/test/language')
  }

  describe '#load' do
    context 'when there is no file' do
      it 'should return nil' do
        storage.save(json: hash.to_json, name: 'dummy-name')
        expect(storage.read(name: 'inexistent_file')).to be_nil
      end
    end

    after(:example) do
      File.delete(File.join(path, 'dummy-name.json'))
    end
  end

  describe '#save and #load' do
    context 'after saving' do
      it 'should retrieve the same content' do
        storage.save(json: JSON.pretty_generate(hash), name: hash[:name])
        stored_hash = storage.read(name: hash[:name])
        expect(stored_hash).to eq(hash)
      end

      after(:example) do
        File.delete(File.join(path, 'sebastian.json'))
      end
    end
  end
end
