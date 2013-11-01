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

    def set_lineup arr
      set_array my_key, arr
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

    def to_base base
      player_id = r.rpop(my_key)
      if base == 1
        set_array key(:bases), [player_id.to_i,0,0]
      elsif base == 2
        set_array key(:bases), [0,player_id.to_i,0]
      elsif base == 3
        set_array key(:bases), [0,0,player_id.to_i]
      elsif base == 4
        set_array key(:bases), [0,0,0]
      end
      player_id
    end

    def set_expiration epoch
      r.expireat(my_key, epoch)
    end

    def my_key
      key(my_name)
    end
    def my_name
      @type.to_s+"_lineup"
    end
  end
end
