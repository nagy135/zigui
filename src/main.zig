const rl = @import("raylib");
const std = @import("std");

const BRICK_SIZE = rl.Vector3.init(100, 40, 2);

pub const Brick = struct {
    pos: rl.Vector3,
    color: rl.Color,
};

pub const Game = struct {
    bricks: *[10]Brick,
};

fn drawBrick(brick: Brick) void {
    rl.drawCube(brick.pos, BRICK_SIZE.x, BRICK_SIZE.y, BRICK_SIZE.z, brick.color);
}

fn drawGame(game: Game) void {
    for (game.bricks) |brick| {
        drawBrick(brick);
    }
}

pub fn main() anyerror!void {
    // Initialization
    //--------------------------------------------------------------------------------------
    const screenWidth = 800;
    const screenHeight = 450;

    var rand_impl = std.rand.DefaultPrng.init(42);

    var bricks: [10]Brick = undefined;

    var x: f32 = 0;
    var y: f32 = 0;

    var counterLimit: f32 = 4;
    var counter: f32 = 0;

    const colors = [_]rl.Color{
        rl.Color.red,
        rl.Color.green,
        rl.Color.blue,
        rl.Color.yellow,
        rl.Color.orange,
        rl.Color.purple,
        rl.Color.pink,
        rl.Color.brown,
        rl.Color.black,
    };

    for (&bricks) |*brick| {
        if (counter == counterLimit) {
            counterLimit -= 1;
            counter = 0;
            const shift = 4 - counterLimit;

            x = shift * 60;
            y += 60;
        }
        brick.pos = rl.Vector3.init(200 + x, 40 + y, 1);

        const num = rand_impl.random().int(u32);
        brick.color = colors[num % colors.len];
        x += 120;
        counter += 1;
    }
    const game = Game{
        .bricks = &bricks,
    };

    rl.initWindow(screenWidth, screenHeight, "Hello");
    defer rl.closeWindow(); // Close window and OpenGL context

    rl.setTargetFPS(60); // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    while (!rl.windowShouldClose()) { // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        // TODO: Update your variables here
        //----------------------------------------------------------------------------------

        //----------------------------------------------------------------------------------
        // Draw
        //----------------------------------------------------------------------------------
        rl.beginDrawing();
        defer rl.endDrawing();

        drawGame(game);

        rl.clearBackground(rl.Color.white);

        rl.drawText("Whats up", 190, 200, 20, rl.Color.gold);
        //----------------------------------------------------------------------------------
    }
}
