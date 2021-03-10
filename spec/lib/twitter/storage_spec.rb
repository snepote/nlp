require 'twitter/storage'
require 'ostruct'

RSpec.describe Twitter::Storage do
  let(:id) { 123456789 }
  let(:path) { '/tmp/test/twitter' }
  let(:object) { OpenStruct.new(id: id, data: 'some data') }
  let(:storage) { described_class.new(path: path) }

  describe '#save' do
    context 'given a Tweet object' do
      it 'should be persisted to a file in the given path using id as name' do
        expect(storage.save(object: object)).to eq(object.id)
      end
    end
  end

  describe '#load' do
    context 'given a stored Tweet' do
      it 'should recover the Tweet and be equal to the original object' do
        expect(storage.load(id: id)).to eq(object)
        File.delete(File.join(path, "#{id}.yaml"))
        Dir.delete(path)
      end
    end
  end
end
