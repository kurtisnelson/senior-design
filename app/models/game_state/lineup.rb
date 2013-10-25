module GameState
  class Lineup < State
    def initialize(id, type)
      super(id)
      @type = type
      populate unless llength(my_name) > 0
    end

    def populate
      r.del my_key
      if @type == :home
        parent_lineup = @game.home_lineup
      else
        parent_lineup = @game.away_lineup
      end

      r.pipelined do
        parent_lineup.each {|i| r.rpush my_key, i}
      end
    end

    def to_a
      get_int_array my_name
    end

    def next
      to_a.last
    end

    def add id
      r.lpush my_key, id
    end

    def to_out
      r.rpoplpush(my_key, my_key).to_i
    end

    def to_bases
      r.rpoplpush(my_key, key(:bases)).to_i
    end

    def set_expiration epoch
      r.expireat(my_key, epoch)
    end

    private
    def my_key
      key(my_name)
    end
    def my_name
      @type.to_s+"_lineup"
    end
  end
end
