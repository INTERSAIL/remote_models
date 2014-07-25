require 'test_helper'

class CompanyHeadquartersTest < ActiveSupport::TestCase
  test 'CompanyHeadquarters.all must not be nil' do
    Net::HTTP.expects(:get).with(URI("#{CompanyHeadquarters.site}?type=company_headquarters&id=&where=&limit=0&order=")).returns(
        '[{}]'
    ) if ENV['MOCK']
    headquarters = CompanyHeadquarters.all
    assert_not_nil headquarters
  end

  test 'CompanyHeadquarters.first must not be nil' do
    Net::HTTP.expects(:get).with(URI("#{CompanyHeadquarters.site}?type=company_headquarters&id=&where=&limit=0&order=")).returns(
        '[{}]'
    ) if ENV['MOCK']
    assert_not_nil CompanyHeadquarters.first
  end

  test 'CompanyHeadquarters.first must have headquarters_name not nil' do
    Net::HTTP.expects(:get).with(URI("#{CompanyHeadquarters.site}?type=company_headquarters&id=&where=&limit=0&order=")).returns(
        '[{"headquarters_name": "SEDE"}]'
    ) if ENV['MOCK']
    assert_not_nil CompanyHeadquarters.first.headquarters_name
  end

  test 'First and last CompanyHeadquarters must have different ids' do
    Net::HTTP.expects(:get).with(URI("#{CompanyHeadquarters.site}?type=company_headquarters&id=&where=&limit=0&order=")).returns(
        '[{"id": 1}, {"id": 8000}]'
    ) if ENV['MOCK']
    ch1 = CompanyHeadquarters.first
    ch2 = CompanyHeadquarters.last
    assert_not_equal ch1.id, ch2.id
  end
end