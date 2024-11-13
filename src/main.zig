const rl = @import("raylib");
const std = @import("std");

const BRICK_SIZE = rl.Vector3.init(100, 40, 2);
const BALL_SIZE = rl.Vector3.init(20, 20, 2);
const USER_SIZE = rl.Vector3.init(100, 20, 2);
const SCREEN_WIDTH = 800;
const SCREEN_HEIGHT = 600;

pub const Brick = struct {
    pos: rl.Vector3,
    color: rl.Color,
    dead: bool,
};

pub const Ball = struct {
    pos: rl.Vector3,
    dx: f32,
    dy: f32,
};

pub const Game = struct {
    bricks: *[10]Brick,
    user: rl.Vector3,
    ball: Ball,
};

fn drawBrick(brick: Brick) void {
    rl.drawCube(brick.pos, BRICK_SIZE.x, BRICK_SIZE.y, BRICK_SIZE.z, brick.color);
}

fn drawBall(ball: rl.Vector3) void {
    rl.drawCube(ball, BALL_SIZE.x, BALL_SIZE.y, BALL_SIZE.z, rl.Color.dark_green);
}

fn drawUser(user: rl.Vector3) void {
    rl.drawCube(user, USER_SIZE.x, USER_SIZE.y, USER_SIZE.z, rl.Color.black);
}

fn drawGame(game: Game) void {
    for (game.bricks) |brick| {
        if (!brick.dead) {
            drawBrick(brick);
        }
    }
}

fn gameLogic(game: *Game) void {
    if (game.ball.pos.x <= 0) {
        game.ball.dx *= -1;
    }
    if (game.ball.pos.y <= 0) {
        game.ball.dy *= -1;
    }
    if (game.ball.pos.x >= SCREEN_WIDTH) {
        game.ball.dx *= -1;
    }
    if (game.ball.pos.y >= SCREEN_HEIGHT) {
        game.ball.dy *= -1;
    }

    var i: usize = 0;
    for (game.bricks) |brick| {
        if (brick.dead) {
            continue;
        }
        if (rl.checkCollisionBoxes(rl.BoundingBox{
            .min = rl.Vector3.init(brick.pos.x, brick.pos.y, brick.pos.z),
            .max = rl.Vector3.init(brick.pos.x + BRICK_SIZE.x, brick.pos.y + BRICK_SIZE.y, brick.pos.z + 1),
        }, rl.BoundingBox{
            .min = rl.Vector3.init(game.ball.pos.x, game.ball.pos.y, game.ball.pos.z),
            .max = rl.Vector3.init(game.ball.pos.x + BALL_SIZE.x, game.ball.pos.y + BALL_SIZE.y, game.ball.pos.z + 1),
        })) {
            game.ball.dy *= -1;
            game.bricks[i].dead = true;
        }
        i += 1;
    }

    if (rl.checkCollisionBoxes(rl.BoundingBox{
        .min = rl.Vector3.init(game.user.x, game.user.y, game.user.z),
        .max = rl.Vector3.init(game.user.x + USER_SIZE.x, game.user.y + USER_SIZE.y, game.user.z + 1),
    }, rl.BoundingBox{
        .min = rl.Vector3.init(game.ball.pos.x, game.ball.pos.y, game.ball.pos.z),
        .max = rl.Vector3.init(game.ball.pos.x + BALL_SIZE.x, game.ball.pos.y + BALL_SIZE.y, game.ball.pos.z + 1),
    })) {
        game.ball.dy *= -1;
    }

    game.ball.pos.x += game.ball.dx;
    game.ball.pos.y += game.ball.dy;
}

pub fn main() anyerror!void {
    // Initialization
    //--------------------------------------------------------------------------------------
    const screenWidth = SCREEN_WIDTH;
    const screenHeight = SCREEN_HEIGHT;

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
        brick.dead = false;
        x += 120;
        counter += 1;
    }
    var game = Game{
        .bricks = &bricks,
        .user = rl.Vector3.init(screenWidth / 2, screenHeight - 30, 1),
        .ball = Ball{
            .pos = rl.Vector3.init(screenWidth / 2, screenHeight / 2, 1),
            .dx = 5,
            .dy = 5,
        },
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

        if (rl.isKeyDown(rl.KeyboardKey.key_h)) {
            game.user.x -= 10;
        } else if (rl.isKeyDown(rl.KeyboardKey.key_l)) {
            game.user.x += 10;
        } else if (rl.isKeyDown(rl.KeyboardKey.key_q)) {
            rl.closeWindow();
        }

        gameLogic(&game);

        //----------------------------------------------------------------------------------
        // Draw
        //----------------------------------------------------------------------------------
        rl.beginDrawing();
        defer rl.endDrawing();

        drawGame(game);
        drawUser(game.user);
        drawBall(game.ball.pos);

        rl.clearBackground(rl.Color.white);

        rl.drawText("Whats up", 190, 200, 20, rl.Color.gold);
        //----------------------------------------------------------------------------------
    }
}
