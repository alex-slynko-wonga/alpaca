require 'fakefs/spec_helpers'
describe Alpaca::Version do
  let(:v) do
    Alpaca::Version.new(file: '.semver', major: major, minor: minor,
                        patch: patch, special: special, metadata: metadata)
  end

  let(:major) { 1 }
  let(:minor) { 2 }
  let(:patch) { 3 }
  let(:special) { 'rc' }
  let(:metadata) { '03fb4' }

  describe '#increase :major' do
    it 'v1.2.3-rc+03fb4 -> v2.0.0-rc+03fb4' do
      v.increase :major
      expect(v.to_s).to eq 'v2.0.0-rc+03fb4'
    end
  end

  describe '#increase :minor' do
    it 'v1.2.3-rc+03fb4 -> v1.3.0-rc+03fb4' do
      v.increase :minor
      expect(v.to_s).to eq 'v1.3.0-rc+03fb4'
    end
  end

  describe '#increase :patch' do
    it 'v1.2.3-rc+03fb4 -> v1.2.4-rc+03fb4' do
      v.increase :patch
      expect(v.to_s).to eq 'v1.2.4-rc+03fb4'
    end
  end

  describe '#increase :prerelease' do
    context 'from alpha' do
      let(:special) { 'alpha' }
      it 'v1.2.3-alpha+03fb4 -> v1.2.3-beta+03fb4' do
        v.increase :prerelease
        expect(v.to_s).to eq 'v1.2.3-beta+03fb4'
      end
    end

    context 'from beta' do
      let(:special) { 'beta' }

      it 'v1.2.3-beta+03fb4 -> v1.2.3-rc+03fb4' do
        v.increase :prerelease
        expect(v.to_s).to eq 'v1.2.3-rc+03fb4'
      end
    end

    context 'from rc' do
      it 'it fails with PreReleaseTagReachedFinalVersion' do
        expect { v.increase :prerelease }
          .to raise_error(Alpaca::Version::PreReleaseTagReachedFinalVersion)
      end
    end

    context 'in release version' do
      let(:special) { '' }
      it 'it fails with NotPreRelease' do
        expect { v.increase :prerelease }
          .to raise_error(Alpaca::Version::NotPreRelease)
      end
    end
  end

  describe '#metadata=' do
    it 'v1.2.3-rc+03fb4 -> v1.2.3-rc+334f666' do
      v.metadata = '334f666'
      expect(v.to_s).to eq 'v1.2.3-rc+334f666'
    end
  end

  describe '#release' do
    it 'v1.2.3-rc+03fb4 -> v1.2.3' do
      v.release
      expect(v.to_s).to eq 'v1.2.3'
    end

    context 'in release version' do
      let(:special) { '' }
      it 'v1.2.3 -> fail AlreadyReleaseVersion' do
        expect { v.release }
          .to raise_error(Alpaca::Version::AlreadyRelease)
      end
    end
  end

  describe '#make_prerelease' do
    it 'v1.2.3-rc+03fb4 -> fail AlreadyPreReleaseVersion' do
      v.increase :major
      expect(v.to_s).to eq 'v2.0.0-rc+03fb4'
    end
    it 'v1.2.3 -> v1.2.3-alpha' do
      v.increase :major
      expect(v.to_s).to eq 'v2.0.0-rc+03fb4'
    end
  end

  describe '#to_s' do
    it 'works fine with wrong format' do
      expect(v.to_s('%M%M%F')).to eq '11%F'
    end
  end
end
