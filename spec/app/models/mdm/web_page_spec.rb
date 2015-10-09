RSpec.describe Mdm::WebPage, type: :model do
  it_should_behave_like 'Metasploit::Concern.run'

  context 'associations' do
    it { is_expected.to belong_to(:web_site).class_name('Mdm::WebSite') }
  end

  context 'serialized attributes' do
    context 'cookie' do
      let(:string_cookie) do
        "test_name=test_value"
      end

      let(:hash_cookie) do
        {
            name: 'test name',
            value: 'test value'
        }
      end

      let(:webrick_cookie) do
        WEBrick::Cookie.new('test name', 'test value')
      end

      let(:web_page) { FactoryGirl.create(:mdm_web_page, cookie: cookie) }

      context 'with string cookie' do
        let(:cookie) { string_cookie }

        it 'persists successfully' do
          expect{web_page}.to change{Mdm::WebPage.count}.by(1)
        end

        it 'reading cookie returns a string' do
          expect(web_page.cookie).to be_a String
        end
      end

      context 'with Hash cookie' do
        let(:cookie) { hash_cookie }

        it 'persists successfully' do
          expect{web_page}.to change{Mdm::WebPage.count}.by(1)
        end

        it 'reading cookie returns a hash' do
          expect(web_page.cookie).to be_a Hash
        end
      end

      context 'with WEBrick::Cookie' do
        let(:cookie) { webrick_cookie }

        it 'persists successfully' do
          expect{web_page}.to change{Mdm::WebPage.count}.by(1)
        end

        it 'reading cookie returns as WEBrick::Cookie object' do
          expect(web_page.cookie).to be_a WEBrick::Cookie
        end
      end
    end
  end

  context 'database' do

    context 'timestamps'do
      it { is_expected.to have_db_column(:created_at).of_type(:datetime).with_options(:null => false) }
      it { is_expected.to have_db_column(:updated_at).of_type(:datetime).with_options(:null => false) }
      it { is_expected.to have_db_column(:mtime).of_type(:datetime) }
    end

    context 'columns' do
      it { is_expected.to have_db_column(:web_site_id).of_type(:integer).with_options(:null => false) }
      it { is_expected.to have_db_column(:path).of_type(:text) }
      it { is_expected.to have_db_column(:query).of_type(:text) }
      it { is_expected.to have_db_column(:code).of_type(:integer).with_options(:null => false) }
      it { is_expected.to have_db_column(:cookie).of_type(:text) }
      it { is_expected.to have_db_column(:auth).of_type(:text) }
      it { is_expected.to have_db_column(:ctype).of_type(:text) }
      it { is_expected.to have_db_column(:location).of_type(:text) }
      it { is_expected.to have_db_column(:headers).of_type(:text) }
      it { is_expected.to have_db_column(:body).of_type(:binary) }
      it { is_expected.to have_db_column(:request).of_type(:binary) }
    end

    context 'indices' do
      it { is_expected.to have_db_index(:path) }
      it { is_expected.to have_db_index(:query) }
    end
  end

  context 'factory' do
    it 'should be valid' do
      web_page = FactoryGirl.build(:mdm_web_page)
      expect(web_page).to be_valid
    end
  end

  context '#destroy' do
    it 'should successfully destroy the object' do
      web_page = FactoryGirl.create(:mdm_web_page)
      expect {
        web_page.destroy
      }.to_not raise_error
      expect {
        web_page.reload
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end