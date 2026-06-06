// ==============================================================================
// Lemmings 1
// How many states does your FSM have? 2
// What does each state represent? 
//   - LEFT: The Lemming is currently walking to the left.
//   - RIGHT: The Lemming is currently walking to the right.
// ==============================================================================
module lemmings_1(
    input clk,
    input areset,    
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);
    parameter LEFT = 1'b0, RIGHT = 1'b1;
    reg state, next_state;

    always @(posedge clk or posedge areset) begin
        if (areset) state <= LEFT;
        else        state <= next_state;
    end

    always @(*) begin
        next_state = state;
        case (state)
            LEFT:  next_state = bump_left  ? RIGHT : LEFT;
            RIGHT: next_state = bump_right ? LEFT  : RIGHT;
        endcase
    end

    assign walk_left  = (state == LEFT);
    assign walk_right = (state == RIGHT);
endmodule


// ==============================================================================
// Lemmings 2
// How many states does your FSM have? 4
// What does each state represent? 
//   - LEFT: Walking left on the ground.
//   - RIGHT: Walking right on the ground.
//   - FALL_L: Falling through the air, retaining a left-facing memory.
//   - FALL_R: Falling through the air, retaining a right-facing memory.
// ==============================================================================
module lemmings_2(
    input clk,
    input areset,    
    input bump_left,
    input bump_right,
    input ground,
    output walk_left,
    output walk_right,
    output aaah
);
    parameter LEFT = 2'd0, RIGHT = 2'd1, FALL_L = 2'd2, FALL_R = 2'd3;
    reg [1:0] state, next_state;

    always @(posedge clk or posedge areset) begin
        if (areset) state <= LEFT;
        else        state <= next_state;
    end

    always @(*) begin
        next_state = state;
        case (state)
            LEFT:   next_state = !ground ? FALL_L : (bump_left ? RIGHT : LEFT);
            RIGHT:  next_state = !ground ? FALL_R : (bump_right ? LEFT : RIGHT);
            FALL_L: next_state = ground  ? LEFT   : FALL_L;
            FALL_R: next_state = ground  ? RIGHT  : FALL_R;
        endcase
    end

    assign walk_left  = (state == LEFT);
    assign walk_right = (state == RIGHT);
    assign aaah       = (state == FALL_L) || (state == FALL_R);
endmodule


// ==============================================================================
// Lemmings 3
// How many states does your FSM have? 6
// What does each state represent? 
//   - LEFT / RIGHT: Walking horizontally.
//   - FALL_L / FALL_R: Falling (overrides walking and digging).
//   - DIG_L / DIG_R: Digging downward, retaining horizontal facing direction.
// ==============================================================================
module lemmings_3(
    input clk,
    input areset,    
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);
    parameter LEFT = 3'd0, RIGHT = 3'd1, FALL_L = 3'd2, FALL_R = 3'd3, DIG_L = 3'd4, DIG_R = 3'd5;
    reg [2:0] state, next_state;

    always @(posedge clk or posedge areset) begin
        if (areset) state <= LEFT;
        else        state <= next_state;
    end

    always @(*) begin
        next_state = state;
        case (state)
            LEFT:   next_state = !ground ? FALL_L : (dig ? DIG_L : (bump_left ? RIGHT : LEFT));
            RIGHT:  next_state = !ground ? FALL_R : (dig ? DIG_R : (bump_right ? LEFT : RIGHT));
            FALL_L: next_state = ground  ? LEFT   : FALL_L;
            FALL_R: next_state = ground  ? RIGHT  : FALL_R;
            DIG_L:  next_state = !ground ? FALL_L : DIG_L;
            DIG_R:  next_state = !ground ? FALL_R : DIG_R;
            default: next_state = LEFT;
        endcase
    end

    assign walk_left  = (state == LEFT);
    assign walk_right = (state == RIGHT);
    assign aaah       = (state == FALL_L) || (state == FALL_R);
    assign digging    = (state == DIG_L)  || (state == DIG_R);
endmodule


// ==============================================================================
// Lemmings 4
// How many states does your FSM have? 7
// What does each state represent? 
//   - LEFT / RIGHT: Walking horizontally.
//   - FALL_L / FALL_R: Falling through the air.
//   - DIG_L / DIG_R: Digging downward.
//   - SPLAT: Terminal state; the Lemming died from falling > 19 clock cycles.
// ==============================================================================
module lemmings_4(
    input clk,
    input areset,    
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);
    parameter LEFT = 3'd0, RIGHT = 3'd1, FALL_L = 3'd2, FALL_R = 3'd3, DIG_L = 3'd4, DIG_R = 3'd5, SPLAT = 3'd6;
    
    reg [2:0] state, next_state;
    reg [4:0] fall_timer; 

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            fall_timer <= 5'd0;
        end else if (state == FALL_L || state == FALL_R) begin
            if (fall_timer < 5'd31) fall_timer <= fall_timer + 1;
            else                    fall_timer <= 5'd31; 
        end else begin
            fall_timer <= 5'd0; 
        end
    end

    always @(posedge clk or posedge areset) begin
        if (areset) state <= LEFT;
        else        state <= next_state;
    end

    always @(*) begin
        next_state = state;
        case (state)
            LEFT:   next_state = !ground ? FALL_L : (dig ? DIG_L : (bump_left ? RIGHT : LEFT));
            RIGHT:  next_state = !ground ? FALL_R : (dig ? DIG_R : (bump_right ? LEFT : RIGHT));
            FALL_L: next_state = ground  ? ((fall_timer > 5'd19) ? SPLAT : LEFT)  : FALL_L;
            FALL_R: next_state = ground  ? ((fall_timer > 5'd19) ? SPLAT : RIGHT) : FALL_R;
            DIG_L:  next_state = !ground ? FALL_L : DIG_L;
            DIG_R:  next_state = !ground ? FALL_R : DIG_R;
            SPLAT:  next_state = SPLAT; 
            default: next_state = LEFT;
        endcase
    end

    assign walk_left  = (state == LEFT);
    assign walk_right = (state == RIGHT);
    assign aaah       = (state == FALL_L) || (state == FALL_R);
    assign digging    = (state == DIG_L)  || (state == DIG_R);
endmodule
