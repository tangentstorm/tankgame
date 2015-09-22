# monkey patches to phaser to allow tilemaps, etc.

module Phaser

  class TileMapLayer
    include Native

    alias_native :resizeWorld, :resizeWorld

  end

  class TileMap
    include Native

    alias_native :create, :create, as: TileMapLayer
    alias_native :createBlankLayer, :createBlankLayer, as: TileMapLayer
    alias_native :addTileSetImage, :addTileSetImage
    alias_native :putTile, :putTile

  end

  class GameObjectFactory
    alias_native :tilemap, :tilemap, as: TileMap
  end

end
