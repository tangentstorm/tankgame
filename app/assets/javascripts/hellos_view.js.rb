NTANKS = 2
MW = 80; MH = 60 # map width/height   ! opal doesn't like multi-assign
TW = 10; TH = 10 # tile width/height

class Range2d

  def initialize w,h
    @w, @h = w, h
  end

  def by_row
    @h.times do |y|
      newrow = true
      @w.times do |x|
        yield x, y, newrow
        newrow = false
      end
    end
  end

  def by_col
    @w.times do |x|
      newcol = true
      @h.times do |y|
        yield x, y, newcol
        newcol = false
      end
    end
  end

end

class Grid < Range2d

  def initialize w,h, fill: nil
    super w, h
    @data = []
    by_row do |x, y, isnew|
      @data.push [] if isnew
      @data[y].push fill
    end
    puts "done with grid initialization"
  end

  def get(x,y)
    return @data[y][x]
  end

  def put(x,y,v)
    return @data[y][x]=v
  end

end




class Sand < Range2d
  # The internal grid has 1 extra row and column, because
  # marching squares works with the 4 surrounding values
  # for each point. We subclass Range2d so that we can
  # loop on the smaller range for rendering, and hold an
  # internal Grid object to track the sand 'particles' for
  # marching squares.

  def initialize w,h
    super w,h
    @grid = Grid.new w+1, h+1
    level = h / 2
    # perform a random walk to generate the terrain
    @grid.by_col do |x, y, isnew|
      level += rand(3)-1 if isnew
      @grid.put x, y, (y < level ? 0 : 1)
    end
  end

  def msquare x,y
    # generate marching square tile from 4 corner bits.
    ((@grid.get( x,   y ) << 3) +
     (@grid.get(x+1,  y ) << 2) +
     (@grid.get(x+1, y+1) << 1) +
     (@grid.get( x,  y+1)))
  end

  def msquares
    by_col do |x, y, isnew|
      yield x, y, msquare(x,y)
    end
  end

end


class GameState < Phaser::State

  def initialize game
    @game = game
  end

  def preload
    @game.load.image "msquares", "sprites/msquares.png"
    @game.load.image "bg", "sprites/background.png"
    NTANKS.times do |i|
      @game.load.image "tank#{i}", "sprites/tank#{i}.png"
      @game.load.image "gun#{i}", "sprites/gun#{i}.png"
    end
  end

  def create
    @game.add.sprite 0, 0, "bg"
    addGround
    NTANKS.times do |i|
      @game.add.sprite i * 200 + 225, 303, "gun#{i}"
      @game.add.sprite i * 200 + 200, 300, "tank#{i}"
    end
  end

  def addGround
    @tilemap = @game.add.tilemap
    @ground  = @tilemap.create "ground", MW, MH, TW, TH
    @tilemap.add_tileset_image "msquares"
    @sand = Sand.new MW,MH
    @sand.msquares do |x,y,tile|
      @tilemap.put_tile tile, x, y, "ground"
    end
    @ground.resize_world
  end

end


class HellosView

  def initialize(selector = 'body', parent = Element)
    game = Phaser::Game.new width:800, height:600
    game.state.add :main, GameState.new(game), true
  end

end
