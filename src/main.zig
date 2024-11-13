const rl = @import("raylib");

pub fn main() anyerror!void {
    // Initialization
    //--------------------------------------------------------------------------------------
    const screenWidth = 800;
    const screenHeight = 450;

    rl.initWindow(screenWidth, screenHeight, "Hello");
    defer rl.closeWindow(); // Close window and OpenGL context

    rl.setTargetFPS(60); // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    const poc = rl.Vector3.init(200, 200, 1);
    var shift = rl.Vector3.init(0, 0, 0);
    // Main game loop
    while (!rl.windowShouldClose()) { // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        // TODO: Update your variables here
        //----------------------------------------------------------------------------------

        rl.drawCube(poc.add(shift), 109, 109, 2, rl.Color.red);
        rl.drawCube(poc.subtract(shift), 109, 109, 2, rl.Color.red);
        shift.x += 0.5;
        shift.y += 0.2;

        //----------------------------------------------------------------------------------
        // Draw
        //----------------------------------------------------------------------------------
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(rl.Color.white);

        rl.drawText("Whats up", 190, 200, 20, rl.Color.gold);
        //----------------------------------------------------------------------------------
    }
}
