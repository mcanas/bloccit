require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the LabelsHelper. For example:
#
# describe LabelsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe LabelsHelper, type: :helper do
  describe 'labels_to_buttons' do
    it 'turns labels into HTML buttons' do
      L1 = Label.create!(name: 'L1')
      L2 = Label.create!(name: 'L2')
      expected_html = '<a class="btn-xs btn-primary" href="/labels/1">L1</a> <a class="btn-xs btn-primary" href="/labels/2">L2</a>'

      expect(labels_to_buttons([L1,L2])).to eq expected_html
    end
  end
end
