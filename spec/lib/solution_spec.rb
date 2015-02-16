require 'alpaca/entity/solution'

describe Alpaca::Solution do
  let(:sln) do
    cur = File.dirname(File.expand_path(__FILE__))
    {
      file: File.join(cur, '../test_data', 'TestSolution.sln'),
      file_path: File.expand_path('spec/test_data/TestSolution.sln'),
      format_version: '12.00',
      vs_version: '12.0.30723.0',
      min_vs_version: '10.0.40219.1',
      project: {
        id: '{B9BAB17F-FD42-452B-8DE3-A85254043711}',
        name: 'TestSolution',
        file: 'TestSolution\TestSolution.csproj'
      }
    }
  end

  describe '::new' do
    subject { Alpaca::Solution.new sln[:file] }

    it 'returns Solution object' do
      expect(subject).to be_an_instance_of Alpaca::Solution
    end

    it 'returns object with solution file' do
      expect(subject.file).to eq sln[:file_path]
    end

    it 'returns object with project from solution' do
      expect(subject.projects).to eq [sln[:project]]
    end

    it 'returns object with solution format version' do
      expect(subject.format_version).to eq sln[:format_version]
    end

    it 'returns object with visual studio version' do
      expect(subject.visual_studio_version).to eq sln[:vs_version]
    end

    it 'returns object with minimum visual studio version' do
      expect(subject.minimum_visual_studio_version)
        .to eq sln[:min_vs_version]
    end

    context 'When solution file does not exists' do
      subject { Alpaca::Solution }

      it 'then fails with RuntimeError' do
        expect { Alpaca::Solution.new 'ghost.sln' }.to raise_error
      end
    end
  end
end
