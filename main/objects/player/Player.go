components {
  id: "Player"
  component: "/main/objects/player/NewPlayer.script"
}
embedded_components {
  id: "sprite"
  type: "sprite"
  data: "default_animation: \"idle\"\n"
  "material: \"/builtins/materials/sprite.material\"\n"
  "textures {\n"
  "  sampler: \"texture_sampler\"\n"
  "  texture: \"/main/objects/player/Barbarian/BarbarianIdle.tilesource\"\n"
  "}\n"
  ""
  position {
    y: -1.0
  }
}
