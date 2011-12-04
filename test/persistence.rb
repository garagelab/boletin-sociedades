# encoding: UTF-8

require_relative "../lib/model"

require "test/unit"

DB_DIR = "/tmp/boletino"

class SociedadTest < Test::Unit::TestCase

  def test_db_creation
    bdb = create_db
    assert File.exists?(DB_DIR)
    bdb.rw.close
    destroy_db
  end

  def test_record_creation
    bdb = create_db
    bdb << (r = { :persona_nombre => "Juan Carlos Petruza", :record_type => "Persona" })
    bdb.flush
    s = bdb.search("petruza")

    assert s.size == 1
    assert s.first.values["persona_nombre"] == r[:persona_nombre]
    bdb.rw.close
    destroy_db
  end

  private 

  def create_db
    BoletinDB.new(DB_DIR)
  end

  def destroy_db
    system "rm -rf #{DB_DIR}"
  end

end
