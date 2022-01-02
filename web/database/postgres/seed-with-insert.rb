require 'pg'
require 'json'
require 'faker'

initial_time = Time.now

conn = PG.connect(host: 'postgres', user: 'test',
                  password: 'test', dbname: 'test')

drop_table =
  """
  DROP INDEX IF EXISTS email_idx;
  DROP TABLE IF EXISTS users
  """

create_table =
  """
  CREATE TABLE users (
    id SERIAL,
    email VARCHAR(50) UNIQUE,
    name VARCHAR(80)
  )
  """

create_email_idx =
  """
  CREATE UNIQUE INDEX email_idx
  ON users (email)
  """

insert_sql =
  """
  WITH emails_to_insert AS (
    SELECT
      'wild' || num || '@example.com' AS email,
      'A wild ' || num AS name
    FROM generate_series(1, 1000000) AS num
  )

  INSERT INTO users
    (email, name)
    SELECT * FROM emails_to_insert
  """

conn.exec(drop_table)
conn.exec(create_table)
conn.exec(create_email_idx)
conn.exec(insert_sql)

puts "Done in #{Time.now - initial_time} seconds"
