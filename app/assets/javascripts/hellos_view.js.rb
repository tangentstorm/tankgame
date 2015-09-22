NTANKS = 2
MW = 80; MH = 60 # map width/height   ! opal doesn't like multi-assign
TW = 10; TH = 10 # tile width/height

class GameState < Phaser::State

  def initialize game
    @game = game
  end

  def preload
    @game.load.image "bg", "sprites/background.png"
    NTANKS.times do |i|
      @game.load.image "tank#{i}", "sprites/tank#{i}.png"
      @game.load.image "gun#{i}", "sprites/gun#{i}.png"
    end
    addGround
  end

  def create
    @game.add.sprite 0, 0, "bg"
    NTANKS.times do |i|
      @game.add.sprite i * 200 + 225, 303, "gun#{i}"
      @game.add.sprite i * 200 + 200, 300, "tank#{i}"
    end
  end

  def addGround
    @game.load.image "msquares", "sprites/msquares.png"
    @tilemap = @game.add.tilemap
    @tilemap.addTileSetImage "msquares"
    @ground  = @tilemap.create "ground", MW, MH, TW, TH
    MH.times do |y|
      MW.times do |x|
        @tilemap.putTile rand(16), x, y, "ground"
      end
    end
    @ground.resizeWorld
  end

end


class HellosView

  def initialize(selector = 'body', parent = Element)
    game = Phaser::Game.new width:800, height:600
    game.state.add :main, GameState.new(game), true
  end

end
