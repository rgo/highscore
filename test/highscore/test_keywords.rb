$:.unshift(File.join(File.dirname(__FILE__), %w{.. .. lib highscore}))
require 'keywords'
require 'keyword'
require "test/unit"

class TestKeywords < Test::Unit::TestCase
  def setup
    @keywords = Highscore::Keywords.new
    @keywords << Highscore::Keyword.new('Ruby', 2)
    @keywords << Highscore::Keyword.new('Sinatra', 3)
    @keywords << Highscore::Keyword.new('Highscore', 1)
    @keywords << Highscore::Keyword.new('the', 10)
  end

  def test_init
    assert Highscore::Keywords.new.length == 0
  end

  def test_each
    @keywords.each do |x|
      assert(x.instance_of?(Highscore::Keyword), "should contain Highscore::Keyword instances, is #{x.class}")
    end
  end

  def test_first
    assert_equal 'the', @keywords.first.text
  end

  def test_last
    assert_equal 'Highscore', @keywords.last.text
  end

  def test_rank
    assert @keywords.length == 4

    ranked = @keywords.rank

    ranked_texts = []
    ranked.each do |keyword|
      assert(keyword.instance_of?(Highscore::Keyword),
             "keywords must be instances of Highscore::Keyword, #{keyword.class} given")
      ranked_texts << keyword.text
    end

    should_rank = %w{the Sinatra Ruby Highscore}

    assert_equal should_rank, ranked_texts
  end

  def test_rank_empty
    assert_equal [], Highscore::Keywords.new.rank
  end

  def test_top
    top = @keywords.top(1)

    assert_equal('the', top[0].text)
    assert_equal(10.0, top[0].weight)
  end

  def test_top_empty
    assert_equal [], Highscore::Keywords.new.top(0)
  end

  def test_merge!
    other = Highscore::Keywords.new
    other << Highscore::Keyword.new('Ruby', 100.3)

    @keywords.merge!(other)

    assert_equal 102.3, @keywords.first.weight
    assert_equal 'Ruby', @keywords.first.text
  end
end