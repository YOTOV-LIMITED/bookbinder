require 'spec_helper'

describe Cli::PushLocalToStaging do
  let(:book_repo) { 'my-user/fixture-book-title' }
  let(:config_hash) { {'book_repo' => book_repo, 'cred_repo' => 'whatever'} }

  let(:fake_distributor) { double(Distributor, distribute: nil) }

  let(:options) do
    {
      app_dir: './final_app',
      build_number: nil,

      aws_credentials: config.aws_credentials,
      cf_credentials: config.cf_staging_credentials,

      book_repo: book_repo,
      production: false
    }
  end

  let(:config) { Configuration.new(config_hash) }
  let(:command) { described_class.new(config) }

  before do
    fake_cred_repo = double(CredRepo, credentials: {'aws' => {}, 'cloud_foundry' => {}})
    allow(CredRepo).to receive(:new).and_return(fake_cred_repo)

    allow(Distributor).to receive(:build).and_return(fake_distributor)
  end

  it 'returns 0' do
    expect(command.run([])).to eq(0)
  end

  it 'builds a distributor with the right options and asks it to distribute' do
    real_distributor = expect_to_receive_and_return_real_now(Distributor, :build, options)
    expect(real_distributor).to receive(:distribute)

    command.run([])
  end
end
