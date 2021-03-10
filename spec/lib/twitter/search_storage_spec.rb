require 'twitter/search_storage'
require 'json'

RSpec.describe Twitter::SearchStorage do
  let(:path) { File.join('/tmp', 'test', 'twitter', 'search_storage') }
  let(:query) { 'random string' }
  let(:storage) { described_class.new(path: path, query: query) }
  let(:object_one) {
    {
      id: 1,
      created_at: "2021-03-04 23:57:54 UTC",
      text: "A text that contains my #{query}",
      user: { id: 11, name: 'Peter', followers_count: 60 }
    }
  }
  let(:object_two) {
    {
      id: 2,
      created_at: "2021-03-04 23:57:54 UTC",
      text: "Some other text that also contains my #{query}",
      user: { id: 22, name: 'Sebastian', followers_count: 34 }
    }
  }

  after(:example) do
    File.delete(storage.filename)
    Dir.delete(path)
  end

  describe 'when is created' do
    context 'and it is first initialised' do
      it 'should save a file with the query and empty results' do
        saved_file = File.read(storage.filename)
        expect(saved_file).to eq(JSON.pretty_generate({ query: query, results: [] }))
      end
    end

    context 'and results added' do
      it 'should return the same results' do
        expect(storage.results).to be_empty
        storage.add(object: object_one)
        storage.add(object: object_two)
        expect(storage.results.count).to eq(2)
        expect(storage.results.first).to eq(object_one)
      end

      it 'should not add the same object twice' do
        storage.add(object: object_one)
        storage.add(object: object_one)
        expect(storage.results.count).to eq(1)
      end
    end
  end

  describe '#save' do
    context 'when an object is added' do
      it 'should persist the object to the file' do
        expect(storage.results).to be_empty
        storage.add(object: object_one)
        expect(storage.results.count).to eq(1)
        expect(File.read(storage.filename)).to eq(JSON.pretty_generate({ query: query, results: [] }))
        storage.add_and_save(object: object_two)
        expect(File.read(storage.filename)).to eq(JSON.pretty_generate(
          {
            query: query, results: [object_one, object_two]
          }))
      end
    end
  end
end
