# monkey patches to phaser to allow tilemaps, etc.

module Phaser

  class TileMapLayer
    include Native

    alias_native :resize_world, :resizeWorld

  end

  class TileMap
    include Native

    alias_native :create, :create, as: TileMapLayer
    alias_native :add_tileset_image, :addTilesetImage
    alias_native :put_tile, :putTile

  end

  class GameObjectFactory
    alias_native :tilemap, :tilemap, as: TileMap
  end

end
