PADDLE_SPEED = 200
PADDLE_HEIGHT = 150
PADDLE_WIDTH = 50

BALL_SPEED = 500
BALL_RADIUS = 25

p1_score = 0
p2_score = 0

ball = { x = 0, y = 0, vel = { x = 0, y = 0 } }
p1 = { x = 0, y = 0, vel = { x = 0, y = 0 } }
p2 = { x = 0, y = 0, vel = { x = 0, y = 0 } }

function checkBoundsCollision()
	local max_x = love.graphics.getWidth()
	local max_y = love.graphics.getHeight()

	if ball.x >= max_x then
		ball.x = love.graphics.getWidth() / 2
		p1_score = p1_score + 1
	elseif ball.x - BALL_RADIUS <= 0 then
		ball.x = love.graphics.getWidth() / 2
		p2_score = p1_score + 1
	end
	if ball.y + BALL_RADIUS >= max_y or ball.y - BALL_RADIUS <= 0 then
		ball.vel.y = 0 - ball.vel.y
	end
end

-- TODO: make it so hitting at an angle changes the angle of the bounce
local function checkBallPaddleCollision(rx, ry)
	local test_x = ball.x
	local test_y = ball.y

	if ball.x < rx then -- left edge
		test_x = rx
	elseif ball.x > rx + PADDLE_WIDTH then -- right edge
		test_x = rx + PADDLE_WIDTH
	end

	if ball.y < ry then -- top edge
		test_y = ry
	elseif ball.y > ry + PADDLE_HEIGHT then -- bottom edge
		test_y = ry + PADDLE_HEIGHT
	end

	local dist_x = ball.x - test_x
	local dist_y = ball.y - test_y
	local distance = math.sqrt((dist_x * dist_x) + (dist_y * dist_y))

	if distance <= BALL_RADIUS then
		return true
	else
		return false
	end
end

-- LOVE GAME LOOP FUNCTIONS
function love.load()
	local width = love.graphics.getWidth()
	local height = love.graphics.getHeight()
	local midX = width / 2
	local midY = height / 2

	p1.x = 100
	p1.y = midY - (PADDLE_HEIGHT / 2)

	p2.x = width - 100
	p2.y = midY - (PADDLE_HEIGHT / 2)

	ball.x = midX
	ball.y = midY

	local startingDirSeed = math.random(0, 100)
	local startingVelocityX
	local startingVelocityY

	if startingDirSeed < 50 then
		startingVelocityX = 0 - BALL_SPEED
	else
		startingVelocityX = BALL_SPEED
	end
	startingVelocityY = startingDirSeed

	ball.vel.x = startingVelocityX
	ball.vel.y = startingVelocityY
end

-- @param dt delta time
function love.update(dt)
	-- Handle keyboard input for paddle up/down for P1
	if love.keyboard.isDown("s") then
		p1.vel.y = PADDLE_SPEED * dt
	elseif love.keyboard.isDown("w") then
		p1.vel.y = PADDLE_SPEED * -1 * dt
	else
		p1.vel.y = 0
	end
	-- Handle keypresses for P2
	if love.keyboard.isDown("down") then
		p2.vel.y = PADDLE_SPEED * dt
	elseif love.keyboard.isDown("up") then
		p2.vel.y = PADDLE_SPEED * -1 * dt
	else
		p2.vel.y = 0
	end

	-- move paddle according to velocity
	p1.y = p1.y + p1.vel.y
	p2.y = p2.y + p2.vel.y

	-- move ball according to velocity
	ball.x = ball.x + ball.vel.x * dt
	ball.y = ball.y + ball.vel.y * dt

	-- paddle collision - bounce and preserve y
	if checkBallPaddleCollision(p1.x, p1.y) then
		ball.vel.x = 0 - ball.vel.x
		ball.vel.y = ball.vel.y + p1.vel.y
	elseif checkBallPaddleCollision(p2.x, p2.y) then
		ball.vel.x = 0 - ball.vel.x
		ball.vel.y = ball.vel.y + p2.vel.y
	end
	checkBoundsCollision()
end

function love.draw()
	love.graphics.rectangle("line", p1.x, p1.y, PADDLE_WIDTH, PADDLE_HEIGHT)
	love.graphics.rectangle("line", p2.x, p2.y, PADDLE_WIDTH, PADDLE_HEIGHT)

	local center_x = love.graphics.getWidth() / 2
	love.graphics.line(center_x, 0, center_x, love.graphics.getHeight())
	love.graphics.print(tostring(p1_score), center_x - 20, 50)
	love.graphics.print(tostring(p2_score), center_x + 20, 50)

	love.graphics.circle("line", ball.x, ball.y, BALL_RADIUS)
end
