# monkey patches to phaser to allow tilemaps, etc.

module Phaser

  class TileMap
    def initialize native
      @native = native
    end
  end

  class << GameObjectFactory
    alias_native :tilemap, :tilemap, as: TileMap
  end

end
