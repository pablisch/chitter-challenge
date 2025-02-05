require 'peep_repository'

def reset_tables
  seed_sql = File.read('spec/seeds.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'chitter_test' })
  connection.exec(seed_sql)
end

describe PeepRepository do
  before(:each) do 
    reset_tables
  end

  context "#all" do
    it "returns all Peep objects" do
      repo = PeepRepository.new
      peeps = repo.all
      expect(peeps.length).to eq 7
      expect(peeps.first.body).to eq "Today I coded"
      expect(peeps.first.time).to eq "2023-04-01 13:00:00"
      expect(peeps.first.tags).to eq "#code, #amber"
      expect(peeps.first.user_id).to eq 1
      expect(peeps[2].body).to eq 'Today I slept'
    end
  end


  context "#create" do
    it "creates a new peep" do
      repo = PeepRepository.new
      new_peep = Peep.new
      new_peep.body = "Today I surfed"
      new_peep.time = '2023-04-07 23:00:00'
      new_peep.tags = "#surf, #amber, #billy"
      repo.create(new_peep)
      peeps = repo.all
      expect(peeps.length).to eq 8
      expect(peeps.last.body).to eq "Today I surfed"
      expect(peeps.last.time).to eq '2023-04-07 23:00:00'
      expect(peeps.last.tags).to eq "#surf, #amber, #billy"
      
    end
  end

  context "#all_with_username" do
    it "returns all Peep objects with usernames gathered from Users" do
      repo = PeepRepository.new
      peeps = repo.all_with_names
      expect(peeps.length).to eq 7
      expect(peeps.first.body).to eq "Today I coded"
      expect(peeps.first.time).to eq "2023-04-01 13:00:00"
      expect(peeps.first.tags).to eq "#code, #amber"
      expect(peeps.first.user_id).to eq 1
      expect(peeps.first.name).to eq 'Amber Thompson'
      expect(peeps.first.username).to eq 'Amber'
      expect(peeps[2].body).to eq 'Today I slept'
    end
  end





  reset_tables
end