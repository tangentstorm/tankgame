NTANKS = 2

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
  end

  def create
    @game.add.sprite 0, 0, "bg"
    NTANKS.times do |i|
      @game.add.sprite i * 200 + 225, 303, "gun#{i}"
      @game.add.sprite i * 200 + 200, 300, "tank#{i}"
    end
  end

end


class HellosView

  def initialize(selector = 'body', parent = Element)
    game = Phaser::Game.new width:800, height:600
    game.state.add :main, GameState.new(game), true
  end

end
