#!/usr/local/bin/ruby

require "test/unit"
require "pqa.rb"

class QueryTest < Test::Unit::TestCase

  def test_add
    q = Query.new
    q.append("test")
    assert(q.to_s == " test", "append should insert leading space, instead:" + q.to_s + ":")  
  end

  def test_is_select
    assert(Query.new("SELECT * from users").is_select, "SELECT detection failed")
    assert(Query.new("select * from users").is_select, "SELECT detection failed")
  end

  def test_is_delete
    assert(Query.new("DELETE * from users"), "DELETE detection failed")
  end

  def test_is_insert
    assert(Query.new("insert into users values etc etc"), "INSERT detection failed")
  end
end

class ParseStub < String

  def parse_query_segment
    to_s
  end

  def parse_duration_segment
    to_s
  end
end

def MyQuery
  attr_reader :callback

  def normalize
    @callback = true
  end
end

class GenericLogReaderTest < Test::Unit::TestCase

  def test_uniq
    g = GenericLogReader.new(nil, "PGLogLine", "PGLogAccumulator")  
    g.queries = [Query.new("select * from users"), Query.new("select * from groups"), Query.new("select * from users")]
    assert(g.unique_queries == 2)
  end

  def normalize  
    g = GenericLog.new(nil)  
    q = MyQuery.new
    g.queries = [q]
    g.normalize
    assert(q.callback)
  end

end

class MySQLLogLineTest < Test::Unit::TestCase
  NEW_QUERY="        1 Query       SELECT profiles.userid from profiles"
  CONNECT_DISCARD="040609 12:00:28       4 Connect     root@localhost on test-ssr"
  CONT="                     longdescs.thetext"

  def test_is_new_query
    m = MySQLLogLine.new(NEW_QUERY)
    assert(m.is_new_query)
  end

  def test_continuation
    m = MySQLLogLine.new(CONT)
    assert(m.is_continuation)
  end

  def test_discard
    m = MySQLLogLine.new(CONNECT_DISCARD)
    assert(!m.is_new_query)
    assert(!m.is_continuation)
  end
  
end

class OverallStatsReportTest < Test::Unit::TestCase
  
  def setup
    @log = GenericLogReader.new(nil,nil,nil)
    @q1 = Query.new("select * from foobars;") ; @q1.duration = 5.0 ; @log.queries << @q1
  end

  def test_total_duration
    q2 = Query.new("select * from buz;") ; q2.duration = 10.0 ; @log.queries << q2
    r = OverallStatsReport.new(@log)
    assert_equal(r.total_duration, 15.0)
  end

  def test_find_shortest
    q2 = Query.new("select * from buz;") ; q2.duration = 15.0 ; @log.queries << q2
    r = OverallStatsReport.new(@log)
    assert_equal(r.find_shortest, @q1)
  end

  def test_find_longest
    q2 = Query.new("select * from buz;") ; q2.duration = 15.0 ; @log.queries << q2
    r = OverallStatsReport.new(@log)
    assert_equal(r.find_longest, q2)
  end

  def test_find_shortest_with_nil_duration
    q2 = Query.new("select * from buz;") ; @log.queries << q2
    r = OverallStatsReport.new(@log)
    assert_equal(r.find_shortest, @q1)
  end
end

class QueryByTypeReportTest < Test::Unit::TestCase

  def test_create_report
    log = GenericLogReader.new(nil,nil,nil)
    log.queries << Query.new("select * from foobars;")
    log.queries << Query.new("insert into foo values (a,b);")
    log.queries << Query.new("insert into foo values (a,b);")
    log.queries << Query.new("update foo set bar = where baz = buz;")
    log.queries << Query.new("update foo set bar = where baz = buz;")
    log.queries << Query.new("update foo set bar = where baz = buz;")
    log.queries << Query.new("delete from foo;")
    log.queries << Query.new("delete from foo;")
    log.queries << Query.new("delete from foo;")
    log.queries << Query.new("delete from foo;")
    r = QueriesByTypeReport.new(log)
    assert_equal(r.create_report[0], 1)
    assert_equal(r.create_report[1], 2)
    assert_equal(r.create_report[2], 3)
    assert_equal(r.create_report[3], 4)
  end

end

