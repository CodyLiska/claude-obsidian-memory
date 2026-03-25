# Phaser Stack Notes

> Reference notes for game development projects using Phaser 3 with Vite.

---

## Project Setup

```bash
npm create vite@latest project-name -- --template vanilla
cd project-name
npm install phaser
npm run dev
```

### Recommended folder structure

```
/src
  /scenes       ← one file per scene (GameScene.js, MenuScene.js etc)
  /assets       ← images, audio, tilemaps
  /objects      ← reusable game objects (Player.js, Enemy.js etc)
  /config       ← game config, constants
  main.js       ← entry point, Phaser.Game config
```

---

## Game Config Pattern

```js
// main.js
import Phaser from "phaser";
import GameScene from "./scenes/GameScene";

const config = {
  type: Phaser.AUTO,
  width: 800,
  height: 600,
  physics: {
    default: "arcade",
    arcade: { gravity: { y: 300 }, debug: false },
  },
  scene: [GameScene],
};

export default new Phaser.Game(config);
```

---

## Scene Structure

```js
export default class GameScene extends Phaser.Scene {
  constructor() {
    super({ key: "GameScene" });
  }

  preload() {
    // Load assets here
    this.load.image("player", "assets/player.png");
    this.load.tilemapTiledJSON("map", "assets/map.json");
  }

  create() {
    // Set up game objects, physics, input, events
  }

  update() {
    // Game loop — runs every frame
    // Keep this lean — move logic into object classes
  }
}
```

---

## Common Patterns

### Player movement

```js
// In create()
this.cursors = this.input.keyboard.createCursorKeys();
this.player = this.physics.add.sprite(100, 450, "player");
this.player.setBounce(0.2);
this.player.setCollideWorldBounds(true);

// In update()
if (this.cursors.left.isDown) {
  this.player.setVelocityX(-160);
} else if (this.cursors.right.isDown) {
  this.player.setVelocityX(160);
} else {
  this.player.setVelocityX(0);
}

if (this.cursors.up.isDown && this.player.body.touching.down) {
  this.player.setVelocityY(-330);
}
```

### Tilemap with collision

```js
// In create()
const map = this.make.tilemap({ key: "map" });
const tileset = map.addTilesetImage("tiles", "tiles");
const ground = map.createLayer("Ground", tileset, 0, 0);
ground.setCollisionByProperty({ collides: true });
this.physics.add.collider(this.player, ground);
```

### Scene switching

```js
this.scene.start("GameScene"); // switch to scene
this.scene.launch("UIScene"); // run scene in parallel
this.scene.pause("GameScene"); // pause without destroying
```

---

## Gotchas

- `update()` runs every frame — keep it lean, move heavy logic to object classes
- Assets must be loaded in `preload()` before use in `create()` — async load errors are silent
- Arcade physics bodies are rectangles — use `setSize()` and `setOffset()` to tune hitboxes
- Vite hot reload sometimes breaks Phaser state — full page refresh is more reliable during development
- Use `this.events` for scene-level events and `this.game.events` for global game events
- Camera follow: `this.cameras.main.startFollow(this.player)` — set bounds with `setBounds()`
