def move(snake, direction)
  snake = add_new_head(snake, direction)
  snake.shift()
  return snake
end

def grow(snake, direction)
  add_new_head(snake, direction)
end

def new_food(food, snake, dimensions)
  # available_positions = get_all_coordinates(dimensions) - food - snake
  # new_food = available_positions.shuffle[0]
  positions_taken = food.concat(snake)
  new_position = get_random_position(dimensions)
  while positions_taken.include? new_position
    new_position = get_random_position(dimensions)
  end

  new_position
end

def obstacle_ahead?(snake, direction, dimensions)
  next_position = get_next_position(snake, direction)
  snake_reached = snake.include?(next_position)
  x_wall_reached = !((0...dimensions[:width]).include? next_position[0])
  y_wall_reached = !((0...dimensions[:height]).include? next_position[1])

  snake_reached or x_wall_reached or y_wall_reached
end

def danger?(snake, direction, dimensions)
  direction = direction.dup
  next_direction = direction.dup[direction.index(direction.max)] += 1
  in_danger = obstacle_ahead?(snake, direction, dimensions) \
                or obstacle_ahead?(snake, next_direction, dimensions)

  in_danger ? true : false
end

def get_next_position(snake, direction)
  snake[-1].map.with_index { |x, i| x + direction[i] }
end

def get_random_position(dimensions)
  random_x = Random.new.rand(0...dimensions[:width])
  random_y = Random.new.rand(0...dimensions[:height])
  random_position = [random_x, random_y]
end

def add_new_head(snake, direction)
  snake = snake.dup()
  new_head = get_next_position(snake, direction)
  snake.push(new_head)
end

# def get_all_coordinates(dimensions)
#   coordinates = []
#   (0..dimensions[:height]).each do |row|
#     (0..dimensions[:width]).each{ |col| coordinates.push([row, col]) }
#   end
#   return coordinates
# end

p new_food([[0, 0]], [[0, 1], [1, 1]], {width: 2, height: 2})