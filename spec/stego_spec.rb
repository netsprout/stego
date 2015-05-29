require 'spec_helper'

describe Stego do
  context "Stego" do
    let(:original_filename) { "original_test.jpg" }
    let(:embedded_filename) { "embedded_test.png" }
    let(:extract_filename)  { "extract_data_test.txt" }
    let(:embed_time)        { Time.now }
    let(:user)              { FactoryGirl.create :user }
    let(:image)             { FactoryGirl.create :image, user: user}
    let(:embed_data)        { "Test Embed Data"}

    describe "#embed" do

      let(:embed_cmd)   { "echo '#{embed_data}' | #{Stego::STEGO_APP} embed --messagefile - --coverfile #{original_filename} --stegofile #{embedded_filename}" }

      context "when raw text is passed to be embedded" do
        let(:options) { { embed_data: embed_data } }

        it "calls the OpenStego command line app with correct inline embed command and file paths" do
          expect(subject).to receive(:system).with(embed_cmd)
          subject.embed("#{original_filename}", "#{embedded_filename}", options)
        end
      end
    end

    describe "#extract" do
      let(:extract_cmd) { "#{Stego::STEGO_APP} extract --stegofile #{embedded_filename} --extractfile #{extract_filename}" }

      context "when passed extract data output file" do
        let(:options) { { extractfile: extract_filename } }

        it "calls the OpenStego command line app with correct extract command and file paths" do
          expect(subject).to receive(:system).with(extract_cmd)
          subject.extract("#{embedded_filename}", options)
        end
      end
    end
  end

end