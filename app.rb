require 'ruby2d'

WINDOW_WIDTH = 800
WINDOW_HEIGHT = 600
RECT_SIZE = 20
FRAME = 4
RECT_COLOR = "white"
BACKGROUND = "black"
BAR_LEN = 100
BAR_THICCNESS = 20
BAR_Y =  WINDOW_HEIGHT - BAR_THICCNESS - 100
BAR_COLOR= "red"
BAR_SPEED = 10
TARGET_WIDTH = BAR_LEN
TARGET_HEIGHT = BAR_THICCNESS
TARGET_CAP = 128
TARGET_PADD = 20

class Target
  attr_accessor :x, :y, :dead
  def initialize(x, y, dead)
    @x = x
    @y = y
    @dead = dead
  end
end

def draw_targets(target_pool)
  for j in 1...5
    for i in 0...5
      target_pool[i][j] = Target.new(100 + (TARGET_WIDTH + TARGET_PADD) * i ,50 * j, false)
    end
  end
  
  return target_pool

end


def main
  set width: WINDOW_WIDTH, height: WINDOW_HEIGHT
  set title: "Pong Game"
  set background: BACKGROUND
  set borderless: 2
  set fullscreen: false

  song = Music.new('app.wav')
  song.loop = true
  song.volume = 10
  song.play

  target_pool = Array.new(5){Array.new(5)}
  target_pool = draw_targets(target_pool)
 
  target_pool_count = 0

  proj_x = 100
  proj_y = 100
  proj_dx = 1
  proj_dy = 1

  bar_x = WINDOW_WIDTH/2 - BAR_LEN / 2
  bar_y = BAR_Y - BAR_THICCNESS/2
  @pause = false

  @proj_rect = Square.new(x: proj_x, y: proj_y, size: RECT_SIZE, color: RECT_COLOR)

  @barreact = Rectangle.new(x: bar_x, y: bar_y, width: BAR_LEN,
    height: BAR_THICCNESS, color: BAR_COLOR)
  targets_rect = []
  target_pool.each do |targets|
    targets.each do |target|
      if !target.nil? && !target.dead
      targets_rect.push(Rectangle.new(x: target.x, y: target.y, width: TARGET_WIDTH,
        height: TARGET_HEIGHT, color: 'green'))
      end
    end
    

  end

  update do
    if @pause == false
      proj_nx = proj_x + proj_dx * FRAME
      targets_rect.each do |target|
        if target.contains?(proj_nx,@proj_rect.y)
          proj_dx = proj_dx * -1
          proj_nx = proj_x + proj_dx * FRAME
        end
      end
      if proj_nx < 0 || proj_x + RECT_SIZE > WINDOW_WIDTH || @barreact.contains?(proj_nx,@proj_rect.y) 
        proj_dx = proj_dx * -1
        proj_nx = proj_x + proj_dx * FRAME
      end
      proj_x = proj_nx
      @proj_rect.x = proj_x

      proj_ny = proj_y + proj_dy * FRAME
      targets_rect.each do |target|
        if target.contains?(@proj_rect.x,proj_ny)
          proj_dy = proj_dy * -1
          proj_ny = proj_y + proj_dy * FRAME
        end
      end
      if proj_ny < 0 || proj_y + RECT_SIZE > WINDOW_HEIGHT || @barreact.contains?(@proj_rect.x,proj_ny)
        proj_dy = proj_dy * -1
        proj_ny = proj_y + proj_dy * FRAME
      end
      proj_y = proj_ny
      @proj_rect.y = proj_y

    end

  end
  on :key_held do |event|
    if @pause == false
      # A key was pressed
      key = event.key
      case key
      when 'right'
          @barreact.x = @barreact.x + BAR_SPEED if @barreact.x + BAR_LEN < WINDOW_WIDTH
      when 'left'
        @barreact.x = @barreact.x - BAR_SPEED if @barreact.x > 0
      end
    end
  end

  on :key_down do |event|
    # A key was pressed
    key = event.key
    case key
    when 'space'
      @pause = !@pause
    when 'a'
      exit
    end
    puts @pause
 end
 
  show

end

# call main function
main
