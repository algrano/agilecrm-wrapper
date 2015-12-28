require 'spec_helper'

describe AgileCRMWrapper::Task do
  let(:task) { AgileCRMWrapper::Task.find(123) }

  describe '.all' do
    subject { AgileCRMWrapper::Task.all }

    it 'should return an array of Tasks' do
      expect(subject.map(&:class).uniq).to eq([AgileCRMWrapper::Task])
    end
  end

  describe '.pending' do
    subject { AgileCRMWrapper::Task.pending }

    it 'should return an array of Tasks' do
      expect(subject.map(&:class).uniq).to eq([AgileCRMWrapper::Task])
    end
  end

  describe '.find' do
    let(:id) { 123 }
    subject { AgileCRMWrapper::Task.find(id) }

    context 'given an existing task ID' do
      it { should be_kind_of(AgileCRMWrapper::Task) }

      its(:id) { should eq id }
    end

    context 'given an unknown task ID' do
      let(:id) { 0 }
      it { expect { is_expected.to raise_error(AgileCRMWrapper::NotFound) } }
    end
  end

  describe '.delete' do
    context 'given a single ID' do
      subject { AgileCRMWrapper::Task.delete(123) }

      its(:status) { should eq 204 }
    end
  end

  describe '.create' do
    subject do
      AgileCRMWrapper::Task.create(
        type: 'OTHER',
        priority_type: 'NORMAL',
        due: Time.now.to_i,
        contacts: [123],
        subject: 'Subject',
        owner_id: 1234
      )
    end

    its(:class) { should eq AgileCRMWrapper::Task }
  end

  describe '#update' do
    it 'updates the receiving task with the supplied key-value pair(s)' do
      expect do
        task.update(subject: 'Foo!')
      end.to change{
        task.subject
      }.to('Foo!')
    end
  end

  describe '#destroy' do
    let(:task) { AgileCRMWrapper::Task.find(123) }
    subject { task.destroy }

    its(:status) { should eq 204 }
  end
end
