NTANKS = 2
MW = 80; MH = 60 # map width/height   ! opal doesn't like multi-assign
TW = 10; TH = 10 # tile width/height

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
    MH.times do |y|
      MW.times do |x|
        if y > MH/2 then @tilemap.put_tile rand(16), x, y, "ground" end
      end
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
