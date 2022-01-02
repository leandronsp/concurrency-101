require 'pg'

class DBConnection
  def self.test
    PG.connect(host: 'postgres', user: 'test',
               password: 'test', dbname: 'test')
  end
end
